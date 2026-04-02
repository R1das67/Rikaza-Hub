local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local BallEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BallUpdate")
local ParryRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ParryEvent")

BallEvent.OnClientEvent:Connect(function(data)
    if data.Target == LocalPlayer or data.Target == LocalPlayer.Character then
        local char = LocalPlayer.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local distance = (data.Position - root.Position).Magnitude
        local timeToHit = distance / data.Speed
        
        task.wait(timeToHit - 0.04)
        
        ParryRemote:FireServer()
    end
end)
