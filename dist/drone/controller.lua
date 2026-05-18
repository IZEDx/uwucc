package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["11"] = 2,["12"] = 2,["13"] = 3,["14"] = 3,["15"] = 3,["16"] = 3,["17"] = 4,["18"] = 4,["19"] = 4,["20"] = 4,["21"] = 4,["22"] = 4,["23"] = 5,["24"] = 5,["25"] = 5,["26"] = 7,["27"] = 7,["28"] = 8,["29"] = 8,["30"] = 9,["31"] = 9,["32"] = 11,["33"] = 11,["34"] = 11,["35"] = 11,["36"] = 11,["37"] = 11,["38"] = 11,["39"] = 13,["40"] = 14,["41"] = 13,["42"] = 56,["43"] = 56,["44"] = 56,["45"] = 65,["46"] = 65,["47"] = 65,["49"] = 65,["50"] = 62,["51"] = 63,["52"] = 66,["53"] = 67,["54"] = 69,["55"] = 69,["56"] = 69,["57"] = 69,["58"] = 69,["59"] = 69,["60"] = 69,["61"] = 77,["62"] = 77,["63"] = 77,["64"] = 77,["65"] = 77,["66"] = 77,["67"] = 77,["68"] = 84,["69"] = 65,["70"] = 87,["71"] = 88,["72"] = 89,["73"] = 87,["74"] = 92,["75"] = 93,["76"] = 94,["77"] = 95,["79"] = 97,["80"] = 98,["81"] = 98,["82"] = 98,["83"] = 98,["84"] = 98,["85"] = 98,["86"] = 98,["87"] = 98,["88"] = 98,["89"] = 92,["90"] = 109,["91"] = 110,["92"] = 111,["94"] = 109,["95"] = 115,["96"] = 115,["97"] = 115,["99"] = 116,["100"] = 117,["101"] = 118,["102"] = 120,["103"] = 121,["104"] = 122,["105"] = 123,["106"] = 124,["107"] = 127,["108"] = 128,["110"] = 130,["111"] = 130,["112"] = 132,["113"] = 133,["114"] = 134,["116"] = 136,["117"] = 139,["118"] = 142,["119"] = 149,["120"] = 150,["121"] = 150,["122"] = 150,["123"] = 150,["124"] = 150,["125"] = 155,["126"] = 156,["127"] = 157,["128"] = 159,["129"] = 160,["130"] = 161,["131"] = 162,["132"] = 165,["133"] = 166,["134"] = 168,["135"] = 170,["136"] = 171,["137"] = 172,["138"] = 173,["140"] = 170,["141"] = 170,["142"] = 170,["143"] = 115,["144"] = 180,["145"] = 181,["146"] = 182,["147"] = 183,["148"] = 184,["149"] = 185,["150"] = 186,["151"] = 188,["152"] = 188,["153"] = 190,["154"] = 191,["155"] = 192,["156"] = 193,["158"] = 195,["160"] = 188,["161"] = 198,["162"] = 199,["163"] = 200,["164"] = 201,["165"] = 203,["169"] = 188,["170"] = 208,["171"] = 209,["172"] = 210,["173"] = 211,["175"] = 213,["178"] = 188,["179"] = 217,["180"] = 218,["181"] = 219,["182"] = 220,["183"] = 221,["185"] = 223,["188"] = 188,["189"] = 188,["190"] = 181,["191"] = 180,["192"] = 231,["193"] = 232,["194"] = 233,["195"] = 234,["196"] = 235,["197"] = 236,["198"] = 237,["199"] = 238,["200"] = 240,["201"] = 240,["202"] = 240,["203"] = 242,["204"] = 242,["205"] = 242,["206"] = 242,["207"] = 242,["208"] = 242,["209"] = 242,["210"] = 240,["211"] = 240,["212"] = 240,["213"] = 252,["215"] = 253,["216"] = 253,["217"] = 253,["218"] = 253,["219"] = 253,["220"] = 253,["221"] = 253,["222"] = 253,["223"] = 254,["227"] = 255,["231"] = 256,["235"] = 257,["239"] = 258,["241"] = 252,["242"] = 260,["243"] = 261,["244"] = 261,["245"] = 263,["246"] = 263,["247"] = 263,["248"] = 263,["249"] = 261,["250"] = 264,["251"] = 264,["252"] = 264,["253"] = 264,["254"] = 261,["255"] = 261,["256"] = 267,["257"] = 231});
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
local ____math = require("lib.math")
local lerp = ____math.lerp
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
    status.base = clamp((cfg.base.hover + altCmd) * (1 - sensors.airP / 2), cfg.base.min, cfg.base.max)
    local prevVelF = self.algos.velF.sensorHistory:youngest() or 0
    local velFCmd = self.algos.velF:compute(
        lerp(prevVelF, sensors.velF, 0.2),
        targets.velF,
        status.dt
    )
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
