-- drone/uwui/dashboard.tsx
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["drone/uwui/dashboard.tsx"] = _G.__tracetrace["drone/uwui/dashboard.tsx"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["6"] = 2,["7"] = 2,["8"] = 2,["9"] = 2,["10"] = 2,["11"] = 2,["12"] = 2,["13"] = 4,["14"] = 4,["15"] = 5,["16"] = 5,["17"] = 39,["18"] = 40,["19"] = 41,["20"] = 42,["22"] = 44,["23"] = 44,["24"] = 43,["26"] = 44,["28"] = 44,["29"] = 44,["30"] = 44,["31"] = 44,["34"] = 43,["35"] = 47,["36"] = 47,["37"] = 47,["38"] = 47,["39"] = 47,["40"] = 47,["41"] = 47,["42"] = 48,["44"] = 50,["45"] = 52,["46"] = 49,["47"] = 50,["49"] = 51,["50"] = 52,["51"] = 53,["52"] = 54,["53"] = 55,["54"] = 56,["55"] = 56,["56"] = 56,["57"] = 56,["58"] = 56,["59"] = 58,["62"] = 59,["63"] = 60,["64"] = 61,["65"] = 62,["67"] = 56,["70"] = 66,["72"] = 67,["73"] = 68,["76"] = 71,["77"] = 72,["79"] = 74,["82"] = 47,["83"] = 43,["85"] = 79,["87"] = 79,["88"] = 79,["91"] = 79,["92"] = 79,["94"] = 80,["95"] = 43,["96"] = 43,["97"] = 39,["98"] = 7,["99"] = 8,["100"] = 9,["101"] = 10,["102"] = 10,["103"] = 10,["104"] = 11,["105"] = 12,["107"] = 12,["108"] = 12,["109"] = 12,["112"] = 13,["114"] = 14,["115"] = 15,["116"] = 16,["117"] = 17,["118"] = 18,["119"] = 19,["120"] = 20,["122"] = 22,["125"] = 24,["127"] = 25,["128"] = 26,["129"] = 27,["130"] = 28,["131"] = 29,["132"] = 30,["133"] = 31,["135"] = 33,["138"] = 7});
local ____exports = {}
local ____uwui = require("lib.uwui-gpu.uwui")
local Box = ____uwui.Box
local each = ____uwui.each
local Text = ____uwui.Text
local useGPU = ____uwui.useGPU
local useSignal = ____uwui.useSignal
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
                local algo = props.controller.algos[name]
                local ____UwUi_node_4 = UwUi.node
                local ____Box_3 = Box
                y = y + 35
                return ____UwUi_node_4(
                    ____Box_3,
                    {
                        x = 10,
                        y = y,
                        w = -10,
                        h = 30,
                        bg = palette.bg(algo.disabled.value and 3 or 4),
                        onInput = function(____, ____bindingPattern0)
                            local button
                            local ____type
                            ____type = ____bindingPattern0.type
                            button = ____bindingPattern0.button
                            if ____type ~= "mouse_click" then
                                return
                            end
                            if button == 1 then
                                props.algo.value = algo
                            elseif button == 2 then
                                algo.disabled.value = not algo.disabled.value
                            end
                        end
                    },
                    UwUi.node(
                        Text,
                        {
                            x = 0.5,
                            y = 0.5,
                            align = "middle",
                            justify = "center",
                            size = 16,
                            color = palette.text(2)
                        },
                        string.format("%s: %.2f", name, input)
                    )
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
    local algo = useSignal(props.controller.algos.alt)
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
            UwUi.node(____exports.Status, {controller = props.controller, algo = algo})
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
            UwUi.node(Graphs, {algo = algo})
        )
    )
end
return ____exports
