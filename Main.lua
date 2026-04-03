local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

local function hasWeapon()
    local char = player.Character
    if not char then return false end
    return char:FindFirstChildOfClass("Tool") ~= nil
end

local function forceGameSettings()
    local replicated = game:GetService("ReplicatedStorage")
    local modules = replicated:FindFirstChild("Modules")
    local settingsLib = modules and modules:FindFirstChild("SettingsLibrary")
    
    if settingsLib then
        local s = require(settingsLib)
        if s.Info then
            pcall(function()
                if s.Info["Auto Shoot"] then s.Info["Auto Shoot"].CurrentValue = "Custom" end
                if s.Info["Auto Shoot Reaction Time"] then s.Info["Auto Shoot Reaction Time"].CurrentValue = 0.01 end
                if s.Info["Aim Assist"] then s.Info["Aim Assist"].CurrentValue = "Custom" end
                if s.Info["Aim Assist Strength"] then s.Info["Aim Assist Strength"].CurrentValue = 1.0 end
                if s.Info["Camera Shake"] then s.Info["Camera Shake"].CurrentValue = false end
            end)
        end
    end
end

local function getClosestVisibleTarget()
    local closest, dist = nil, 200
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local pos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local screenPos = Vector2.new(pos.X, pos.Y)
                local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y * 0.42)
                local d = (screenPos - center).Magnitude
                if d < dist then
                    closest = head
                    dist = d
                end
            end
        end
    end
    return closest
end

runService.RenderStepped:Connect(function()
    local settings = _G.BetterRivalsSettings
    if not settings then return end
    
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if char and root then
        if not hasWeapon() then
            if root:FindFirstChild("BR_Fly") then root.BR_Fly:Destroy() end
            char.Humanoid.PlatformStand = false
            return
        end

        forceGameSettings()
        local target = getClosestVisibleTarget()

        if target and settings.AutoAim then
            local tPos = camera:WorldToViewportPoint(target.Position)
            local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y * 0.42)
            local diff = Vector2.new(tPos.X, tPos.Y) - center
            if mousemoverel then
                mousemoverel(diff.X * 0.3, diff.Y * 0.3)
            end
            
            if settings.AutoShoot and diff.Magnitude < 30 then
                if not _G.ShotCooldown or tick() - _G.ShotCooldown > 0.12 then
                    if mouse1click then 
                        mouse1click() 
                    elseif mouse1press then
                        mouse1press()
                        task.wait(0.02)
                        mouse1release()
                    end
                    _G.ShotCooldown = tick()
                end
            end
        end

        if settings.Fly then
            local bv = root:FindFirstChild("BR_Fly") or Instance.new("BodyVelocity", root)
            bv.Name = "BR_Fly"
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            
            local moveDir = Vector3.new(0,0,0)
            if userInput:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if userInput:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if userInput:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if userInput:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
            
            if moveDir.Magnitude > 0 then
                bv.Velocity = moveDir.Unit * (settings.FlySpeed * 35)
            else
                bv.Velocity = Vector3.new(0,0,0)
            end
            char.Humanoid.PlatformStand = true
        else
            if root:FindFirstChild("BR_Fly") then root.BR_Fly:Destroy() end
            char.Humanoid.PlatformStand = false
        end
    end
end)
