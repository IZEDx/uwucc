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
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["10"] = 1,["11"] = 1,["12"] = 2,["13"] = 2,["14"] = 2,["15"] = 15,["16"] = 15,["17"] = 16,["18"] = 17,["19"] = 18,["21"] = 18,["22"] = 18,["23"] = 18,["25"] = 18,["27"] = 16,["28"] = 20,["29"] = 21,["30"] = 21,["32"] = 22,["33"] = 22,["35"] = 24,["36"] = 25,["37"] = 26,["38"] = 26,["39"] = 26,["40"] = 26,["41"] = 26,["42"] = 26,["43"] = 26,["44"] = 26,["45"] = 26,["46"] = 26,["47"] = 26,["49"] = 28,["50"] = 15,["51"] = 37,["52"] = 37,["53"] = 38,["54"] = 38,["55"] = 38,["56"] = 38,["57"] = 38,["58"] = 38,["59"] = 38,["60"] = 39,["61"] = 40,["62"] = 41,["63"] = 42,["64"] = 43,["65"] = 44,["66"] = 45,["67"] = 43,["68"] = 47,["69"] = 47,["70"] = 47,["71"] = 47,["72"] = 47,["73"] = 47,["74"] = 47,["75"] = 47,["76"] = 47,["77"] = 47,["78"] = 49,["79"] = 37,["80"] = 52,["81"] = 52,["82"] = 53,["83"] = 52,["84"] = 64,["85"] = 64,["86"] = 65,["87"] = 66,["88"] = 67,["90"] = 68,["91"] = 68,["92"] = 69,["93"] = 70,["94"] = 71,["95"] = 72,["96"] = 72,["97"] = 72,["98"] = 72,["99"] = 72,["100"] = 72,["101"] = 72,["102"] = 72,["103"] = 72,["104"] = 72,["105"] = 72,["106"] = 72,["107"] = 73,["108"] = 68,["111"] = 64});
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
