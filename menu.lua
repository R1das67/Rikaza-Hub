local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Better Rivals", HidePremium = false, SaveConfig = true, ConfigFolder = "RivalsConfig"})

local Main = _G.MainLogic

local VisualsTab = Window:MakeTab({
	Name = "Optik",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

VisualsTab:AddToggle({
	Name = "Custom Sky (Status)",
	Default = false,
	Callback = function(Value)
		Main.Status.Sky = Value
		if Value then Main.UpdateSky(Main.CurrentSky) end
	end    
})

VisualsTab:AddDropdown({
	Name = "Himmel auswählen",
	Default = "Empty",
	Options = {"Empty", "Night-Sky"},
	Callback = function(Value)
		Main.UpdateSky(Value)
	end    
})

local WeaponTab = Window:MakeTab({
	Name = "Waffen-Skins",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

WeaponTab:AddToggle({
	Name = "Custom Weapon (Status)",
	Default = false,
	Callback = function(Value)
		Main.Status.Weapon = Value
	end    
})

WeaponTab:AddDropdown({
	Name = "Farbe wählen",
	Default = "Empty",
	Options = {"Empty", "Galaxy"},
	Callback = function(Value)
		Main.CurrentColor = Value
	end    
})

WeaponTab:AddDropdown({
	Name = "Waffe wählen",
	Default = "Empty",
	Options = {
		"Empty", "Scharfschützengewehr", "Sturmgewehr", "Salvengewehr", 
		"Schrotflinte", "Uzi", "Minigun", "RPG", "Flammenwerfer", 
		"Armbrust", "Bogen", "Pistole", "Revolver", "Katana", 
		"Messer", "Streitkolben", "Kampfaxt", "Kettensäge", "Dolche"
	},
	Callback = function(Value)
		Main.TargetWeapon = Value
	end    
})

OrionLib:Init()
