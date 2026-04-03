local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

if pgui:FindFirstChild("BetterRivalsUI") then pgui.BetterRivalsUI:Destroy() end

-- Einstellungen ohne ReactionTime (da intern auf 10ms festgesetzt)
_G.BetterRivalsSettings = _G.BetterRivalsSettings or {
    AutoAim = false,
    AutoShoot = false,
    Fly = false,
    FlySpeed = 2
}

local sgui = Instance.new("ScreenGui")
sgui.Name = "BetterRivalsUI"
sgui.ResetOnSpawn = false
sgui.Parent = pgui

-- HAUPTFENSTER
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 500, 0, 350)
main.Position = UDim2.new(0.5, -250, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sgui

-- Fenster-Toggle mit Taste 'K'
userInput.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        main.Visible = not main.Visible
    end
end)

local title = Instance.new("TextLabel")
title.Text = "Better Rivals"
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 20, 0, 15)
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundTransparency = 1
title.Parent = main

local sub = Instance.new("TextLabel")
sub.Text = "made by rikaza | Taste [K] zum Verstecken"
sub.Size = UDim2.new(0, 300, 0, 20)
sub.Position = UDim2.new(0, 20, 0, 38)
sub.TextColor3 = Color3.fromRGB(150, 150, 150)
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Font = Enum.Font.Gotham
sub.TextSize = 12
sub.BackgroundTransparency = 1
sub.Parent = main

local container = Instance.new("Frame")
container.Name = "ContentContainer"
container.Size = UDim2.new(0, 300, 1, -80)
container.Position = UDim2.new(0, 180, 0, 80)
container.BackgroundTransparency = 1
container.Parent = main

local tabs = {}

local function createTab(name, order)
    local f = Instance.new("Frame")
    f.Name = name .. "Tab"
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.Parent = container
    tabs[name] = f
    
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Btn"
    btn.Size = UDim2.new(0, 150, 0, 45)
    btn.Position = UDim2.new(0, 15, 0, 80 + (order * 55))
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = main
    
    -- UI Corner für Buttons
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do t.Visible = false end
        f.Visible = true
    end)
    return f
end

local function addStatus(parent, key, labelText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Text = labelText or "Status:"
    label.Size = UDim2.new(0, 150, 0, 25)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local off = Instance.new("TextButton")
    off.Text = "OFF"
    off.Size = UDim2.new(0, 80, 0, 30)
    off.Position = UDim2.new(0, 0, 0, 30)
    off.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    off.TextColor3 = _G.BetterRivalsSettings[key] == false and Color3.fromRGB(255, 50, 50) or Color3.new(1, 1, 1)
    off.Parent = frame
    
    local on = Instance.new("TextButton")
    on.Text = "ON"
    on.Size = UDim2.new(0, 80, 0, 30)
    on.Position = UDim2.new(0, 90, 0, 30)
    on.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    on.TextColor3 = _G.BetterRivalsSettings[key] == true and Color3.fromRGB(50, 255, 50) or Color3.new(1, 1, 1)
    on.Parent = frame

    off.MouseButton1Click:Connect(function()
        _G.BetterRivalsSettings[key] = false
        off.TextColor3 = Color3.fromRGB(255, 50, 50)
        on.TextColor3 = Color3.new(1, 1, 1)
    end)
    on.MouseButton1Click:Connect(function()
        _G.BetterRivalsSettings[key] = true
        on.TextColor3 = Color3.fromRGB(50, 255, 50)
        off.TextColor3 = Color3.new(1, 1, 1)
    end)
end

local function addInput(parent, name, min, max, yPos, key)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0, 150, 1, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 80, 0, 30)
    box.Position = UDim2.new(0, 160, 0.5, -15)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Text = tostring(_G.BetterRivalsSettings[key])
    box.Parent = frame
    
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            local clamped = math.clamp(val, min, max)
            _G.BetterRivalsSettings[key] = clamped
            box.Text = tostring(clamped)
        else
            box.Text = tostring(_G.BetterRivalsSettings[key])
        end
    end)
end

-- TABS ERSTELLEN
local aimTab = createTab("Auto-Aim", 0)
addStatus(aimTab, "AutoAim", "Aim-Magnet Status:")

local shootTab = createTab("Auto-Shoot", 1)
addStatus(shootTab, "AutoShoot", "Trigger Status (10ms):")

local flyTab = createTab("Fly", 2)
addStatus(flyTab, "Fly", "Flug-Modus Status:")
addInput(flyTab, "Flug-Speed (1-80):", 1, 80, 65, "FlySpeed")

tabs["Auto-Aim"].Visible = true
