-- lib/uwui/color.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/uwui/color.ts"] = _G.__tracetrace["lib/uwui/color.ts"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__New = ____lualib.__TS__New
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["9"] = 1,["10"] = 1,["11"] = 2,["12"] = 2,["15"] = 110,["16"] = 111,["17"] = 112,["19"] = 114,["20"] = 115,["21"] = 116,["22"] = 116,["23"] = 116,["24"] = 116,["25"] = 116,["27"] = 110,["30"] = 125,["31"] = 126,["32"] = 127,["33"] = 127,["35"] = 128,["36"] = 128,["38"] = 129,["39"] = 129,["41"] = 130,["42"] = 130,["44"] = 131,["45"] = 131,["47"] = 132,["48"] = 125,["49"] = 4,["50"] = 5,["51"] = 6,["52"] = 8,["53"] = 8,["54"] = 8,["55"] = 16,["56"] = 12,["57"] = 13,["58"] = 14,["59"] = 17,["60"] = 18,["61"] = 19,["62"] = 20,["63"] = 16,["64"] = 35,["65"] = 36,["66"] = 37,["67"] = 38,["68"] = 39,["70"] = 42,["71"] = 43,["72"] = 43,["74"] = 44,["75"] = 45,["76"] = 47,["77"] = 48,["78"] = 48,["79"] = 48,["80"] = 48,["81"] = 48,["82"] = 48,["83"] = 48,["84"] = 52,["86"] = 55,["87"] = 61,["88"] = 35,["89"] = 74,["90"] = 75,["91"] = 75,["92"] = 75,["93"] = 75,["94"] = 76,["95"] = 74,["96"] = 80,["97"] = 81,["98"] = 80,["99"] = 84,["100"] = 84,["101"] = 85,["103"] = 86,["104"] = 86,["105"] = 87,["106"] = 88,["108"] = 89,["109"] = 89,["110"] = 90,["111"] = 91,["112"] = 92,["113"] = 92,["114"] = 92,["115"] = 92,["116"] = 92,["117"] = 89,["120"] = 86,["123"] = 97,["124"] = 97,["125"] = 99,["126"] = 100,["127"] = 97,["128"] = 102,["129"] = 103,["130"] = 97,["131"] = 97,["132"] = 84,["133"] = 9,["138"] = 24,["146"] = 32,["154"] = 65,["162"] = 69,["163"] = 69,["165"] = 70});
local ____exports = {}
local ____math = require("lib.math")
local lerp = ____math.lerp
local ____util = require("lib.util")
local clamp = ____util.clamp
---
-- @noSelf
function ____exports.hslToRgb(h, s, l)
    if s == 0 then
        return {r = l, g = l, b = l}
    else
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        return {
            r = ____exports.hueToRgb(p, q, h + 1 / 3),
            g = ____exports.hueToRgb(p, q, h),
            b = ____exports.hueToRgb(p, q, h - 1 / 3)
        }
    end
end
---
-- @noSelf
function ____exports.hueToRgb(p, q, t)
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
local colIdxMap = {}
local currentColIdx = 0
local colsDepleted = false
____exports.Color = __TS__Class()
local Color = ____exports.Color
Color.name = "Color"
function Color.prototype.____constructor(self, r, g, b)
    self.quantizedR = 0
    self.quantizedG = 0
    self.quantizedB = 0
    self.quantizedR = math.floor(clamp(r, 0, 1) * ____exports.Color.depth)
    self.quantizedG = math.floor(clamp(g, 0, 1) * ____exports.Color.depth)
    self.quantizedB = math.floor(clamp(b, 0, 1) * ____exports.Color.depth)
    self:register()
end
function Color.prototype.register(self)
    local key = self.key
    if self.isRegistered then
        self._idx = colIdxMap[key]
        return self._idx
    end
    currentColIdx = (currentColIdx + 1) % 200
    if currentColIdx == 0 then
        colsDepleted = true
    end
    self._idx = 255 - currentColIdx
    colIdxMap[key] = self._idx
    if colsDepleted then
        local old = table.concat(
            __TS__ArrayMap(
                {term.getPaletteColor(self._idx)},
                function(____, c) return math.floor(c * ____exports.Color.depth) end
            ),
            ":"
        )
        colIdxMap[old] = nil
    end
    term.setPaletteColor(self._idx, self.quantizedR / ____exports.Color.depth, self.quantizedG / ____exports.Color.depth, self.quantizedB / ____exports.Color.depth)
    return self._idx
end
function Color.hsl(h, s, l)
    local ____exports_hslToRgb_result_0 = ____exports.hslToRgb(h, s, l)
    local r = ____exports_hslToRgb_result_0.r
    local g = ____exports_hslToRgb_result_0.g
    local b = ____exports_hslToRgb_result_0.b
    return __TS__New(____exports.Color, r, g, b)
end
function Color.rgb(r, g, b)
    return __TS__New(____exports.Color, r, g, b)
end
function Color.gradient(self, resolution, ...)
    local steps = {...}
    local gradientColors = {}
    do
        local i = 0
        while i < #steps - 1 do
            local from = steps[i + 1].value
            local to = steps[i + 1 + 1].value
            do
                local j = 0
                while j < resolution do
                    local t = j / resolution
                    gradientColors[#gradientColors + 1] = __TS__New(
                        ____exports.Color,
                        lerp(from.r, to.r, t),
                        lerp(from.g, to.g, t),
                        lerp(from.b, to.b, t)
                    ).idx
                    j = j + 1
                end
            end
            i = i + 1
        end
    end
    return {
        colors = gradientColors,
        vertical = function(x, y)
            return gradientColors[math.floor(y * #gradientColors) + 1]
        end,
        horizontal = function(x, y)
            return gradientColors[math.floor(x * #gradientColors) + 1]
        end
    }
end
Color.depth = 20
__TS__SetDescriptor(
    Color.prototype,
    "value",
    {get = function(self)
        return {r = self.quantizedR / ____exports.Color.depth, g = self.quantizedG / ____exports.Color.depth, b = self.quantizedB / ____exports.Color.depth}
    end},
    true
)
__TS__SetDescriptor(
    Color.prototype,
    "key",
    {get = function(self)
        return (((tostring(self.quantizedR) .. ":") .. tostring(self.quantizedG)) .. ":") .. tostring(self.quantizedB)
    end},
    true
)
__TS__SetDescriptor(
    Color.prototype,
    "isRegistered",
    {get = function(self)
        return colIdxMap[self.key] ~= nil
    end},
    true
)
__TS__SetDescriptor(
    Color.prototype,
    "idx",
    {get = function(self)
        if not self.isRegistered then
            return self:register()
        end
        return self._idx
    end},
    true
)
return ____exports
