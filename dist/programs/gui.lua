-- programs/gui.tsx
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["programs/gui.tsx"] = _G.__tracetrace["programs/gui.tsx"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["12"] = 5,["13"] = 5,["14"] = 6,["15"] = 6,["16"] = 7,["17"] = 7,["18"] = 7,["19"] = 7,["20"] = 7,["21"] = 8,["22"] = 8,["23"] = 10,["24"] = 11,["25"] = 12,["26"] = 14,["27"] = 14,["28"] = 14,["29"] = 15,["30"] = 22,["31"] = 24,["32"] = 24,["33"] = 24,["34"] = 24,["35"] = 24,["36"] = 24,["37"] = 24,["38"] = 24,["39"] = 24,["40"] = 24,["41"] = 44,["42"] = 46,["43"] = 47,["44"] = 48,["45"] = 50,["46"] = 50,["47"] = 50,["48"] = 50,["49"] = 51,["50"] = 59,["51"] = 59,["52"] = 59,["53"] = 59,["54"] = 59,["55"] = 62,["56"] = 62,["57"] = 62,["58"] = 59,["59"] = 59,["60"] = 64,["61"] = 64,["62"] = 64,["63"] = 64,["64"] = 65,["65"] = 65,["66"] = 65,["67"] = 64,["68"] = 64,["69"] = 66,["70"] = 66,["71"] = 66,["72"] = 66,["73"] = 66,["74"] = 64,["75"] = 64,["76"] = 67,["77"] = 67,["78"] = 67,["79"] = 67,["80"] = 67,["81"] = 68,["82"] = 68,["83"] = 68,["84"] = 68,["85"] = 68,["86"] = 69,["87"] = 69,["88"] = 69,["89"] = 69,["90"] = 69,["91"] = 72,["92"] = 72,["93"] = 72,["94"] = 69,["95"] = 69,["96"] = 64,["97"] = 64,["98"] = 78,["99"] = 78,["100"] = 79,["103"] = 79,["104"] = 79,["106"] = 80,["107"] = 81,["111"] = 85,["112"] = 86,["115"] = 90,["118"] = 91,["119"] = 91,["120"] = 92,["121"] = 92,["122"] = 92,["123"] = 92,["124"] = 92,["125"] = 92,["126"] = 92,["127"] = 92,["128"] = 93,["130"] = 94,["131"] = 95,["133"] = 97,["135"] = 99,["136"] = 101,["137"] = 103,["138"] = 103,["139"] = 103,["140"] = 104,["142"] = 105,["143"] = 106,["145"] = 108,["147"] = 110,["148"] = 111,["149"] = 112,["150"] = 113,["151"] = 114,["152"] = 115,["153"] = 116,["154"] = 117,["155"] = 116,["156"] = 115,["158"] = 123,["159"] = 103,["160"] = 103,["162"] = 92,["163"] = 92,["167"] = 130,["170"] = 132,["171"] = 133,["173"] = 135,["174"] = 136,["175"] = 137,["176"] = 138,["177"] = 139,["178"] = 138,["180"] = 142,["183"] = 78,["184"] = 147});
local ____exports = {}
local ____program = require("lib.program")
local program = ____program.program
local ____color = require("lib.uwui.color")
local Color = ____color.Color
local ____components = require("lib.uwui.components")
local Box = ____components.Box
local Button = ____components.Button
local Columns = ____components.Columns
local Text = ____components.Text
local ____uwui = require("lib.uwui.uwui")
local UwUi = ____uwui.UwUi
term.clear()
term.setCursorPos(1, 1)
local uwui = __TS__New(UwUi, {term = term})
local function inset(n)
    return {x = n, y = n, w = -n, h = -n}
end
local centered = {x = 0.5, y = 0.5, justify = "center", align = "middle"}
local start = os.clock()
local transFlag = Color:gradient(
    30,
    Color.hsl(0.57, 0.8, 0.7),
    Color.hsl(0.9, 0.6, 0.8),
    Color.hsl(0.8, 0, 0.9),
    Color.hsl(0.8, 0, 0.9),
    Color.hsl(0.8, 0, 0.9),
    Color.hsl(0.9, 0.6, 0.8),
    Color.hsl(0.57, 0.8, 0.7)
)
uwui:render(UwUi.node(Box, {bg = transFlag.vertical}))
local pink = Color.hsl(0.9, 0.6, 0.8)
local bg = Color.hsl(0.73, 0.25, 0.15)
local surface = Color.hsl(0.68, 0.22, 0.26)
local root = fs.combine(
    fs.getDir(shell.getRunningProgram()),
    ".."
)
local programs = {}
programs[""] = __TS__ArrayMap(
    __TS__ArrayFilter(
        fs.list(fs.combine(root, "programs")),
        function(____, f) return __TS__StringEndsWith(f, ".lua") and f ~= "gui.lua" end
    ),
    function(____, f) return {
        name = string.sub(f, 1, -5),
        color = pink
    } end
)
__TS__ArrayForEach(
    __TS__ArrayFilter(
        __TS__ArrayMap(
            fs.list(root),
            function(____, f) return {
                f,
                fs.combine(root, f, "programs")
            } end
        ),
        function(____, ____bindingPattern0)
            local p
            local _ = ____bindingPattern0[1]
            p = ____bindingPattern0[2]
            return fs.isDir(p)
        end
    ),
    function(____, ____bindingPattern0)
        local dir
        local file
        file = ____bindingPattern0[1]
        dir = ____bindingPattern0[2]
        local color = Color.hsl(
            math.random(),
            0.6,
            0.8
        )
        programs[file] = __TS__ArrayMap(
            __TS__ArrayFilter(
                fs.list(dir),
                function(____, f) return __TS__StringEndsWith(f, ".lua") end
            ),
            function(____, f) return {
                name = string.sub(f, 1, -5),
                color = color
            } end
        )
    end
)
local function App()
    return UwUi.node(
        Box,
        __TS__ObjectAssign(
            {},
            inset(5),
            {bg = bg.idx}
        ),
        UwUi.node(Text, {
            color = pink.idx,
            justify = "center",
            align = "middle",
            font = "7px-Bold",
            x = 0.5,
            y = 0.3
        }, "owo OS"),
        UwUi.node(
            Box,
            {stale = "programs"},
            UwUi.node(
                Columns,
                {justify = "center", x = 0.5},
                table.unpack(__TS__ArrayMap(
                    __TS__ObjectEntries(programs),
                    function(____, ____bindingPattern0)
                        local ps
                        local category
                        category = ____bindingPattern0[1]
                        ps = ____bindingPattern0[2]
                        return UwUi.node(
                            Box,
                            nil,
                            UwUi.node(Text, {
                                color = pink.idx,
                                justify = "center",
                                x = 0.5,
                                align = "bottom",
                                y = -20 - #ps * 15
                            }, category),
                            table.unpack(__TS__ArrayMap(
                                ps,
                                function(____, p, i) return UwUi.node(
                                    Button,
                                    {
                                        bg = p.color.idx,
                                        color = bg.idx,
                                        justify = "center",
                                        x = 0.5,
                                        align = "bottom",
                                        h = 13,
                                        w = 0.8,
                                        padding = 0,
                                        y = -20 - i * 15,
                                        font = "7px",
                                        onClick = function()
                                            uwui:defer(function()
                                                shell.run(fs.combine(root, category, "programs", p.name .. ".lua"))
                                            end)
                                        end
                                    },
                                    p.name
                                ) end
                            ))
                        )
                    end
                ))
            )
        ),
        UwUi.node(
            Button,
            {
                stale = "shell",
                bg = surface.idx,
                color = pink.idx,
                justify = "right",
                x = -4,
                y = 4,
                font = "5px-Bold-Condesed",
                onClick = function()
                    uwui:stop()
                end
            },
            ">_"
        )
    )
end
program(function() return uwui:run(App) end)
return ____exports
