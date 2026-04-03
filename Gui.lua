local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

if pgui:FindFirstChild("BetterRivalsUI") then pgui.BetterRivalsUI:Destroy() end

_G.BetterRivalsSettings = _G.BetterRivalsSettings or {
    AutoAim = false,
    AutoShoot = false,
    Fly = false,
    ReactionTime = 1,
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

local container = Instance.new("Frame")
container.Name = "ContentContainer"
container.Size = UDim2.new(0, 350, 1, -80)
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
    btn.Size = UDim2.new(0, 160, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, 80 + (order * 50))
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = main
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do t.Visible = false end
        f.Visible = true
    end)
    return f
end

local function addStatus(parent, key)
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
    off.Parent = frame

    local on = Instance.new("TextButton")
    on.Text = "ON"
    on.Size = UDim2.new(0, 60, 0, 30)
    on.Position = UDim2.new(0, 170, 0.5, -15)
    on.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    on.TextColor3 = Color3.new(1, 1, 1)
    on.Parent = frame

    off.MouseButton1Click:Connect(function()
        _G.BetterRivalsSettings[key] = false
        off.TextColor3 = Color3.fromRGB(255, 0, 0)
        on.TextColor3 = Color3.new(1, 1, 1)
    end)

    on.MouseButton1Click:Connect(function()
        _G.BetterRivalsSettings[key] = true
        on.TextColor3 = Color3.fromRGB(0, 255, 0)
        off.TextColor3 = Color3.new(1, 1, 1)
    end)
end

local function addInput(parent, name, min, max, yPos, key)
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
    box.Text = tostring(_G.BetterRivalsSettings[key])
    box.Parent = parent

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            local clamped = math.clamp(math.floor(val), min, max)
            _G.BetterRivalsSettings[key] = clamped
            box.Text = tostring(clamped)
        else
            box.Text = tostring(_G.BetterRivalsSettings[key])
        end
    end)
end

local aimTab = createTab("Auto-Aim", 0)
addStatus(aimTab, "AutoAim")

local shootTab = createTab("Auto-Shoot", 1)
addStatus(shootTab, "AutoShoot")
addInput(shootTab, "Reaktionszeit (1-50):", 1, 50, 50, "ReactionTime")

local flyTab = createTab("Fly", 2)
addStatus(flyTab, "Fly")
addInput(flyTab, "Speed (1-80):", 1, 80, 50, "FlySpeed")

tabs["Auto-Aim"].Visible = true
