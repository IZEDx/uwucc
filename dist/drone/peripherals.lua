-- drone/peripherals.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["drone/peripherals.ts"] = _G.__tracetrace["drone/peripherals.ts"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__StringSlice = ____lualib.__TS__StringSlice
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["14"] = 1,["15"] = 1,["16"] = 1,["17"] = 2,["18"] = 2,["19"] = 3,["20"] = 3,["21"] = 3,["23"] = 41,["24"] = 74,["25"] = 74,["26"] = 81,["27"] = 81,["28"] = 81,["29"] = 81,["30"] = 81,["31"] = 74,["32"] = 74,["33"] = 92,["34"] = 92,["35"] = 92,["36"] = 74,["37"] = 74,["38"] = 100,["39"] = 100,["40"] = 100,["41"] = 100,["42"] = 100,["43"] = 100,["44"] = 100,["45"] = 100,["46"] = 100,["47"] = 100,["48"] = 111,["49"] = 113,["50"] = 114,["51"] = 115,["52"] = 116,["53"] = 117,["54"] = 119,["55"] = 120,["56"] = 121,["57"] = 123,["58"] = 125,["59"] = 126,["60"] = 127,["61"] = 129,["62"] = 130,["63"] = 131,["64"] = 132,["65"] = 133,["66"] = 134,["67"] = 136,["68"] = 141,["69"] = 142,["70"] = 113,["71"] = 145,["72"] = 146,["73"] = 147,["74"] = 147,["75"] = 147,["76"] = 148,["77"] = 149,["78"] = 149,["79"] = 149,["80"] = 150,["81"] = 151,["82"] = 152,["83"] = 153,["84"] = 154,["85"] = 155,["86"] = 156,["87"] = 156,["88"] = 156,["89"] = 159,["90"] = 160,["91"] = 160,["92"] = 160,["93"] = 160,["94"] = 160,["95"] = 160,["96"] = 160,["97"] = 156,["98"] = 156,["99"] = 156,["100"] = 167,["101"] = 168,["103"] = 170,["104"] = 171,["105"] = 172,["108"] = 145,["111"] = 180,["112"] = 181,["113"] = 182,["114"] = 183,["117"] = 178,["123"] = 186,["124"] = 187,["125"] = 188,["126"] = 188,["127"] = 188,["128"] = 188,["130"] = 186,["131"] = 192,["132"] = 193,["133"] = 194,["135"] = 192,["136"] = 198,["137"] = 200,["138"] = 201,["139"] = 201,["140"] = 201,["141"] = 201,["142"] = 201,["143"] = 201,["144"] = 201,["145"] = 202,["146"] = 203,["147"] = 204,["148"] = 205,["149"] = 206,["150"] = 206,["151"] = 206,["152"] = 206,["153"] = 206,["154"] = 207,["155"] = 208,["156"] = 209,["157"] = 210,["158"] = 211,["160"] = 213,["161"] = 214,["165"] = 201,["166"] = 201,["167"] = 200,["168"] = 198});
local ____exports = {}
local ____chalk = require("lib.chalk")
local anyKey = ____chalk.anyKey
local showHeader = ____chalk.showHeader
local ____config = require("lib.config")
local Config = ____config.Config
local ____util = require("lib.util")
local clamp = ____util.clamp
local round = ____util.round
____exports.Peripherals = {}
____exports.cfg = __TS__New(Config, "connectors", {sensors = {}, rotors = {fl = "electric_motor_0", fr = "electric_motor_1", bl = "electric_motor_2", br = "electric_motor_3"}, monitors = {status = "monitor_0"}, inputs = {xyz = "redstone_relay_0", cruise = "left"}})
____exports.peripherals = {
    sensors = {},
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
    local pose = sublevel.getLogicalPose()
    ____exports.state.alt = pose.position.y
    ____exports.state.airP = aero.getAirPressure(vector.new(0, ____exports.state.alt, 0))
    local vel = sublevel.getLinearVelocity()
    ____exports.state.velF = vel.x
    ____exports.state.velR = vel.z
    local pitch, yaw, roll = pose.orientation:toEuler()
    local r = 180 / math.pi
    ____exports.state.pitch = roll * r
    ____exports.state.roll = pitch * r
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
    showHeader("Peripheral Setup")
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
                print("")
                print(((((section .. ".") .. tostring(key)) .. " (") .. side) .. "):")
                term.write("> ")
                side = read(
                    nil,
                    {side},
                    function(p)
                        return __TS__ArrayMap(
                            __TS__ArrayFilter(
                                peripheral.getNames(),
                                function(____, pp) return __TS__StringStartsWith(pp, p) end
                            ),
                            function(____, pp) return __TS__StringSlice(pp, #p) end
                        )
                    end,
                    ""
                )
                print("")
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
        printError(e)
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
