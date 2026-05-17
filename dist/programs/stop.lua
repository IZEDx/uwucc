-- programs/stop.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["programs/stop.ts"] = _G.__tracetrace["programs/stop.ts"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 2,["6"] = 3,["7"] = 4,["8"] = 5,["11"] = 8});
for ____, name in ipairs(peripheral.getNames()) do
    if __TS__StringStartsWith(name, "electric_motor") then
        local p = peripheral.wrap(name)
        p.stop()
    end
end
print("All motors stopped")
