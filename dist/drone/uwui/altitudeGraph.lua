package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 12,["6"] = 1,["7"] = 1,["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 2,["12"] = 2,["13"] = 3,["14"] = 3,["15"] = 3,["16"] = 3,["17"] = 4,["18"] = 4,["19"] = 4,["20"] = 4,["21"] = 5,["22"] = 5,["23"] = 5,["24"] = 5,["25"] = 6,["26"] = 6,["27"] = 10,["28"] = 10,["29"] = 124,["30"] = 140,["31"] = 141,["32"] = 141,["33"] = 141,["34"] = 157,["35"] = 143,["36"] = 144,["37"] = 145,["38"] = 146,["39"] = 147,["40"] = 148,["41"] = 149,["42"] = 150,["43"] = 151,["44"] = 152,["45"] = 153,["46"] = 154,["47"] = 155,["48"] = 156,["49"] = 159,["50"] = 159,["51"] = 159,["52"] = 159,["53"] = 159,["54"] = 159,["55"] = 159,["56"] = 159,["57"] = 159,["58"] = 159,["59"] = 159,["60"] = 170,["61"] = 170,["62"] = 170,["63"] = 170,["64"] = 170,["65"] = 170,["66"] = 170,["67"] = 170,["68"] = 170,["69"] = 170,["70"] = 170,["72"] = 182,["73"] = 182,["74"] = 183,["75"] = 184,["76"] = 185,["77"] = 186,["78"] = 187,["79"] = 187,["80"] = 187,["81"] = 187,["82"] = 187,["83"] = 187,["84"] = 187,["85"] = 187,["86"] = 187,["87"] = 188,["88"] = 189,["89"] = 189,["90"] = 189,["91"] = 189,["92"] = 189,["93"] = 189,["94"] = 189,["95"] = 189,["96"] = 189,["97"] = 189,["98"] = 189,["100"] = 182,["103"] = 214,["104"] = 214,["105"] = 214,["106"] = 214,["107"] = 214,["108"] = 214,["109"] = 214,["110"] = 214,["111"] = 214,["112"] = 215,["114"] = 12,["115"] = 13,["116"] = 15,["117"] = 16,["118"] = 17,["119"] = 18,["120"] = 19,["121"] = 20,["122"] = 21,["123"] = 22,["124"] = 24,["125"] = 24,["126"] = 24,["127"] = 26,["128"] = 27,["129"] = 28,["131"] = 30,["132"] = 32,["133"] = 34,["134"] = 35,["135"] = 36,["136"] = 37,["137"] = 38,["139"] = 40,["140"] = 41,["141"] = 42,["143"] = 45,["144"] = 45,["145"] = 45,["146"] = 45,["147"] = 46,["148"] = 47,["149"] = 52,["150"] = 53,["151"] = 54,["152"] = 55,["153"] = 56,["154"] = 56,["155"] = 56,["156"] = 57,["157"] = 58,["158"] = 59,["159"] = 61,["160"] = 62,["161"] = 63,["162"] = 65,["163"] = 66,["164"] = 66,["166"] = 67,["168"] = 68,["169"] = 69,["170"] = 70,["171"] = 71,["172"] = 72,["173"] = 73,["174"] = 74,["175"] = 75,["176"] = 76,["177"] = 77,["178"] = 78,["179"] = 79,["180"] = 80,["181"] = 81,["185"] = 83,["186"] = 83,["188"] = 84,["189"] = 84,["190"] = 85,["191"] = 85,["192"] = 85,["193"] = 86,["194"] = 87,["195"] = 88,["196"] = 88,["197"] = 88,["198"] = 88,["199"] = 88,["200"] = 85,["201"] = 85,["205"] = 100,["206"] = 100,["208"] = 101,["209"] = 101,["210"] = 102,["211"] = 102,["212"] = 102,["213"] = 103,["214"] = 104,["215"] = 105,["216"] = 105,["217"] = 105,["218"] = 105,["219"] = 106,["220"] = 107,["221"] = 107,["222"] = 107,["223"] = 107,["224"] = 107,["225"] = 102,["226"] = 102,["230"] = 115,["232"] = 115,["233"] = 115,["234"] = 115,["235"] = 115,["239"] = 116,["240"] = 116,["241"] = 117,["245"] = 15});
local ____exports = {}
local AltitudeGrid, TITLE_FONT_SIZE, LABEL_FONT_SIZE
local ____math = require("lib.math")
local clamp = ____math.clamp
local formatValue = ____math.formatValue
local lerp = ____math.lerp
local niceStep = ____math.niceStep
local ____hooks = require("lib.uwui-gpu.hooks")
local each = ____hooks.each
local ____components = require("lib.uwui-gpu.components")
local If = ____components.If
local Line = ____components.Line
local Text = ____components.Text
local ____hooks = require("lib.uwui-gpu.hooks")
local useSignal = ____hooks.useSignal
local useTick = ____hooks.useTick
local useGPU = ____hooks.useGPU
local ____uwui = require("lib.uwui-gpu.uwui")
local Box = ____uwui.Box
local rgb = ____uwui.rgb
local UwUi = ____uwui.UwUi
local ____palette = require("drone.uwui.palette")
local palette = ____palette.palette
local ____signal = require("lib.uwui-gpu.signal")
local resolve = ____signal.resolve
function AltitudeGrid(props)
    local gpu = useGPU()
    local ____gpu_clip_1 = gpu.clip
    local w = ____gpu_clip_1.w
    local h = ____gpu_clip_1.h
    local ____props_2 = props
    local padding = ____props_2.padding
    local plotW = ____props_2.plotW
    local plotH = ____props_2.plotH
    local midY = ____props_2.midY
    local center = ____props_2.center
    local displayMin = ____props_2.displayMin
    local displayRange = ____props_2.displayRange
    local gridCount = ____props_2.gridCount
    local gridStep = ____props_2.gridStep
    local axisColor = ____props_2.axisColor
    local gridColor = ____props_2.gridColor
    local textColor = ____props_2.textColor
    local title = ____props_2.title
    local scaleLabel = ____props_2.scaleLabel
    gpu:drawText(
        title,
        padding.left,
        6,
        textColor.r,
        textColor.g,
        textColor.b,
        "Arial",
        TITLE_FONT_SIZE,
        "bold"
    )
    gpu:drawText(
        scaleLabel,
        w - padding.right - 48,
        6,
        textColor.r,
        textColor.g,
        textColor.b,
        "Arial",
        TITLE_FONT_SIZE,
        "bold"
    )
    do
        local index = 0
        while index <= gridCount do
            local value = displayMin + index * gridStep
            local y = midY - (value - center) / displayRange * plotH
            local color = gridColor
            if y >= padding.top and y <= h then
                gpu:drawLine(
                    padding.left,
                    y,
                    padding.left + plotW,
                    y,
                    color.r,
                    color.g,
                    color.b
                )
                local label = formatValue(value)
                gpu:drawText(
                    label,
                    4,
                    clamp(y - LABEL_FONT_SIZE / 2, padding.top, h),
                    textColor.r,
                    textColor.g,
                    textColor.b,
                    "Arial",
                    LABEL_FONT_SIZE,
                    "bold"
                )
            end
            index = index + 1
        end
    end
    gpu:drawRect(
        padding.left,
        padding.top,
        plotW,
        plotH,
        80,
        100,
        140
    )
    return {}
end
TITLE_FONT_SIZE = 12
LABEL_FONT_SIZE = 10
function ____exports.AltitudeGraph(props)
    useTick()
    local gpu = useGPU()
    local state = useSignal({center = 0, displayRange = 10})
    local algo = resolve(props.algo)
    local sensorHistory = algo.sensorHistory.items
    local targetHistory = algo.targetHistory.items
    local lastSensor = algo.sensorHistory:youngest() or 0
    local ____gpu_clip_0 = gpu.clip
    local w = ____gpu_clip_0.w
    local h = ____gpu_clip_0.h
    local targetSum = 0
    for ____, value in ipairs(targetHistory) do
        targetSum = targetSum + value
    end
    local targetCenter = #targetHistory > 0 and targetSum / #targetHistory or state.value.center
    local center = lerp(state.value.center, targetCenter, 0.08)
    local sampleMin = center
    local sampleMax = center
    for ____, value in ipairs(sensorHistory) do
        sampleMin = math.min(sampleMin, value)
        sampleMax = math.max(sampleMax, value)
    end
    for ____, value in ipairs(targetHistory) do
        sampleMin = math.min(sampleMin, value)
        sampleMax = math.max(sampleMax, value)
    end
    local targetRange = math.max(
        2,
        math.max(center - sampleMin, sampleMax - center) * 2
    )
    local displayRange = lerp(state.value.displayRange, targetRange, 0.1)
    state.value = {center = center, displayRange = displayRange}
    local padding = {left = 46, right = 55, top = 25, bottom = 30}
    local plotW = math.max(1, w - padding.left - padding.right)
    local plotH = math.max(1, h - padding.top - padding.bottom)
    local midY = padding.top + plotH / 2
    local function valueToY(value)
        return midY - (value - center) / displayRange * plotH
    end
    local gridStep = niceStep(displayRange / 8)
    local gridCount = math.floor(displayRange / gridStep)
    local displayMin = center - displayRange / 2
    local axisColor = rgb(145, 231, 255)
    local gridColor = rgb(55, 70, 95)
    local textColor = palette.text(0)
    return UwUi.node(
        Box,
        {x = 10, y = 10, w = -10, h = -10},
        UwUi.node(
            AltitudeGrid,
            {
                padding = padding,
                plotW = plotW,
                plotH = plotH,
                midY = midY,
                center = center,
                displayMin = displayMin,
                displayRange = displayRange,
                gridCount = gridCount,
                gridStep = gridStep,
                axisColor = axisColor,
                gridColor = gridColor,
                textColor = textColor,
                title = algo.name,
                scaleLabel = "+/-" .. formatValue(displayRange / 2)
            }
        ),
        UwUi.node(
            If,
            {condition = #targetHistory > 10},
            UwUi.node(
                Line,
                {smoothing = 0.8},
                table.unpack(each(
                    targetHistory,
                    function(target, idx)
                        local xStep = plotW / #targetHistory
                        local mode = algo.modeHistory:get(idx)
                        return {
                            x = padding.left + idx * xStep,
                            y = valueToY(target),
                            color = rgb(mode == "attack" and 200 or 105, mode == "attack" and 180 or 180, mode == "attack" and 180 or 210)
                        }
                    end
                ))
            )
        ),
        UwUi.node(
            If,
            {condition = #sensorHistory > 10},
            UwUi.node(
                Line,
                {smoothing = 0.8},
                table.unpack(each(
                    sensorHistory,
                    function(value, idx)
                        local xStep = plotW / #sensorHistory
                        local normalized = clamp((value - center) / (displayRange / 2), -1, 1)
                        local intensity = math.max(
                            0,
                            1 - math.abs(normalized)
                        )
                        local mode = algo.modeHistory:get(idx)
                        return {
                            x = padding.left + idx * xStep,
                            y = valueToY(value),
                            color = rgb(240 - 145 * intensity, 80, mode == "attack" and 200 or 255)
                        }
                    end
                ))
            )
        ),
        UwUi.node(
            Box,
            {
                x = -25,
                y = valueToY(lastSensor),
                w = 25,
                h = 15,
                align = "middle"
            },
            UwUi.node(
                Text,
                {x = 0, y = 0.5, align = "middle"},
                formatValue(lastSensor)
            )
        )
    )
end
return ____exports
