-- drone/peripherals.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["drone/peripherals.ts"] = _G.__tracetrace["drone/peripherals.ts"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["11"] = 1,["12"] = 1,["13"] = 2,["14"] = 2,["15"] = 3,["16"] = 3,["17"] = 3,["19"] = 41,["20"] = 74,["21"] = 75,["22"] = 75,["23"] = 75,["24"] = 75,["25"] = 75,["26"] = 74,["27"] = 81,["28"] = 81,["29"] = 81,["30"] = 81,["31"] = 81,["32"] = 74,["33"] = 74,["34"] = 92,["35"] = 92,["36"] = 92,["37"] = 74,["38"] = 74,["39"] = 100,["40"] = 100,["41"] = 100,["42"] = 100,["43"] = 100,["44"] = 100,["45"] = 100,["46"] = 100,["47"] = 100,["48"] = 100,["49"] = 111,["50"] = 113,["51"] = 114,["52"] = 115,["53"] = 116,["54"] = 118,["55"] = 119,["56"] = 121,["57"] = 122,["58"] = 123,["59"] = 125,["60"] = 126,["61"] = 127,["62"] = 128,["63"] = 129,["64"] = 130,["65"] = 132,["66"] = 137,["67"] = 138,["68"] = 113,["69"] = 141,["70"] = 142,["71"] = 142,["72"] = 142,["73"] = 143,["74"] = 144,["75"] = 144,["76"] = 144,["77"] = 145,["78"] = 146,["79"] = 147,["80"] = 148,["81"] = 149,["82"] = 150,["84"] = 152,["85"] = 153,["86"] = 154,["89"] = 141,["92"] = 162,["93"] = 163,["94"] = 164,["97"] = 160,["103"] = 167,["104"] = 168,["105"] = 169,["106"] = 169,["107"] = 169,["108"] = 169,["110"] = 167,["111"] = 173,["112"] = 174,["113"] = 175,["115"] = 173,["116"] = 179,["117"] = 181,["118"] = 182,["119"] = 182,["120"] = 182,["121"] = 182,["122"] = 182,["123"] = 182,["124"] = 182,["125"] = 183,["126"] = 184,["127"] = 185,["128"] = 186,["129"] = 187,["130"] = 187,["131"] = 187,["132"] = 187,["133"] = 187,["134"] = 188,["135"] = 189,["136"] = 190,["137"] = 191,["138"] = 192,["140"] = 194,["141"] = 195,["145"] = 182,["146"] = 182,["147"] = 181,["148"] = 179});
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
                        local s = invert * newSpeed
                        if __TS__NumberIsNaN(__TS__Number(s)) then
                            rotor.stop()
                            printError(("Tried setting rotor " .. name) .. " to NaN")
                        else
                            rotor.setSpeed(s)
                            speeds[name] = newSpeed
                        end
                    end
                end
            end
        end
    )))
end
return ____exports
