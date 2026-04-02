local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Suche nach den Remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local ParryEvent = nil

if Remotes then
    -- Wir suchen intelligent nach dem richtigen Event, das KEIN BindableEvent ist
    for _, child in pairs(Remotes:GetChildren()) do
        if child:IsA("RemoteEvent") and (child.Name:find("Parry") or child.Name:find("Click")) then
            ParryEvent = child
            break
        end
    end
    
    -- Falls die Suche oben nichts findet, nehmen wir den Standard-Namen als Backup
    if not ParryEvent then
        ParryEvent = Remotes:FindFirstChild("ParryButtonPress")
    end
end

_G.AutoShoot = false

local function getCurrentBall()
    local ballFolder = workspace:FindFirstChild("Balls")
    if ballFolder then
        for _, ball in pairs(ballFolder:GetChildren()) do
            -- Check, ob es der echte Spielball ist
            if ball:GetAttribute("realBall") == true or ball:FindFirstChild("zoomies") then
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
        
        -- Prüfen, ob der Ball auf den Spieler zufliegt
        local ballDirection = (playerPos - ballPos).Unit
        local isComingTowardsMe = velocity.Unit:Dot(ballDirection)
        
        if isComingTowardsMe > 0.1 then
            local speed = velocity.Magnitude
            -- Dynamische Reichweite (angepasst für Ping auf PC/iPad)
            local dynamicRange = 12 + (speed * 0.22)
            
            if distance <= dynamicRange then
                if ParryEvent then
                    -- Hier ist der Fix: Wir prüfen, welche Methode wir nutzen müssen
                    if ParryEvent:IsA("RemoteEvent") then
                        ParryEvent:FireServer()
                    elseif ParryEvent:IsA("BindableEvent") then
                        ParryEvent:Fire()
                    end
                end
            end
        end
    end
end)
