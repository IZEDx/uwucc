-- drone/uwui/dashboard.tsx
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["drone/uwui/dashboard.tsx"] = _G.__tracetrace["drone/uwui/dashboard.tsx"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["6"] = 1,["7"] = 1,["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 1,["12"] = 3,["13"] = 3,["14"] = 4,["15"] = 4,["16"] = 37,["17"] = 38,["18"] = 39,["19"] = 40,["21"] = 42,["22"] = 42,["23"] = 41,["25"] = 42,["27"] = 42,["28"] = 42,["29"] = 42,["30"] = 42,["33"] = 41,["34"] = 45,["35"] = 45,["36"] = 45,["37"] = 45,["38"] = 45,["39"] = 45,["40"] = 45,["42"] = 46,["43"] = 46,["44"] = 45,["45"] = 46,["47"] = 46,["48"] = 46,["49"] = 46,["50"] = 46,["52"] = 47,["54"] = 45,["55"] = 41,["57"] = 50,["59"] = 50,["60"] = 50,["63"] = 50,["64"] = 50,["66"] = 51,["67"] = 41,["68"] = 41,["69"] = 37,["70"] = 6,["71"] = 7,["72"] = 8,["73"] = 8,["74"] = 8,["75"] = 9,["76"] = 10,["78"] = 10,["79"] = 10,["80"] = 10,["83"] = 11,["85"] = 12,["86"] = 13,["87"] = 14,["88"] = 15,["89"] = 16,["90"] = 17,["91"] = 18,["93"] = 20,["96"] = 22,["98"] = 23,["99"] = 24,["100"] = 25,["101"] = 26,["102"] = 27,["103"] = 28,["104"] = 29,["106"] = 31,["109"] = 6});
local ____exports = {}
local ____uwui = require("lib.uwui-gpu.uwui")
local Box = ____uwui.Box
local each = ____uwui.each
local Text = ____uwui.Text
local useGPU = ____uwui.useGPU
local UwUi = ____uwui.UwUi
local ____graphs = require("drone.uwui.graphs")
local Graphs = ____graphs.Graphs
local ____palette = require("drone.uwui.palette")
local palette = ____palette.palette
function ____exports.Status(props)
    local gpu = useGPU()
    local s = props.controller.status.value
    local y = 0
    local ____UwUi_node_2 = UwUi.node
    local ____Text_1 = Text
    y = y + 10
    return {
        ____UwUi_node_2(
            ____Text_1,
            {
                x = 10,
                y = y,
                size = 17,
                color = palette.text(0)
            },
            "Targets"
        ),
        each(
            __TS__ObjectEntries(props.controller.inputs),
            function(____bindingPattern0)
                local input
                local name
                name = ____bindingPattern0[1]
                input = ____bindingPattern0[2]
                local ____UwUi_node_4 = UwUi.node
                local ____Text_3 = Text
                y = y + 20
                return ____UwUi_node_4(
                    ____Text_3,
                    {
                        x = 10,
                        y = y,
                        size = 16,
                        color = palette.text(2)
                    },
                    string.format("%s: %.2f", name, input)
                )
            end
        ),
        UwUi.node(
            Text,
            {
                x = 0.5,
                y = -10,
                justify = "center",
                align = "bottom",
                size = 17,
                color = palette.text(4)
            },
            string.format("DT: %.2f", s.avgDt)
        )
    }
end
function ____exports.Dashboard(props)
    local gpu = useGPU()
    local ____gpu_clip_0 = gpu.clip
    local w = ____gpu_clip_0.w
    local h = ____gpu_clip_0.h
    return UwUi.node(
        Box,
        {
            w = w,
            h = h,
            bg = palette.bg(2)
        },
        UwUi.node(
            Box,
            {
                x = 10,
                y = 10,
                w = 150,
                h = -10,
                bg = palette.bg(3),
                radius = 20,
                border = palette.bg(5)
            },
            UwUi.node(____exports.Status, {controller = props.controller})
        ),
        UwUi.node(
            Box,
            {
                x = 170,
                y = 10,
                w = -10,
                h = -10,
                bg = palette.bg(3),
                radius = 20,
                border = palette.bg(5)
            },
            UwUi.node(Graphs, {controller = props.controller})
        )
    )
end
return ____exports
