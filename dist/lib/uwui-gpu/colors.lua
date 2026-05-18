package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 23,["6"] = 1,["7"] = 1,["8"] = 1,["9"] = 23,["10"] = 24,["11"] = 25,["12"] = 25,["14"] = 26,["15"] = 26,["17"] = 27,["18"] = 27,["20"] = 28,["21"] = 28,["23"] = 29,["24"] = 29,["26"] = 30,["28"] = 5,["29"] = 6,["30"] = 6,["31"] = 6,["32"] = 6,["33"] = 6,["34"] = 6,["35"] = 6,["36"] = 6,["37"] = 6,["38"] = 6,["39"] = 6,["40"] = 6,["41"] = 6,["42"] = 6,["43"] = 6,["44"] = 6,["45"] = 6,["46"] = 5,["47"] = 9,["48"] = 10,["49"] = 11,["51"] = 13,["52"] = 14,["53"] = 15,["54"] = 15,["55"] = 15,["56"] = 15,["57"] = 15,["59"] = 9});
local ____exports = {}
local hueToRgb
local ____math = require("lib.math")
local clamp = ____math.clamp
local round = ____math.round
function hueToRgb(p, q, t)
    t = t % 1
    if t < 0 then
        t = t + 1
    end
    if t > 1 then
        t = t - 1
    end
    if t < 1 / 6 then
        return p + (q - p) * 6 * t
    end
    if t < 1 / 2 then
        return q
    end
    if t < 2 / 3 then
        return p + (q - p) * (2 / 3 - t) * 6
    end
    return p
end
function ____exports.rgb(r, g, b)
    return {
        r = clamp(
            round(r),
            0,
            255
        ),
        g = clamp(
            round(g),
            0,
            255
        ),
        b = clamp(
            round(b),
            0,
            255
        )
    }
end
function ____exports.hsl(h, s, l)
    if s == 0 then
        return {r = l, g = l, b = l}
    else
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        return {
            r = hueToRgb(p, q, h + 1 / 3),
            g = hueToRgb(p, q, h),
            b = hueToRgb(p, q, h - 1 / 3)
        }
    end
end
return ____exports
