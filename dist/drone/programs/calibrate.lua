package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["7"] = 1,["8"] = 1,["9"] = 2,["10"] = 2,["11"] = 3,["12"] = 3,["13"] = 3,["14"] = 4,["15"] = 4,["16"] = 4,["17"] = 5,["18"] = 5,["19"] = 5,["20"] = 7,["21"] = 8,["22"] = 9,["23"] = 10,["24"] = 11,["25"] = 13,["26"] = 17,["27"] = 17,["28"] = 17,["29"] = 17,["30"] = 17,["31"] = 17,["32"] = 17,["33"] = 17,["34"] = 26,["35"] = 27,["36"] = 28,["37"] = 29,["38"] = 30,["39"] = 31,["40"] = 32,["41"] = 33,["42"] = 41,["43"] = 42,["44"] = 43,["46"] = 46,["47"] = 47,["48"] = 48,["49"] = 49,["50"] = 50,["51"] = 51,["52"] = 53,["53"] = 54,["54"] = 55,["55"] = 56,["56"] = 58,["57"] = 59,["58"] = 59,["59"] = 59,["60"] = 59,["61"] = 60,["62"] = 60,["63"] = 60,["64"] = 60,["65"] = 61,["66"] = 62,["67"] = 63,["68"] = 65,["69"] = 66,["70"] = 73,["71"] = 75,["72"] = 76,["73"] = 78,["74"] = 79,["75"] = 80,["76"] = 81,["77"] = 81,["78"] = 81,["79"] = 81,["80"] = 82,["81"] = 83,["82"] = 84,["83"] = 85,["84"] = 85,["85"] = 84,["86"] = 90,["87"] = 91,["88"] = 92,["89"] = 93,["90"] = 94,["91"] = 95,["92"] = 96,["93"] = 97,["94"] = 98,["95"] = 98,["96"] = 100,["97"] = 100,["98"] = 100,["99"] = 100,["100"] = 98,["101"] = 101,["102"] = 101,["103"] = 101,["104"] = 101,["105"] = 98,["106"] = 98,["107"] = 103,["108"] = 104,["109"] = 105,["110"] = 106,["111"] = 108,["112"] = 114,["113"] = 120,["114"] = 126,["115"] = 133,["116"] = 134,["117"] = 135,["118"] = 136,["119"] = 137,["120"] = 138,["122"] = 140,["124"] = 143,["125"] = 144,["127"] = 147,["128"] = 148,["129"] = 149,["130"] = 150,["131"] = 151,["133"] = 154,["134"] = 155,["135"] = 156,["136"] = 157,["137"] = 158,["138"] = 159,["139"] = 160,["144"] = 166,["145"] = 168,["146"] = 169,["147"] = 171,["148"] = 172,["149"] = 173,["150"] = 174,["151"] = 175,["152"] = 175,["153"] = 177,["154"] = 177,["155"] = 177,["156"] = 177,["157"] = 175,["158"] = 178,["159"] = 178,["160"] = 178,["161"] = 178,["162"] = 175,["163"] = 175,["164"] = 181,["165"] = 182,["166"] = 183,["167"] = 185,["168"] = 186,["169"] = 187,["171"] = 26,["172"] = 191,["173"] = 191,["174"] = 191,["175"] = 191});
local ____exports = {}
local ____program = require("lib.program")
local program = ____program.program
local ____controller = require("drone.controller")
local Controller = ____controller.Controller
local ____peripherals = require("drone.peripherals")
local sensors = ____peripherals.state
local stopRotors = ____peripherals.stopRotors
local ____util = require("lib.util")
local centerValues = ____util.centerValues
local clamp = ____util.clamp
local ____chalk = require("lib.chalk")
local anyKey = ____chalk.anyKey
local showHeader = ____chalk.showHeader
local TRIM_STEP = 0.00005
local MAX_TRIM = 0.3
local ANGLE_THRESHOLD = 1.5
local SETTLE_TIME = 1
local TARGET_HEIGHT = 3
local controller = __TS__New(Controller, {load = false, tick = false})
controller.inputs = {
    alt = controller.inputs.alt,
    velF = 0,
    velR = 0,
    velU = 0,
    pitch = 0,
    roll = 0
}
local function calibrationLoop()
    stopRotors()
    local cfg = controller.cfg.data
    local success = false
    local settleTime = 0
    local base = cfg.base.hover * 0.6
    local trimDelta = 0
    local trims = {fl = base, fr = base, bl = base, br = base}
    for ____, pid in ipairs(__TS__ObjectValues(controller.algos)) do
        pid.disabled.value = true
        pid:reset()
    end
    showHeader("Trim Calibrator :3")
    print("")
    print("This will calibrate the base hover and rotor trims.")
    print("Make sure the aircraft is still and level before starting.")
    print("")
    anyKey()
    local settledPitch = sensors.pitch
    local settledRoll = sensors.roll
    local originAlt = sensors.alt
    local startTime = os.clock()
    while true do
        local minTrim = math.min(
            math.huge,
            table.unpack(__TS__ObjectValues(trims))
        )
        local maxTrim = math.max(
            -math.huge,
            table.unpack(__TS__ObjectValues(trims))
        )
        trimDelta = maxTrim - minTrim
        base = minTrim + trimDelta / 2
        local settled = clamp(settleTime * 100 / SETTLE_TIME, 0, 100)
        cfg.base.hover = 0
        cfg.trims = {fl = trims.fl * (settled / 100), fr = trims.fr * (settled / 100), bl = trims.bl * (settled / 100), br = trims.br * (settled / 100)}
        controller:tick()
        local pitchError = sensors.pitch - settledPitch
        local rollError = sensors.roll - settledRoll
        showHeader("Calibrating Trims...")
        print("")
        term.setTextColor(colors.lightBlue)
        print(string.format(
            "Elapsed: %ds",
            os.clock() - startTime
        ))
        term.setTextColor(colors.blue)
        print(string.format("Settled: %d%%", settled))
        print(string.format(
            "Height: %d%%",
            clamp((sensors.alt - originAlt) * 100 / TARGET_HEIGHT, 0, 100)
        ))
        print("")
        term.setTextColor(colors.purple)
        print(string.format("Base Hover: %.3f", base))
        print(string.format("Deviation: %.3f", trimDelta))
        print(string.format("Pitch Error: %.3f", pitchError))
        print(string.format("Roll Error: %.3f", rollError))
        print("")
        term.setTextColor(colors.pink)
        textutils.tabulate(
            {"Trims", "Left", "Right"},
            {
                "Front",
                string.format("%.3f", trims.fl),
                string.format("%.3f", trims.fr)
            },
            {
                "Back",
                string.format("%.3f", trims.bl),
                string.format("%.3f", trims.br)
            }
        )
        print("")
        term.setTextColor(colors.lightGray)
        print("Press Q to cancel")
        term.setTextColor(colors.white)
        local pitchFront = pitchError > ANGLE_THRESHOLD and -TRIM_STEP * 10 or (pitchError < -ANGLE_THRESHOLD and -TRIM_STEP or 0)
        local pitchBack = pitchError > ANGLE_THRESHOLD and -TRIM_STEP or (pitchError < -ANGLE_THRESHOLD and -TRIM_STEP * 10 or 0)
        local rollLeft = rollError > ANGLE_THRESHOLD and -TRIM_STEP * 10 or (rollError < -ANGLE_THRESHOLD and -TRIM_STEP or 0)
        local rollRight = rollError > ANGLE_THRESHOLD and -TRIM_STEP or (rollError < -ANGLE_THRESHOLD and -TRIM_STEP * 10 or 0)
        if pitchFront ~= 0 or pitchBack ~= 0 or rollLeft ~= 0 or rollRight ~= 0 then
            trims.fl = trims.fl + (pitchFront + rollLeft)
            trims.fr = trims.fr + (pitchFront + rollRight)
            trims.bl = trims.bl + (pitchBack + rollLeft)
            trims.br = trims.br + (pitchBack + rollRight)
            settleTime = 0
        else
            settleTime = settleTime + controller.status.value.dt
        end
        for ____, key in ipairs({"fl", "fr", "bl", "br"}) do
            trims[key] = clamp(trims[key], -MAX_TRIM, MAX_TRIM)
        end
        if sensors.alt - originAlt > 0.5 then
            trims.fl = trims.fl - TRIM_STEP * 2
            trims.fr = trims.fr - TRIM_STEP * 2
            trims.bl = trims.bl - TRIM_STEP * 2
            trims.br = trims.br - TRIM_STEP * 2
        end
        if settleTime > SETTLE_TIME then
            trims.fl = trims.fl + TRIM_STEP * 3
            trims.fr = trims.fr + TRIM_STEP * 3
            trims.bl = trims.bl + TRIM_STEP * 3
            trims.br = trims.br + TRIM_STEP * 3
            if sensors.alt - originAlt > TARGET_HEIGHT then
                success = true
                break
            end
        end
    end
    stopRotors()
    if success then
        centerValues(trims)
        showHeader("Calibrated! :3")
        print(string.format("Hover base: %.3f", base))
        print("")
        print("Normalized Trims:")
        textutils.tabulate(
            {"", "Left", "Right"},
            {
                "Front",
                string.format("%.5f", trims.fl),
                string.format("%.5f", trims.fr)
            },
            {
                "Back",
                string.format("%.5f", trims.bl),
                string.format("%.5f", trims.br)
            }
        )
        cfg.base.hover = base
        cfg.trims = trims
        controller.cfg:save()
        print("")
        print("Saved!")
        anyKey()
    end
end
program(
    controller:loop(),
    calibrationLoop
)
return ____exports
