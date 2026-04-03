local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- Funktion zum Finden des nächsten Gegners (für Auto-Aim)
local function getClosestPlayer()
    local closest = nil
    local dist = math.huge
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid").Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if magnitude < dist then
                    closest = p.Character.HumanoidRootPart
                    dist = magnitude
                end
            end
        end
    end
    return closest
end

-- Haupt-Loop
runService.RenderStepped:Connect(function()
    local s = _G.BetterRivalsSettings
    if not s then return end
    
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local tool = char and char:FindFirstChildOfClass("Tool")

    -- 1. HANDLUNG: AUTO-AIM
    if s.AutoAim and tool then
        local n = tool.Name:lower()
        -- Waffen-Filter (Sniper, Fäuste, etc. ignorieren)
        if not (n:find("sniper") or n:find("fist") or n:find("flare") or n:find("sign")) then
            local target = getClosestPlayer()
            if target then
                -- Hier wird die Kamera wirklich auf den Gegner gedreht
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end
        end
    end

    -- 2. HANDLUNG: AUTO-SHOOT
    if s.AutoShoot and tool then
        local target = getClosestPlayer()
        if target then
            -- Reaktionszeit Delay (s.ReactionTime 1-50)
            task.wait(s.ReactionTime * 0.01) 
            -- Simuliert den Linksklick
            mouse1press()
            task.wait(0.05)
            mouse1release()
        end
    end

    -- 3. HANDLUNG: FLY
    if s.Fly and root then
        local bv = root:FindFirstChild("BetterRivalsFly") or Instance.new("BodyVelocity")
        bv.Name = "BetterRivalsFly"
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bv.Parent = root
        
        local targetY = s.FlyHeight or 5
        local speed = s.FlySpeed or 1
        
        -- Bewegt den Charakter basierend auf Input und Speed
        local moveDir = char.Humanoid.MoveDirection
        bv.Velocity = (moveDir * speed) + Vector3.new(0, (targetY - root.Position.Y) * 5, 0)
    else
        if root and root:FindFirstChild("BetterRivalsFly") then
            root.BetterRivalsFly:Destroy()
        end
    end
end)
