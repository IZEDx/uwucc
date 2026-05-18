package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__Spread = ____lualib.__TS__Spread
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["15"] = 12,["16"] = 12,["17"] = 12,["19"] = 13,["20"] = 14,["21"] = 12,["22"] = 16,["23"] = 17,["24"] = 18,["25"] = 16,["26"] = 21,["27"] = 22,["28"] = 22,["30"] = 23,["31"] = 24,["32"] = 25,["33"] = 24,["34"] = 21,["35"] = 29,["36"] = 30,["37"] = 30,["38"] = 30,["39"] = 30,["40"] = 31,["41"] = 32,["42"] = 30,["43"] = 30,["44"] = 34,["45"] = 29,["46"] = 37,["47"] = 37,["48"] = 37,["50"] = 37,["51"] = 37,["53"] = 38,["54"] = 39,["55"] = 39,["56"] = 39,["57"] = 39,["58"] = 40,["59"] = 41,["60"] = 39,["61"] = 39,["62"] = 43,["63"] = 44,["64"] = 45,["66"] = 46,["70"] = 48,["72"] = 50,["73"] = 37,["74"] = 53,["75"] = 53,["76"] = 54,["77"] = 55,["79"] = 55,["80"] = 56,["81"] = 57,["83"] = 55,["85"] = 60,["86"] = 61,["87"] = 61,["88"] = 61,["89"] = 61,["91"] = 53});
local ____exports = {}
____exports.EventEmitter = __TS__Class()
local EventEmitter = ____exports.EventEmitter
EventEmitter.name = "EventEmitter"
function EventEmitter.prototype.____constructor(self)
    self._listeners = {}
    self._forwards = __TS__New(Set)
end
function EventEmitter.prototype.forwardEvents(self, target)
    self._forwards:add(target)
    return function() return self._forwards:delete(target) end
end
function EventEmitter.prototype.on(self, key, cb)
    if not self._listeners[key] then
        self._listeners[key] = __TS__New(Set)
    end
    self._listeners[key]:add(cb)
    return function()
        self._listeners[key]:delete(cb)
    end
end
function EventEmitter.prototype.once(self, key, cb)
    local unsub
    unsub = self:on(
        key,
        function(...)
            unsub()
            return cb(...)
        end
    )
    return unsub
end
function EventEmitter.prototype.pull(self, key, timeout, stopPropagation)
    if timeout == nil then
        timeout = 0
    end
    if stopPropagation == nil then
        stopPropagation = false
    end
    local result
    self:once(
        key,
        function(...)
            local args = {...}
            result = args
            return stopPropagation
        end
    )
    local startTime = os.clock()
    while not result do
        if timeout > 0 and os.clock() - startTime > timeout then
            error(
                __TS__New(Error, "Timeout"),
                0
            )
        end
        sleep(0.05)
    end
    return result
end
function EventEmitter.prototype.emit(self, key, ...)
    local args = {...}
    local forward = true
    local ____opt_0 = self._listeners[key]
    if ____opt_0 ~= nil then
        ____opt_0:forEach(function(____, listener)
            if listener(__TS__Spread(args)) then
                forward = false
            end
        end)
    end
    if forward then
        self._forwards:forEach(function(____, f) return f:emit(
            key,
            __TS__Spread(args)
        ) end)
    end
end
return ____exports
