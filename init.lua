local function loadScript(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        return result
    end
end

local mainUrl = "https://raw.githubusercontent.com/R1das67/Rikaza-Hub/refs/heads/main/main.lua"
local menuUrl = "https://raw.githubusercontent.com/R1das67/Rikaza-Hub/refs/heads/main/menu.lua"

loadScript(mainUrl)
task.wait(0.2)
loadScript(menuUrl)
