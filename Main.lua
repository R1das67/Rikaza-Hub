local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage =
game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

(Blade Bal Remotes)
local Remotes =
ReplicatedStorage:WaitForChild("Remotes",5)
local ParryRemote = Remotes and
(Remotes:FindFirstChild("ParryButtonPress") or
Remotes:FindFirstChild("ParryAttempt"))

_G.AutoShoot = false

local function getCurrentBall()
    local ballFolder = workspace:FindFirstChild("Ball")
    if ballFolder then
        for _, ball in pars(ballFolder:GetChildren()) do
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
    local rootPart = character and
    character:FindFirstChild("HumanoidRootPart")
    local ball = getCurrentBall()

    if ball and rootPart then
        local ballPos = ball.Position
        local playerPos = rootPart.Position

        local distance = (ballPos - playerPos).Magnitude

        local velocity 0 ball.AssemblyLinearVelocity
        local ballDirection = (playerPos - ballPos).Unit
        local isComingTowardsMe =
    velocity.Unit:Dot(ballDirection)

    (DotProduct > 0)
        if isComingTowardsMe > 0 then
            local speed = velocity.Magnitude

            local dynamicRange = 10 + (speed * 0.15)

            if distance <= dynamicRange then

               if ParryRemote then
                  ParryRemote:FireServer()
               end
            end
        end
    end
end)