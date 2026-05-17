-- drone/uwui/altitudeGraph.tsx
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["drone/uwui/altitudeGraph.tsx"] = _G.__tracetrace["drone/uwui/altitudeGraph.tsx"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 11,["6"] = 1,["7"] = 1,["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 2,["12"] = 2,["13"] = 3,["14"] = 3,["15"] = 4,["16"] = 4,["17"] = 4,["18"] = 4,["19"] = 5,["20"] = 5,["21"] = 5,["22"] = 5,["23"] = 6,["24"] = 6,["25"] = 114,["26"] = 130,["27"] = 131,["28"] = 131,["29"] = 131,["30"] = 147,["31"] = 133,["32"] = 134,["33"] = 135,["34"] = 136,["35"] = 137,["36"] = 138,["37"] = 139,["38"] = 140,["39"] = 141,["40"] = 142,["41"] = 143,["42"] = 144,["43"] = 145,["44"] = 146,["45"] = 149,["46"] = 149,["47"] = 149,["48"] = 149,["49"] = 149,["50"] = 149,["51"] = 149,["52"] = 149,["53"] = 149,["54"] = 149,["55"] = 149,["56"] = 160,["57"] = 160,["58"] = 160,["59"] = 160,["60"] = 160,["61"] = 160,["62"] = 160,["63"] = 160,["64"] = 160,["65"] = 160,["66"] = 160,["68"] = 172,["69"] = 172,["70"] = 173,["71"] = 174,["72"] = 175,["73"] = 176,["74"] = 177,["75"] = 177,["76"] = 177,["77"] = 177,["78"] = 177,["79"] = 177,["80"] = 177,["81"] = 177,["82"] = 177,["83"] = 178,["84"] = 179,["85"] = 179,["86"] = 179,["87"] = 179,["88"] = 179,["89"] = 179,["90"] = 179,["91"] = 179,["92"] = 179,["93"] = 179,["94"] = 179,["96"] = 172,["99"] = 204,["100"] = 204,["101"] = 204,["102"] = 204,["103"] = 204,["104"] = 204,["105"] = 204,["106"] = 204,["107"] = 204,["108"] = 205,["110"] = 11,["111"] = 12,["112"] = 14,["113"] = 15,["114"] = 16,["115"] = 17,["116"] = 18,["117"] = 19,["118"] = 21,["119"] = 21,["120"] = 21,["121"] = 23,["122"] = 24,["123"] = 25,["125"] = 27,["126"] = 29,["127"] = 31,["128"] = 32,["129"] = 33,["130"] = 34,["131"] = 35,["133"] = 37,["134"] = 38,["135"] = 39,["137"] = 42,["138"] = 42,["139"] = 42,["140"] = 42,["141"] = 43,["142"] = 44,["143"] = 49,["144"] = 50,["145"] = 51,["146"] = 52,["147"] = 53,["148"] = 53,["149"] = 53,["150"] = 54,["151"] = 55,["152"] = 56,["153"] = 58,["154"] = 59,["155"] = 60,["156"] = 62,["157"] = 63,["159"] = 63,["160"] = 63,["161"] = 63,["164"] = 64,["166"] = 65,["167"] = 66,["168"] = 67,["169"] = 68,["170"] = 69,["171"] = 70,["172"] = 71,["173"] = 72,["174"] = 73,["175"] = 74,["176"] = 75,["177"] = 76,["178"] = 77,["179"] = 78,["183"] = 80,["184"] = 80,["185"] = 81,["186"] = 81,["187"] = 81,["188"] = 82,["189"] = 84,["190"] = 85,["191"] = 85,["192"] = 85,["193"] = 85,["194"] = 85,["195"] = 81,["196"] = 81,["199"] = 96,["200"] = 96,["201"] = 97,["202"] = 97,["203"] = 97,["204"] = 98,["205"] = 100,["206"] = 101,["207"] = 101,["208"] = 101,["209"] = 101,["210"] = 102,["211"] = 103,["212"] = 103,["213"] = 103,["214"] = 103,["215"] = 103,["216"] = 97,["217"] = 97,["220"] = 14});
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
local Line = ____components.Line
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
            if y >= padding.top and y <= h - padding.bottom + LABEL_FONT_SIZE / 2 then
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
                    y - LABEL_FONT_SIZE / 2,
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
    local sensorHistory = props.algo.sensorHistory.items
    local targetHistory = props.algo.targetHistory.items
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
    local padding = {left = 46, right = 12, top = 22, bottom = 20}
    local plotW = math.max(1, w - padding.left - padding.right)
    local plotH = math.max(1, h - padding.top - padding.bottom)
    local midY = padding.top + plotH / 2
    local function valueToY(value)
        return midY - (value - center) / displayRange * plotH
    end
    local gridStep = niceStep(displayRange / 4)
    local gridCount = math.floor(displayRange / gridStep)
    local displayMin = center - displayRange / 2
    local axisColor = rgb(145, 231, 255)
    local gridColor = rgb(55, 70, 95)
    local textColor = palette.text(0)
    return UwUi.node(
        Box,
        {
            bg = palette.bg(3),
            border = rgb(35, 45, 65),
            radius = 10
        },
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
                title = props.algo.name,
                scaleLabel = "+/-" .. formatValue(displayRange / 2)
            }
        ),
        UwUi.node(
            Line,
            {smoothing = 0.8},
            table.unpack(each(
                targetHistory,
                function(target, idx)
                    local xStep = #targetHistory > 1 and plotW / (#targetHistory - 1) or plotW
                    local mode = props.algo.modeHistory:get(idx)
                    return {
                        x = padding.left + idx * xStep,
                        y = valueToY(target),
                        color = rgb(mode == "attack" and 200 or 105, mode == "attack" and 180 or 180, mode == "attack" and 180 or 210)
                    }
                end
            ))
        ),
        UwUi.node(
            Line,
            {smoothing = 0.8},
            table.unpack(each(
                sensorHistory,
                function(value, idx)
                    local xStep = #sensorHistory > 1 and plotW / (#sensorHistory - 1) or plotW
                    local normalized = clamp((value - center) / (displayRange / 2), -1, 1)
                    local intensity = math.max(
                        0,
                        1 - math.abs(normalized)
                    )
                    local mode = props.algo.modeHistory:get(idx)
                    return {
                        x = padding.left + idx * xStep,
                        y = valueToY(value),
                        color = rgb(240 - 145 * intensity, 80, mode == "attack" and 200 or 255)
                    }
                end
            ))
        )
    )
end
return ____exports
