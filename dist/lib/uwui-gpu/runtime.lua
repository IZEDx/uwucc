-- lib/uwui-gpu/runtime.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/uwui-gpu/runtime.ts"] = _G.__tracetrace["lib/uwui-gpu/runtime.ts"] or {}
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
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["12"] = 1,["13"] = 1,["14"] = 2,["15"] = 2,["17"] = 5,["21"] = 5,["22"] = 21,["23"] = 23,["24"] = 23,["25"] = 23,["26"] = 23,["27"] = 23,["28"] = 23,["29"] = 23,["30"] = 18,["31"] = 5,["32"] = 29,["33"] = 29,["35"] = 31,["37"] = 31,["41"] = 33,["42"] = 34,["43"] = 36,["44"] = 37,["45"] = 38,["48"] = 68,["51"] = 46,["52"] = 47,["53"] = 48,["54"] = 49,["55"] = 50,["56"] = 51,["57"] = 52,["58"] = 53,["59"] = 54,["60"] = 51,["61"] = 51,["62"] = 51,["64"] = 46,["65"] = 60,["66"] = 61,["67"] = 62,["68"] = 63,["72"] = 46,["73"] = 46,["79"] = 70,["82"] = 26});
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
