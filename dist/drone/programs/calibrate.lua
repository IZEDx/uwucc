package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["7"] = 1,["8"] = 1,["9"] = 2,["10"] = 2,["11"] = 3,["12"] = 3,["13"] = 3,["14"] = 4,["15"] = 4,["16"] = 4,["17"] = 5,["18"] = 5,["19"] = 5,["20"] = 7,["21"] = 8,["22"] = 9,["23"] = 10,["24"] = 11,["25"] = 13,["26"] = 17,["27"] = 17,["28"] = 17,["29"] = 17,["30"] = 17,["31"] = 17,["32"] = 17,["33"] = 25,["34"] = 26,["35"] = 27,["36"] = 28,["37"] = 29,["38"] = 30,["39"] = 31,["40"] = 32,["41"] = 40,["42"] = 41,["43"] = 42,["45"] = 45,["46"] = 46,["47"] = 47,["48"] = 48,["49"] = 49,["50"] = 50,["51"] = 52,["52"] = 53,["53"] = 54,["54"] = 56,["55"] = 57,["56"] = 57,["57"] = 57,["58"] = 57,["59"] = 58,["60"] = 58,["61"] = 58,["62"] = 58,["63"] = 59,["64"] = 60,["65"] = 61,["66"] = 63,["67"] = 64,["68"] = 71,["69"] = 73,["70"] = 75,["71"] = 76,["72"] = 77,["73"] = 78,["74"] = 78,["75"] = 78,["76"] = 78,["77"] = 79,["78"] = 80,["79"] = 81,["80"] = 82,["81"] = 82,["82"] = 81,["83"] = 87,["84"] = 88,["85"] = 89,["86"] = 90,["87"] = 91,["88"] = 92,["89"] = 93,["90"] = 93,["91"] = 95,["92"] = 95,["93"] = 95,["94"] = 95,["95"] = 93,["96"] = 96,["97"] = 96,["98"] = 96,["99"] = 96,["100"] = 93,["101"] = 93,["102"] = 98,["103"] = 99,["104"] = 100,["105"] = 101,["106"] = 103,["107"] = 104,["108"] = 105,["109"] = 106,["110"] = 107,["111"] = 108,["112"] = 109,["113"] = 110,["114"] = 111,["115"] = 112,["116"] = 113,["117"] = 114,["119"] = 117,["121"] = 120,["122"] = 121,["123"] = 122,["124"] = 123,["125"] = 124,["127"] = 127,["128"] = 128,["129"] = 129,["130"] = 130,["131"] = 131,["132"] = 132,["133"] = 133,["138"] = 139,["139"] = 141,["140"] = 142,["141"] = 144,["142"] = 145,["143"] = 146,["144"] = 147,["145"] = 148,["146"] = 148,["147"] = 150,["148"] = 150,["149"] = 150,["150"] = 150,["151"] = 148,["152"] = 151,["153"] = 151,["154"] = 151,["155"] = 151,["156"] = 148,["157"] = 148,["158"] = 154,["159"] = 155,["160"] = 156,["161"] = 158,["162"] = 159,["163"] = 160,["165"] = 25,["166"] = 164,["167"] = 164,["168"] = 164,["169"] = 164});
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
local TRIM_STEP = 0.0001
local MAX_TRIM = 0.2
local ANGLE_THRESHOLD = 1
local SETTLE_TIME = 1
local TARGET_HEIGHT = 3
local controller = __TS__New(Controller, {load = false, tick = false})
controller.inputs = {
    alt = controller.inputs.alt,
    velF = 0,
    velR = 0,
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
        if pitchError > ANGLE_THRESHOLD then
            trims.fl = trims.fl - TRIM_STEP * 10
            trims.fr = trims.fr - TRIM_STEP * 10
            trims.bl = trims.bl - TRIM_STEP
            trims.br = trims.br - TRIM_STEP
            settleTime = 0
        elseif pitchError < -ANGLE_THRESHOLD then
            trims.fl = trims.fl - TRIM_STEP
            trims.fr = trims.fr - TRIM_STEP
            trims.bl = trims.bl - TRIM_STEP * 10
            trims.br = trims.br - TRIM_STEP * 10
            settleTime = 0
        else
            settleTime = settleTime + controller.status.value.dt
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
