-- gpu/programs/clear.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["gpu/programs/clear.ts"] = _G.__tracetrace["gpu/programs/clear.ts"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 1,["6"] = 1,["7"] = 3,["8"] = 4,["9"] = 5,["10"] = 7,["11"] = 8,["12"] = 9,["15"] = 13,["16"] = 15,["17"] = 17,["18"] = 18,["21"] = 22,["22"] = 23,["23"] = 24,["24"] = 25,["25"] = 26,["26"] = 26,["28"] = 27,["31"] = 30,["32"] = 3});
local ____exports = {}
local ____program = require("lib.program")
local program = ____program.program
program(function()
    print("DirectGPU Display Cleaner")
    print("=========================")
    local gpu = (peripheral.find("directgpu"))
    if not gpu then
        print("ERROR: DirectGPU peripheral not found!")
        return
    end
    print("Found DirectGPU peripheral")
    local displays = gpu.listDisplays()
    if #displays == 0 then
        print("No displays found - nothing to clear")
        return
    end
    print("Found", #displays, "display(s)")
    for ____, display in ipairs(displays) do
        print("Removing display", display, "...")
        local success = gpu.removeDisplay(display)
        if success then
            print("  Removed!")
        else
            print("  Failed to remove!")
        end
    end
    print("\nAll displays cleared!")
end)
return ____exports
