package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 3,["6"] = 5,["7"] = 6,["8"] = 7,["9"] = 8,["12"] = 20,["15"] = 11,["16"] = 12,["17"] = 13,["18"] = 13,["19"] = 13,["20"] = 13,["21"] = 13,["22"] = 13,["23"] = 13,["24"] = 13,["25"] = 13,["26"] = 13,["27"] = 14,["28"] = 14,["29"] = 14,["30"] = 14,["31"] = 14,["32"] = 14,["33"] = 14,["34"] = 14,["35"] = 14,["36"] = 14,["37"] = 14,["38"] = 14,["39"] = 15,["40"] = 15,["41"] = 15,["42"] = 15,["43"] = 15,["44"] = 15,["45"] = 15,["46"] = 15,["47"] = 15,["48"] = 15,["49"] = 16,["50"] = 17,["57"] = 22});
local ____exports = {}
local gpu = (peripheral.find("directgpu"))
local display = gpu.autoDetectAndCreateDisplayWithResolution(2)
local info = gpu.getDisplayInfo(display)
local W = info.pixelWidth
local H = info.pixelHeight
do
    local function ____catch(e)
        printError(e)
    end
    local ____try, ____hasReturned = pcall(function()
        while true do
            gpu.clear(display, 20, 20, 30)
            gpu.fillRect(
                display,
                10,
                10,
                80,
                40,
                255,
                0,
                0
            )
            gpu.drawText(
                display,
                "Hello DirectGPU ",
                12,
                65,
                255,
                255,
                255,
                "Arial",
                18,
                "bold"
            )
            gpu.drawLine(
                display,
                0,
                0,
                W,
                H,
                255,
                0,
                0
            )
            gpu.updateDisplay(display)
            sleep(0.05)
        end
    end)
    if not ____try then
        ____catch(____hasReturned)
    end
    do
        gpu.removeDisplay(display)
    end
end
return ____exports
