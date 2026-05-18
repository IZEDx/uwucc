package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSlice = ____lualib.__TS__StringSlice
local __TS__ArrayPushArray = ____lualib.__TS__ArrayPushArray
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["13"] = 2,["14"] = 3,["15"] = 4,["17"] = 6,["18"] = 7,["19"] = 8,["20"] = 9,["21"] = 10,["23"] = 12,["24"] = 13,["25"] = 14,["27"] = 16,["28"] = 17,["29"] = 17,["30"] = 17,["31"] = 17,["33"] = 19,["37"] = 23,["38"] = 23,["40"] = 24,["41"] = 2,["44"] = 28,["45"] = 29,["47"] = 30,["48"] = 30,["49"] = 31,["50"] = 30,["53"] = 33,["54"] = 28,["57"] = 39,["58"] = 40,["59"] = 41,["60"] = 42,["62"] = 43,["63"] = 43,["64"] = 44,["65"] = 43,["68"] = 46,["69"] = 39,["72"] = 50,["73"] = 51,["74"] = 51,["75"] = 51,["76"] = 51,["77"] = 51,["78"] = 51,["79"] = 51,["80"] = 50});
local ____exports = {}
---
-- @noSelf
function ____exports.normalizeChildren(children)
    if not __TS__ArrayIsArray(children) then
        return {children}
    end
    local normalized = {}
    local curString = ""
    for ____, c in ipairs(children) do
        if type(c) == "string" then
            curString = curString .. __TS__StringTrim(c) .. " "
        else
            if curString ~= "" then
                normalized[#normalized + 1] = __TS__StringSlice(curString, 0, #curString - 1)
                curString = ""
            end
            if __TS__ArrayIsArray(c) then
                __TS__ArrayPushArray(
                    normalized,
                    ____exports.normalizeChildren(c)
                )
            else
                normalized[#normalized + 1] = c
            end
        end
    end
    if curString ~= "" then
        normalized[#normalized + 1] = __TS__StringSlice(curString, 0, #curString - 1)
    end
    return normalized
end
---
-- @noSelf
function ____exports.buffer(size, prime)
    local b = {}
    do
        local i = 0
        while i < size do
            b[i + 1] = prime
            i = i + 1
        end
    end
    return b
end
---
-- @noSelf
function ____exports.pixelBuffer(w, h, prime)
    w = math.ceil(w)
    h = math.ceil(h)
    local b = {}
    do
        local y = 0
        while y < h do
            b[y + 1] = ____exports.buffer(w, prime)
            y = y + 1
        end
    end
    return b
end
---
-- @noSelf
function ____exports.parseStringBuffer(rows)
    return __TS__ArrayMap(
        rows,
        function(____, r, y) return __TS__ArrayMap(
            __TS__StringSplit(r, ""),
            function(____, s) return string.byte(s) end
        ) end
    )
end
return ____exports
