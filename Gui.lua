local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local StandbyFrame = Instance.new("Frame")
local UICornerMain = Instance.new("UICorner")
local UICornerStandby = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local StandbyTitle = Instance.new("TextLabel")
local Arrow = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local Divider = Instance.new("Frame")
local CategoryLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
local StatusLight = Instance.new("Frame")
local LightCorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "RikazaHub"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.325, 0, 0.275, 0) 
MainFrame.Size = UDim2.new(0.35, 0, 0.45, 0)
MainFrame.Draggable = true
MainFrame.Active = true

UICornerMain.CornerRadius = UDim.new(0, 15)
UICornerMain.Parent = MainFrame

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0.02, 0)
Title.Size = UDim2.new(0.7, 0, 0.15, 0)
Title.Text = "⚜️ Rikaza Hub ⚜️"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

Divider.Parent = MainFrame
Divider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0.05, 0, 0.18, 0)
Divider.Size = UDim2.new(0.9, 0, 0, 1)

CloseButton.Parent = MainFrame
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(0.88, 0, 0.02, 0)
CloseButton.Size = UDim2.new(0.1, 0, 0.12, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold

StandbyFrame.Parent = ScreenGui
StandbyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StandbyFrame.Position = UDim2.new(0.35, 0, 0.02, 0)
StandbyFrame.Size = UDim2.new(0.3, 0, 0.08, 0)
StandbyFrame.Visible = false
StandbyFrame.Draggable = true
StandbyFrame.Active = true

UICornerStandby.CornerRadius = UDim.new(0, 10)
UICornerStandby.Parent = StandbyFrame

StandbyTitle.Parent = StandbyFrame
StandbyTitle.BackgroundTransparency = 1
StandbyTitle.Size = UDim2.new(0.8, 0, 1, 0)
StandbyTitle.Text = "⚜️ Rikaza Hub ⚜️"
StandbyTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
StandbyTitle.TextScaled = true
StandbyTitle.Font = Enum.Font.GothamBold

CategoryLabel.Parent = MainFrame
CategoryLabel.BackgroundTransparency = 1
CategoryLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
CategoryLabel.Size = UDim2.new(0.4, 0, 0.12, 0)
CategoryLabel.Text = "🔫 Auto"
CategoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CategoryLabel.TextScaled = true
CategoryLabel.Font = Enum.Font.GothamMedium
CategoryLabel.TextXAlignment = Enum.TextXAlignment.Left

ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0.5, 0, 0.25, 0)
ToggleButton.Size = UDim2.new(0.45, 0, 0.15, 0)
ToggleButton.Text = "AutoShoot: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamSemibold

ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

StatusLight.Parent = ToggleButton
StatusLight.Position = UDim2.new(0.9, 0, 0.4, 0)
StatusLight.Size = UDim2.new(0.05, 0, 0.2, 0)
StatusLight.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
LightCorner.CornerRadius = UDim.new(1, 0)
LightCorner.Parent = StatusLight

local isOpen = true
_G.AutoShoot = false

local function updateView()
    if isOpen then
        MainFrame.Visible = true
        StandbyFrame.Visible = false
        Arrow.Parent = MainFrame
        Arrow.Position = UDim2.new(0.78, 0, 0.02, 0)
        Arrow.Text = "⬇️"
    else
        MainFrame.Visible = false
        StandbyFrame.Visible = true
        Arrow.Parent = StandbyFrame
        Arrow.Position = UDim2.new(0.85, 0, 0.1, 0)
        Arrow.Text = "⬆️"
    end
end

Arrow.Parent = MainFrame
Arrow.BackgroundTransparency = 1
Arrow.Size = UDim2.new(0.1, 0, 0.12, 0)
Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
Arrow.TextScaled = true
Arrow.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    updateView()
end)

CloseButton.MouseButton1Click:Connect(function()
    _G.AutoShoot = false
    ScreenGui:Destroy()
end)

ToggleButton.MouseButton1Click:Connect(function()
    _G.AutoShoot = not _G.AutoShoot
    if _G.AutoShoot then
        ToggleButton.Text = "AutoShoot: ON"
        StatusLight.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    else
        ToggleButton.Text = "AutoShoot: OFF"
        StatusLight.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

updateView()
