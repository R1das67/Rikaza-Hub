local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local function getCrosshairPos()
    local pgui = player:WaitForChild("PlayerGui")
    -- Rivals nutzt oft Namen wie "Cursor", "Center" oder "Crosshair" in ihrem HUD
    local hud = pgui:FindFirstChild("HUD") or pgui:FindFirstChild("Gui")
    local cross = hud and (hud:FindFirstChild("Crosshair", true) or hud:FindFirstChild("Cursor", true))
    
    if cross and cross:IsA("GuiObject") then
        return Vector2.new(cross.AbsolutePosition.X + (cross.AbsoluteSize.X/2), cross.AbsolutePosition.Y + (cross.AbsoluteSize.Y/2))
    end
    return camera.ViewportSize / 2
end

local function getClosestPlayer()
    local closest = nil
    local dist = math.huge
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid").Health > 0 then
            local char = p.Character
            local targetPart = char:FindFirstChild("HumanoidRootPart") -- Standard: Torso
            
            -- Spezialfall: Scharfschützengewehr soll auf den Kopf zielen
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool and tool.Name:find("Scharfschützengewehr") and char:FindFirstChild("Head") then
                targetPart = char.Head
            end

            local _, onScreen = camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local magnitude = (targetPart.Position - myRoot.Position).Magnitude
                if magnitude < dist then
                    closest = targetPart
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
            if target then
                local crossPos = getCrosshairPos()
                local targetPos, onScreen = camera:WorldToViewportPoint(target.Position)
                local targetVec = Vector2.new(targetPos.X, targetPos.Y)
                
                if s.AutoAim and onScreen then
                    local diff = targetVec - crossPos
                    if mousemoverel then
                        mousemoverel(diff.X * 0.45, diff.Y * 0.45)
                    end
                end

                if s.AutoShoot then
                    local distToCrosshair = (targetVec - crossPos).Magnitude
                    if distToCrosshair < 50 then
                        task.wait(s.ReactionTime * 0.01)
                        if mouse1press then
                            mouse1press()
                            task.wait(0.02)
                            mouse1release()
                        end
                    end
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
            local camCF = camera.CFrame
            local direction = (camCF.LookVector * -moveDir.Z) + (camCF.RightVector * moveDir.X)
            bv.Velocity = direction.Unit * speed
        else
            bv.Velocity = Vector3.new(0, 0, 0)
        end
    else
        if hum then hum.PlatformStand = false end
        if root and root:FindFirstChild("BetterRivalsFly") then root.BetterRivalsFly:Destroy() end
    end
end)
