-- lib/uwui-gpu/components.tsx
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/uwui-gpu/components.tsx"] = _G.__tracetrace["lib/uwui-gpu/components.tsx"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["10"] = 1,["11"] = 1,["12"] = 2,["13"] = 2,["14"] = 2,["15"] = 17,["16"] = 17,["17"] = 18,["18"] = 19,["19"] = 20,["21"] = 20,["22"] = 20,["23"] = 20,["25"] = 20,["27"] = 18,["28"] = 22,["29"] = 23,["30"] = 23,["32"] = 24,["33"] = 24,["35"] = 26,["36"] = 27,["37"] = 28,["38"] = 28,["39"] = 28,["40"] = 28,["41"] = 28,["42"] = 28,["43"] = 28,["44"] = 28,["45"] = 28,["46"] = 28,["47"] = 28,["49"] = 30,["50"] = 17,["51"] = 39,["52"] = 39,["53"] = 40,["54"] = 40,["55"] = 40,["56"] = 40,["57"] = 40,["58"] = 40,["59"] = 40,["60"] = 41,["61"] = 42,["62"] = 43,["63"] = 44,["64"] = 45,["65"] = 46,["66"] = 47,["67"] = 45,["68"] = 49,["69"] = 49,["70"] = 49,["71"] = 49,["72"] = 49,["73"] = 49,["74"] = 49,["75"] = 49,["76"] = 49,["77"] = 49,["78"] = 51,["79"] = 39,["80"] = 54,["81"] = 54,["82"] = 55,["83"] = 54,["84"] = 66,["85"] = 66,["86"] = 67,["87"] = 68,["88"] = 69,["90"] = 70,["91"] = 70,["92"] = 71,["93"] = 72,["94"] = 73,["95"] = 74,["96"] = 74,["97"] = 74,["98"] = 74,["99"] = 74,["100"] = 74,["101"] = 74,["102"] = 74,["103"] = 74,["104"] = 74,["105"] = 74,["106"] = 74,["107"] = 75,["108"] = 70,["111"] = 66});
local ____exports = {}
local ____math = require("lib.math")
local clamp = ____math.clamp
local ____hooks = require("lib.uwui-gpu.hooks")
local useGPU = ____hooks.useGPU
local useTick = ____hooks.useTick
function ____exports.Box(props, ...)
    local children = {...}
    local ____useGPU_3 = useGPU
    local ____props_2 = props
    local ____temp_1 = not not props.bg
    if ____temp_1 then
        local ____props_filled_0 = props.filled
        if ____props_filled_0 == nil then
            ____props_filled_0 = true
        end
        ____temp_1 = ____props_filled_0
    end
    local gpu = ____useGPU_3(__TS__ObjectAssign({}, ____props_2, {opaque = ____temp_1}))
    local rect = {x = 0, y = 0, w = gpu.clip.w, h = gpu.clip.h}
    if props.bg then
        gpu:drawRoundedRect(rect, props.radius or 0, props.bg, true)
    end
    if props.border then
        gpu:drawRoundedRect(rect, props.radius or 0, props.border, false)
    end
    if props.debug then
        local ticks = useTick(false)
        gpu:drawText(
            tostring(ticks),
            0,
            0,
            255,
            255,
            255,
            "Segoue UI",
            14,
            "bold"
        )
    end
    return children
end
function ____exports.Text(props, ...)
    local children = {...}
    local text = table.concat(
        __TS__ArrayMap(
            children,
            function(____, s) return tostring(s) end
        ),
        " "
    )
    local color = props.color or ({r = 255, g = 255, b = 255})
    local size = props.size or 10
    local font = "Segoue UI"
    local style = props.style or "bold"
    local gpu = useGPU(function(gpu)
        local metrics = gpu.gpu.measureText(text, "Segoue UI", size, style)
        return __TS__ObjectAssign({}, props, {w = props.w or metrics.width, h = props.h or metrics.height})
    end)
    gpu:drawTextWrapped(
        text,
        {x = 0, y = 0},
        color,
        gpu.clip.w,
        size / 2,
        font,
        size,
        style
    )
    return {}
end
function ____exports.Key(props, ...)
    local children = {...}
    return children
end
function ____exports.Line(props, ...)
    local points = {...}
    local gpu = useGPU()
    local y = points[1].y
    local smoothing = 1 - clamp(props.smoothing or 0.5, 0, 1)
    do
        local i = 0
        while i < #points - 1 do
            local p = points[i + 1]
            local n = points[i + 1 + 1]
            local ny = y + (n.y - y) * smoothing
            local ____gpu_drawLine_11 = gpu.drawLine
            local ____array_10 = __TS__SparseArrayNew(p.x, y, n.x, ny)
            local ____opt_4 = p.color
            __TS__SparseArrayPush(____array_10, ____opt_4 and ____opt_4.r or 255)
            local ____opt_6 = p.color
            __TS__SparseArrayPush(____array_10, ____opt_6 and ____opt_6.g or 255)
            local ____opt_8 = p.color
            __TS__SparseArrayPush(____array_10, ____opt_8 and ____opt_8.b or 255)
            ____gpu_drawLine_11(
                gpu,
                __TS__SparseArraySpread(____array_10)
            )
            y = ny
            i = i + 1
        end
    end
end
return ____exports
