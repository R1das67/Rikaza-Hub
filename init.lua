local function loadRaw(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    return result
end

local mainUrl = "https://raw.githubusercontent.com/R1das67/Rikaza-Hub/refs/heads/main/main.lua"
local menuUrl = "https://raw.githubusercontent.com/R1das67/Rikaza-Hub/refs/heads/main/menu.lua"

loadRaw(mainUrl)
task.wait(0.5)
loadRaw(menuUrl)
