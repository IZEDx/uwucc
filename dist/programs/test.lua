-- programs/test.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["programs/test.ts"] = _G.__tracetrace["programs/test.ts"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 1,["6"] = 1,["7"] = 1,["8"] = 3,["9"] = 4,["10"] = 5,["11"] = 6});
local ____exports = {}
local ____events = require("lib.events")
local KeyEvent = ____events.KeyEvent
local pullEventAs = ____events.pullEventAs
while true do
    local e = pullEventAs(KeyEvent, "key")
    if e then
        print(keys.getName(e.key))
    end
end
return ____exports
