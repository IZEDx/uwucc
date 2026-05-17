-- lib/chalk.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/chalk.ts"] = _G.__tracetrace["lib/chalk.ts"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__StringAccess = ____lualib.__TS__StringAccess
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ObjectDefineProperty = ____lualib.__TS__ObjectDefineProperty
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["18"] = 253,["19"] = 1,["20"] = 1,["21"] = 1,["24"] = 44,["25"] = 45,["26"] = 44,["29"] = 49,["30"] = 49,["31"] = 49,["33"] = 50,["34"] = 51,["35"] = 49,["38"] = 55,["39"] = 56,["40"] = 57,["41"] = 58,["42"] = 55,["45"] = 63,["46"] = 64,["47"] = 65,["48"] = 66,["49"] = 66,["50"] = 66,["51"] = 66,["52"] = 67,["53"] = 63,["56"] = 177,["57"] = 178,["58"] = 178,["59"] = 178,["60"] = 178,["61"] = 177,["64"] = 182,["65"] = 183,["66"] = 184,["68"] = 186,["69"] = 186,["70"] = 187,["71"] = 188,["72"] = 189,["73"] = 190,["74"] = 191,["75"] = 192,["76"] = 193,["77"] = 195,["78"] = 195,["80"] = 196,["81"] = 196,["83"] = 197,["84"] = 198,["85"] = 199,["86"] = 199,["89"] = 201,["92"] = 204,["94"] = 186,["97"] = 207,["98"] = 182,["101"] = 211,["102"] = 212,["103"] = 214,["104"] = 216,["106"] = 218,["107"] = 218,["108"] = 219,["109"] = 220,["110"] = 221,["111"] = 222,["112"] = 223,["113"] = 224,["114"] = 225,["115"] = 226,["116"] = 227,["117"] = 228,["118"] = 229,["119"] = 230,["120"] = 232,["121"] = 232,["123"] = 233,["124"] = 233,["126"] = 235,["127"] = 235,["129"] = 236,["130"] = 236,["132"] = 238,["133"] = 239,["134"] = 240,["135"] = 240,["138"] = 242,["141"] = 245,["143"] = 218,["146"] = 249,["147"] = 211,["148"] = 253,["149"] = 254,["150"] = 254,["151"] = 254,["152"] = 254,["153"] = 258,["154"] = 259,["155"] = 260,["156"] = 258,["158"] = 266,["159"] = 267,["161"] = 267,["162"] = 267,["163"] = 268,["164"] = 269,["165"] = 270,["166"] = 271,["168"] = 272,["169"] = 272,["172"] = 273,["173"] = 274,["175"] = 276,["178"] = 279,["179"] = 267,["181"] = 282,["182"] = 283,["183"] = 284,["184"] = 285,["185"] = 286,["186"] = 286,["187"] = 286,["188"] = 286,["189"] = 286,["190"] = 289,["191"] = 289,["192"] = 289,["193"] = 289,["194"] = 289,["197"] = 295,["199"] = 3,["200"] = 3,["201"] = 3,["202"] = 3,["203"] = 3,["204"] = 3,["205"] = 3,["206"] = 3,["207"] = 3,["208"] = 3,["209"] = 3,["210"] = 3,["211"] = 3,["212"] = 3,["213"] = 3,["214"] = 3,["215"] = 3,["216"] = 3,["217"] = 27,["218"] = 27,["219"] = 27,["220"] = 27,["221"] = 27,["222"] = 27,["223"] = 27,["224"] = 28,["225"] = 28,["226"] = 28,["227"] = 28,["228"] = 28,["229"] = 28,["230"] = 28,["231"] = 29,["232"] = 29,["233"] = 29,["234"] = 29,["235"] = 29,["236"] = 29,["237"] = 29,["240"] = 32,["241"] = 33,["242"] = 34,["243"] = 35,["244"] = 36,["245"] = 37,["246"] = 38,["247"] = 38,["248"] = 38,["249"] = 38,["250"] = 39,["251"] = 40,["252"] = 32,["253"] = 71,["254"] = 71,["255"] = 71,["257"] = 72,["260"] = 73,["261"] = 74,["262"] = 75,["263"] = 75,["264"] = 75,["265"] = 75,["266"] = 76,["267"] = 78,["268"] = 79,["269"] = 102,["270"] = 103,["271"] = 104,["272"] = 104,["273"] = 104,["274"] = 104,["275"] = 104,["276"] = 104,["277"] = 104,["278"] = 104,["279"] = 104,["280"] = 104,["281"] = 104,["282"] = 104,["283"] = 104,["284"] = 104,["285"] = 104,["286"] = 104,["287"] = 104,["288"] = 103,["289"] = 115,["290"] = 71,["291"] = 118,["292"] = 118,["293"] = 118,["295"] = 119,["296"] = 120,["297"] = 121,["298"] = 122,["299"] = 123,["300"] = 124,["301"] = 125,["302"] = 126,["303"] = 127,["304"] = 128,["305"] = 129,["306"] = 130,["307"] = 131,["308"] = 132,["309"] = 133,["310"] = 134,["311"] = 135,["312"] = 136,["313"] = 137,["314"] = 138,["315"] = 139,["316"] = 140,["318"] = 142,["319"] = 143,["320"] = 144,["321"] = 144,["322"] = 144,["323"] = 144,["324"] = 145,["325"] = 146,["326"] = 147,["328"] = 149,["329"] = 150,["331"] = 153,["332"] = 118,["335"] = 157,["336"] = 158,["337"] = 159,["338"] = 160,["339"] = 161,["340"] = 162,["341"] = 157,["344"] = 166,["345"] = 167,["346"] = 168,["347"] = 170,["351"] = 166,["352"] = 264});
local ____exports = {}
local backupStyle, chalkFactory
local ____events = require("lib.events")
local KeyEvent = ____events.KeyEvent
local pullEventAs = ____events.pullEventAs
---
-- @noSelf
function ____exports.getHeader()
    return term._shellTitle or ":3"
end
---
-- @noSelf
function ____exports.clearLine(c)
    if c == nil then
        c = ____exports.chalk
    end
    local w, h = term.getSize()
    ____exports.print(c(string.rep(" ", w)))
end
---
-- @noSelf
function ____exports.clear()
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1, 1)
end
---
-- @noSelf
function ____exports.printCentered(paddingColor, ...)
    local text = ____exports.chalk(...)
    local w = term.getSize()
    local x = math.max(
        0,
        math.floor((w - #____exports.stripStyling(text)) / 2)
    )
    ____exports.print((paddingColor(string.rep(" ", x)) .. text) .. paddingColor(string.rep(" ", x)))
end
---
-- @noSelf
function ____exports.print(...)
    local ____exports_write_3 = ____exports.write
    local ____array_2 = __TS__SparseArrayNew(...)
    __TS__SparseArrayPush(____array_2, "\r\n")
    ____exports_write_3(__TS__SparseArraySpread(____array_2))
end
---
-- @noSelf
function ____exports.stripStyling(...)
    local styled = ____exports.chalk(...)
    local out = ""
    do
        local i = 0
        while i < #styled do
            local c = __TS__StringAccess(styled, i)
            local x, y = term.getCursorPos()
            if c == "{" then
                local f = __TS__StringAccess(styled, i + 1)
                local b = __TS__StringAccess(styled, i + 2)
                local colF = colors.fromBlit(f)
                local colB = colors.fromBlit(b)
                if f == "_" or colF then
                    i = i + 1
                end
                if b == "_" or colB then
                    i = i + 1
                end
                if colF or colB or f == "_" or b == "_" then
                    i = i + 1
                    if __TS__StringAccess(styled, i) == "}" then
                        i = i + 1
                    end
                else
                    out = out .. c
                end
            else
                out = out .. c
            end
            i = i + 1
        end
    end
    return out
end
---
-- @noSelf
function ____exports.write(...)
    local restore = backupStyle()
    local text = ____exports.chalk(...)
    local w, h = term.getSize()
    do
        local i = 0
        while i < #text do
            local c = __TS__StringAccess(text, i)
            local x, y = term.getCursorPos()
            if c == "\n" then
                _G.print("")
            elseif x > w + 2 then
                term.setCursorPos(w - 2, y)
                term.write("...")
            elseif c == "{" then
                local f = __TS__StringAccess(text, i + 1)
                local b = __TS__StringAccess(text, i + 2)
                local colF = colors.fromBlit(f)
                local colB = colors.fromBlit(b)
                if f == "_" or colF then
                    i = i + 1
                end
                if colF then
                    term.setTextColor(colF)
                end
                if b == "_" or colB then
                    i = i + 1
                end
                if colB then
                    term.setBackgroundColor(colB)
                end
                if colF or colB or f == "_" or b == "_" then
                    i = i + 1
                    if __TS__StringAccess(text, i) == "}" then
                        i = i + 1
                    end
                else
                    term.write(c)
                end
            else
                term.write(c)
            end
            i = i + 1
        end
    end
    restore()
end
function backupStyle()
    local backup = {
        fg = term.getTextColor(),
        bg = term.getBackgroundColor()
    }
    return function()
        term.setTextColor(backup.fg)
        term.setBackgroundColor(backup.bg)
    end
end
function chalkFactory(options)
    local _chalk = setmetatable(
        {},
        {__call = function(____, ...)
            local args = {...}
            local fgBlit = options and options.fg and colors.toBlit(options.fg) or "_"
            local bgBlit = options and options.bg and colors.toBlit(options.bg) or "_"
            local output = (("{" .. fgBlit) .. bgBlit) .. "}"
            local part
            while true do
                part = table.remove(args, 1)
                if not part then
                    break
                end
                if type(part) == "function" and part.__isChalk then
                    return (output .. (#output == 3 and "" or " ")) .. tostring(part(...))
                else
                    output = output .. (#output == 3 and "" or " ") .. tostring(part)
                end
            end
            return output
        end}
    )
    for ____, _name in ipairs(__TS__ObjectKeys(colors)) do
        local name = _name
        local color = colors[name]
        if type(color) == "number" then
            __TS__ObjectDefineProperty(
                _chalk,
                name,
                {get = function() return chalkFactory(__TS__ObjectAssign({}, options, {fg = color})) end}
            )
            __TS__ObjectDefineProperty(
                _chalk,
                ("bg" .. string.upper(string.sub(name, 1, 1))) .. string.sub(name, 2),
                {get = function() return chalkFactory(__TS__ObjectAssign({}, options, {bg = color})) end}
            )
        end
    end
    return _chalk
end
____exports.palette = {
    background = {blit = "f", hex = "#1a1626"},
    surface = {blit = "e", hex = "#2e2540"},
    overlay = {blit = "d", hex = "#3d3357"},
    border = {blit = "c", hex = "#54456e"},
    textDisabled = {blit = "b", hex = "#7a6a9a"},
    textSubtle = {blit = "a", hex = "#a08ec0"},
    textMuted = {blit = "0", hex = "#c3b4e0"},
    textDefault = {blit = "9", hex = "#f5f0ff"},
    success = {blit = "8", hex = "#6ed4a0"},
    primary = {blit = "7", hex = "#5ecfcf"},
    info = {blit = "6", hex = "#8ec8f5"},
    secondary = {blit = "5", hex = "#d96fa8"},
    error = {blit = "4", hex = "#f08080"},
    warning = {blit = "3", hex = "#f0c87a"},
    focus = {blit = "2", hex = "#f09bc8"},
    cursor = {blit = "1", hex = "#fce8f3"}
}
term.setPaletteColor(
    colors.black,
    __TS__ParseInt(
        string.sub("#1a1626", 2),
        16
    )
)
term.setPaletteColor(
    colors.gray,
    __TS__ParseInt(
        string.sub("#2e2540", 2),
        16
    )
)
term.setPaletteColor(
    colors.lightGray,
    __TS__ParseInt(
        string.sub("#3d3357", 2),
        16
    )
)
---
-- @noSelf
function ____exports.showHeader(title)
    local w, h = term.getSize()
    local shellTitle = title or ____exports.getHeader()
    term._shellTitle = shellTitle
    ____exports.clear()
    ____exports.clearLine(____exports.chalk.bgGray)
    ____exports.printCentered(
        ____exports.chalk.bgGray,
        ____exports.chalk.pink(shellTitle)
    )
    ____exports.clearLine(____exports.chalk.bgGray)
    ____exports.clearLine()
end
function ____exports.printError(e, maxTrace)
    if maxTrace == nil then
        maxTrace = 5
    end
    if e == nil then
        return
    end
    term.setTextColor(colors.red)
    _G.print("ERROR:")
    local trace = debug.traceback(
        tostring(e),
        3
    )
    local ____error = __TS__StringTrim(__TS__StringSplit(trace, "stack traceback:")[1])
    term.setTextColor(colors.orange)
    _G.print(____error)
    term.setTextColor(colors.lightGray)
    ____exports.print(table.concat(
        __TS__ArrayFilter(
            __TS__ArrayMap(
                __TS__StringSplit(
                    table.concat(
                        __TS__ArraySlice(
                            __TS__StringSplit(trace, "stack traceback:"),
                            1
                        ),
                        "\n"
                    ),
                    "\n"
                ),
                function(____, l) return __TS__StringTrim(l) end
            ),
            function(____, l, i) return #l > 0 and i < maxTrace end
        ),
        "\n"
    ))
    term.setTextColor(colors.white)
end
function ____exports.printValue(value, level)
    if level == nil then
        level = 0
    end
    if type(value) == "number" then
        term.setTextColor(colors.lightBlue)
        ____exports.print(tostring(value))
    elseif type(value) == "boolean" then
        term.setTextColor(colors.purple)
        ____exports.print(tostring(value))
    elseif type(value) == "string" then
        term.setTextColor(colors.orange)
        ____exports.print(("\"" .. value) .. "\"")
    elseif type(value) == "function" then
        term.setTextColor(colors.green)
        ____exports.print(tostring(value))
    elseif type(value) == "table" and level < 3 then
        term.setTextColor(colors.lightGray)
        ____exports.print("{")
        level = level + 1
        for ____, key in ipairs(__TS__ObjectKeys(value)) do
            term.setTextColor(colors.white)
            term.write(string.rep(" ", level) .. key .. " ")
            term.setTextColor(colors.lightGray)
            term.write("= ")
            ____exports.printValue(value[key])
        end
        level = level - 1
        term.setTextColor(colors.lightGray)
        ____exports.print(string.rep(
            " ",
            math.floor(level)
        ) .. "}")
    elseif type(value) == "table" then
        term.setTextColor(colors.green)
        ____exports.print(tostring(value))
    else
        term.setTextColor(colors.lightGray)
        ____exports.print(tostring(value))
    end
    term.setTextColor(colors.white)
end
---
-- @noSelf
function ____exports.anyKey()
    ____exports.print("")
    term.setTextColor(colors.lightGray)
    ____exports.print("Press any key to continue...")
    term.setTextColor(colors.white)
    os.pullEvent("key")
end
---
-- @noSelf
function ____exports.waitForKey(key)
    while true do
        local e = pullEventAs(KeyEvent, "key")
        if not key or (e and e.key) == key then
            return
        end
    end
end
____exports.chalk = chalkFactory({})
return ____exports
