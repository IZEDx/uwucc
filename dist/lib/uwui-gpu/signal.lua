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
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["13"] = 74,["14"] = 75,["15"] = 74,["16"] = 83,["17"] = 84,["18"] = 84,["19"] = 84,["21"] = 84,["23"] = 84,["24"] = 83,["25"] = 87,["26"] = 91,["27"] = 92,["28"] = 92,["29"] = 92,["30"] = 93,["31"] = 93,["32"] = 93,["34"] = 93,["36"] = 93,["37"] = 92,["38"] = 92,["39"] = 91,["40"] = 95,["41"] = 96,["42"] = 97,["43"] = 98,["44"] = 99,["45"] = 98,["48"] = 103,["49"] = 87,["50"] = 18,["51"] = 19,["52"] = 21,["53"] = 22,["54"] = 22,["55"] = 22,["56"] = 42,["57"] = 42,["58"] = 39,["59"] = 39,["60"] = 40,["61"] = 42,["62"] = 23,["63"] = 24,["64"] = 25,["65"] = 25,["66"] = 25,["67"] = 25,["68"] = 25,["69"] = 26,["70"] = 27,["71"] = 28,["72"] = 23,["73"] = 31,["74"] = 32,["75"] = 32,["76"] = 32,["77"] = 31,["78"] = 35,["79"] = 36,["80"] = 35,["81"] = 63,["82"] = 63,["83"] = 63,["85"] = 64,["86"] = 65,["87"] = 65,["89"] = 66,["90"] = 63,["91"] = 69,["92"] = 70,["93"] = 70,["94"] = 70,["95"] = 70,["96"] = 70,["97"] = 70,["98"] = 70,["99"] = 69,["105"] = 45,["107"] = 48,["108"] = 49,["118"] = 53,["120"] = 53,["122"] = 54,["124"] = 57,["125"] = 59,["126"] = 60,["127"] = 60,["133"] = 78,["134"] = 79,["135"] = 79,["137"] = 80,["138"] = 78});
local ____exports = {}
function ____exports.signal(value)
    return __TS__New(____exports.Signal, value)
end
function ____exports.extract(value)
    local ____temp_4
    if type(value) == "function" then
        ____temp_4 = value()
    else
        ____temp_4 = value
    end
    return ____temp_4
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
function ____exports.resolve(value)
    if value and __TS__InstanceOf(value, ____exports.Signal) then
        return value.value
    end
    return ____exports.extract(value)
end
return ____exports
