local Main = {
    Status = { 
        Sky = false, 
        Weapon = false 
    },
    Assets = {
        ["Night-Sky"] = {
            Bk = "rbxassetid://126573945551190",
            Dn = "rbxassetid://115443898978952",
            Ft = "rbxassetid://101479513398061",
            Lf = "rbxassetid://116991307580716",
            Rt = "rbxassetid://99792927739485",
            Up = "rbxassetid://90829753884118"
        },
        ["Galaxy"] = "rbxassetid://102550976675126"
    },
    Dictionary = {
        ["Scharfschützengewehr"] = "Sniper",
        ["Sturmgewehr"] = "Assault Rifle",
        ["Salvengewehr"] = "Burst Rifle",
        ["Schrotflinte"] = "Shotgun",
        ["Uzi"] = "Uzi",
        ["Minigun"] = "Minigun",
        ["RPG"] = "RPG",
        ["Flammenwerfer"] = "Flamethrower",
        ["Armbrust"] = "Crossbow",
        ["Bogen"] = "Bow",
        ["Pistole"] = "Handgun",
        ["Revolver"] = "Revolver",
        ["Katana"] = "Katana",
        ["Messer"] = "Knife",
        ["Streitkolben"] = "Maul",
        ["Kampfaxt"] = "Battle Axe",
        ["Kettensäge"] = "Chainsaw",
        ["Dolche"] = "Daggers"
    },
    CurrentSky = "Empty",
    CurrentColor = "Empty",
    TargetWeapon = "Empty"
}

_G.MainLogic = Main

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local function getInternalName(inputName)
    if inputName == "Empty" then return "Empty" end
    return Main.Dictionary[inputName] or inputName
end

local function applySkinDeep(object, textureId)
    if object:IsA("MeshPart") or object:IsA("SpecialMesh") then
        local prop = object:IsA("MeshPart") and "TextureID" or "TextureId"
        if object[prop] ~= textureId then
            object[prop] = textureId
        end
    end
    for _, child in pairs(object:GetChildren()) do
        applySkinDeep(child, textureId)
    end
end

RunService.RenderStepped:Connect(function()
    if Main.Status.Weapon and Main.CurrentColor ~= "Empty" then
        local texId = Main.Assets[Main.CurrentColor]
        local searchName = getInternalName(Main.TargetWeapon)
        
        for _, model in pairs(Camera:GetChildren()) do
            if model:IsA("Model") then
                if searchName == "Empty" or string.find(model.Name:lower(), searchName:lower()) then
                    applySkinDeep(model, texId)
                end
            end
        end
    end
end)

function Main.UpdateSky(name)
    Main.CurrentSky = name
    local targetSky = Lighting:FindFirstChild("LightingController")
    if not Main.Status.Sky or name == "Empty" or not targetSky then return end
    local skyData = Main.Assets[name]
    if type(skyData) == "table" then
        targetSky.SkyboxBk = skyData.Bk
        targetSky.SkyboxDn = skyData.Dn
        targetSky.SkyboxFt = skyData.Ft
        targetSky.SkyboxLf = skyData.Lf
        targetSky.SkyboxRt = skyData.Rt
        targetSky.SkyboxUp = skyData.Up
        targetSky.SunAngularSize = 0
        targetSky.MoonAngularSize = 0
    end
end

return Main
