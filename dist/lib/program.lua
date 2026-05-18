package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["6"] = 4,["7"] = 4,["8"] = 5,["9"] = 6,["10"] = 7,["11"] = 7,["12"] = 8,["15"] = 12,["16"] = 13,["19"] = 10,["25"] = 9,["28"] = 8,["29"] = 7,["30"] = 6,["31"] = 19,["32"] = 4,["35"] = 25,["38"] = 30,["39"] = 31,["42"] = 27,["43"] = 28,["49"] = 26,["52"] = 25});
local ____exports = {}
function ____exports.program(...)
    local fns = {...}
    local ok = true
    parallel.waitForAny(table.unpack(__TS__ArrayMap(
        fns,
        function(____, fn)
            return function()
                do
                    local function ____catch(e)
                        printError(e)
                        ok = false
                    end
                    local ____try, ____hasReturned, ____returnValue = pcall(function()
                        return true, fn()
                    end)
                    if not ____try then
                        ____hasReturned, ____returnValue = ____catch(____hasReturned)
                    end
                    if ____hasReturned then
                        return ____returnValue
                    end
                end
            end
        end
    )))
    term.setGraphicsMode(false)
end
---
-- @noSelf
function ____exports.runSafe(fn)
    do
        local function ____catch(e)
            printError(e)
            return true, {false, e}
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            fn()
            return true, {true, nil}
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
end
return ____exports
