package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["5"] = 1,["6"] = 1,["7"] = 1,["8"] = 3,["9"] = 5,["10"] = 10,["11"] = 11,["12"] = 13,["13"] = 14,["14"] = 16,["15"] = 17,["17"] = 20,["18"] = 21,["19"] = 22,["20"] = 23,["21"] = 25,["22"] = 26,["23"] = 27,["24"] = 29,["25"] = 30,["26"] = 31,["28"] = 34,["29"] = 35,["30"] = 37,["31"] = 38,["32"] = 39,["36"] = 46,["37"] = 47,["40"] = 43,["41"] = 43,["42"] = 43,["43"] = 43,["44"] = 43,["45"] = 43,["46"] = 43,["47"] = 43,["48"] = 44,["49"] = 44,["50"] = 44,["51"] = 44,["52"] = 44,["53"] = 44,["54"] = 44,["55"] = 44,["56"] = 44,["57"] = 44,["63"] = 42,["66"] = 50,["67"] = 51,["68"] = 25,["69"] = 54,["70"] = 55,["71"] = 56,["72"] = 58,["73"] = 59,["74"] = 60,["75"] = 61,["76"] = 62,["77"] = 63,["79"] = 58,["80"] = 66,["81"] = 67,["82"] = 68,["83"] = 69,["84"] = 70,["88"] = 58,["89"] = 58,["90"] = 77,["91"] = 78});
local ____exports = {}
local ____events = require("lib.events")
local KeyEvent = ____events.KeyEvent
local pullEventAs = ____events.pullEventAs
local gpu = (peripheral.find("directgpu"))
local IMAGES = {"https://i.guim.co.uk/img/media/c6f7b43fa821d06fe1ab4311e558686529931492/180_92_1046_628/master/1046.jpg?width=465&dpr=1&s=none&crop=none", "https://wallpapers.com/images/hd/minecraft-shaders-1920-x-965-ifep35n93dhu1uzw.jpg", "https://wallpapers.com/images/hd/minecraft-shaders-1920-x-1080-dxnqfhk4rnysfhx5.jpg"}
local SLIDE_DURATION = 5
local RESOLUTION = 2
print("Image Slideshow - Auto-detecting monitor+.")
local display = gpu.autoDetectAndCreateDisplayWithResolution(RESOLUTION)
if not display or display == -1 then
    error("Failed to create display", 0)
end
local info = gpu.getDisplayInfo(display)
local w = info.pixelWidth
local h = info.pixelHeight
print(string.format("Display: %dx%d", w, h))
local function loadAndDisplayImage(url)
    print("Loading: " .. url)
    local response = http.get(url, nil, true)
    if not response then
        printError("Failed to fetch: " .. url)
        return false
    end
    local data = response.readAll()
    response.close()
    if #data < 100 then
        printError("Invalid image data")
        return false
    end
    do
        local function ____catch(err)
            printError("Failed to load image: " .. tostring(err))
            return true, false
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            gpu.loadJPEGRegion(
                display,
                data,
                0,
                0,
                w,
                h
            )
            gpu.fillRect(
                display,
                0,
                0,
                200,
                200,
                200,
                50,
                200
            )
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
    gpu.updateDisplay(display)
    return true
end
print("Starting slideshow+. (Press Q to quit)")
local currentIndex = 0
local running = true
parallel.waitForAny(
    function()
        while running do
            loadAndDisplayImage(IMAGES[currentIndex + 1])
            sleep(SLIDE_DURATION)
            currentIndex = (currentIndex + 1) % #IMAGES
        end
    end,
    function()
        while true do
            local e = pullEventAs(KeyEvent, "key")
            if e and e.key == keys.q then
                running = false
                break
            end
        end
    end
)
gpu.removeDisplay(display)
print("Done")
return ____exports
