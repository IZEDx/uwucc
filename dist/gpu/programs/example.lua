package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__NumberToFixed = ____lualib.__TS__NumberToFixed
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["7"] = 82,["8"] = 1,["9"] = 1,["10"] = 2,["11"] = 2,["12"] = 2,["13"] = 2,["14"] = 2,["15"] = 2,["16"] = 2,["17"] = 14,["18"] = 15,["19"] = 16,["21"] = 17,["22"] = 18,["23"] = 19,["24"] = 20,["25"] = 21,["26"] = 22,["28"] = 24,["29"] = 27,["31"] = 14,["32"] = 34,["33"] = 35,["34"] = 35,["35"] = 35,["36"] = 36,["38"] = 37,["39"] = 38,["40"] = 38,["41"] = 38,["42"] = 38,["43"] = 38,["44"] = 38,["45"] = 38,["46"] = 38,["48"] = 35,["49"] = 35,["50"] = 34,["51"] = 47,["52"] = 48,["53"] = 49,["54"] = 49,["55"] = 49,["56"] = 49,["57"] = 49,["58"] = 49,["59"] = 49,["60"] = 48,["61"] = 50,["62"] = 50,["63"] = 50,["64"] = 50,["65"] = 50,["66"] = 50,["67"] = 50,["68"] = 48,["69"] = 59,["70"] = 59,["71"] = 59,["72"] = 59,["73"] = 59,["74"] = 59,["75"] = 59,["76"] = 48,["77"] = 62,["78"] = 63,["80"] = 63,["81"] = 63,["82"] = 63,["83"] = 63,["84"] = 63,["87"] = 64,["89"] = 64,["90"] = 64,["91"] = 64,["92"] = 64,["93"] = 64,["96"] = 65,["97"] = 65,["99"] = 66,["100"] = 66,["101"] = 66,["102"] = 66,["104"] = 68,["107"] = 72,["109"] = 72,["110"] = 72,["111"] = 72,["112"] = 72,["113"] = 72,["115"] = 73,["118"] = 47,["119"] = 79,["120"] = 80,["121"] = 81,["122"] = 82,["123"] = 83,["124"] = 84,["125"] = 86,["126"] = 87,["127"] = 88,["128"] = 89,["129"] = 90,["131"] = 86,["132"] = 93,["133"] = 94,["134"] = 94,["135"] = 94,["136"] = 94,["137"] = 94,["138"] = 86,["139"] = 86});
local ____exports = {}
local screenW, screenH, frameSignal
local ____program = require("lib.program")
local program = ____program.program
local ____uwui = require("lib.uwui-gpu.uwui")
local UwUi = ____uwui.UwUi
local Box = ____uwui.Box
local Text = ____uwui.Text
local each = ____uwui.each
local signal = ____uwui.signal
local useSignal = ____uwui.useSignal
local function CardView(props)
    return UwUi.node(
        Box,
        {
            x = props.card.x,
            y = props.card.y,
            w = props.card.w,
            h = props.card.h,
            bg = props.card.color,
            key = props.card.id
        },
        UwUi.node(Text, {x = 8, y = 8, color = {r = 255, g = 255, b = 255}, size = 4}, props.card.label),
        UwUi.node(Text, {x = 8, y = 24, color = {r = 220, g = 230, b = 255}, size = 3}, "id=", props.card.id)
    )
end
local function Animated(props)
    return each(
        props.cards.value,
        function(card, idx) return UwUi.node(
            CardView,
            {
                key = idx,
                card = __TS__ObjectAssign(
                    {},
                    card,
                    {
                        y = 20 + math.floor(10 * math.sin(frameSignal.value * 1.1 + idx * 0.8)),
                        x = 20 + idx * 200 + math.floor(8 * math.cos(frameSignal.value * 0.7 + idx))
                    }
                )
            }
        ) end
    )
end
local function Dashboard()
    local cards = useSignal({{
        id = 1,
        x = 20,
        y = 50,
        w = 180,
        h = 72,
        color = {r = 90, g = 120, b = 255},
        label = "Flight"
    }, {
        id = 2,
        x = 220,
        y = 50,
        w = 180,
        h = 72,
        color = {r = 80, g = 200, b = 150},
        label = "Telemetry"
    }, {
        id = 3,
        x = 420,
        y = 50,
        w = 180,
        h = 72,
        color = {r = 255, g = 140, b = 80},
        label = "UI"
    }})
    return UwUi.node(
        Box,
        {
            x = 0,
            y = 0,
            w = screenW,
            h = screenH,
            bg = {r = 34, g = 38, b = 46}
        },
        UwUi.node(
            Box,
            {
                x = 20,
                y = 20,
                w = screenW - 40,
                h = 100,
                bg = {r = 50, g = 40, b = 50}
            },
            UwUi.node(
                Text,
                {x = 20, y = 8, color = {r = 255, g = 240, b = 190}, size = 4},
                "uwui-gpu primitives t=",
                __TS__NumberToFixed(
                    os.clock(),
                    2
                )
            ),
            UwUi.node(Text, {x = 20, y = 32, color = {r = 180, g = 205, b = 255}, size = 3}, "opaque Boxes act as repaint boundaries")
        ),
        UwUi.node(
            Box,
            {
                x = 20,
                y = 150,
                w = screenW - 40,
                h = 80,
                bg = {r = 50, g = 40, b = 50}
            },
            UwUi.node(Animated, {cards = cards})
        )
    )
end
local gpu = (peripheral.find("directgpu"))
local display = gpu.autoDetectAndCreateDisplay()
local info = gpu.getDisplayInfo(display)
screenW = info.pixelWidth
screenH = info.pixelHeight
frameSignal = signal(0)
program(
    function()
        while true do
            frameSignal.value = os.clock()
            sleep(0)
        end
    end,
    function()
        UwUi.render(
            function() return UwUi.node(Dashboard, nil) end,
            gpu,
            display
        )
    end
)
return ____exports
