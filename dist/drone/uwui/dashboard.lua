package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["6"] = 3,["7"] = 3,["8"] = 3,["9"] = 3,["10"] = 3,["11"] = 3,["12"] = 3,["13"] = 6,["14"] = 6,["15"] = 7,["16"] = 7,["17"] = 58,["18"] = 59,["19"] = 60,["20"] = 61,["22"] = 63,["23"] = 63,["24"] = 62,["26"] = 63,["28"] = 63,["29"] = 63,["30"] = 63,["31"] = 63,["34"] = 62,["35"] = 66,["36"] = 66,["37"] = 66,["38"] = 66,["39"] = 66,["40"] = 66,["41"] = 66,["42"] = 67,["44"] = 69,["45"] = 71,["46"] = 68,["47"] = 69,["49"] = 70,["50"] = 71,["51"] = 72,["52"] = 73,["53"] = 74,["54"] = 75,["55"] = 75,["56"] = 75,["57"] = 75,["58"] = 75,["59"] = 77,["62"] = 78,["63"] = 79,["64"] = 80,["65"] = 81,["67"] = 75,["70"] = 85,["72"] = 86,["73"] = 87,["76"] = 90,["77"] = 91,["79"] = 93,["82"] = 66,["83"] = 62,["85"] = 98,["87"] = 98,["88"] = 98,["91"] = 98,["92"] = 98,["94"] = 99,["95"] = 62,["96"] = 62,["97"] = 58,["98"] = 9,["99"] = 10,["100"] = 11,["101"] = 12,["102"] = 12,["103"] = 12,["104"] = 13,["105"] = 14,["107"] = 14,["108"] = 14,["109"] = 14,["112"] = 15,["114"] = 16,["115"] = 17,["116"] = 18,["117"] = 19,["118"] = 20,["119"] = 21,["120"] = 22,["122"] = 24,["125"] = 26,["127"] = 27,["128"] = 28,["129"] = 29,["130"] = 30,["131"] = 31,["132"] = 32,["133"] = 33,["135"] = 35,["138"] = 9});
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
