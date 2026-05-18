package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__Spread = ____lualib.__TS__Spread
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["13"] = 74,["14"] = 75,["15"] = 74,["16"] = 82,["17"] = 86,["18"] = 87,["19"] = 87,["20"] = 87,["21"] = 88,["22"] = 88,["23"] = 88,["25"] = 88,["27"] = 88,["28"] = 87,["29"] = 87,["30"] = 86,["31"] = 90,["32"] = 91,["33"] = 92,["34"] = 93,["35"] = 94,["36"] = 93,["39"] = 98,["40"] = 82,["41"] = 18,["42"] = 19,["43"] = 21,["44"] = 22,["45"] = 22,["46"] = 22,["47"] = 42,["48"] = 42,["49"] = 39,["50"] = 39,["51"] = 40,["52"] = 42,["53"] = 23,["54"] = 24,["55"] = 25,["56"] = 25,["57"] = 25,["58"] = 25,["59"] = 25,["60"] = 26,["61"] = 27,["62"] = 28,["63"] = 23,["64"] = 31,["65"] = 32,["66"] = 32,["67"] = 32,["68"] = 31,["69"] = 35,["70"] = 36,["71"] = 35,["72"] = 63,["73"] = 63,["74"] = 63,["76"] = 64,["77"] = 65,["78"] = 65,["80"] = 66,["81"] = 63,["82"] = 69,["83"] = 70,["84"] = 70,["85"] = 70,["86"] = 70,["87"] = 70,["88"] = 70,["89"] = 70,["90"] = 69,["96"] = 45,["98"] = 48,["99"] = 49,["109"] = 53,["111"] = 53,["113"] = 54,["115"] = 57,["116"] = 59,["117"] = 60,["118"] = 60,["124"] = 78,["125"] = 79,["126"] = 79,["127"] = 79,["129"] = 79,["131"] = 79,["132"] = 78});
local ____exports = {}
function ____exports.signal(value)
    return __TS__New(____exports.Signal, value)
end
function ____exports.derive(signals, deriver)
    local function resolve()
        return __TS__ArrayMap(
            signals,
            function(____, item)
                local ____temp_5
                if __TS__InstanceOf(item, ____exports.Signal) then
                    ____temp_5 = item.value
                else
                    ____temp_5 = item
                end
                return ____temp_5
            end
        )
    end
    local out = ____exports.signal(deriver(__TS__Spread(resolve())))
    for ____, item in ipairs(signals) do
        if __TS__InstanceOf(item, ____exports.Signal) then
            item:subscribe(function()
                out.value = deriver(__TS__Spread(resolve()))
            end)
        end
    end
    return out
end
local nextSignalId = 0
local hookStack = {}
local collectors = {}
____exports.Signal = __TS__Class()
local Signal = ____exports.Signal
Signal.name = "Signal"
function Signal.prototype.____constructor(self, _value)
    self._value = _value
    nextSignalId = nextSignalId + 1
    self.id = nextSignalId
    self.listeners = __TS__New(Set)
end
function Signal.collect(self, fn)
    local signals = {}
    ____exports.Signal:hook(function(s)
        local ____temp_0 = #signals + 1
        signals[____temp_0] = s
        return ____temp_0
    end)
    fn()
    ____exports.Signal:unhook()
    return signals
end
function Signal.hook(self, hook)
    local ____temp_1 = #hookStack + 1
    hookStack[____temp_1] = hook
    return ____temp_1
end
function Signal.unhook(self)
    return table.remove(hookStack)
end
function Signal.prototype.subscribe(self, cb, immediate)
    if immediate == nil then
        immediate = false
    end
    self.listeners:add(cb)
    if immediate then
        cb(self._value)
    end
    return function() return self.listeners:delete(cb) end
end
function Signal.prototype.derive(self, deriver)
    return ____exports.derive(
        {self},
        function(...)
            local values = {...}
            return deriver(values[1])
        end
    )
end
__TS__SetDescriptor(
    Signal.prototype,
    "untracked",
    {
        get = function(self)
            return self._value
        end,
        set = function(self, v)
            self._value = v
        end
    },
    true
)
__TS__SetDescriptor(
    Signal.prototype,
    "value",
    {
        get = function(self)
            local ____opt_2 = hookStack[#hookStack]
            if ____opt_2 ~= nil then
                ____opt_2(self)
            end
            return self._value
        end,
        set = function(self, v)
            self._value = v
            for ____, listener in __TS__Iterator(self.listeners) do
                listener(v)
            end
        end
    },
    true
)
function ____exports.extract(value)
    local ____temp_4
    if type(value) == "function" then
        ____temp_4 = value()
    else
        ____temp_4 = value
    end
    return ____temp_4
end
return ____exports
