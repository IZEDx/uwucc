-- drone/uwui/graphs.tsx
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["drone/uwui/graphs.tsx"] = _G.__tracetrace["drone/uwui/graphs.tsx"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 5,["6"] = 5,["7"] = 5,["8"] = 7,["9"] = 7,["10"] = 9,["11"] = 9,["12"] = 12,["13"] = 13,["14"] = 15,["15"] = 16,["16"] = 17,["18"] = 17,["19"] = 17,["20"] = 17,["21"] = 17,["22"] = 17,["24"] = 18,["26"] = 15});
local ____exports = {}
local ____uwui = require("lib.uwui-gpu.uwui")
local Box = ____uwui.Box
local UwUi = ____uwui.UwUi
local ____palette = require("drone.uwui.palette")
local palette = ____palette.palette
local ____altitudeGraph = require("drone.uwui.altitudeGraph")
local AltitudeGraph = ____altitudeGraph.AltitudeGraph
local TITLE_FONT_SIZE = 12
local LABEL_FONT_SIZE = 10
function ____exports.Graphs(props)
    return UwUi.node(
        Box,
        {
            bg = palette.bg(3),
            x = 10,
            y = 10,
            w = -20,
            h = -10
        },
        UwUi.node(AltitudeGraph, {algo = props.controller.algos.alt})
    )
end
return ____exports
