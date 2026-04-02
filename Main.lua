local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function getParryEvent()
    for _, desc in pairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") or desc:IsA("BindableEvent") then
            if desc.Name:find("Parry") or desc.Name:find("Click") then
                return desc
            end
        end
    end
    return nil
end

local ParryEvent = getParryEvent()

local function isBallTargetingMe(obj, rootPart)
    local relativePos = rootPart.Position - obj.Position
    local velocity = obj.AssemblyLinearVelocity
    if velocity.Magnitude < 5 then return false end
    local dot = velocity.Unit:Dot(relativePos.Unit)
    if dot > 0.1 then
        local distance = relativePos.Magnitude
        local speed = velocity.Magnitude
        local timeToHit = distance / speed
        if timeToHit < 1.5 or distance < 30 then
            return true
        end
    end
    return false
end

RunService.Heartbeat:Connect(function()
    if not _G.AutoShoot then return end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local ball = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.CanCollide and not obj:IsDescendantOf(character) then
            if isBallTargetingMe(obj, rootPart) then
                ball = obj
                break
            end
        end
    end
    if ball then
        local distance = (ball.Position - rootPart.Position).Magnitude
        local speed = ball.AssemblyLinearVelocity.Magnitude
        local triggerDistance = 15 + (speed * 0.45)
        if distance <= triggerDistance then
            if ParryEvent then
                if ParryEvent:IsA("RemoteEvent") then
                    ParryEvent:FireServer()
                else
                    ParryEvent:Fire()
                end
            end
        end
    end
end)
