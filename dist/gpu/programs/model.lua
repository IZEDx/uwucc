package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 1,["6"] = 1,["7"] = 3,["8"] = 5,["9"] = 6,["10"] = 7,["11"] = 9,["12"] = 10,["13"] = 12,["14"] = 13,["15"] = 14,["16"] = 16,["17"] = 17,["18"] = 18,["19"] = 20,["20"] = 21,["21"] = 22,["22"] = 24,["23"] = 26,["24"] = 28,["25"] = 29,["26"] = 30,["27"] = 32,["29"] = 32,["31"] = 33,["33"] = 33,["35"] = 35,["36"] = 36,["37"] = 36,["38"] = 36,["39"] = 36,["40"] = 36,["41"] = 36,["42"] = 36,["43"] = 37,["44"] = 37,["45"] = 37,["46"] = 37,["47"] = 37,["48"] = 37,["49"] = 37,["50"] = 37,["51"] = 37,["52"] = 37,["53"] = 38,["54"] = 38,["55"] = 38,["56"] = 38,["57"] = 38,["58"] = 38,["59"] = 38,["60"] = 38,["61"] = 38,["62"] = 38,["63"] = 40,["64"] = 41,["65"] = 42,["66"] = 43,["67"] = 46,["70"] = 80,["73"] = 49,["74"] = 50,["75"] = 51,["76"] = 52,["77"] = 56,["78"] = 57,["79"] = 59,["80"] = 60,["81"] = 60,["82"] = 60,["83"] = 60,["84"] = 60,["85"] = 60,["86"] = 60,["87"] = 60,["88"] = 60,["89"] = 60,["90"] = 60,["91"] = 60,["92"] = 60,["93"] = 60,["94"] = 75,["95"] = 77,["102"] = 82,["104"] = 82,["106"] = 83});
local ____exports = {}
local ____chalk = require("lib.chalk")
local printValue = ____chalk.printValue
local OBJ_FILE = "disk/static/Drone_Icon_UI_MC2.obj"
local FOV = 50
local NEAR = 0.05
local FAR = 100
local ROTATE_SPEED = 22
local MODEL_SCALE = 0.5
local CAMERA_X = 0
local CAMERA_Y = 5
local CAMERA_Z = -20
local BG_R = 0
local BG_G = 0
local BG_B = 0
local MODEL_R = 220
local MODEL_G = 200
local MODEL_B = 220
local gpu = (peripheral.find("directgpu"))
local display = gpu.autoDetectAndCreateDisplayWithResolution(2)
gpu.setupCamera(display, FOV, NEAR, FAR)
gpu.setCameraPosition(display, CAMERA_X, CAMERA_Y, CAMERA_Z)
gpu.lookAt(display, 0, -2, 0)
local ____opt_0 = gpu.setBackfaceCulling
if ____opt_0 ~= nil then
    ____opt_0(display, false)
end
local ____opt_2 = gpu.setPhongShading
if ____opt_2 ~= nil then
    ____opt_2(display, true)
end
gpu.clearLights(display)
gpu.addAmbientLight(
    display,
    255,
    255,
    255,
    0.95
)
gpu.addDirectionalLight(
    display,
    -0.45,
    -0.85,
    -0.35,
    255,
    255,
    255,
    0.65
)
gpu.addDirectionalLight(
    display,
    0.5,
    0.25,
    -0.7,
    120,
    180,
    255,
    0.25
)
local file = (fs.open(OBJ_FILE, "r"))
printValue(file)
local objData = file.readAll()
local modelId = gpu.load3DModel(objData)
local lastTime = os.clock()
do
    local function ____catch(e)
        printError(e)
    end
    local ____try, ____hasReturned = pcall(function()
        while true do
            local now = os.clock()
            local dt = now - lastTime
            lastTime = now
            gpu.clear(display, BG_R, BG_G, BG_B)
            gpu.clearZBuffer(display)
            local pitch, yaw, roll = sublevel.getLogicalPose().orientation:toEuler()
            gpu.draw3DModel(
                display,
                modelId,
                0,
                0,
                0,
                math.deg(-pitch),
                0,
                math.deg(-roll),
                MODEL_SCALE,
                MODEL_R,
                MODEL_G,
                MODEL_B
            )
            gpu.updateDisplay(display)
            sleep(0.03)
        end
    end)
    if not ____try then
        ____catch(____hasReturned)
    end
    do
        local ____opt_4 = gpu.unload3DModel
        if ____opt_4 ~= nil then
            ____opt_4(modelId)
        end
        gpu.removeDisplay(display)
    end
end
return ____exports
