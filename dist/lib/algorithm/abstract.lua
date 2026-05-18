package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["9"] = 2,["10"] = 2,["11"] = 3,["12"] = 3,["13"] = 4,["14"] = 4,["15"] = 15,["16"] = 15,["17"] = 15,["18"] = 27,["19"] = 27,["20"] = 28,["21"] = 29,["22"] = 30,["23"] = 19,["24"] = 20,["25"] = 21,["26"] = 22,["27"] = 32,["28"] = 32,["29"] = 32,["30"] = 33,["32"] = 35,["33"] = 26,["34"] = 38,["35"] = 39,["36"] = 40,["37"] = 41,["38"] = 42,["39"] = 43,["40"] = 44,["41"] = 45,["42"] = 46,["44"] = 48,["46"] = 50,["47"] = 38,["48"] = 66,["49"] = 67,["50"] = 66,["56"] = 60,["57"] = 61,["58"] = 62,["59"] = 63,["61"] = 54,["62"] = 55,["63"] = 56});
local ____exports = {}
local ____history = require("lib.history")
local History = ____history.History
local ____util = require("lib.util")
local ____pairs = ____util.pairs
local ____signal = require("lib.uwui-gpu.signal")
local signal = ____signal.signal
____exports.Algorithm = __TS__Class()
local Algorithm = ____exports.Algorithm
Algorithm.name = "Algorithm"
function Algorithm.prototype.____constructor(self, name, config, defaultParameters, defaultState)
    self.name = name
    self.config = config
    self.defaultParameters = defaultParameters
    self.defaultState = defaultState
    self.disabled = signal(false)
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
    if self.disabled.value then
        self.state.output = 0
    else
        self.state.output = self:onCompute(self.state.error, dt)
    end
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
