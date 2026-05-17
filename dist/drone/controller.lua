-- drone/controller.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["drone/controller.ts"] = _G.__tracetrace["drone/controller.ts"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["11"] = 2,["12"] = 2,["13"] = 3,["14"] = 3,["15"] = 3,["16"] = 3,["17"] = 4,["18"] = 4,["19"] = 4,["20"] = 4,["21"] = 4,["22"] = 4,["23"] = 5,["24"] = 5,["25"] = 5,["26"] = 7,["27"] = 7,["28"] = 8,["29"] = 8,["30"] = 10,["31"] = 10,["32"] = 10,["33"] = 10,["34"] = 10,["35"] = 10,["36"] = 10,["37"] = 12,["38"] = 13,["39"] = 12,["40"] = 55,["41"] = 55,["42"] = 55,["43"] = 64,["44"] = 64,["45"] = 64,["47"] = 64,["48"] = 61,["49"] = 62,["50"] = 65,["51"] = 66,["52"] = 68,["53"] = 68,["54"] = 68,["55"] = 68,["56"] = 68,["57"] = 68,["58"] = 68,["59"] = 76,["60"] = 76,["61"] = 76,["62"] = 76,["63"] = 76,["64"] = 76,["65"] = 76,["66"] = 83,["67"] = 64,["68"] = 86,["69"] = 87,["70"] = 88,["71"] = 86,["72"] = 91,["73"] = 92,["74"] = 93,["75"] = 94,["77"] = 96,["78"] = 97,["79"] = 97,["80"] = 97,["81"] = 97,["82"] = 97,["83"] = 97,["84"] = 97,["85"] = 97,["86"] = 97,["87"] = 91,["88"] = 108,["89"] = 109,["90"] = 110,["92"] = 108,["93"] = 114,["94"] = 114,["95"] = 114,["97"] = 115,["98"] = 116,["99"] = 117,["100"] = 119,["101"] = 120,["102"] = 121,["103"] = 122,["104"] = 123,["105"] = 126,["106"] = 127,["108"] = 129,["109"] = 129,["110"] = 131,["111"] = 132,["112"] = 133,["114"] = 135,["115"] = 138,["116"] = 141,["117"] = 144,["118"] = 145,["119"] = 146,["120"] = 147,["121"] = 149,["122"] = 150,["123"] = 151,["124"] = 152,["125"] = 155,["126"] = 156,["127"] = 158,["128"] = 160,["129"] = 161,["130"] = 162,["131"] = 163,["133"] = 160,["134"] = 160,["135"] = 160,["136"] = 114,["137"] = 170,["138"] = 171,["139"] = 172,["140"] = 173,["141"] = 174,["142"] = 175,["143"] = 176,["144"] = 178,["145"] = 178,["146"] = 180,["147"] = 181,["148"] = 182,["149"] = 183,["151"] = 185,["153"] = 178,["154"] = 188,["155"] = 189,["156"] = 190,["157"] = 191,["158"] = 193,["162"] = 178,["163"] = 198,["164"] = 199,["165"] = 200,["166"] = 201,["168"] = 203,["171"] = 178,["172"] = 207,["173"] = 208,["174"] = 209,["175"] = 210,["176"] = 211,["178"] = 213,["181"] = 178,["182"] = 178,["183"] = 171,["184"] = 170,["185"] = 221,["186"] = 222,["187"] = 223,["188"] = 224,["189"] = 225,["190"] = 226,["191"] = 227,["192"] = 228,["193"] = 230,["194"] = 230,["195"] = 230,["196"] = 232,["197"] = 232,["198"] = 232,["199"] = 232,["200"] = 232,["201"] = 232,["202"] = 232,["203"] = 230,["204"] = 230,["205"] = 230,["206"] = 242,["208"] = 243,["209"] = 243,["210"] = 243,["211"] = 243,["212"] = 243,["213"] = 243,["214"] = 243,["215"] = 243,["216"] = 244,["220"] = 245,["224"] = 246,["228"] = 247,["232"] = 248,["234"] = 242,["235"] = 250,["236"] = 251,["237"] = 251,["238"] = 253,["239"] = 253,["240"] = 253,["241"] = 253,["242"] = 251,["243"] = 254,["244"] = 254,["245"] = 254,["246"] = 254,["247"] = 251,["248"] = 251,["249"] = 257,["250"] = 221});
local ____exports = {}
local ____config = require("lib.config")
local Config = ____config.Config
local ____util = require("lib.util")
local clamp = ____util.clamp
local computeRotorThrusts = ____util.computeRotorThrusts
local normalizeThrusts = ____util.normalizeThrusts
local ____peripherals = require("drone.peripherals")
local applyThrusts = ____peripherals.applyThrusts
local peripherals = ____peripherals.peripherals
local sensors = ____peripherals.state
local stateLoop = ____peripherals.stateLoop
local stopRotors = ____peripherals.stopRotors
local ____events = require("lib.events")
local KeyEvent = ____events.KeyEvent
local pullEventAs = ____events.pullEventAs
local ____lac = require("lib.algorithm.lac")
local LAC = ____lac.LAC
local ____signal = require("lib.uwui-gpu.signal")
local signal = ____signal.signal
____exports.parts = {
    "alt",
    "velF",
    "velR",
    "pitch",
    "roll"
}
local function defaultConfig()
    return __TS__New(Config, "config", {controller = {max_pitch = 20, max_roll = 20}, base = {hover = 0.5, min = 0, max = 1}, trims = {fl = 0, fr = 0, bl = 0, br = 0}})
end
____exports.Controller = __TS__Class()
local Controller = ____exports.Controller
Controller.name = "Controller"
function Controller.prototype.____constructor(self, options)
    if options == nil then
        options = {}
    end
    self.options = options
    self.status = signal({})
    self._lastDts = {}
    self.cfg = options.cfg or defaultConfig()
    self.tunings = options.tunings or __TS__New(Config, "tunings", {})
    self.inputs = {
        alt = sensors.alt,
        velF = 0,
        velR = 0,
        pitch = 0,
        roll = 0
    }
    self.algos = {
        alt = __TS__New(LAC, "alt", self.tunings),
        velF = __TS__New(LAC, "velF", self.tunings),
        velR = __TS__New(LAC, "velR", self.tunings),
        pitch = __TS__New(LAC, "pitch", self.tunings),
        roll = __TS__New(LAC, "roll", self.tunings)
    }
    self:reset()
end
function Controller.prototype.load(self)
    self.cfg:load()
    self.tunings:load()
end
function Controller.prototype.reset(self)
    self:load()
    for ____, algo in ipairs(__TS__ObjectValues(self.algos)) do
        algo:reset()
    end
    stopRotors()
    self.status.value = {
        lastTick = os.clock(),
        tickCount = 0,
        dt = 0,
        avgDt = 0,
        upTime = 0,
        base = 0,
        thrusts = {fl = 0, fr = 0, br = 0, bl = 0}
    }
end
function Controller.prototype.setInputs(self, inputs)
    for ____, name in ipairs(____exports.parts) do
        self.inputs[name] = inputs[name] or self.inputs[name]
    end
end
function Controller.prototype.tick(self, noApply)
    if noApply == nil then
        noApply = false
    end
    local cfg = self.cfg.data
    local status = self.status.value
    local targets = self.inputs
    status.tickCount = status.tickCount + 1
    local now = os.clock()
    status.dt = math.max(0.05, now - status.lastTick)
    status.lastTick = now
    status.upTime = status.upTime + status.dt
    if #self._lastDts >= 4 then
        table.remove(self._lastDts, 1)
    end
    local ____self__lastDts_0 = self._lastDts
    ____self__lastDts_0[#____self__lastDts_0 + 1] = status.dt
    local dtSum = 0
    for ____, dt in ipairs(self._lastDts) do
        dtSum = dtSum + dt
    end
    status.avgDt = dtSum / 4
    local altCmd = self.algos.alt:compute(sensors.alt, targets.alt, status.avgDt)
    status.base = clamp(cfg.base.hover + altCmd, cfg.base.min, cfg.base.max)
    local velFCmd = self.algos.velF:compute(sensors.velF, targets.velF, status.dt)
    local maxPitch = self.cfg.data.controller.max_pitch
    local pitchTarget = clamp(targets.pitch - velFCmd * maxPitch, -maxPitch, maxPitch)
    local pitchCmd = self.algos.pitch:compute(sensors.pitch, pitchTarget, status.dt)
    local velRCmd = self.algos.velR:compute(sensors.velR, targets.velR, status.dt)
    local maxRoll = self.cfg.data.controller.max_roll
    local rollTarget = clamp(targets.roll + velRCmd * maxRoll, -maxRoll, maxRoll)
    local rollCmd = self.algos.roll:compute(sensors.roll, rollTarget, status.dt)
    status.thrusts = computeRotorThrusts(status.base, pitchCmd, rollCmd, cfg.trims)
    normalizeThrusts(status.thrusts)
    self.status.value = status
    parallel.waitForAll(
        function()
            if not noApply then
                applyThrusts(status.thrusts)
            end
        end,
        function() return sleep(0) end
    )
end
function Controller.prototype.loop(self)
    return function()
        local opts = self.options or ({})
        opts.display = opts.display ~= false
        opts.tick = opts.tick ~= false
        opts.load = opts.load ~= false
        opts.quit = opts.quit ~= false
        parallel.waitForAny(
            stateLoop,
            function()
                while true do
                    if opts.load then
                        self:load()
                    end
                    sleep(3)
                end
            end,
            function()
                while true do
                    sleep(10)
                    local e = pullEventAs(KeyEvent, "key")
                    if (e and e.key) == keys.q then
                        return
                    end
                end
            end,
            function()
                while true do
                    if opts.tick then
                        self:tick()
                    else
                        sleep(1)
                    end
                end
            end,
            function()
                while true do
                    if peripherals.monitors.status and opts.display then
                        self:printStatus(peripherals.monitors.status)
                        sleep(0.5)
                    else
                        sleep(3)
                    end
                end
            end
        )
    end
end
function Controller.prototype.printStatus(self, target)
    local oldTerm = term.redirect(target or term.current())
    target.setTextScale(1)
    term.clear()
    term.setCursorPos(1, 1)
    local s = self.status.value
    term.setTextColor(colors.lightGray)
    print(string.format("DT: %.2f", s.avgDt))
    local function pidsRow(fmt, pid)
        return {
            10,
            {
                pid.name,
                string.format("%s" .. fmt, pid.state.current >= 0 and " " or "", pid.state.current),
                string.format("%s" .. fmt, pid.state.target >= 0 and " " or "", pid.state.target),
                string.format("%s" .. fmt, pid.state.error >= 0 and " " or "", pid.state.error),
                string.format("%s%.3f", pid.state.output >= 0 and " " or "", pid.state.output),
                pid.state.mode == "attack" and "ATK" or "DEC"
            }
        }
    end
    local ____textutils_tabulate_4 = textutils.tabulate
    local ____array_3 = __TS__SparseArrayNew(
        {
            "PIDs",
            "Current",
            "Target",
            "Error",
            "Cmd",
            "Mode"
        },
        table.unpack(pidsRow("%.1f", self.algos.alt))
    )
    __TS__SparseArrayPush(
        ____array_3,
        table.unpack(pidsRow("%.2f", self.algos.velF))
    )
    __TS__SparseArrayPush(
        ____array_3,
        table.unpack(pidsRow("%.2f", self.algos.velR))
    )
    __TS__SparseArrayPush(
        ____array_3,
        table.unpack(pidsRow("%.2f", self.algos.pitch))
    )
    __TS__SparseArrayPush(
        ____array_3,
        table.unpack(pidsRow("%.2f", self.algos.roll))
    )
    ____textutils_tabulate_4(__TS__SparseArraySpread(____array_3))
    print("")
    textutils.tabulate(
        {"Thrusts", "Left", "Right"},
        {
            "Front",
            string.format("%.3f", s.thrusts.fl),
            string.format("%.3f", s.thrusts.fr)
        },
        {
            "Back",
            string.format("%.3f", s.thrusts.bl),
            string.format("%.3f", s.thrusts.br)
        }
    )
    term.redirect(oldTerm)
end
return ____exports
