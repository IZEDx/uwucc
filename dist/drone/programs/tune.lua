package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["10"] = 1,["11"] = 1,["12"] = 1,["13"] = 2,["14"] = 2,["15"] = 3,["16"] = 3,["17"] = 3,["18"] = 5,["19"] = 5,["20"] = 6,["21"] = 6,["22"] = 7,["23"] = 7,["24"] = 9,["25"] = 26,["26"] = 44,["27"] = 44,["28"] = 44,["29"] = 44,["30"] = 44,["31"] = 44,["32"] = 44,["33"] = 52,["34"] = 53,["35"] = 55,["36"] = 55,["37"] = 55,["38"] = 55,["39"] = 55,["40"] = 55,["41"] = 55,["42"] = 56,["43"] = 56,["44"] = 56,["45"] = 56,["46"] = 56,["47"] = 56,["48"] = 56,["49"] = 64,["50"] = 64,["51"] = 64,["52"] = 64,["53"] = 64,["54"] = 64,["55"] = 64,["56"] = 72,["57"] = 72,["58"] = 72,["59"] = 72,["60"] = 72,["61"] = 72,["62"] = 72,["63"] = 80,["64"] = 81,["65"] = 82,["66"] = 83,["67"] = 83,["68"] = 83,["69"] = 83,["70"] = 83,["71"] = 83,["72"] = 83,["74"] = 87,["75"] = 88,["76"] = 90,["77"] = 91,["78"] = 92,["80"] = 94,["81"] = 94,["82"] = 95,["83"] = 96,["84"] = 97,["85"] = 97,["87"] = 98,["88"] = 98,["90"] = 100,["91"] = 101,["92"] = 102,["93"] = 103,["94"] = 104,["95"] = 105,["96"] = 106,["97"] = 107,["98"] = 108,["99"] = 109,["100"] = 110,["103"] = 94,["107"] = 115,["108"] = 115,["109"] = 116,["110"] = 115,["113"] = 119,["114"] = 119,["115"] = 119,["116"] = 119,["117"] = 119,["118"] = 122,["119"] = 123,["120"] = 124,["122"] = 126,["123"] = 129,["124"] = 131,["125"] = 131,["126"] = 131,["127"] = 131,["128"] = 131,["129"] = 131,["130"] = 131,["131"] = 80,["132"] = 134,["133"] = 135,["134"] = 137,["135"] = 138,["136"] = 139,["137"] = 140,["139"] = 143,["140"] = 144,["141"] = 149,["143"] = 156,["144"] = 157,["145"] = 159,["146"] = 160,["147"] = 161,["148"] = 162,["149"] = 163,["151"] = 165,["153"] = 160,["154"] = 168,["155"] = 169,["156"] = 172,["157"] = 173,["158"] = 175,["159"] = 176,["160"] = 177,["161"] = 178,["162"] = 180,["163"] = 181,["164"] = 182,["165"] = 182,["166"] = 182,["167"] = 182,["168"] = 182,["169"] = 182,["170"] = 189,["171"] = 190,["173"] = 194,["174"] = 195,["175"] = 197,["176"] = 198,["177"] = 200,["178"] = 201,["179"] = 204,["180"] = 204,["181"] = 204,["182"] = 204,["183"] = 204,["184"] = 204,["185"] = 207,["186"] = 209,["187"] = 210,["188"] = 212,["189"] = 213,["190"] = 214,["191"] = 215,["192"] = 216,["193"] = 216,["194"] = 216,["195"] = 216,["196"] = 217,["197"] = 218,["198"] = 219,["199"] = 220,["200"] = 221,["201"] = 222,["202"] = 223,["203"] = 224,["204"] = 225,["205"] = 226,["206"] = 228,["207"] = 229,["208"] = 230,["211"] = 234,["214"] = 241,["215"] = 243,["216"] = 244,["217"] = 245,["218"] = 246,["219"] = 247,["221"] = 250,["222"] = 251,["223"] = 252,["224"] = 253,["225"] = 254,["226"] = 261,["227"] = 262,["228"] = 263,["229"] = 264,["230"] = 266,["231"] = 267,["232"] = 268,["233"] = 270,["234"] = 271,["235"] = 272,["236"] = 273,["237"] = 274,["238"] = 275,["239"] = 276,["240"] = 277,["241"] = 278,["242"] = 279,["243"] = 281,["244"] = 284,["245"] = 285,["246"] = 286,["247"] = 291,["248"] = 292,["249"] = 293,["250"] = 295,["251"] = 296,["252"] = 134,["253"] = 299,["254"] = 300,["255"] = 301,["256"] = 301,["257"] = 301,["258"] = 302,["260"] = 305,["261"] = 307,["262"] = 307,["263"] = 307,["264"] = 308,["266"] = 299,["267"] = 312,["268"] = 313,["269"] = 315,["270"] = 316,["271"] = 317,["273"] = 318,["274"] = 318,["275"] = 319,["276"] = 318,["279"] = 321,["280"] = 322,["281"] = 323,["282"] = 325,["283"] = 326,["284"] = 328,["285"] = 329,["286"] = 330,["288"] = 312,["289"] = 334,["290"] = 334,["291"] = 334,["292"] = 334});
local ____exports = {}
local ____chalk = require("lib.chalk")
local anyKey = ____chalk.anyKey
local showHeader = ____chalk.showHeader
local ____controller = require("drone.controller")
local Controller = ____controller.Controller
local ____events = require("lib.events")
local KeyEvent = ____events.KeyEvent
local pullEventAs = ____events.pullEventAs
local ____peripherals = require("drone.peripherals")
local stopRotors = ____peripherals.stopRotors
local ____pid = require("lib.algorithm.pid")
local PID = ____pid.PID
local ____program = require("lib.program")
local program = ____program.program
stopRotors()
local ZN = {basic = {kp = 0.6, ti = 0.5, td = 0.125}, lessOvershoot = {kp = 0.33, ti = 0.5, td = 0.33}, noOvershoot = {kp = 0.2, ti = 0.5, td = 0.33}}
local CONFIG = {
    OSCILLATION_THRESHOLD = 1,
    STEP_TIME = 30,
    SETTLE_TIME = 3,
    CROSSINGS = 5,
    KP_STEPS = 20
}
local controller = __TS__New(Controller)
controller.inputs.alt = controller.inputs.alt + 30
local pidNames = {
    "alt",
    "pitch",
    "roll",
    "velF",
    "velR"
}
local defaultKps = {
    alt = 0.03,
    pitch = 0.003,
    roll = 0.003,
    velF = 0.05,
    velR = 0.05
}
local targetOffsets = {
    alt = 10,
    velF = 0,
    velR = 0,
    pitch = 0,
    roll = 0
}
local targetRanges = {
    alt = 0,
    velF = 10,
    velR = 10,
    pitch = 10,
    roll = 10
}
local function detectOscillation(errorHistory)
    local elapsed = errorHistory:timespan()
    if elapsed < CONFIG.STEP_TIME / 2 then
        return {
            isOscillating = false,
            amplitude = 0,
            frequency = 0,
            period = 0,
            crossings = 0
        }
    end
    local firstCrossing = 0
    local crossings = 0
    local minVal = math.huge
    local maxVal = -math.huge
    local amplitudes = {}
    do
        local i = 1
        while i < errorHistory:size() do
            local prev = errorHistory:get(i - 1) or 0
            local curr = errorHistory:get(i) or 0
            if curr < minVal then
                minVal = curr
            end
            if curr > maxVal then
                maxVal = curr
            end
            if prev * curr < 0 then
                crossings = crossings + 1
                if firstCrossing == 0 then
                    firstCrossing = i - 1
                    minVal = curr
                    maxVal = -curr
                elseif (crossings - 1) % 2 == 0 then
                    local amplitude = math.abs(maxVal - minVal) / 2
                    amplitudes[#amplitudes + 1] = amplitude
                    minVal = curr
                    maxVal = curr
                end
            end
            i = i + 1
        end
    end
    do
        local i = 2
        while i < firstCrossing do
            errorHistory:shift()
            i = i + 1
        end
    end
    local amplitude = __TS__ArrayReduce(
        amplitudes,
        function(____, a, b) return a + b end,
        0
    ) / math.max(#amplitudes, 1)
    local period = 0
    if crossings > 0 then
        period = 2 * elapsed / crossings
    end
    local frequency = 1 / math.max(0.001, period)
    local isOscillating = amplitude > CONFIG.OSCILLATION_THRESHOLD and crossings > CONFIG.CROSSINGS
    return {
        isOscillating = isOscillating,
        amplitude = amplitude,
        frequency = frequency,
        period = period,
        crossings = crossings
    }
end
local function tuneWithZN(name)
    controller:reset()
    for ____, n in ipairs(__TS__ObjectKeys(controller.algos)) do
        local pid = controller.algos[n]
        pid:reset()
        pid.errorHistory:clear()
    end
    if not __TS__StringStartsWith(name, "vel") then
        controller.algos.velF.tuning = {kp = 0, ki = 0, kd = 0}
        controller.algos.velR.tuning = {kp = 0, ki = 0, kd = 0}
    end
    local pid = controller.algos[name]
    pid.errorHistory._timespan = CONFIG.STEP_TIME
    local oldKp = pid.tuning.kp > 0 and pid.tuning.kp or defaultKps[name]
    local function stepToKp(step)
        local v = ((step + 1) / CONFIG.KP_STEPS - 0.5) * 2
        if v < 0 then
            return oldKp - oldKp * v * v
        else
            return oldKp + oldKp * v * v
        end
    end
    local maxKp = stepToKp(CONFIG.KP_STEPS)
    local minKp = stepToKp(0)
    local originTarget = controller.inputs[name]
    local startTime = os.clock()
    local step = 0
    local criticalKp = 0
    local criticalPeriod = 0
    local crossingss = 0
    while step < CONFIG.KP_STEPS and criticalKp == 0 do
        pid:reset()
        pid.tuning = {
            kp = stepToKp(step),
            ki = 0,
            kd = 0,
            iMax = 1
        }
        if step % 2 == 0 then
            controller.inputs[name] = originTarget + targetOffsets[name] + targetRanges[name] * 2 * (math.random() - 0.5)
        end
        step = step + 1
        local stepTime = 0
        while stepTime < CONFIG.STEP_TIME and criticalKp == 0 do
            local elapsed = os.clock() - startTime
            controller:tick()
            stepTime = stepTime + controller.status.dt
            local ____detectOscillation_result_0 = detectOscillation(pid.errorHistory)
            local isOscillating = ____detectOscillation_result_0.isOscillating
            local amplitude = ____detectOscillation_result_0.amplitude
            local frequency = ____detectOscillation_result_0.frequency
            local period = ____detectOscillation_result_0.period
            local crossings = ____detectOscillation_result_0.crossings
            crossingss = crossings
            showHeader(("Tuning " .. name) .. "...")
            print("")
            term.setTextColor(colors.lightBlue)
            print(string.format("Step: %d / %d     ", step, CONFIG.KP_STEPS))
            print(string.format("Elapsed: %ds", elapsed))
            term.setTextColor(colors.blue)
            print(string.format(
                "Sampled: %.2fs",
                pid.errorHistory:timespan()
            ))
            term.setTextColor(colors.purple)
            print(string.format("Kp: %.5f < %.5f < %.5f     ", minKp, pid.tuning.kp, maxKp))
            term.setTextColor(colors.pink)
            print(string.format("Amp: %.5f    ", amplitude))
            print(string.format("Crossings: %d / %d    ", crossings, CONFIG.CROSSINGS))
            print(string.format("Period: %.2f   ", period))
            print("")
            term.setTextColor(colors.lightGray)
            print("Press Q to cancel")
            term.setTextColor(colors.white)
            if isOscillating then
                criticalKp = pid.tuning.kp
                criticalPeriod = period
            end
        end
        if crossingss < 2 then
        end
    end
    pid.errorHistory._timespan = 10
    if criticalKp == 0 then
        controller:reset()
        print("ERROR: Could not find critical gain!")
        anyKey()
        return false
    end
    showHeader(name .. " tuned! :3")
    print("")
    term.setTextColor(colors.lightBlue)
    print(string.format("Critical Kp: %.2f | Period: %.2f sec", criticalKp, criticalPeriod))
    print("")
    local zn = ZN[pid.config.zn]
    local ku = criticalKp
    local tu = criticalPeriod
    local ti = controller.status.avgDt
    local kp = zn.kp * ku
    local ki = kp / (zn.ti * tu) * ti
    local kd = zn.td * kp * tu / ti
    term.setTextColor(colors.blue)
    print("Calculated tunings:")
    print(string.format("  Zn: %s", pid.config.zn))
    print(string.format("  Ku: %.10f", ku))
    print(string.format("  Tu: %.10f", tu))
    print(string.format("  Ti: %.10f", ti))
    print(string.format("  Kp: %.10f", kp))
    print(string.format("  Ki: %.10f", ki))
    print(string.format("  Kd: %.10f", kd))
    print("")
    controller:reset()
    term.setTextColor(colors.purple)
    print("Saving tunings...")
    pid.config = {ku = ku, ti = ti, tu = tu}
    PID.config:save()
    print("")
    term.setTextColor(colors.white)
    anyKey()
    return true
end
local function tune(pidName)
    local originalTargets = {}
    for ____, ____value in ipairs(__TS__ObjectEntries(controller.inputs)) do
        local name = ____value[1]
        local target = ____value[2]
        originalTargets[name] = target
    end
    tuneWithZN(pidName)
    for ____, ____value in ipairs(__TS__ObjectEntries(originalTargets)) do
        local name = ____value[1]
        local target = ____value[2]
        controller.inputs[name] = target
    end
end
local function tuningMenu()
    controller:reset()
    showHeader("PID Auto-Tuner :3")
    print("")
    print("Available PIDs:")
    do
        local i = 0
        while i < #pidNames do
            print((("  " .. tostring(i + 1)) .. ". ") .. pidNames[i + 1])
            i = i + 1
        end
    end
    print("  0. Exit")
    print("")
    print(("Select PID to tune (1-" .. tostring(#pidNames)) .. "): ")
    local choice = pullEventAs(KeyEvent, "key")
    local idx = choice and tonumber(string.char(choice.key)) or 0
    if idx > 0 and idx <= #pidNames then
        tune(pidNames[idx])
        tuningMenu()
    end
end
program(
    tuningMenu,
    controller:loop({display = true, load = false, tick = false, quit = true})
)
return ____exports
