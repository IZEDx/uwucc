-- drone/uwui/errorGraph.tsx
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["drone/uwui/errorGraph.tsx"] = _G.__tracetrace["drone/uwui/errorGraph.tsx"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["6"] = 10,["7"] = 1,["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 1,["12"] = 2,["13"] = 2,["14"] = 3,["15"] = 3,["16"] = 4,["17"] = 4,["18"] = 4,["19"] = 4,["20"] = 5,["21"] = 5,["22"] = 5,["23"] = 5,["24"] = 6,["25"] = 6,["26"] = 97,["27"] = 112,["28"] = 113,["29"] = 113,["30"] = 113,["31"] = 128,["32"] = 115,["33"] = 116,["34"] = 117,["35"] = 118,["36"] = 119,["37"] = 120,["38"] = 121,["39"] = 122,["40"] = 123,["41"] = 124,["42"] = 125,["43"] = 126,["44"] = 127,["45"] = 130,["46"] = 130,["47"] = 130,["48"] = 130,["49"] = 130,["50"] = 130,["51"] = 130,["52"] = 130,["53"] = 130,["54"] = 130,["55"] = 130,["56"] = 141,["57"] = 141,["58"] = 141,["59"] = 141,["60"] = 141,["61"] = 141,["62"] = 141,["63"] = 141,["64"] = 141,["65"] = 141,["66"] = 141,["68"] = 153,["69"] = 153,["70"] = 154,["71"] = 155,["72"] = 156,["73"] = 157,["74"] = 158,["75"] = 158,["76"] = 158,["77"] = 158,["78"] = 158,["79"] = 158,["80"] = 158,["81"] = 158,["82"] = 158,["83"] = 159,["84"] = 160,["85"] = 160,["86"] = 160,["87"] = 160,["88"] = 160,["89"] = 160,["90"] = 160,["91"] = 160,["92"] = 160,["93"] = 160,["94"] = 160,["96"] = 153,["99"] = 174,["100"] = 174,["101"] = 174,["102"] = 174,["103"] = 174,["104"] = 174,["105"] = 174,["106"] = 174,["107"] = 174,["108"] = 183,["109"] = 183,["110"] = 183,["111"] = 183,["112"] = 183,["113"] = 183,["114"] = 183,["115"] = 183,["116"] = 183,["117"] = 184,["119"] = 10,["120"] = 11,["121"] = 13,["122"] = 14,["123"] = 15,["124"] = 16,["125"] = 18,["126"] = 18,["127"] = 18,["128"] = 19,["129"] = 21,["130"] = 22,["131"] = 23,["132"] = 24,["133"] = 25,["134"] = 26,["135"] = 27,["136"] = 28,["139"] = 32,["140"] = 32,["141"] = 32,["142"] = 32,["143"] = 32,["144"] = 32,["145"] = 32,["146"] = 33,["147"] = 34,["148"] = 35,["149"] = 36,["150"] = 37,["151"] = 39,["152"] = 47,["153"] = 48,["154"] = 49,["155"] = 50,["156"] = 51,["157"] = 51,["158"] = 51,["159"] = 52,["160"] = 53,["161"] = 54,["162"] = 56,["163"] = 57,["164"] = 58,["165"] = 60,["166"] = 61,["167"] = 63,["168"] = 64,["170"] = 64,["171"] = 64,["172"] = 64,["174"] = 65,["175"] = 66,["176"] = 67,["177"] = 68,["178"] = 69,["179"] = 70,["180"] = 71,["181"] = 72,["182"] = 73,["183"] = 74,["184"] = 75,["185"] = 76,["186"] = 77,["187"] = 78,["190"] = 80,["191"] = 80,["192"] = 81,["193"] = 81,["194"] = 81,["195"] = 82,["196"] = 83,["197"] = 84,["198"] = 85,["199"] = 85,["200"] = 85,["201"] = 85,["202"] = 86,["203"] = 86,["204"] = 86,["205"] = 86,["206"] = 86,["207"] = 81,["208"] = 81,["211"] = 13});
local ____exports = {}
local ErrorGrid, TITLE_FONT_SIZE, LABEL_FONT_SIZE
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
function ErrorGrid(props)
    local gpu = useGPU()
    local ____gpu_clip_1 = gpu.clip
    local w = ____gpu_clip_1.w
    local h = ____gpu_clip_1.h
    local ____props_2 = props
    local padding = ____props_2.padding
    local plotW = ____props_2.plotW
    local plotH = ____props_2.plotH
    local midY = ____props_2.midY
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
            local y = midY - value / displayRange * plotH
            local color = index == gridCount / 2 and axisColor or gridColor
            if y >= padding.top and y <= h - padding.bottom then
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
                    y - 6,
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
    gpu:drawLine(
        padding.left,
        midY,
        padding.left + plotW,
        midY,
        axisColor.r,
        axisColor.g,
        axisColor.b
    )
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
function ____exports.ErrorGraph(props)
    useTick()
    local gpu = useGPU()
    local state = useSignal({targetRange = 5, displayRange = 5, min = -5, max = 5})
    local ____gpu_clip_0 = gpu.clip
    local w = ____gpu_clip_0.w
    local h = ____gpu_clip_0.h
    local items = props.algo.errorHistory.items
    local sampleMin = 0
    local sampleMax = 0
    if #items > 0 then
        sampleMin = items[1]
        sampleMax = items[1]
        for ____, value in ipairs(items) do
            sampleMin = math.min(sampleMin, value)
            sampleMax = math.max(sampleMax, value)
        end
    end
    local rawMax = math.max(
        5,
        math.max(
            math.abs(sampleMin),
            math.abs(sampleMax)
        )
    )
    local targetRange = rawMax * 2
    local smoothedRange = lerp(state.value.displayRange, targetRange, 0.1)
    local displayRange = math.max(smoothedRange, 10)
    local displayMax = displayRange / 2
    local displayMin = -displayMax
    state.value = __TS__ObjectAssign({}, state.value, {targetRange = targetRange, displayRange = displayRange, min = displayMin, max = displayMax})
    local padding = {left = 46, right = 12, top = 22, bottom = 20}
    local plotW = math.max(1, w - padding.left - padding.right)
    local plotH = math.max(1, h - padding.top - padding.bottom)
    local midY = padding.top + plotH / 2
    local function valueToY(value)
        return midY - value / displayRange * plotH
    end
    local xStep = #items > 1 and plotW / (#items - 1) or plotW
    local gridStep = niceStep(displayRange / 4)
    local gridCount = math.floor(displayRange / gridStep)
    local axisColor = rgb(145, 231, 255)
    local gridColor = rgb(55, 70, 95)
    local textColor = palette.text(0)
    local title = props.algo.name
    local scaleLabel = "+/-" .. formatValue(displayMax)
    return UwUi.node(
        Box,
        {
            bg = palette.bg(3),
            border = rgb(35, 45, 65),
            radius = 10
        },
        UwUi.node(ErrorGrid, {
            padding = padding,
            plotW = plotW,
            plotH = plotH,
            midY = midY,
            displayMin = displayMin,
            displayRange = displayRange,
            gridCount = gridCount,
            gridStep = gridStep,
            axisColor = axisColor,
            gridColor = gridColor,
            textColor = textColor,
            title = title,
            scaleLabel = scaleLabel
        }),
        UwUi.node(
            Line,
            {smoothing = 0.8},
            table.unpack(each(
                items,
                function(____error, idx)
                    local normalized = clamp(____error / displayMax, -1, 1)
                    local x = padding.left + idx * xStep
                    local y = valueToY(____error)
                    local intensity = math.max(
                        0,
                        1 - math.abs(normalized)
                    )
                    return {
                        x = x,
                        y = y,
                        color = rgb(240 - 145 * intensity, 80, 255)
                    }
                end
            ))
        )
    )
end
return ____exports
