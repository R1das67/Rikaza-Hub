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

local title = Instance.new("TextLabel")
title.Text = "Better Rivals"
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 20, 0, 15)
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1
title.Parent = main

local sub = Instance.new("TextLabel")
sub.Text = "made by rikaza"
sub.Size = UDim2.new(0, 200, 0, 20)
sub.Position = UDim2.new(0, 20, 0, 38)
sub.TextColor3 = Color3.fromRGB(180, 180, 180)
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Font = Enum.Font.Gotham
sub.TextSize = 13
sub.BackgroundTransparency = 1
sub.Parent = main

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 160, 1, -80)
sidebar.Position = UDim2.new(0, 10, 0, 80)
sidebar.BackgroundTransparency = 1
sidebar.Parent = main

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 350, 1, -80)
container.Position = UDim2.new(0, 180, 0, 80)
container.BackgroundTransparency = 1
container.Parent = main

local tabs = {}

local function createTab(name, iconAssetId)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.Parent = container
    tabs[name] = f
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    btn.Text = "          " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    btn.Parent = sidebar
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 25, 0, 25)
    icon.Position = UDim2.new(0, 10, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Image = iconAssetId
    icon.ImageColor3 = Color3.new(1, 1, 1)
    icon.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do t.Visible = false end
        f.Visible = true
    end)
    return f
end

local function addStatus(parent, settingKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = "Status:"
    label.Size = UDim2.new(0, 80, 1, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local off = Instance.new("TextButton")
    off.Text = "OFF"
    off.Size = UDim2.new(0, 60, 0, 30)
    off.Position = UDim2.new(0, 100, 0.5, -15)
    off.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    off.TextColor3 = Color3.fromRGB(255, 0, 0)
    off.Font = Enum.Font.GothamBold
    off.Parent = frame

    local on = Instance.new("TextButton")
    on.Text = "ON"
    on.Size = UDim2.new(0, 60, 0, 30)
    on.Position = UDim2.new(0, 170, 0.5, -15)
    on.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    on.TextColor3 = Color3.new(1, 1, 1)
    on.Font = Enum.Font.GothamBold
    on.Parent = frame

    off.MouseButton1Click:Connect(function()
        off.TextColor3 = Color3.fromRGB(255, 0, 0)
        on.TextColor3 = Color3.new(1, 1, 1)
        _G.BetterRivalsSettings[settingKey] = false
    end)

    on.MouseButton1Click:Connect(function()
        on.TextColor3 = Color3.fromRGB(0, 255, 0)
        off.TextColor3 = Color3.new(1, 1, 1)
        _G.BetterRivalsSettings[settingKey] = true
    end)
end

local function addInput(parent, name, min, max, yPos, settingKey)
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0, 180, 0, 30)
    label.Position = UDim2.new(0, 0, 0, yPos)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = parent

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 70, 0, 30)
    box.Position = UDim2.new(0, 190, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Text = tostring(min)
    box.Parent = parent

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            local clamped = math.clamp(math.floor(val), min, max)
            box.Text = tostring(clamped)
            _G.BetterRivalsSettings[settingKey] = clamped
        else
            box.Text = tostring(min)
            _G.BetterRivalsSettings[settingKey] = min
        end
    end)
end

local aim = createTab("Auto-Aim", "rbxassetid://1000042846")
addStatus(aim, "AutoAim")

local shoot = createTab("Auto-Shoot", "rbxassetid://1000042848")
addStatus(shoot, "AutoShoot")
addInput(shoot, "Reaktionszeit (1-50s):", 1, 50, 50, "ReactionTime")

local fly = createTab("Fly", "rbxassetid://1000042850")
addStatus(fly, "Fly")
addInput(fly, "High (5-70m):", 5, 70, 50, "FlyHeight")
addInput(fly, "Fly-Geschw. (1-80):", 1, 80, 90, "FlySpeed")

tabs["Auto-Aim"].Visible = true
