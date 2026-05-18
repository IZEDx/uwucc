package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__NumberToFixed = ____lualib.__TS__NumberToFixed
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 2,["9"] = 3,["10"] = 2,["13"] = 7,["14"] = 8,["15"] = 8,["16"] = 8,["17"] = 8,["18"] = 7,["21"] = 12,["22"] = 13,["23"] = 12,["24"] = 16,["25"] = 17,["27"] = 18,["28"] = 18,["29"] = 19,["30"] = 18,["33"] = 21,["34"] = 16,["35"] = 24,["36"] = 25,["37"] = 26,["38"] = 27,["40"] = 29,["41"] = 24,["42"] = 32,["43"] = 33,["44"] = 34,["45"] = 35,["46"] = 36,["47"] = 36,["49"] = 37,["50"] = 37,["52"] = 38,["53"] = 38,["55"] = 39,["56"] = 32,["57"] = 42,["58"] = 43,["59"] = 44,["60"] = 44,["62"] = 45,["63"] = 45,["65"] = 46,["66"] = 42});
local ____exports = {}
---
-- @noSelf
function ____exports.lerp(a, b, amt)
    return a + (b - a) * amt
end
---
-- @noSelf
function ____exports.clamp(v, lo, hi)
    return math.max(
        lo,
        math.min(hi, v)
    )
end
---
-- @noSelf
function ____exports.round(v)
    return math.floor(v + 0.5)
end
function ____exports.range(n)
    local arr = {}
    do
        local i = 0
        while i < n do
            arr[#arr + 1] = i
            i = i + 1
        end
    end
    return arr
end
function ____exports.sum(ns)
    local sum = 0
    for ____, n in ipairs(ns) do
        sum = sum + n
    end
    return sum
end
function ____exports.niceStep(value)
    local exponent = math.floor(math.log10(value))
    local base = math.pow(10, exponent)
    local normalized = value / base
    if normalized <= 1 then
        return base
    end
    if normalized <= 2 then
        return 2 * base
    end
    if normalized <= 5 then
        return 5 * base
    end
    return 10 * base
end
function ____exports.formatValue(value)
    local absValue = math.abs(value)
    if absValue < 0.01 then
        return __TS__NumberToFixed(value, 3)
    end
    if absValue < 0.1 then
        return __TS__NumberToFixed(value, 2)
    end
    return __TS__NumberToFixed(value, 1)
end
return ____exports
