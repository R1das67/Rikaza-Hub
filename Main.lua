local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local ParryRemote = nil

if Remotes then
    ParryRemote = Remotes:FindFirstChild("ParryButtonPress") 
               or Remotes:FindFirstChild("ParryAttempt") 
               or Remotes:FindFirstChild("RemoteEvent")
end

_G.AutoShoot = false

local function getCurrentBall()
    local ballFolder = workspace:FindFirstChild("Balls")
    if ballFolder then
        for _, ball in pairs(ballFolder:GetChildren()) do
            if ball:GetAttribute("realBall") == true then
                return ball
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
        local ballPos = ball.Position
        local playerPos = rootPart.Position
        local distance = (ballPos - playerPos).Magnitude
        local velocity = ball.AssemblyLinearVelocity
        
        local ballDirection = (playerPos - ballPos).Unit
        local isComingTowardsMe = velocity.Unit:Dot(ballDirection)
        
        if isComingTowardsMe > 0.1 then
            local speed = velocity.Magnitude
            local dynamicRange = 12 + (speed * 0.2)
            
            if distance <= dynamicRange then
                if ParryRemote then
                    ParryRemote:FireServer()
                end
            end
        end
    end
end)
