package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Promise = ____lualib.__TS__Promise
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["10"] = 59,["31"] = 26,["32"] = 26,["33"] = 27,["34"] = 27,["35"] = 28,["36"] = 29,["38"] = 30,["39"] = 30,["40"] = 31,["41"] = 31,["42"] = 32,["43"] = 32,["44"] = 32,["45"] = 32,["46"] = 32,["48"] = 30,["51"] = 35,["52"] = 27,["53"] = 26,["54"] = 38,["65"] = 54,["66"] = 59,["68"] = 60,["69"] = 60,["73"] = 61,["76"] = 59});
local ____exports = {}
local resolveAsync
--- Given a list of functions returns a function that will execute the given
-- functions one after another, always passing the result of the previous
-- function as an argument to the next function.
-- 
-- If one of the given functions returns a promise, the promise will be resolved
-- before being passed to the next function.
-- 
-- @example ```
-- const join = (...chars: string[]) => chars.join('')
-- pipe(join, parseInt)('1', '2', '3')  // -> 123
-- 
-- const square = (n: number) => n ** 2
-- 
-- // this is equivalent to: square(square(square(2)))
-- pipe(square, square, square)(2)  // -> 256
-- 
-- // also works with promises:
-- fetchNumber :: async () => Promise<number>
-- pipe(fetchNumber, n => n.toString())  // async () => Promise<string>
-- ```
local function pipe(...)
    local funs = {...}
    return function(...)
        local args = {...}
        local nextArgs = args
        local fns = funs
        do
            local i = 0
            while i < #fns do
                nextArgs = {fns[i + 1](table.unpack(nextArgs))}
                local result = table.unpack(nextArgs, 1, 1)
                if result and __TS__InstanceOf(result, __TS__Promise) then
                    return resolveAsync(
                        result,
                        __TS__ArraySlice(funs, i + 1)
                    )
                end
                i = i + 1
            end
        end
        return nextArgs[1]
    end
end
____exports.default = pipe
--- Like `pipe` but takes an argument as its first parameter and invokes the pipe
-- with it.
-- 
-- Note: unlike in `pipe`, the first function of the pipe must take exactly one
-- argument.
-- 
-- @see {@link pipe }
-- @example ```
-- applyPipe(2, double, square, half)  // -> 8
-- ```
____exports.applyPipe = function(arg, ...) return pipe(...)(arg) end
resolveAsync = function(result, funs)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        for ____, fun in ipairs(funs) do
            result = fun(__TS__Await(result))
        end
        return ____awaiter_resolve(
            nil,
            __TS__Await(result)
        )
    end)
end
return ____exports
