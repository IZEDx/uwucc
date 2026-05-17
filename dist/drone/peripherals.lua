-- drone/peripherals.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["drone/peripherals.ts"] = _G.__tracetrace["drone/peripherals.ts"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["9"] = 1,["10"] = 1,["11"] = 2,["12"] = 2,["13"] = 3,["14"] = 3,["15"] = 3,["17"] = 41,["18"] = 74,["19"] = 75,["20"] = 75,["21"] = 75,["22"] = 75,["23"] = 75,["24"] = 74,["25"] = 81,["26"] = 81,["27"] = 81,["28"] = 81,["29"] = 81,["30"] = 74,["31"] = 74,["32"] = 92,["33"] = 92,["34"] = 92,["35"] = 74,["36"] = 74,["37"] = 100,["38"] = 100,["39"] = 100,["40"] = 100,["41"] = 100,["42"] = 100,["43"] = 100,["44"] = 100,["45"] = 100,["46"] = 100,["47"] = 111,["48"] = 113,["49"] = 114,["50"] = 115,["51"] = 116,["52"] = 118,["53"] = 119,["54"] = 121,["55"] = 122,["56"] = 123,["57"] = 125,["58"] = 126,["59"] = 127,["60"] = 128,["61"] = 129,["62"] = 130,["63"] = 132,["64"] = 137,["65"] = 138,["66"] = 113,["67"] = 141,["68"] = 142,["69"] = 142,["70"] = 142,["71"] = 143,["72"] = 144,["73"] = 144,["74"] = 144,["75"] = 145,["76"] = 146,["77"] = 147,["78"] = 148,["79"] = 149,["80"] = 150,["82"] = 152,["83"] = 153,["84"] = 154,["87"] = 141,["90"] = 162,["91"] = 163,["92"] = 164,["95"] = 160,["101"] = 167,["102"] = 168,["103"] = 169,["104"] = 169,["105"] = 169,["106"] = 169,["108"] = 167,["109"] = 173,["110"] = 174,["111"] = 175,["113"] = 173,["114"] = 179,["115"] = 181,["116"] = 182,["117"] = 182,["118"] = 182,["119"] = 182,["120"] = 182,["121"] = 182,["122"] = 182,["123"] = 183,["124"] = 184,["125"] = 185,["126"] = 186,["127"] = 187,["128"] = 187,["129"] = 187,["130"] = 187,["131"] = 187,["132"] = 188,["133"] = 189,["134"] = 190,["137"] = 182,["138"] = 182,["139"] = 181,["140"] = 179});
local ____exports = {}
local ____chalk = require("lib.chalk")
local anyKey = ____chalk.anyKey
local ____config = require("lib.config")
local Config = ____config.Config
local ____util = require("lib.util")
local clamp = ____util.clamp
local round = ____util.round
____exports.Peripherals = {}
____exports.cfg = __TS__New(Config, "connectors", {sensors = {altitude = "altitude_sensor_0", gimbal = "gimbal_sensor_0", vel_fwd = "velocity_sensor_0", vel_right = "velocity_sensor_1"}, rotors = {fl = "electric_motor_0", fr = "electric_motor_1", bl = "electric_motor_2", br = "electric_motor_3"}, monitors = {status = "monitor_0"}, inputs = {xyz = "redstone_relay_0", cruise = "left"}})
____exports.peripherals = {
    sensors = {
        altitude = peripheral.wrap(____exports.cfg.data.sensors.altitude),
        gimbal = peripheral.wrap(____exports.cfg.data.sensors.gimbal),
        vel_fwd = peripheral.wrap(____exports.cfg.data.sensors.vel_fwd),
        vel_right = peripheral.wrap(____exports.cfg.data.sensors.vel_right)
    },
    rotors = {
        fl = peripheral.wrap(____exports.cfg.data.rotors.fl),
        fr = peripheral.wrap(____exports.cfg.data.rotors.fr),
        bl = peripheral.wrap(____exports.cfg.data.rotors.bl),
        br = peripheral.wrap(____exports.cfg.data.rotors.br)
    },
    monitors = {status = peripheral.wrap(____exports.cfg.data.monitors.status)},
    inputs = {
        xyz = peripheral.wrap(____exports.cfg.data.inputs.xyz),
        cruise = {isOn = function() return redstone.getInput(____exports.cfg.data.inputs.cruise) end}
    }
}
____exports.state = {
    alt = 0,
    airP = 0,
    velF = 0,
    velR = 0,
    pitch = 0,
    roll = 0,
    input = {x = 0, y = 0, z = 0},
    cruise = false
}
local speeds = {}
function ____exports.pullState()
    local p = ____exports.peripherals
    ____exports.state.alt = p.sensors.altitude.getHeight()
    ____exports.state.airP = p.sensors.altitude.getAirPressure()
    ____exports.state.velF = p.sensors.vel_fwd.getVelocity()
    ____exports.state.velR = p.sensors.vel_right.getVelocity()
    local angles = p.sensors.gimbal.getAngles()
    ____exports.state.pitch = -angles[2]
    ____exports.state.roll = angles[1]
    local leftInput = p.inputs.xyz.getAnalogInput("left")
    local rightInput = p.inputs.xyz.getAnalogInput("right")
    local topInput = p.inputs.xyz.getAnalogInput("top")
    local bottomInput = p.inputs.xyz.getAnalogInput("bottom")
    local frontInput = p.inputs.xyz.getAnalogInput("front")
    local backInput = p.inputs.xyz.getAnalogInput("back")
    ____exports.state.input = {x = rightInput / 15 - leftInput / 15, y = topInput / 15 - bottomInput / 15, z = frontInput / 15 - backInput / 15}
    ____exports.state.cruise = p.inputs.cruise.isOn()
    return ____exports.state
end
function ____exports.peripheralsSetup()
    for ____, ____value in ipairs(__TS__ObjectEntries(____exports.cfg.data)) do
        local _s = ____value[1]
        local _p = ____value[2]
        local section = _s
        for ____, ____value in ipairs(__TS__ObjectEntries(_p)) do
            local _k = ____value[1]
            local side = ____value[2]
            local key = _k
            local p = ____exports.peripherals[section][key]
            while not p do
                print((((("Peripheral " .. section) .. ".") .. tostring(key)) .. " not found on side ") .. side)
                side = read()
                p = peripheral.wrap(side)
            end
            ____exports.cfg:set(section, key, side)
            ____exports.peripherals[section][key] = p
            ____exports.cfg:save()
        end
    end
end
do
    local function ____catch(e)
        ____exports.peripheralsSetup()
        ____exports.pullState()
        anyKey()
    end
    local ____try, ____hasReturned = pcall(function()
        ____exports.pullState()
    end)
    if not ____try then
        ____catch(____hasReturned)
    end
end
function ____exports.stateLoop()
    while true do
        parallel.waitForAll(
            ____exports.pullState,
            function() return sleep(0) end
        )
    end
end
function ____exports.stopRotors()
    for ____, r in ipairs(__TS__ObjectValues(____exports.peripherals.rotors)) do
        r.stop()
    end
end
function ____exports.applyThrusts(thrusts)
    parallel.waitForAll(table.unpack(__TS__ArrayMap(
        __TS__ObjectEntries(thrusts),
        function(____, ____bindingPattern0)
            local thrust
            local name
            name = ____bindingPattern0[1]
            thrust = ____bindingPattern0[2]
            return function()
                local rotor = ____exports.peripherals.rotors[name]
                if rotor ~= nil then
                    local invert = (name == "fl" or name == "br") and -1 or 1
                    local oldSpeed = speeds[name] or invert * rotor.getSpeed()
                    local newSpeed = clamp(
                        round(thrust * 256),
                        -256,
                        256
                    )
                    if newSpeed ~= oldSpeed then
                        rotor.setSpeed(invert * newSpeed)
                        speeds[name] = newSpeed
                    end
                end
            end
        end
    )))
end
return ____exports
