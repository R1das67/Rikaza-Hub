local function loadScript(name, url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        return result
    end
end

local mainUrl = ""
local menuUrl = ""

loadScript("MainLogic", mainUrl)
task.wait(0.5)
loadScript("Menu", menuUrl)
