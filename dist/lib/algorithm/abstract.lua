-- lib/algorithm/abstract.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/algorithm/abstract.ts"] = _G.__tracetrace["lib/algorithm/abstract.ts"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["9"] = 2,["10"] = 2,["11"] = 3,["12"] = 3,["13"] = 14,["14"] = 14,["15"] = 14,["16"] = 25,["17"] = 25,["18"] = 26,["19"] = 27,["20"] = 28,["21"] = 18,["22"] = 19,["23"] = 20,["24"] = 30,["25"] = 30,["26"] = 30,["27"] = 31,["29"] = 33,["30"] = 24,["31"] = 36,["32"] = 37,["33"] = 38,["34"] = 39,["35"] = 40,["36"] = 41,["37"] = 42,["38"] = 43,["39"] = 44,["40"] = 36,["41"] = 60,["42"] = 61,["43"] = 60,["49"] = 54,["50"] = 55,["51"] = 56,["52"] = 57,["54"] = 48,["55"] = 49,["56"] = 50});
local ____exports = {}
local ____history = require("lib.history")
local History = ____history.History
local ____util = require("lib.util")
local ____pairs = ____util.pairs
____exports.Algorithm = __TS__Class()
local Algorithm = ____exports.Algorithm
Algorithm.name = "Algorithm"
function Algorithm.prototype.____constructor(self, name, config, defaultParameters, defaultState)
    self.name = name
    self.config = config
    self.defaultParameters = defaultParameters
    self.defaultState = defaultState
    self.sensorHistory = __TS__New(History)
    self.targetHistory = __TS__New(History)
    self.errorHistory = __TS__New(History)
    for ____, ____value in ipairs(____pairs(defaultParameters)) do
        local k = ____value[1]
        local v = ____value[2]
        self.config:define(name, k, v)
    end
    self:reset()
end
function Algorithm.prototype.compute(self, current, target, dt)
    self.state.current = current
    self.sensorHistory:add(current)
    self.state.target = target
    self.targetHistory:add(target)
    self.state.error = target - current
    self.errorHistory:add(self.state.error)
    self.state.output = self:onCompute(self.state.error, dt)
    return self.state.output
end
function Algorithm.prototype.reset(self)
    self.state = __TS__ObjectAssign({}, self.defaultState, {current = 0, target = 0, error = 0, output = 0})
end
__TS__SetDescriptor(
    Algorithm.prototype,
    "parameters",
    {
        get = function(self)
            local data = self.config.data
            local name = self.name
            data[name] = data[name] or ({})
            return data[name]
        end,
        set = function(self, cfg)
            __TS__ObjectAssign(self.parameters, cfg)
            self:reset()
        end
    },
    true
)
return ____exports
