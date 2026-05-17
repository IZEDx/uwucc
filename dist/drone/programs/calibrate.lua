-- drone/programs/calibrate.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["drone/programs/calibrate.ts"] = _G.__tracetrace["drone/programs/calibrate.ts"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["7"] = 1,["8"] = 1,["9"] = 2,["10"] = 2,["11"] = 3,["12"] = 3,["13"] = 3,["14"] = 4,["15"] = 4,["16"] = 4,["17"] = 5,["18"] = 5,["19"] = 5,["20"] = 7,["21"] = 8,["22"] = 9,["23"] = 10,["24"] = 11,["25"] = 13,["26"] = 14,["27"] = 14,["28"] = 14,["29"] = 14,["30"] = 14,["31"] = 14,["32"] = 14,["33"] = 22,["34"] = 23,["35"] = 24,["36"] = 25,["37"] = 26,["38"] = 27,["39"] = 28,["40"] = 29,["41"] = 37,["42"] = 38,["43"] = 44,["45"] = 47,["46"] = 48,["47"] = 49,["48"] = 50,["49"] = 51,["50"] = 52,["51"] = 54,["52"] = 55,["53"] = 56,["54"] = 58,["55"] = 59,["56"] = 59,["57"] = 59,["58"] = 59,["59"] = 60,["60"] = 60,["61"] = 60,["62"] = 60,["63"] = 61,["64"] = 62,["65"] = 63,["66"] = 65,["67"] = 66,["68"] = 73,["69"] = 75,["70"] = 77,["71"] = 78,["72"] = 79,["73"] = 80,["74"] = 80,["75"] = 80,["76"] = 80,["77"] = 81,["78"] = 82,["79"] = 83,["80"] = 84,["81"] = 84,["82"] = 83,["83"] = 89,["84"] = 90,["85"] = 91,["86"] = 92,["87"] = 93,["88"] = 94,["89"] = 95,["90"] = 95,["91"] = 97,["92"] = 97,["93"] = 97,["94"] = 97,["95"] = 95,["96"] = 98,["97"] = 98,["98"] = 98,["99"] = 98,["100"] = 95,["101"] = 95,["102"] = 100,["103"] = 101,["104"] = 102,["105"] = 103,["106"] = 105,["107"] = 106,["108"] = 107,["109"] = 108,["110"] = 109,["111"] = 110,["112"] = 111,["113"] = 112,["114"] = 113,["115"] = 114,["116"] = 115,["117"] = 116,["119"] = 119,["121"] = 122,["122"] = 123,["123"] = 124,["124"] = 125,["125"] = 126,["127"] = 129,["128"] = 130,["129"] = 131,["130"] = 132,["131"] = 133,["132"] = 134,["133"] = 135,["138"] = 141,["139"] = 143,["140"] = 144,["141"] = 146,["142"] = 147,["143"] = 148,["144"] = 149,["145"] = 150,["146"] = 150,["147"] = 152,["148"] = 152,["149"] = 152,["150"] = 152,["151"] = 150,["152"] = 153,["153"] = 153,["154"] = 153,["155"] = 153,["156"] = 150,["157"] = 150,["158"] = 156,["159"] = 157,["160"] = 158,["161"] = 160,["162"] = 161,["163"] = 162,["165"] = 22,["166"] = 166,["167"] = 166,["168"] = 166,["169"] = 166});
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
local controller = __TS__New(Controller)
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
        pid.tuning = {kp = 0, ki = 0, kd = 0, iMax = 1}
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
            settleTime = settleTime + controller.status.dt
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
    controller:loop({display = true, quit = true, load = false, tick = false}),
    calibrationLoop
)
return ____exports
