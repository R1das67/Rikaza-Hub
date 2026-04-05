local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

local function getRealCrosshairPos()
    local pgui = player:FindFirstChild("PlayerGui")
    local hud = pgui and (pgui:FindFirstChild("HUD") or pgui:FindFirstChild("Gui"))
    local cross = hud and (hud:FindFirstChild("Crosshair", true) or hud:FindFirstChild("Cursor", true))
    if cross and cross:IsA("GuiObject") and cross.AbsolutePosition.X > 0 then
        return cross.AbsolutePosition + (cross.AbsoluteSize / 2)
    end
    return Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y * 0.42)
end

local function hasWeapon()
    local char = player.Character
    return char and char:FindFirstChildOfClass("Tool") ~= nil
end

local function getTargetInCircle(center)
    local closest, dist = nil, 80 
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local pos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
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
    local s = _G.BetterRivalsSettings
    if not s or not hasWeapon() then 
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = false
        end
        return 
    end

    local char = player.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    local crossPos = getRealCrosshairPos()
    local target = getTargetInCircle(crossPos)

    if target and s.AimLock then
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        
        if s.AutoShoot then
            local tPos = camera:WorldToViewportPoint(target.Position)
            local diff = (Vector2.new(tPos.X, tPos.Y) - crossPos).Magnitude
            
            if diff < 20 then
                if not _G.ShotCooldown or tick() - _G.ShotCooldown > 0.05 then
                    if mouse1click then 
                        mouse1click() 
                    elseif mouse1press then
                        mouse1press()
                        task.wait(0.01)
                        mouse1release()
                    end
                    _G.ShotCooldown = tick()
                end
            end
        end
    end

    if s.Fly and root then
        local bv = root:FindFirstChild("BR_Fly") or Instance.new("BodyVelocity", root)
        bv.Name = "BR_Fly"
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        local md = Vector3.new(0,0,0)
        if userInput:IsKeyDown(Enum.KeyCode.W) then md = md + camera.CFrame.LookVector end
        if userInput:IsKeyDown(Enum.KeyCode.S) then md = md - camera.CFrame.LookVector end
        if userInput:IsKeyDown(Enum.KeyCode.A) then md = md - camera.CFrame.RightVector end
        if userInput:IsKeyDown(Enum.KeyCode.D) then md = md + camera.CFrame.RightVector end
        bv.Velocity = md.Magnitude > 0 and md.Unit * (s.FlySpeed * 35) or Vector3.new(0,0,0)
        char.Humanoid.PlatformStand = true
    else
        if root and root:FindFirstChild("BR_Fly") then root.BR_Fly:Destroy() end
        if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
    end
end)
