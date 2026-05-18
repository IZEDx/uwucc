package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["6"] = 1,["7"] = 1,["8"] = 2,["9"] = 2,["10"] = 3,["11"] = 3,["12"] = 4,["13"] = 4,["14"] = 4,["15"] = 5,["16"] = 5,["17"] = 6,["18"] = 6,["19"] = 7,["20"] = 7,["21"] = 28,["22"] = 29,["23"] = 30,["24"] = 31,["25"] = 31,["26"] = 31,["27"] = 31,["28"] = 31,["29"] = 31,["30"] = 31,["31"] = 30,["32"] = 42,["33"] = 43,["34"] = 44,["35"] = 46,["36"] = 47,["37"] = 48,["38"] = 50,["39"] = 51,["40"] = 52,["41"] = 53,["42"] = 55,["43"] = 57,["44"] = 58,["45"] = 60,["46"] = 66,["47"] = 67,["48"] = 68,["49"] = 69,["50"] = 70,["52"] = 72,["53"] = 73,["55"] = 75,["56"] = 76,["57"] = 79,["59"] = 46,["60"] = 83,["61"] = 84,["62"] = 85,["63"] = 85,["64"] = 85,["65"] = 85,["66"] = 86,["67"] = 86,["68"] = 86,["69"] = 85,["70"] = 85,["71"] = 88,["72"] = 89});
local ____exports = {}
local ____program = require("lib.program")
local program = ____program.program
local ____controller = require("drone.controller")
local Controller = ____controller.Controller
local ____util = require("lib.util")
local clamp = ____util.clamp
local ____peripherals = require("drone.peripherals")
local state = ____peripherals.state
local stopRotors = ____peripherals.stopRotors
local ____chalk = require("lib.chalk")
local showHeader = ____chalk.showHeader
local ____runtime = require("lib.uwui-gpu.runtime")
local UwUi = ____runtime.UwUi
local ____dashboard = require("drone.uwui.dashboard")
local Dashboard = ____dashboard.Dashboard
local controller = __TS__New(Controller)
controller.inputs.alt = controller.inputs.alt
local cfg = controller.cfg:extend({controller = {
    min_alt = 50,
    max_alt = 250,
    max_vel_x = 30,
    max_vel_y = 30,
    max_vel_z = 30,
    acceleration = 5,
    drag = 0.95
}}).data
showHeader(":3")
print("huh")
local vel = {x = 0, y = 0, z = 0}
local function inputLoop()
    local lastTime = os.clock()
    sleep(0.5)
    while true do
        local now = os.clock()
        local dt = now - lastTime
        lastTime = now
        local accel = cfg.controller.acceleration
        local maxVelY = cfg.controller.max_vel_y
        vel.y = state.input.y ~= 0 and clamp(vel.y + state.input.y * accel * dt, -maxVelY, maxVelY) or 0
        controller.inputs.alt = clamp(controller.inputs.alt + vel.y * dt, cfg.controller.min_alt, cfg.controller.max_alt)
        local maxVelX = cfg.controller.max_vel_x
        local maxVelZ = cfg.controller.max_vel_z
        if not state.cruise then
            vel.x = state.input.x * maxVelX
            vel.z = state.input.z * maxVelZ
        else
            vel.x = clamp(vel.x + state.input.x * accel * dt, -maxVelX, maxVelX)
            vel.z = clamp(vel.z + state.input.z * accel * dt, -maxVelZ, maxVelZ)
        end
        controller.inputs.velR = vel.x
        controller.inputs.velF = vel.z
        sleep(0.05)
    end
end
local gpu = (peripheral.find("directgpu"))
local display = gpu.autoDetectAndCreateDisplay()
program(
    controller:loop(),
    inputLoop,
    function() return UwUi.render(
        function() return UwUi.node(Dashboard, {controller = controller}) end,
        gpu,
        display
    ) end
)
gpu.removeDisplay(display)
stopRotors()
return ____exports
