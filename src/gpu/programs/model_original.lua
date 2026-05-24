local OBJ_FILE = "Drone_Icon_UI_MC.obj"

local FOV = 50
local NEAR = 0.05
local FAR = 100
local ROTATE_SPEED = 22
local MODEL_SCALE = 2.25

local CAMERA_X = 1.7
local CAMERA_Y = 1.15
local CAMERA_Z = -4.6

local BG_R, BG_G, BG_B = 0, 0, 0
local MODEL_R, MODEL_G, MODEL_B = 0, 200, 255

local function printf(fmt, ...)
    print(string.format(fmt, ...))
end

local function readAll(path)
    local file = fs.open(path, "r")
    if not file then
        error("Cannot open OBJ file: " .. path)
    end

    local data = file.readAll()
    file.close()

    return data or ""
end

local function requireMethod(gpu, name)
    if type(gpu[name]) ~= "function" then
        error("Missing DirectGPU method: " .. name)
    end
end

local function callIfExists(gpu, name, ...)
    if type(gpu[name]) == "function" then
        return pcall(gpu[name], ...)
    end

    return false
end

local function parseIndex(value, count)
    value = tonumber(value)

    if not value then
        return nil
    end

    if value < 0 then
        return count + value + 1
    end

    return value
end

local function parseFaceToken(token, vertexCount)
    local index = token:match("^(%-?%d+)")
    return parseIndex(index, vertexCount)
end

local function normalizeVector(x, y, z)
    local length = math.sqrt(x * x + y * y + z * z)

    if length <= 0 then
        return 0, 1, 0
    end

    return x / length, y / length, z / length
end

local function makeNormal(a, b, c)
    local ux = b[1] - a[1]
    local uy = b[2] - a[2]
    local uz = b[3] - a[3]

    local vx = c[1] - a[1]
    local vy = c[2] - a[2]
    local vz = c[3] - a[3]

    return normalizeVector(uy * vz - uz * vy, uz * vx - ux * vz, ux * vy - uy * vx)
end

local function prepareOBJ(data)
    local sourceVertices = {}
    local faceLines = {}

    local minX, minY, minZ = math.huge, math.huge, math.huge
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge

    for line in data:gmatch("[^\r\n]+") do
        local x, y, z = line:match("^%s*v%s+([%+%-%.%deE]+)%s+([%+%-%.%deE]+)%s+([%+%-%.%deE]+)")

        if x then
            x = tonumber(x)
            y = tonumber(y)
            z = tonumber(z)

            local vx = x
            local vy = z
            local vz = -y

            sourceVertices[#sourceVertices + 1] = {vx, vy, vz}

            minX = math.min(minX, vx)
            minY = math.min(minY, vy)
            minZ = math.min(minZ, vz)

            maxX = math.max(maxX, vx)
            maxY = math.max(maxY, vy)
            maxZ = math.max(maxZ, vz)
        end

        if line:match("^%s*f%s+") then
            faceLines[#faceLines + 1] = line
        end
    end

    if #sourceVertices == 0 then
        error("OBJ contains no vertices")
    end

    local centerX = (minX + maxX) * 0.5
    local centerY = (minY + maxY) * 0.5
    local centerZ = (minZ + maxZ) * 0.5

    local span = math.max(maxX - minX, maxY - minY, maxZ - minZ)
    local scale = span > 0 and 1 / span or 1

    for i = 1, #sourceVertices do
        local v = sourceVertices[i]

        v[1] = (v[1] - centerX) * scale
        v[2] = (v[2] - centerY) * scale
        v[3] = (v[3] - centerZ) * scale
    end

    local vertices = {}
    local normals = {}
    local faces = {}

    local function pushVertex(v, nx, ny, nz)
        local index = #vertices + 1

        vertices[index] = {v[1], v[2], v[3]}
        normals[index] = {nx, ny, nz}

        return index
    end

    local function pushTriangle(a, b, c)
        local nx, ny, nz = makeNormal(a, b, c)

        local cx = (a[1] + b[1] + c[1]) / 3
        local cy = (a[2] + b[2] + c[2]) / 3
        local cz = (a[3] + b[3] + c[3]) / 3

        if nx * cx + ny * cy + nz * cz < 0 then
            b, c = c, b
            nx, ny, nz = -nx, -ny, -nz
        end

        local a1 = pushVertex(a, nx, ny, nz)
        local b1 = pushVertex(b, nx, ny, nz)
        local c1 = pushVertex(c, nx, ny, nz)

        local a2 = pushVertex(a, nx, ny, nz)
        local b2 = pushVertex(c, nx, ny, nz)
        local c2 = pushVertex(b, nx, ny, nz)

        faces[#faces + 1] = {a1, b1, c1}
        faces[#faces + 1] = {a2, b2, c2}
    end

    for _, line in ipairs(faceLines) do
        local indices = {}

        for token in line:gmatch("%S+") do
            if token ~= "f" then
                indices[#indices + 1] = parseFaceToken(token, #sourceVertices)
            end
        end

        for i = 2, #indices - 1 do
            local a = sourceVertices[indices[1]]
            local b = sourceVertices[indices[i]]
            local c = sourceVertices[indices[i + 1]]

            if a and b and c then
                pushTriangle(a, b, c)
            end
        end
    end

    local out = {}

    for i = 1, #vertices do
        local v = vertices[i]
        out[#out + 1] = string.format("v %.8f %.8f %.8f", v[1], v[2], v[3])
    end

    for i = 1, #normals do
        local n = normals[i]
        out[#out + 1] = string.format("vn %.8f %.8f %.8f", n[1], n[2], n[3])
    end

    for i = 1, #faces do
        local f = faces[i]
        out[#out + 1] = string.format("f %d//%d %d//%d %d//%d", f[1], f[1], f[2], f[2], f[3], f[3])
    end

    return table.concat(out, "\n"), #vertices, #faces
end

local function waitFrame(seconds)
    local timer = os.startTimer(seconds)

    while true do
        local event, id = os.pullEventRaw()

        if event == "terminate" then
            return false
        end

        if event == "timer" and id == timer then
            return true
        end
    end
end

local function main()
    local gpu = peripheral.find("directgpu")
    if not gpu then
        error("No DirectGPU peripheral found")
    end

    requireMethod(gpu, "autoDetectAndCreateDisplay")
    requireMethod(gpu, "setupCamera")
    requireMethod(gpu, "setCameraPosition")
    requireMethod(gpu, "lookAt")
    requireMethod(gpu, "clearZBuffer")
    requireMethod(gpu, "load3DModel")
    requireMethod(gpu, "draw3DModel")
    requireMethod(gpu, "clearLights")
    requireMethod(gpu, "addAmbientLight")
    requireMethod(gpu, "addDirectionalLight")

    local displayId = gpu.autoDetectAndCreateDisplay()
    if not displayId then
        error("Could not auto-detect display")
    end

    callIfExists(gpu, "enableDeltaMode", displayId)

    gpu.setupCamera(displayId, FOV, NEAR, FAR)
    gpu.setCameraPosition(displayId, CAMERA_X, CAMERA_Y, CAMERA_Z)
    gpu.lookAt(displayId, 0, 0, 0)

    callIfExists(gpu, "setBackfaceCulling", displayId, false)
    callIfExists(gpu, "setPhongShading", displayId, true)

    gpu.clearLights(displayId)
    gpu.addAmbientLight(displayId, 255, 255, 255, 0.95)
    gpu.addDirectionalLight(displayId, -0.45, -0.85, -0.35, 255, 255, 255, 0.65)
    gpu.addDirectionalLight(displayId, 0.5, 0.25, -0.7, 120, 180, 255, 0.25)

    local objData = readAll(OBJ_FILE)
    local preparedObj, vertexCount, faceCount = prepareOBJ(objData)
    local modelId = gpu.load3DModel(preparedObj)

    printf("Loaded model %d with %d vertices and %d faces.", modelId, vertexCount, faceCount)

    local yaw = -25
    local lastTime = os.clock()

    while true do
        local now = os.clock()
        local dt = now - lastTime
        lastTime = now

        yaw = (yaw + ROTATE_SPEED * dt) % 360

        gpu.clear(displayId, BG_R, BG_G, BG_B)
        gpu.clearZBuffer(displayId)

        gpu.draw3DModel(displayId, modelId, 0, 0, 0, 0, yaw, 0, MODEL_SCALE, MODEL_R, MODEL_G, MODEL_B)

        if gpu.updateDisplay then
            gpu.updateDisplay(displayId)
        end

        if not waitFrame(0.03) then
            break
        end
    end

    gpu.clear(displayId, 0, 0, 0)

    if gpu.updateDisplay then
        gpu.updateDisplay(displayId)
    end

    if gpu.unload3DModel then
        gpu.unload3DModel(modelId)
    end
end

local ok, err = pcall(main)

if not ok then
    printError("Error: " .. tostring(err))
end
