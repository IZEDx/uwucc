package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["14"] = 2,["15"] = 2,["16"] = 3,["17"] = 3,["18"] = 3,["19"] = 6,["20"] = 7,["21"] = 8,["23"] = 8,["27"] = 9,["28"] = 9,["29"] = 9,["30"] = 9,["31"] = 10,["32"] = 11,["33"] = 11,["35"] = 12,["36"] = 13,["37"] = 14,["38"] = 6,["39"] = 17,["40"] = 18,["41"] = 17,["42"] = 21,["43"] = 22,["44"] = 23,["45"] = 24,["46"] = 25,["47"] = 24,["48"] = 27,["49"] = 28,["50"] = 29,["51"] = 30,["52"] = 31,["53"] = 30,["56"] = 35,["57"] = 22,["58"] = 21,["59"] = 39,["60"] = 39,["61"] = 39,["63"] = 40,["64"] = 41,["65"] = 42,["66"] = 40,["67"] = 44,["68"] = 44,["69"] = 44,["70"] = 44,["71"] = 39,["72"] = 47,["73"] = 48,["74"] = 49,["75"] = 50,["76"] = 50,["78"] = 51,["79"] = 52,["80"] = 49,["81"] = 54,["82"] = 55,["83"] = 47,["84"] = 58,["85"] = 61,["86"] = 62,["88"] = 62,["92"] = 63,["93"] = 63,["95"] = 64,["96"] = 65,["97"] = 67,["98"] = 68,["99"] = 69,["100"] = 70,["101"] = 72,["102"] = 72,["104"] = 73,["105"] = 73,["107"] = 75,["108"] = 76,["109"] = 76,["111"] = 77,["112"] = 77,["114"] = 78,["115"] = 78,["117"] = 79,["118"] = 79,["121"] = 82,["122"] = 82,["124"] = 83,["125"] = 83,["127"] = 84,["128"] = 84,["130"] = 85,["131"] = 85,["133"] = 87,["134"] = 88,["135"] = 89,["136"] = 90,["138"] = 93,["139"] = 94,["140"] = 95,["141"] = 96,["143"] = 99,["144"] = 105,["145"] = 105,["146"] = 105,["148"] = 105,["149"] = 106,["150"] = 58,["151"] = 109,["152"] = 110,["153"] = 111,["154"] = 111,["155"] = 111,["156"] = 112,["157"] = 113,["158"] = 114,["160"] = 116,["161"] = 111,["162"] = 111,["163"] = 109});
local ____exports = {}
local ____node = require("lib.uwui-gpu.node")
local Node = ____node.Node
local ____signal = require("lib.uwui-gpu.signal")
local Signal = ____signal.Signal
local signal = ____signal.signal
function ____exports.useHook(create)
    local node = Node.current
    if not node then
        error(
            __TS__New(Error, "hooks are only available from within UwUi.render()"),
            0
        )
    end
    local ____node_0, ____hookIndex_1 = node, "hookIndex"
    local ____node_hookIndex_2 = ____node_0[____hookIndex_1]
    ____node_0[____hookIndex_1] = ____node_hookIndex_2 + 1
    local index = ____node_hookIndex_2
    local existing = node.hooks[index + 1]
    if existing then
        return existing
    end
    local created = create(node)
    node.hooks[index + 1] = created
    return created
end
function ____exports.useSignal(initial)
    return ____exports.useHook(function() return signal(initial) end)
end
function ____exports.useDerived(fn)
    return ____exports.useHook(function()
        local initial
        local signals = Signal:collect(function()
            initial = fn()
        end)
        local derived = signal(initial)
        for ____, item in ipairs(signals) do
            if __TS__InstanceOf(item, Signal) then
                item:subscribe(function()
                    derived.value = fn()
                end)
            end
        end
        return derived
    end)
end
function ____exports.useTick(forceTick)
    if forceTick == nil then
        forceTick = true
    end
    local state = ____exports.useHook(function(node)
        node.forceRender = forceTick
        return {tickCount = 0}
    end)
    local ____state_3, ____tickCount_4 = state, "tickCount"
    local ____state_tickCount_5 = ____state_3[____tickCount_4]
    ____state_3[____tickCount_4] = ____state_tickCount_5 + 1
    return ____state_tickCount_5
end
function ____exports.useEffect(effect, deps)
    local cleanup
    local function run()
        if cleanup then
            cleanup()
        end
        cleanup = effect()
        return nil
    end
    local derived = ____exports.useDerived(run)
    local ____ = derived
end
function ____exports.useGPU(_options)
    local node = Node.current
    if not node or not node.gpu then
        error(
            __TS__New(Error, "useGPU is only available from within UwUi.render()"),
            0
        )
    end
    if not _options then
        return node.gpu
    end
    local options = type(_options) == "function" and _options(node.gpu) or _options
    local clip = node.gpu.clip
    local x = options.x or 0
    local y = options.y or 0
    local w = options.w or clip.w - x
    local h = options.h or clip.h - y
    if w == 0 then
        w = clip.w - x
    end
    if h == 0 then
        h = clip.h - y
    end
    if options.mode ~= "absolute" then
        if math.abs(x) <= 1 then
            x = x * clip.w
        end
        if math.abs(y) <= 1 then
            y = y * clip.h
        end
        if math.abs(w) <= 1 then
            w = w * clip.w
        end
        if math.abs(h) <= 1 then
            h = h * clip.h
        end
    end
    if x < 0 then
        x = clip.w + x
    end
    if y < 0 then
        y = clip.h + y
    end
    if w < 0 then
        w = clip.w - x + w
    end
    if h < 0 then
        h = clip.h - y + h
    end
    if options.justify == "center" then
        x = x - w / 2
    elseif options.justify == "right" then
        x = x - w
    end
    if options.align == "middle" then
        y = y - h / 2
    elseif options.align == "bottom" then
        y = y - h
    end
    node.gpu = node.gpu:createView({x = x, y = y, w = w, h = h})
    local ____options_opaque_6 = options.opaque
    if ____options_opaque_6 == nil then
        ____options_opaque_6 = node.opaque
    end
    node.opaque = ____options_opaque_6
    return node.gpu
end
function ____exports.each(items, fn)
    local list = __TS__InstanceOf(items, Signal) and items.value or items
    return __TS__ArrayMap(
        list,
        function(____, v, i)
            local r = fn(v, i)
            if __TS__InstanceOf(r, Node) then
                r.key = r.key or i
            end
            return r
        end
    )
end
return ____exports
