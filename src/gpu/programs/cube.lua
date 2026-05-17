local gpu = peripheral.find("directgpu")
local display = gpu.autoDetectAndCreateDisplay()

gpu.setupCamera(display, 60, 0.1, 1000)
gpu.setCameraPosition(display, 0, 2, 5)
gpu.addAmbientLight(display, 60, 60, 60, 0.3)
gpu.addDirectionalLight(display, 0, -1, 0, 255, 255, 255, 0.8)

local rot = 0
while true do
    gpu.clear(display, 0, 0, 0)
    gpu.clearZBuffer(display)
    gpu.drawCube(display, 0, 0, 0, 2, rot, rot, 0, 255, 120, 120)
    gpu.updateDisplay(display)
    rot = rot + 2
    sleep(0.05)
end
