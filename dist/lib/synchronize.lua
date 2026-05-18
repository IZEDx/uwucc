package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Promise = ____lualib.__TS__Promise
local __TS__New = ____lualib.__TS__New
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["9"] = 8,["12"] = 11,["13"] = 12,["14"] = 12,["15"] = 12,["16"] = 13,["17"] = 12,["18"] = 12,["19"] = 11,["20"] = 17,["21"] = 18,["22"] = 19,["23"] = 20,["24"] = 21,["25"] = 22,["26"] = 22,["27"] = 24,["28"] = 24,["29"] = 24,["30"] = 25,["33"] = 29,["36"] = 27,["43"] = 24,["44"] = 22,["45"] = 22,["46"] = 34,["47"] = 34,["48"] = 34,["49"] = 34,["51"] = 17});
local ____exports = {}
local queue = {}
---
-- @noSelf
function ____exports.schedule(fn)
    return __TS__New(
        __TS__Promise,
        function(____, res, rej)
            queue[#queue + 1] = {fn = fn, res = res, rej = rej}
        end
    )
end
function ____exports.synchronize()
    local startTime = os.clock()
    while true do
        local now = os.clock()
        print("DT: ", now - startTime)
        parallel.waitForAll(
            function() return sleep(0) end,
            table.unpack(__TS__ArrayMap(
                queue,
                function(____, task) return function()
                    if not task.at or task.at <= now then
                        do
                            local function ____catch(e)
                                task:rej(e)
                            end
                            local ____try, ____hasReturned = pcall(function()
                                task:res(task:fn())
                            end)
                            if not ____try then
                                ____catch(____hasReturned)
                            end
                        end
                    end
                end end
            ))
        )
        queue = __TS__ArrayFilter(
            queue,
            function(____, task) return task.at and task.at > now end
        )
    end
end
return ____exports
