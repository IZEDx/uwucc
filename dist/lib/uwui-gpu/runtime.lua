package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["12"] = 1,["13"] = 1,["14"] = 2,["15"] = 2,["17"] = 6,["21"] = 6,["22"] = 24,["23"] = 26,["24"] = 26,["25"] = 26,["26"] = 26,["27"] = 26,["28"] = 26,["29"] = 26,["30"] = 21,["31"] = 6,["32"] = 32,["33"] = 32,["35"] = 34,["37"] = 34,["41"] = 36,["42"] = 37,["43"] = 39,["44"] = 40,["45"] = 41,["48"] = 97,["51"] = 49,["52"] = 50,["53"] = 51,["54"] = 52,["55"] = 53,["56"] = 54,["57"] = 55,["58"] = 56,["59"] = 57,["60"] = 58,["61"] = 54,["62"] = 54,["63"] = 54,["65"] = 49,["66"] = 64,["67"] = 65,["68"] = 66,["69"] = 67,["73"] = 49,["74"] = 70,["75"] = 71,["76"] = 72,["77"] = 73,["78"] = 74,["79"] = 75,["82"] = 92,["84"] = 49,["85"] = 49,["91"] = 99,["94"] = 29});
local ____exports = {}
local ____node = require("lib.uwui-gpu.node")
local Node = ____node.Node
local ____gpu_2Dview = require("lib.uwui-gpu.gpu-view")
local GPUView = ____gpu_2Dview.GPUView
____exports.UwUi = {}
local UwUi = ____exports.UwUi
do
    ---
    -- @noSelf
    function UwUi.node(component, props, ...)
        local children = {...}
        return __TS__New(
            Node,
            component,
            props or ({}),
            children,
            props and props.key
        )
    end
    function UwUi.render(root, gpu, display)
        if display == nil then
            display = gpu.autoDetectAndCreateDisplay()
        end
        if not display then
            error(
                __TS__New(Error, "Display not available"),
                0
            )
        end
        gpu.setTransparentBackground(display, true)
        gpu.setTransparencyColor(display, -1, -1, -1)
        local info = gpu.getDisplayInfo(display)
        local tree = root()
        local rootView = __TS__New(GPUView, gpu, display, {x = 0, y = 0, w = info.pixelWidth, h = info.pixelHeight})
        do
            local function ____catch(e)
                error(e, 0)
            end
            local ____try, ____hasReturned = pcall(function()
                parallel.waitForAny(
                    function()
                        local frame = 0
                        while true do
                            frame = frame + 1
                            parallel.waitForAll(
                                function()
                                    gpu.clearZBuffer(display)
                                    tree:render(rootView)
                                    gpu.updateDisplay(display)
                                end,
                                function() return sleep(0.05) end
                            )
                        end
                    end,
                    function()
                        while true do
                            local e = {os.pullEvent()}
                            if e[1] == "Terminate" then
                                return
                            end
                        end
                    end,
                    function()
                        while true do
                            if gpu.hasEvents(display) then
                                local event = gpu.pollEvent(display)
                                if event and event.type and event.x and event.y then
                                    tree:input(event)
                                end
                            end
                            sleep(0.05)
                        end
                    end
                )
            end)
            if not ____try then
                ____catch(____hasReturned)
            end
            do
                gpu.removeDisplay(display)
            end
        end
    end
end
return ____exports
