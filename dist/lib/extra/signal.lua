-- lib/extra/signal.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/extra/signal.ts"] = _G.__tracetrace["lib/extra/signal.ts"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local __TS__Spread = ____lualib.__TS__Spread
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["17"] = 123,["18"] = 124,["19"] = 123,["22"] = 8,["23"] = 9,["24"] = 8,["27"] = 13,["28"] = 14,["29"] = 14,["30"] = 14,["32"] = 14,["34"] = 14,["35"] = 13,["36"] = 32,["37"] = 33,["38"] = 33,["39"] = 33,["40"] = 38,["41"] = 38,["42"] = 35,["43"] = 35,["44"] = 36,["45"] = 38,["46"] = 51,["47"] = 51,["48"] = 51,["50"] = 52,["51"] = 53,["52"] = 54,["53"] = 54,["55"] = 55,["56"] = 56,["57"] = 55,["58"] = 51,["59"] = 60,["60"] = 61,["61"] = 62,["62"] = 60,["63"] = 66,["64"] = 67,["65"] = 68,["66"] = 68,["67"] = 68,["68"] = 69,["70"] = 71,["71"] = 66,["72"] = 75,["73"] = 76,["74"] = 76,["75"] = 76,["76"] = 76,["77"] = 75,["78"] = 80,["79"] = 81,["80"] = 82,["82"] = 84,["83"] = 80,["84"] = 88,["85"] = 92,["86"] = 92,["87"] = 92,["88"] = 93,["89"] = 94,["90"] = 95,["91"] = 96,["92"] = 96,["93"] = 97,["94"] = 96,["95"] = 96,["96"] = 96,["99"] = 101,["100"] = 88,["101"] = 105,["102"] = 109,["103"] = 109,["104"] = 109,["105"] = 110,["106"] = 111,["107"] = 111,["108"] = 111,["109"] = 111,["110"] = 111,["111"] = 113,["112"] = 114,["113"] = 115,["114"] = 114,["115"] = 114,["116"] = 111,["117"] = 111,["118"] = 118,["119"] = 118,["120"] = 118,["121"] = 118,["122"] = 105,["123"] = 34,["129"] = 47,["130"] = 48,["132"] = 40,["133"] = 41,["134"] = 42,["135"] = 43});
local ____exports = {}
---
-- @noSelf
function ____exports.signal(value)
    return __TS__New(____exports.Signal, value)
end
---
-- @noSelf
function ____exports.isGetter(getter)
    return type(getter) == "function"
end
---
-- @noSelf
function ____exports.extract(getter)
    local ____isGetter_result_0
    if ____exports.isGetter(getter) then
        ____isGetter_result_0 = getter()
    else
        ____isGetter_result_0 = getter
    end
    return ____isGetter_result_0
end
local _signalId = 0
____exports.Signal = __TS__Class()
local Signal = ____exports.Signal
Signal.name = "Signal"
function Signal.prototype.____constructor(self, _value)
    self._value = _value
    _signalId = _signalId + 1
    self.id = _signalId
    self.listeners = __TS__New(Set)
end
function Signal.prototype.subscribe(self, cb, noImmediate)
    if noImmediate == nil then
        noImmediate = false
    end
    ____exports.Signal.touched:add(self)
    self.listeners:add(cb)
    if not noImmediate then
        cb(self.value)
    end
    return function()
        self.listeners:delete(cb)
    end
end
function Signal.prototype.derive(self, deriver)
    ____exports.Signal.touched:add(self)
    return ____exports.Signal.derive({self}, deriver)
end
function Signal.resolveFields(obj)
    local newObj = {}
    for ____, ____value in ipairs(__TS__ObjectEntries(obj)) do
        local key = ____value[1]
        local value = ____value[2]
        newObj[key] = ____exports.Signal.resolve(value)
    end
    return newObj
end
function Signal.resolveArray(arr)
    return __TS__ArrayMap(
        arr,
        function(____, item) return ____exports.Signal.resolve(item) end
    )
end
function Signal.resolve(v)
    if __TS__InstanceOf(v, ____exports.Signal) then
        return v.value
    end
    return v
end
function Signal.derive(signals, deriver)
    local function values()
        return ____exports.Signal.resolveArray(signals)
    end
    local derived = ____exports.signal(deriver(__TS__Spread(values())))
    for ____, s in ipairs(signals) do
        if __TS__InstanceOf(s, ____exports.Signal) then
            s:subscribe(
                function()
                    derived.value = deriver(__TS__Spread(values()))
                end,
                true
            )
        end
    end
    return derived
end
function Signal.subscribe(signals, subscriber)
    local function values()
        return ____exports.Signal.resolveArray(signals)
    end
    subscriber(__TS__Spread(values()))
    local unsubs = __TS__ArrayMap(
        __TS__ArrayFilter(
            signals,
            function(____, s) return __TS__InstanceOf(s, ____exports.Signal) end
        ),
        function(____, s) return s:subscribe(
            function()
                subscriber(__TS__Spread(values()))
            end,
            true
        ) end
    )
    return function() return __TS__ArrayForEach(
        unsubs,
        function(____, u) return u() end
    ) end
end
Signal.touched = __TS__New(Set)
__TS__SetDescriptor(
    Signal.prototype,
    "value",
    {
        get = function(self)
            ____exports.Signal.touched:add(self)
            return self._value
        end,
        set = function(self, v)
            ____exports.Signal.touched:add(self)
            self._value = v
            self.listeners:forEach(function(____, set) return set(v) end)
        end
    },
    true
)
return ____exports
