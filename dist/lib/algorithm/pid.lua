-- lib/algorithm/pid.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/algorithm/pid.ts"] = _G.__tracetrace["lib/algorithm/pid.ts"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["13"] = 1,["14"] = 1,["15"] = 2,["16"] = 2,["17"] = 3,["18"] = 3,["19"] = 11,["20"] = 60,["21"] = 60,["22"] = 60,["23"] = 83,["24"] = 83,["25"] = 83,["27"] = 63,["28"] = 64,["29"] = 71,["30"] = 71,["31"] = 71,["32"] = 71,["33"] = 71,["34"] = 71,["35"] = 71,["36"] = 79,["37"] = 80,["38"] = 81,["39"] = 84,["40"] = 86,["41"] = 88,["42"] = 88,["43"] = 89,["44"] = 89,["45"] = 90,["46"] = 90,["47"] = 91,["48"] = 87,["49"] = 93,["50"] = 83,["51"] = 131,["52"] = 131,["53"] = 131,["55"] = 132,["56"] = 132,["58"] = 134,["59"] = 135,["60"] = 136,["61"] = 137,["62"] = 139,["63"] = 145,["64"] = 146,["65"] = 148,["66"] = 153,["67"] = 131,["68"] = 156,["69"] = 157,["70"] = 158,["71"] = 158,["72"] = 158,["73"] = 158,["74"] = 158,["75"] = 158,["76"] = 158,["77"] = 156,["78"] = 61,["84"] = 117,["86"] = 96,["87"] = 97,["88"] = 98,["89"] = 99,["90"] = 99,["91"] = 99,["92"] = 99,["93"] = 100,["94"] = 101,["95"] = 102,["96"] = 103,["97"] = 103,["98"] = 103,["99"] = 103,["100"] = 103,["101"] = 103,["102"] = 109,["104"] = 111,["105"] = 112,["116"] = 126,["117"] = 127,["118"] = 128,["120"] = 120,["121"] = 121,["122"] = 122});
local ____exports = {}
local ____config = require("lib.config")
local Config = ____config.Config
local ____history = require("lib.history")
local History = ____history.History
local ____util = require("lib.util")
local clamp = ____util.clamp
____exports.ZN = {basic = {kp = 0.6, ti = 0.5, td = 0.125}, lessOvershoot = {kp = 0.33, ti = 0.5, td = 0.33}, noOvershoot = {kp = 0.2, ti = 0.5, td = 0.33}}
____exports.PID = __TS__Class()
local PID = ____exports.PID
PID.name = "PID"
function PID.prototype.____constructor(self, cfg)
    if cfg == nil then
        cfg = {}
    end
    self._tuned = false
    self._tuning = {kp = 0, ki = 0, kd = 0, iMax = 1}
    self.state = {
        current = 0,
        target = 0,
        error = 0,
        integral = 0,
        cmd = 0
    }
    self.name = "default_pid"
    self.color = colors.lightGray
    self.errorHistory = __TS__New(History)
    __TS__ObjectAssign(self, cfg)
    ____exports.PID.config:load()
    local ____opt_0 = self.config
    local ____temp_8 = ____opt_0 and ____opt_0.ku or cfg.ku or 0
    local ____opt_2 = self.config
    local ____temp_9 = ____opt_2 and ____opt_2.ti or cfg.ti or 0
    local ____opt_4 = self.config
    local ____temp_10 = ____opt_4 and ____opt_4.tu or cfg.tu or 0
    local ____opt_6 = self.config
    self.config = {ku = ____temp_8, ti = ____temp_9, tu = ____temp_10, zn = ____opt_6 and ____opt_6.zn or cfg.zn or "basic"}
    ____exports.PID.config:save()
end
function PID.prototype.compute(self, current, target, dt)
    if dt == nil then
        dt = 1
    end
    if not self._tuned then
        self.tuning = {}
    end
    self.state.current = current
    self.state.target = target
    local ____error = target - current
    self.errorHistory:add(____error)
    self.state.integral = clamp(self.state.integral + ____error * dt, -self.tuning.iMax, self.tuning.iMax)
    local derivative = (____error - self.state.error) / dt
    self.state.error = ____error
    self.state.cmd = self.tuning.kp * ____error + self.tuning.ki * self.state.integral + self.tuning.kd * derivative
    return self.state.cmd
end
function PID.prototype.reset(self)
    self.tuning = {}
    self.state = {
        current = 0,
        target = 0,
        integral = 0,
        error = 0,
        cmd = 0
    }
end
PID.config = __TS__New(Config, "pids", {})
__TS__SetDescriptor(
    PID.prototype,
    "tuning",
    {
        get = function(self)
            return self._tuning
        end,
        set = function(self, tuning)
            if #__TS__ObjectKeys(tuning) == 0 then
                local zn = ____exports.ZN[self.config.zn]
                local ____self_config_11 = self.config
                local ku = ____self_config_11.ku
                local tu = ____self_config_11.tu
                local ti = ____self_config_11.ti
                local kp = zn.kp * ku
                local ki = kp / (zn.ti * tu) * ti
                local kd = zn.td * kp * tu / ti
                self._tuning = {
                    kp = not __TS__NumberIsNaN(__TS__Number(kp)) and __TS__NumberIsFinite(__TS__Number(kp)) and kp or 0,
                    ki = not __TS__NumberIsNaN(__TS__Number(ki)) and __TS__NumberIsFinite(__TS__Number(ki)) and ki or 0,
                    kd = not __TS__NumberIsNaN(__TS__Number(kd)) and __TS__NumberIsFinite(__TS__Number(kd)) and kd or 0,
                    iMax = 1
                }
                self._tuned = false
            else
                __TS__ObjectAssign(self._tuning, tuning)
                self._tuned = true
            end
        end
    },
    true
)
__TS__SetDescriptor(
    PID.prototype,
    "config",
    {
        get = function(self)
            local cfg = ____exports.PID.config.data[self.name] or ({})
            ____exports.PID.config.data[self.name] = cfg
            return cfg
        end,
        set = function(self, cfg)
            __TS__ObjectAssign(self.config, cfg)
            self:reset()
        end
    },
    true
)
return ____exports
