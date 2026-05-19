package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["12"] = 2,["13"] = 2,["14"] = 3,["15"] = 3,["16"] = 3,["17"] = 3,["18"] = 4,["19"] = 4,["20"] = 4,["21"] = 4,["22"] = 4,["23"] = 4,["24"] = 5,["25"] = 5,["26"] = 5,["27"] = 7,["28"] = 7,["29"] = 8,["30"] = 8,["31"] = 9,["32"] = 9,["33"] = 11,["34"] = 11,["35"] = 11,["36"] = 11,["37"] = 11,["38"] = 11,["39"] = 11,["40"] = 11,["41"] = 13,["42"] = 14,["43"] = 13,["44"] = 56,["45"] = 56,["46"] = 56,["47"] = 65,["48"] = 65,["49"] = 65,["51"] = 65,["52"] = 62,["53"] = 63,["54"] = 66,["55"] = 67,["56"] = 69,["57"] = 69,["58"] = 69,["59"] = 69,["60"] = 69,["61"] = 69,["62"] = 69,["63"] = 69,["64"] = 78,["65"] = 78,["66"] = 78,["67"] = 78,["68"] = 78,["69"] = 78,["70"] = 78,["71"] = 78,["72"] = 86,["73"] = 65,["74"] = 89,["75"] = 90,["76"] = 91,["77"] = 89,["78"] = 94,["79"] = 95,["80"] = 96,["81"] = 97,["83"] = 99,["84"] = 100,["85"] = 100,["86"] = 100,["87"] = 100,["88"] = 100,["89"] = 100,["90"] = 100,["91"] = 100,["92"] = 100,["93"] = 94,["94"] = 111,["95"] = 112,["96"] = 113,["98"] = 111,["99"] = 117,["100"] = 117,["101"] = 117,["103"] = 118,["104"] = 119,["105"] = 120,["106"] = 122,["107"] = 124,["108"] = 125,["109"] = 126,["110"] = 127,["111"] = 129,["112"] = 129,["114"] = 130,["115"] = 130,["116"] = 132,["117"] = 132,["118"] = 132,["119"] = 132,["120"] = 132,["121"] = 135,["122"] = 138,["123"] = 140,["124"] = 140,["125"] = 140,["126"] = 140,["127"] = 140,["128"] = 146,["129"] = 149,["130"] = 150,["131"] = 150,["132"] = 150,["133"] = 150,["134"] = 150,["135"] = 156,["136"] = 157,["137"] = 158,["138"] = 160,["139"] = 162,["140"] = 163,["141"] = 164,["142"] = 166,["143"] = 167,["144"] = 169,["145"] = 171,["146"] = 172,["147"] = 172,["149"] = 173,["150"] = 171,["151"] = 117,["152"] = 177,["153"] = 178,["154"] = 179,["155"] = 180,["156"] = 181,["157"] = 182,["158"] = 183,["159"] = 185,["160"] = 185,["161"] = 187,["162"] = 188,["163"] = 189,["164"] = 190,["166"] = 192,["168"] = 185,["169"] = 195,["170"] = 196,["171"] = 197,["172"] = 198,["173"] = 200,["177"] = 185,["178"] = 205,["179"] = 206,["180"] = 207,["181"] = 208,["183"] = 210,["186"] = 185,["187"] = 214,["188"] = 215,["189"] = 216,["190"] = 217,["191"] = 218,["193"] = 220,["196"] = 185,["197"] = 185,["198"] = 178,["199"] = 177,["200"] = 228,["201"] = 229,["202"] = 230,["203"] = 231,["204"] = 232,["205"] = 233,["206"] = 234,["207"] = 235,["208"] = 237,["209"] = 237,["210"] = 237,["211"] = 239,["212"] = 239,["213"] = 239,["214"] = 239,["215"] = 239,["216"] = 239,["217"] = 239,["218"] = 237,["219"] = 237,["220"] = 237,["221"] = 249,["223"] = 250,["224"] = 250,["225"] = 250,["226"] = 250,["227"] = 250,["228"] = 250,["229"] = 250,["230"] = 250,["231"] = 251,["235"] = 252,["239"] = 253,["243"] = 254,["247"] = 255,["249"] = 249,["250"] = 257,["251"] = 258,["252"] = 258,["253"] = 260,["254"] = 260,["255"] = 260,["256"] = 260,["257"] = 258,["258"] = 261,["259"] = 261,["260"] = 261,["261"] = 261,["262"] = 258,["263"] = 258,["264"] = 264,["265"] = 228});
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
    "velU",
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
        velU = 0,
        velR = 0,
        pitch = 0,
        roll = 0
    }
    self.algos = {
        alt = __TS__New(LAC, "alt", self.tunings),
        velU = __TS__New(LAC, "velU", self.tunings),
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
    status.avgDt = __TS__ArrayReduce(
        self._lastDts,
        function(____, a, b) return a + b end,
        0
    ) / #self._lastDts
    local velUTarget = self.algos.alt:compute(sensors.alt, targets.alt, status.avgDt)
    local prevVelU = self.algos.velU.sensorHistory:youngest() or 0
    local velUCmd = self.algos.velU:compute(
        lerp(prevVelU, sensors.velU, 0.2),
        velUTarget,
        status.avgDt
    )
    status.base = clamp(cfg.base.hover + velUCmd, cfg.base.min, cfg.base.max)
    local prevVelF = self.algos.velF.sensorHistory:youngest() or 0
    local velFCmd = self.algos.velF:compute(
        lerp(prevVelF, sensors.velF, 0.2),
        targets.velF,
        status.avgDt
    )
    local maxPitch = cfg.controller.max_pitch
    local pitchTarget = clamp(targets.pitch - velFCmd * maxPitch, -maxPitch, maxPitch)
    local pitchCmd = self.algos.pitch:compute(sensors.pitch, pitchTarget, status.avgDt)
    local velRCmd = self.algos.velR:compute(sensors.velR, targets.velR, status.avgDt)
    local maxRoll = cfg.controller.max_roll
    local rollTarget = clamp(targets.roll + velRCmd * maxRoll, -maxRoll, maxRoll)
    local rollCmd = self.algos.roll:compute(sensors.roll, rollTarget, status.avgDt)
    status.thrusts = computeRotorThrusts(status.base, pitchCmd, rollCmd, cfg.trims)
    normalizeThrusts(status.thrusts)
    self.status.value = status
    parallel.waitForAll(function()
        if not noApply then
            applyThrusts(status.thrusts)
        end
        sleep(0)
    end)
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
