local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

if pgui:FindFirstChild("BetterRivalsUI") then pgui.BetterRivalsUI:Destroy() end

_G.BetterRivalsSettings = _G.BetterRivalsSettings or {
    AutoAim = false,
    AutoShoot = false,
    Fly = false,
    ReactionTime = 1,
    FlyHeight = 5,
    FlySpeed = 1
}

local sgui = Instance.new("ScreenGui")
sgui.Name = "BetterRivalsUI"
sgui.ResetOnSpawn = false
sgui.Parent = pgui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 550, 0, 400)
main.Position = UDim2.new(0.5, -275, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sgui

-- Container für die Tab-Inhalte
local container = Instance.new("Frame")
container.Name = "ContentContainer"
container.Size = UDim2.new(0, 350, 1, -80)
container.Position = UDim2.new(0, 180, 0, 80)
container.BackgroundTransparency = 1
container.Parent = main

local tabs = {}

local function createTab(name, iconId, order)
    local f = Instance.new("Frame")
    f.Name = name .. "Tab"
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.Parent = container
    tabs[name] = f
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, 80 + (order * 50))
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    btn.Text = "          " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    btn.Parent = main
    
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 25, 0, 25)
    img.Position = UDim2.new(0, 10, 0.5, -12)
    img.Image = iconId
    img.ImageColor3 = Color3.new(1, 1, 1)
    img.BackgroundTransparency = 1
    img.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do t.Visible = false end
        f.Visible = true
    end)
    return f
end

-- STATUS-LOGIK (ON/OFF)
local function addStatus(parent, key)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local off = Instance.new("TextButton")
    off.Text = "OFF"
    off.Size = UDim2.new(0, 60, 0, 30)
    off.Position = UDim2.new(0, 100, 0, 5)
    off.TextColor3 = Color3.fromRGB(255, 0, 0)
    off.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    off.Parent = frame

    local on = Instance.new("TextButton")
    on.Text = "ON"
    on.Size = UDim2.new(0, 60, 0, 30)
    on.Position = UDim2.new(0, 170, 0, 5)
    on.TextColor3 = Color3.new(1, 1, 1)
    on.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    on.Parent = frame

    off.MouseButton1Click:Connect(function()
        off.TextColor3 = Color3.fromRGB(255, 0, 0)
        on.TextColor3 = Color3.new(1, 1, 1)
        _G.BetterRivalsSettings[key] = false
    end)

    on.MouseButton1Click:Connect(function()
        on.TextColor3 = Color3.fromRGB(0, 255, 0)
        off.TextColor3 = Color3.new(1, 1, 1)
        _G.BetterRivalsSettings[key] = true
    end)
end

-- INPUT-LOGIK (ZAHLEN)
local function addInput(parent, name, min, max, y, key)
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0, 150, 0, 30)
    label.Position = UDim2.new(0, 0, 0, y)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 70, 0, 30)
    box.Position = UDim2.new(0, 190, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Text = tostring(_G.BetterRivalsSettings[key])
    box.Parent = parent

    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then
            local val = math.clamp(math.floor(n), min, max)
            _G.BetterRivalsSettings[key] = val
            box.Text = tostring(val)
        else
            box.Text = tostring(_G.BetterRivalsSettings[key])
        end
    end)
end

-- TABS ERSTELLEN UND BEFÜLLEN
local aimTab = createTab("Auto-Aim", "rbxassetid://1000042846", 0)
addStatus(aimTab, "AutoAim")

local shootTab = createTab("Auto-Shoot", "rbxassetid://1000042848", 1)
addStatus(shootTab, "AutoShoot")
addInput(shootTab, "Reaktionszeit (1-50):", 1, 50, 50, "ReactionTime")

local flyTab = createTab("Fly", "rbxassetid://1000042850", 2)
addStatus(flyTab, "Fly")
addInput(flyTab, "Höhe (5-70m):", 5, 70, 50, "FlyHeight")
addInput(flyTab, "Speed (1-80):", 1, 80, 90, "FlySpeed")

-- Standard-Tab anzeigen
tabs["Auto-Aim"].Visible = true
