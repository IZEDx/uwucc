package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 1,["6"] = 1,["7"] = 3,["8"] = 3,["9"] = 5,["10"] = 6,["11"] = 7,["12"] = 3,["13"] = 3});
local ____exports = {}
local ____uwui = require("lib.uwui-gpu.uwui")
local rgb = ____uwui.rgb
____exports.palette = {
    bg = function(i) return rgb(10 * i, 8 * i, 12 * i) end,
    text = function(i)
        local l = 245 - i * 15
        return rgb(l, l, l)
    end
}
return ____exports
