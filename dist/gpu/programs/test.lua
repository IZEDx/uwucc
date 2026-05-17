-- gpu/programs/test.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["gpu/programs/test.ts"] = _G.__tracetrace["gpu/programs/test.ts"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 1,["6"] = 1,["7"] = 1,["8"] = 3,["9"] = 5,["10"] = 6,["11"] = 7,["12"] = 8,["13"] = 10,["14"] = 12,["15"] = 14,["16"] = 15,["17"] = 16,["18"] = 17,["19"] = 17,["20"] = 17,["21"] = 17,["22"] = 17,["23"] = 17,["24"] = 17,["25"] = 17,["26"] = 17,["27"] = 17,["28"] = 18,["29"] = 18,["30"] = 18,["31"] = 18,["32"] = 18,["33"] = 18,["34"] = 18,["35"] = 18,["36"] = 18,["37"] = 18,["38"] = 18,["39"] = 18,["40"] = 19,["41"] = 19,["42"] = 19,["43"] = 19,["44"] = 19,["45"] = 19,["46"] = 19,["47"] = 19,["48"] = 19,["49"] = 19,["50"] = 20,["51"] = 22,["52"] = 23});
local ____exports = {}
local ____chalk = require("lib.chalk")
local anyKey = ____chalk.anyKey
local printValue = ____chalk.printValue
local gpu = (peripheral.find("directgpu"))
local display = gpu.autoDetectAndCreateDisplayWithResolution(2)
local info = gpu.getDisplayInfo(display)
local W = info.pixelWidth
local H = info.pixelHeight
printValue(info)
debug.getregistry()
gpu.updateDisplay(display)
gpu.clear(display, 20, 20, 30)
gpu.updateDisplay(display)
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
anyKey()
gpu.removeDisplay(display)
return ____exports
