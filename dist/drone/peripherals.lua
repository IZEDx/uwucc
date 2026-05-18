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
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["14"] = 1,["15"] = 1,["16"] = 1,["17"] = 2,["18"] = 2,["19"] = 3,["20"] = 3,["21"] = 3,["23"] = 41,["24"] = 74,["25"] = 74,["26"] = 81,["27"] = 81,["28"] = 81,["29"] = 81,["30"] = 81,["31"] = 74,["32"] = 74,["33"] = 92,["34"] = 92,["35"] = 92,["36"] = 74,["37"] = 74,["38"] = 100,["39"] = 100,["40"] = 100,["41"] = 100,["42"] = 100,["43"] = 100,["44"] = 100,["45"] = 100,["46"] = 100,["47"] = 100,["48"] = 111,["49"] = 113,["50"] = 114,["51"] = 115,["52"] = 116,["53"] = 117,["54"] = 119,["55"] = 120,["56"] = 121,["57"] = 123,["58"] = 125,["59"] = 126,["60"] = 128,["61"] = 129,["62"] = 130,["63"] = 131,["64"] = 132,["65"] = 133,["66"] = 135,["67"] = 140,["68"] = 141,["69"] = 113,["70"] = 144,["71"] = 145,["72"] = 146,["73"] = 146,["74"] = 146,["75"] = 147,["76"] = 148,["77"] = 148,["78"] = 148,["79"] = 149,["80"] = 150,["81"] = 151,["82"] = 152,["83"] = 153,["84"] = 154,["85"] = 155,["86"] = 155,["87"] = 155,["88"] = 158,["89"] = 159,["90"] = 159,["91"] = 159,["92"] = 159,["93"] = 159,["94"] = 159,["95"] = 159,["96"] = 155,["97"] = 155,["98"] = 155,["99"] = 166,["100"] = 167,["102"] = 169,["103"] = 170,["104"] = 171,["107"] = 144,["110"] = 179,["111"] = 180,["112"] = 181,["113"] = 182,["116"] = 177,["122"] = 185,["123"] = 186,["124"] = 187,["125"] = 187,["126"] = 187,["127"] = 187,["129"] = 185,["130"] = 191,["131"] = 192,["132"] = 193,["134"] = 191,["135"] = 197,["136"] = 199,["137"] = 200,["138"] = 200,["139"] = 200,["140"] = 200,["141"] = 200,["142"] = 200,["143"] = 200,["144"] = 201,["145"] = 202,["146"] = 203,["147"] = 204,["148"] = 205,["149"] = 205,["150"] = 205,["151"] = 205,["152"] = 205,["153"] = 206,["154"] = 207,["155"] = 208,["156"] = 209,["157"] = 210,["159"] = 212,["160"] = 213,["164"] = 200,["165"] = 200,["166"] = 199,["167"] = 197});
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
    ____exports.state.pitch = math.deg(roll)
    ____exports.state.roll = math.deg(pitch)
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
