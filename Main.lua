local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- 1. ZENTRALE EINSTELLUNGEN ÜBERSCHREIBEN
local function applyInternalSettings()
    local replicated = game:GetService("ReplicatedStorage")
    local modules = replicated:FindFirstChild("Modules")
    local settingsLib = modules and modules:FindFirstChild("SettingsLibrary")
    
    if settingsLib then
        local s = require(settingsLib)
        -- Wir greifen direkt in die 'Info' Tabelle der Library ein
        if s.Info then
            -- Auto-Shoot Schalter und Zeit (10ms)
            if s.Info["Auto Shoot"] then s.Info["Auto Shoot"].DefaultValue = "Custom" end
            if s.Info["Auto Shoot Reaction Time"] then s.Info["Auto Shoot Reaction Time"].DefaultValue = 0.01 end
            
            -- Aim-Assist Schalter und Stärke (Maximum)
            if s.Info["Aim Assist"] then s.Info["Aim Assist"].DefaultValue = "Custom" end
            if s.Info["Aim Assist Strength"] then s.Info["Aim Assist Strength"].DefaultValue = 1.0 end
            
            -- Bonus: Rückstoß-Wackeln entfernen
            if s.Info["Camera Shake"] then s.Info["Camera Shake"].DefaultValue = false end
        end
    end
end

task.spawn(applyInternalSettings)

-- 2. CROSSHAIR-POSITION FINDEN (Für präzises Aiming)
local function getCrosshairPos()
    local scripts = player:FindFirstChild("PlayerScripts")
    local ui = scripts and scripts:FindFirstChild("UserInterFace")
    local cross = ui and ui:FindFirstChild("Crosshair")
    if cross and cross:IsA("GuiObject") and cross.AbsolutePosition.X > 0 then
        return cross.AbsolutePosition + (cross.AbsoluteSize / 2)
    end
    -- Fallback auf Bildschirmmitte (0.42 Höhe für Rivals)
    return Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y * 0.42)
end

-- 3. NÄCHSTEN GEGNER FINDEN
local function getClosestPlayer()
    local closest, dist = nil, math.huge
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local tChar = p.Character
            -- Fokus auf Kopf für Sniper, sonst Torso
            local targetPart = tChar:FindFirstChild("Head") or tChar:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local _, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local d = (targetPart.Position - myChar.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        closest, dist = targetPart, d
                    end
                end
            end
        end
    end
    return closest
end

-- 4. DIE HAUPT-SCHLEIFE
runService.RenderStepped:Connect(function()
    local config = _G.BetterRivalsSettings
    if not config then return end
    
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local target = getClosestPlayer()
        
        if target and config.AutoAim then
            local crossPos = getCrosshairPos()
            local tPos = camera:WorldToViewportPoint(target.Position)
            local targetVec = Vector2.new(tPos.X, tPos.Y)
            local diff = targetVec - crossPos
            
            -- Sanftes Mitziehen (Smoothing)
            if mousemoverel then
                mousemoverel(diff.X * 0.4, diff.Y * 0.4)
            end
            
            -- Backup Auto-Shoot (Falls der interne Spiel-Assist mal nicht greift)
            if config.AutoShoot and diff.Magnitude < 40 then
                if mouse1press then
                    mouse1press()
                    task.wait(0.01)
                    mouse1release()
                end
            end
        end
        
        -- Fly-Funktion
        if config.Fly then
            local root = char.HumanoidRootPart
            local bv = root:FindFirstChild("BR_Fly") or Instance.new("BodyVelocity", root)
            bv.Name = "BR_Fly"
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bv.Velocity = char.Humanoid.MoveDirection * ((config.FlySpeed or 1) * 30)
            char.Humanoid.PlatformStand = true
        else
            if char.HumanoidRootPart:FindFirstChild("BR_Fly") then char.HumanoidRootPart.BR_Fly:Destroy() end
            char.Humanoid.PlatformStand = false
        end
    end
end)
