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
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["16"] = 1,["17"] = 1,["18"] = 1,["19"] = 2,["20"] = 2,["21"] = 3,["22"] = 3,["23"] = 3,["24"] = 206,["25"] = 207,["26"] = 208,["28"] = 206,["30"] = 41,["31"] = 41,["32"] = 41,["33"] = 41,["34"] = 41,["35"] = 41,["36"] = 41,["37"] = 80,["38"] = 80,["39"] = 87,["40"] = 87,["41"] = 87,["42"] = 87,["43"] = 87,["44"] = 80,["45"] = 93,["46"] = 93,["47"] = 93,["48"] = 93,["49"] = 93,["50"] = 80,["51"] = 80,["52"] = 104,["53"] = 104,["54"] = 104,["55"] = 80,["56"] = 80,["57"] = 112,["58"] = 112,["59"] = 112,["60"] = 112,["61"] = 112,["62"] = 112,["63"] = 112,["64"] = 112,["65"] = 112,["66"] = 112,["67"] = 112,["68"] = 124,["69"] = 126,["70"] = 127,["71"] = 128,["72"] = 129,["73"] = 130,["74"] = 132,["75"] = 133,["76"] = 134,["77"] = 135,["78"] = 137,["79"] = 139,["80"] = 140,["81"] = 142,["82"] = 143,["83"] = 144,["84"] = 145,["85"] = 146,["86"] = 147,["87"] = 149,["88"] = 154,["89"] = 155,["90"] = 126,["91"] = 158,["92"] = 159,["93"] = 160,["94"] = 160,["95"] = 160,["96"] = 161,["97"] = 162,["98"] = 162,["99"] = 162,["100"] = 163,["101"] = 164,["102"] = 165,["103"] = 166,["104"] = 167,["105"] = 168,["106"] = 169,["107"] = 169,["108"] = 169,["109"] = 172,["110"] = 173,["111"] = 173,["112"] = 173,["113"] = 173,["114"] = 173,["115"] = 173,["116"] = 173,["117"] = 169,["118"] = 169,["119"] = 169,["120"] = 180,["121"] = 181,["123"] = 183,["124"] = 184,["125"] = 185,["128"] = 158,["131"] = 194,["132"] = 195,["133"] = 196,["134"] = 197,["137"] = 191,["138"] = 192,["144"] = 200,["145"] = 201,["146"] = 202,["147"] = 202,["148"] = 202,["149"] = 202,["151"] = 200,["152"] = 212,["153"] = 214,["154"] = 215,["155"] = 215,["156"] = 215,["157"] = 215,["158"] = 215,["159"] = 215,["160"] = 215,["161"] = 216,["162"] = 217,["163"] = 218,["164"] = 219,["165"] = 220,["166"] = 220,["167"] = 220,["168"] = 220,["169"] = 220,["170"] = 221,["171"] = 222,["172"] = 223,["173"] = 224,["174"] = 225,["176"] = 227,["177"] = 228,["181"] = 215,["182"] = 215,["183"] = 214,["184"] = 212,["185"] = 236,["186"] = 238,["187"] = 239,["188"] = 240,["189"] = 241,["190"] = 242,["191"] = 242,["192"] = 242,["193"] = 242,["194"] = 242,["195"] = 243,["196"] = 245,["197"] = 246});
local ____exports = {}
local ____chalk = require("lib.chalk")
local anyKey = ____chalk.anyKey
local showHeader = ____chalk.showHeader
local ____config = require("lib.config")
local Config = ____config.Config
local ____util = require("lib.util")
local clamp = ____util.clamp
local round = ____util.round
function ____exports.stopRotors()
    for ____, r in ipairs(__TS__ObjectValues(____exports.peripherals.rotors)) do
        r.stop()
    end
end
____exports.Peripherals = {}
____exports.cfg = __TS__New(Config, "connectors", {
    sensors = {},
    rotors = {fl = "electric_motor_0", fr = "electric_motor_1", bl = "electric_motor_2", br = "electric_motor_3"},
    propellers = {fl = "gyroscopic_propeller_bearing_0", fr = "gyroscopic_propeller_bearing_1", bl = "gyroscopic_propeller_bearing_2", br = "gyroscopic_propeller_bearing_3"},
    monitors = {status = "monitor_0"},
    inputs = {xyz = "redstone_relay_0", cruise = "left"}
})
____exports.peripherals = {
    sensors = {},
    rotors = {
        fl = peripheral.wrap(____exports.cfg.data.rotors.fl),
        fr = peripheral.wrap(____exports.cfg.data.rotors.fr),
        bl = peripheral.wrap(____exports.cfg.data.rotors.bl),
        br = peripheral.wrap(____exports.cfg.data.rotors.br)
    },
    propellers = {
        fl = peripheral.wrap(____exports.cfg.data.propellers.fl),
        fr = peripheral.wrap(____exports.cfg.data.propellers.fr),
        bl = peripheral.wrap(____exports.cfg.data.propellers.bl),
        br = peripheral.wrap(____exports.cfg.data.propellers.br)
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
    velU = 0,
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
    ____exports.state.velU = vel.y
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
        ____exports.stopRotors()
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
____exports.stopRotors()
local angle = 2
for ____, k in ipairs(__TS__ObjectKeys(____exports.peripherals.propellers)) do
    local key = k
    local p = ____exports.peripherals.propellers[key]
    local x, y, z = table.unpack(
        p.getBlockNormal(),
        1,
        3
    )
    z = z + (__TS__StringEndsWith(key, "l") and angle or -angle)
    p.setManualTarget({x, y, z})
    print("lock propeller", p)
end
return ____exports
