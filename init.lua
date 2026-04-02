_G.AutoShoot = false

local function load(url)
    local success, result = pcall(game.HttpGet, game, url)
    if success then
        local func, err = loadstring(result)
        if func then
            func()
        else
            warn("Error: " .. tostring(err))
        end
    else
        warn("Link Error: " .. tostring(result))
    end
end

load("https://raw.githubusercontent.com/R1das67/Rikaza-Hub/refs/heads/main/Gui.lua")
load("https://raw.githubusercontent.com/R1das67/Rikaza-Hub/refs/heads/main/Main.lua")
