local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local ParryEvent = nil

if Remotes then
    for _, child in pairs(Remotes:GetChildren()) do
        if (child:IsA("RemoteEvent") or child:IsA("BindableEvent")) and (child.Name:find("Parry") or child.Name:find("Click")) then
            ParryEvent = child
            break
        end
    end
end

_G.AutoShoot = false

local function getCurrentBall()
    local folders = {workspace:FindFirstChild("Balls"), workspace:FindFirstChild("Ball")}
    for _, ballFolder in pairs(folders) do
        if ballFolder then
            for _, ball in pairs(ballFolder:GetChildren()) do
                if ball:IsA("BasePart") or ball:IsA("MeshPart") then
                    return ball
                end
            end
        end
    end
    return nil
end

RunService.PostSimulation:Connect(function()
    if not _G.AutoShoot then return end
    
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local ball = getCurrentBall()
    
    if ball and rootPart then
        local distance = (ball.Position - rootPart.Position).Magnitude
        local velocity = ball.AssemblyLinearVelocity
        local speed = velocity.Magnitude
        
        local ballDirection = (rootPart.Position - ball.Position).Unit
        local isComingTowardsMe = velocity.Unit:Dot(ballDirection)
        
        if isComingTowardsMe > 0.1 or distance < 20 then
            local dynamicRange = 18 + (speed * 0.25)
            
            if distance <= dynamicRange then
                if ParryEvent then
                    if ParryEvent:IsA("RemoteEvent") then
                        ParryEvent:FireServer()
                    else
                        ParryEvent:Fire()
                    end
                end
            end
        end
    end
end)
