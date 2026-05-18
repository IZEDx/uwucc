package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["10"] = 1,["11"] = 1,["12"] = 2,["13"] = 2,["14"] = 2,["15"] = 2,["16"] = 4,["17"] = 4,["18"] = 18,["19"] = 18,["20"] = 19,["21"] = 20,["22"] = 21,["24"] = 21,["25"] = 21,["26"] = 21,["28"] = 21,["30"] = 19,["31"] = 23,["32"] = 24,["33"] = 24,["35"] = 25,["36"] = 25,["38"] = 27,["39"] = 28,["40"] = 29,["41"] = 29,["42"] = 29,["43"] = 29,["44"] = 29,["45"] = 29,["46"] = 29,["47"] = 29,["48"] = 29,["49"] = 29,["50"] = 29,["52"] = 31,["53"] = 18,["54"] = 40,["55"] = 40,["56"] = 41,["57"] = 41,["58"] = 41,["59"] = 41,["60"] = 41,["61"] = 41,["62"] = 41,["63"] = 42,["64"] = 43,["65"] = 44,["66"] = 45,["67"] = 46,["68"] = 47,["69"] = 48,["70"] = 46,["71"] = 50,["72"] = 50,["73"] = 50,["74"] = 50,["75"] = 50,["76"] = 50,["77"] = 50,["78"] = 50,["79"] = 50,["80"] = 50,["81"] = 52,["82"] = 40,["83"] = 55,["84"] = 55,["85"] = 56,["86"] = 55,["87"] = 67,["88"] = 67,["89"] = 68,["90"] = 69,["91"] = 70,["93"] = 71,["94"] = 71,["95"] = 72,["96"] = 73,["97"] = 74,["98"] = 75,["99"] = 75,["100"] = 75,["101"] = 75,["102"] = 75,["103"] = 75,["104"] = 75,["105"] = 75,["106"] = 75,["107"] = 75,["108"] = 75,["109"] = 75,["110"] = 76,["111"] = 71,["114"] = 67,["115"] = 80,["116"] = 80,["117"] = 81,["118"] = 82,["119"] = 83,["120"] = 84,["121"] = 85,["122"] = 86,["123"] = 87,["124"] = 88,["125"] = 90,["127"] = 90,["129"] = 91,["131"] = 91,["133"] = 93,["134"] = 94,["135"] = 94,["136"] = 94,["137"] = 94,["138"] = 94,["139"] = 94,["140"] = 94,["141"] = 95,["142"] = 95,["143"] = 95,["144"] = 95,["145"] = 95,["146"] = 95,["147"] = 95,["148"] = 95,["149"] = 95,["150"] = 95,["151"] = 96,["152"] = 96,["153"] = 96,["154"] = 96,["155"] = 96,["156"] = 96,["157"] = 96,["158"] = 96,["159"] = 96,["160"] = 96,["161"] = 83,["162"] = 99,["163"] = 80,["164"] = 108,["165"] = 109,["166"] = 110,["167"] = 111,["168"] = 112,["169"] = 113,["170"] = 114,["171"] = 115,["172"] = 116,["173"] = 116,["175"] = 112,["176"] = 119,["179"] = 121,["180"] = 122,["181"] = 123,["182"] = 123,["183"] = 123,["184"] = 123,["185"] = 123,["186"] = 123,["187"] = 123,["188"] = 123,["189"] = 123,["190"] = 123,["191"] = 123,["192"] = 123,["193"] = 123,["194"] = 123,["195"] = 108});
local ____exports = {}
local ____math = require("lib.math")
local clamp = ____math.clamp
local ____hooks = require("lib.uwui-gpu.hooks")
local useGPU = ____hooks.useGPU
local useTick = ____hooks.useTick
local useHook = ____hooks.useHook
local ____signal = require("lib.uwui-gpu.signal")
local extract = ____signal.extract
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
function ____exports.Scene(props, ...)
    local children = {...}
    useTick()
    local _gpu = useGPU()
    useHook(function()
        local gpu = _gpu.gpu
        local display = _gpu.display
        gpu.setupCamera(display, 50, 0.05, 100)
        gpu.setCameraPosition(display, 10, 0, -30)
        gpu.lookAt(display, 20, 0, 10)
        local ____opt_12 = gpu.setBackfaceCulling
        if ____opt_12 ~= nil then
            ____opt_12(display, false)
        end
        local ____opt_14 = gpu.setPhongShading
        if ____opt_14 ~= nil then
            ____opt_14(display, true)
        end
        gpu.clearLights(display)
        gpu.addAmbientLight(
            display,
            255,
            255,
            255,
            0.95
        )
        gpu.addDirectionalLight(
            display,
            -0.45,
            -0.85,
            -0.35,
            255,
            255,
            255,
            0.65
        )
        gpu.addDirectionalLight(
            display,
            0.5,
            0.25,
            -0.7,
            120,
            180,
            255,
            0.25
        )
    end)
    return children
end
function ____exports.Model(props)
    local _gpu = useGPU()
    local gpu = _gpu.gpu
    local modelId = -1
    useHook(function()
        local file = (fs.open(props.file, "r"))
        local objData = file and file.readAll()
        modelId = gpu.load3DModel(objData)
        if file ~= nil then
            file.close()
        end
    end)
    if modelId <= 0 then
        return
    end
    local pos = extract(props.pos)
    local rot = extract(props.rot)
    gpu.draw3DModel(
        _gpu.display,
        modelId,
        pos and pos.x or 0,
        pos and pos.y or 0,
        pos and pos.z or 0,
        rot and rot.pitch or 0,
        rot and rot.yaw or 0,
        rot and rot.roll or 0,
        0.15,
        255,
        255,
        255
    )
end
return ____exports
