package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__New = ____lualib.__TS__New
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 2,["9"] = 2,["10"] = 3,["11"] = 3,["12"] = 4,["13"] = 4,["14"] = 6,["15"] = 6,["16"] = 6,["17"] = 6,["18"] = 6,["19"] = 6,["20"] = 6,["21"] = 6,["22"] = 6,["23"] = 6,["24"] = 18,["25"] = 31,["26"] = 31,["27"] = 31,["28"] = 31,["29"] = 34,["30"] = 31,["31"] = 35,["32"] = 35,["33"] = 35,["34"] = 35,["35"] = 35,["36"] = 35,["37"] = 32,["38"] = 34,["39"] = 38,["40"] = 39,["41"] = 40,["42"] = 41,["43"] = 44,["44"] = 45,["45"] = 48,["46"] = 49,["48"] = 51,["49"] = 52,["51"] = 55,["52"] = 58,["53"] = 59,["55"] = 62,["57"] = 67,["58"] = 67,["59"] = 67,["60"] = 67,["61"] = 67,["62"] = 70,["63"] = 71,["64"] = 72,["65"] = 38});
local ____exports = {}
local ____history = require("lib.history")
local History = ____history.History
local ____math = require("lib.math")
local clamp = ____math.clamp
local ____abstract = require("lib.algorithm.abstract")
local Algorithm = ____abstract.Algorithm
local defaultParameters = {
    kp = 0.00005,
    kd = 0.05,
    minK = 0.00001,
    maxK = 0.03,
    attack = 0.3,
    decay = 0.3,
    deadband = 0.1,
    hysteresis = 0.01
}
local defaultState = {mode = "attack", lk = 0, fErr = 0, pErr = 0}
____exports.LAC = __TS__Class()
local LAC = ____exports.LAC
LAC.name = "LAC"
__TS__ClassExtends(LAC, Algorithm)
function LAC.prototype.____constructor(self, name, config)
    Algorithm.prototype.____constructor(
        self,
        name,
        config,
        defaultParameters,
        defaultState
    )
    self.modeHistory = __TS__New(History)
end
function LAC.prototype.onCompute(self, ____error, dt)
    local alpha = dt / (0.05 + dt)
    local params = self.parameters
    local state = self.state
    state.fErr = (1 - alpha) * state.fErr + alpha * ____error
    local absfErr = math.abs(state.fErr)
    if state.mode == "decay" and absfErr >= params.deadband + params.hysteresis then
        state.mode = "attack"
    end
    if state.mode == "attack" and absfErr <= params.deadband - params.hysteresis then
        state.mode = "decay"
    end
    self.modeHistory:add(state.mode)
    if state.mode == "attack" then
        state.lk = state.lk + params.attack * absfErr * dt
    else
        state.lk = state.lk + params.decay * (math.log(params.kp) - state.lk) * dt
    end
    local K = clamp(
        math.exp(state.lk),
        params.minK,
        params.maxK
    )
    local derivative = (____error - state.pErr) / dt
    state.pErr = ____error
    return K * ____error + params.kd * derivative
end
return ____exports
