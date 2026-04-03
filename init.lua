_G.BetterRivalsSettings = {
    AutoAim = false,
    AutoShoot = false,
    Fly = false,
    ReactionTime = 1,
    FlyHeight = 5,
    FlySpeed = 1,
    Active = true
}

local gui_raw = "https://raw.githubusercontent.com/R1das67/Rikaza-Hub/refs/heads/main/Gui.lua"
local main_raw = "https://raw.githubusercontent.com/R1das67/Rikaza-Hub/refs/heads/main/Main.lua"

loadstring(game:HttpGet(gui_raw))()
task.wait(0.5)
loadstring(game:HttpGet(main_raw))()
