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

    if s.AutoAim and tool then
        local n = tool.Name:lower()
        if not (n:find("sniper") or n:find("fist") or n:find("flare") or n:find("sign") or n:find("knife")) then
            local target = getClosestPlayer()
            if target then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end
        end
    end

    if s.AutoShoot and tool then
        local target = getClosestPlayer()
        if target then
            task.wait(s.ReactionTime * 0.01) 
            mouse1press()
            task.wait(0.05)
            mouse1release()
        end
    end

    if s.Fly and root and hum then
        local bv = root:FindFirstChild("BetterRivalsFly") or Instance.new("BodyVelocity")
        bv.Name = "BetterRivalsFly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = root
        
        hum.PlatformStand = true 
        
        local speed = s.FlySpeed * 10
        if hum.MoveDirection.Magnitude > 0 then
            bv.Velocity = camera.CFrame.LookVector * speed
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
