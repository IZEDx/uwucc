package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__Spread = ____lualib.__TS__Spread
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["9"] = 9,["10"] = 10,["11"] = 9,["12"] = 13,["13"] = 14,["14"] = 15,["15"] = 15,["16"] = 16,["17"] = 16,["18"] = 16,["19"] = 16,["20"] = 16,["21"] = 16,["22"] = 16,["23"] = 17,["24"] = 18,["25"] = 19,["26"] = 19,["27"] = 19,["28"] = 19,["29"] = 20,["31"] = 22,["32"] = 15,["33"] = 13,["34"] = 33,["35"] = 34,["36"] = 34,["37"] = 34,["38"] = 34,["39"] = 33,["40"] = 37,["41"] = 38,["42"] = 37,["43"] = 41,["44"] = 41,["45"] = 41,["47"] = 41,["48"] = 41,["50"] = 42,["51"] = 42,["52"] = 42,["53"] = 43,["55"] = 45,["56"] = 41,["57"] = 48,["58"] = 50,["59"] = 51,["60"] = 52,["61"] = 53,["62"] = 54,["64"] = 56,["65"] = 57,["66"] = 58,["68"] = 60,["69"] = 48,["70"] = 63,["71"] = 64,["72"] = 65,["73"] = 66,["74"] = 66,["75"] = 66,["76"] = 66,["78"] = 68,["79"] = 69,["81"] = 71,["82"] = 63,["83"] = 74,["84"] = 83,["85"] = 74,["86"] = 101,["87"] = 102,["88"] = 103,["89"] = 103,["91"] = 104,["92"] = 104,["94"] = 106,["95"] = 106,["96"] = 113,["97"] = 114,["98"] = 115,["99"] = 116,["100"] = 116,["102"] = 117,["103"] = 118,["104"] = 119,["105"] = 113});
local ____exports = {}
function ____exports.pairs(obj)
    return __TS__ObjectEntries(obj)
end
function ____exports.memoize(fn)
    local cache = {}
    return function(____, ...)
        local args = {...}
        local key = table.concat(
            __TS__ArrayMap(
                args,
                function(____, a) return tostring(a) end
            ),
            ";"
        )
        local entry = cache[key]
        if not entry then
            entry = {fn(
                nil,
                __TS__Spread(args)
            )}
            cache[key] = entry
        end
        return entry[1]
    end
end
function ____exports.clamp(v, lo, hi)
    return math.max(
        lo,
        math.min(hi, v)
    )
end
function ____exports.round(v)
    return math.floor(v + 0.5)
end
function ____exports.clampThrusts(thrusts, min, max)
    if min == nil then
        min = -1
    end
    if max == nil then
        max = 1
    end
    for ____, ____value in ipairs(__TS__ObjectEntries(thrusts)) do
        local name = ____value[1]
        local value = ____value[2]
        thrusts[name] = ____exports.clamp(value, min, max)
    end
    return thrusts
end
function ____exports.centerValues(thrusts)
    local sum = 0
    local count = 0
    for ____, value in ipairs(__TS__ObjectValues(thrusts)) do
        sum = sum + value
        count = count + 1
    end
    local avg = sum / count
    for name in pairs(thrusts) do
        thrusts[name] = thrusts[name] - avg
    end
    return thrusts
end
function ____exports.normalizeThrusts(thrusts)
    local highest = 1
    for ____, v in ipairs(__TS__ObjectValues(thrusts)) do
        highest = math.max(
            highest,
            math.abs(v)
        )
    end
    for name in pairs(thrusts) do
        thrusts[name] = thrusts[name] / highest
    end
    return thrusts
end
function ____exports.computeRotorThrusts(base, pitchCmd, rollCmd, trim)
    return {fl = base + rollCmd + pitchCmd + (trim and trim.fl or 0), fr = base - rollCmd + pitchCmd + (trim and trim.fr or 0), bl = base + rollCmd - pitchCmd + (trim and trim.bl or 0), br = base - rollCmd - pitchCmd + (trim and trim.br or 0)}
end
local logFile = "disk/log"
local file = fs.open(logFile, "w")
if file ~= nil then
    file.write("")
end
if file ~= nil then
    file.close()
end
function ____exports.log(...)
end
function ____exports.getLuaFunctionLabel(fn)
    local info = debug.getinfo(fn, "Sn")
    local name = info and info.name
    if name and #name > 0 then
        return name
    end
    local src = info and info.short_src or info and info.source or "<fn>"
    local line = info and info.linedefined or -1
    return (src .. ":") .. tostring(line)
end
return ____exports
