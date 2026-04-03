local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

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

runService.RenderStepped:Connect(function()
    local s = _G.BetterRivalsSettings
    if not s then return end
    
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    local tool = char and char:FindFirstChildOfClass("Tool")

    if tool then
        local n = tool.Name
        local ignore = n:find("Fäuste") or n:find("Messer") or n:find("Granate") or n:find("Molotow") or n:find("Schild") or n:find("Dolch") or n:find("Axt") or n:find("Kettensäge") or n:find("Katana") or n:find("Sense") or n:find("Rucksack") or n:find("Kriegshorn") or n:find("Sprungbrett")
        
        if not ignore then
            local target = getClosestPlayer()
            
            if s.AutoAim and target then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end

            if s.AutoShoot and target and not n:find("Scharfschützengewehr") then
                task.wait(s.ReactionTime * 0.01) 
                if mouse1press then
                    mouse1press()
                    task.wait(0.02)
                    mouse1release()
                end
            end
        end
    end

    if s.Fly and root and hum then
        local bv = root:FindFirstChild("BetterRivalsFly") or Instance.new("BodyVelocity")
        bv.Name = "BetterRivalsFly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = root
        hum.PlatformStand = true 
        
        local speed = (s.FlySpeed or 1) * 20
        local moveDir = hum.MoveDirection
        
        if moveDir.Magnitude > 0 then
            -- Berechnet die Richtung basierend auf Kamera-Blickwinkel und WASD-Input
            local camCF = camera.CFrame
            local direction = (camCF.LookVector * moveDir.Z) + (camCF.RightVector * moveDir.X)
            bv.Velocity = direction.Unit * speed
        else
            bv.Velocity = Vector3.new(0, 0, 0)
        end
    else
        if hum then hum.PlatformStand = false end
        if root and root:FindFirstChild("BetterRivalsFly") then
            root.BetterRivalsFly:Destroy()
        end
    end
end)
