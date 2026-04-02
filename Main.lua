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
_G.AutoShoot = false

local function findTargetBall()
    local character = LocalPlayer.Character
    if not character then return nil end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local bestBall = nil
    local closestTargeting = -1 

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(character) then
            local velocity = obj.AssemblyLinearVelocity
            if velocity.Magnitude > 15 then 
                local directionToMe = (rootPart.Position - obj.Position).Unit
                local moveDirection = velocity.Unit
                
                -- Punktprodukt: 1 bedeutet, er fliegt exakt auf dich zu
                local dotProduct = moveDirection:Dot(directionToMe)
                
                -- Nur Bälle beachten, die wirklich Richtung Spieler fliegen (Dot > 0.5)
                if dotProduct > 0.5 then
                    local distance = (obj.Position - rootPart.Position).Magnitude
                    if distance < 250 then
                        return obj 
                    end
                end
            end
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not _G.AutoShoot then return end
    
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local ball = findTargetBall()
    
    if ball and rootPart then
        local distance = (ball.Position - rootPart.Position).Magnitude
        local speed = ball.AssemblyLinearVelocity.Magnitude
        
        local triggerDistance = 15 + (speed * 0.35)
        
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
