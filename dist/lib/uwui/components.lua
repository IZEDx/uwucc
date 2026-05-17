-- lib/uwui/components.tsx
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/uwui/components.tsx"] = _G.__tracetrace["lib/uwui/components.tsx"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__New = ____lualib.__TS__New
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["10"] = 1,["11"] = 1,["12"] = 4,["13"] = 4,["14"] = 21,["15"] = 21,["16"] = 21,["17"] = 21,["19"] = 21,["20"] = 22,["21"] = 21,["22"] = 24,["23"] = 25,["24"] = 26,["25"] = 27,["26"] = 28,["27"] = 29,["28"] = 29,["30"] = 30,["31"] = 30,["33"] = 31,["34"] = 32,["35"] = 32,["37"] = 33,["38"] = 33,["40"] = 34,["41"] = 34,["43"] = 35,["44"] = 35,["47"] = 37,["48"] = 37,["50"] = 38,["51"] = 38,["53"] = 39,["54"] = 39,["56"] = 40,["57"] = 40,["59"] = 41,["60"] = 42,["61"] = 43,["62"] = 44,["64"] = 46,["65"] = 47,["66"] = 48,["67"] = 49,["69"] = 51,["70"] = 51,["71"] = 51,["72"] = 51,["73"] = 51,["74"] = 51,["75"] = 51,["76"] = 24,["77"] = 55,["78"] = 55,["79"] = 55,["80"] = 55,["81"] = 55,["82"] = 55,["83"] = 55,["84"] = 55,["87"] = 77,["88"] = 78,["89"] = 77,["90"] = 81,["91"] = 81,["92"] = 81,["93"] = 81,["95"] = 81,["96"] = 82,["97"] = 81,["98"] = 87,["99"] = 88,["100"] = 88,["101"] = 89,["102"] = 91,["103"] = 91,["104"] = 93,["105"] = 93,["106"] = 93,["107"] = 91,["108"] = 91,["109"] = 100,["110"] = 101,["111"] = 102,["112"] = 103,["113"] = 104,["114"] = 81,["115"] = 87,["116"] = 108,["117"] = 109,["118"] = 110,["119"] = 108,["120"] = 114,["121"] = 114,["123"] = 115,["124"] = 115,["126"] = 115,["127"] = 116,["129"] = 118,["131"] = 114,["132"] = 124,["133"] = 124,["134"] = 125,["135"] = 126,["137"] = 127,["138"] = 128,["141"] = 132,["143"] = 133,["149"] = 137,["150"] = 138,["151"] = 139,["152"] = 140,["153"] = 141,["155"] = 143,["158"] = 124,["159"] = 149,["160"] = 149,["161"] = 150,["162"] = 150,["164"] = 151,["165"] = 152,["167"] = 153,["168"] = 154,["169"] = 154,["170"] = 154,["171"] = 154,["173"] = 149});
local ____exports = {}
local ____font = require("lib.uwui.font")
local Font = ____font.Font
local ____uwui = require("lib.uwui.uwui")
local UwUi = ____uwui.UwUi
____exports.Box = __TS__Class()
local Box = ____exports.Box
Box.name = "Box"
__TS__ClassExtends(Box, UwUi.ClassComponent)
function Box.prototype.____constructor(self, ...)
    Box.____super.prototype.____constructor(self, ...)
    self.name = "Box"
end
function Box.prototype.translate(self, target)
    local x = self.props.x or 0
    local y = self.props.y or 0
    local w = self.props.w or target.w - x
    local h = self.props.h or target.h - y
    if w == 0 then
        w = target.w - x
    end
    if h == 0 then
        h = target.h - y
    end
    if self.props.mode ~= "absolute" then
        if math.abs(x) <= 1 then
            x = x * target.w
        end
        if math.abs(y) <= 1 then
            y = y * target.h
        end
        if math.abs(w) <= 1 then
            w = w * target.w
        end
        if math.abs(h) <= 1 then
            h = h * target.h
        end
    end
    if x < 0 then
        x = target.w + x
    end
    if y < 0 then
        y = target.h + y
    end
    if w < 0 then
        w = target.w - x + w
    end
    if h < 0 then
        h = target.h - y + h
    end
    if self.props.justify == "center" then
        x = x - w / 2
    elseif self.props.justify == "right" then
        x = x - w
    end
    if self.props.align == "middle" then
        y = y - h / 2
    elseif self.props.align == "bottom" then
        y = y - h
    end
    return target:section(
        x,
        y,
        w,
        h,
        self.props.bg or 0
    )
end
local fonts = {
    ["5px"] = __TS__New(Font, {file = "disk/static/sigi-pixel-font-master/Sigi-5px-Regular.json"}),
    ["5px-Bold"] = __TS__New(Font, {file = "disk/static/sigi-pixel-font-master/Sigi-5px-Bold.json"}),
    ["5px-Condesed"] = __TS__New(Font, {file = "disk/static/sigi-pixel-font-master/Sigi-5px-Condensed-Regular.json", spacing = {x = 1, y = 1}}),
    ["5px-Bold-Condesed"] = __TS__New(Font, {file = "disk/static/sigi-pixel-font-master/Sigi-5px-Condensed-Bold.json", spacing = {x = 1, y = 1}}),
    ["7px"] = __TS__New(Font, {file = "disk/static/sigi-pixel-font-master/Sigi-7px-Regular.json"}),
    ["7px-Bold"] = __TS__New(Font, {file = "disk/static/sigi-pixel-font-master/Sigi-7px-Bold.json"})
}
---
-- @noSelf
____exports.Color = function(props, ...)
    return {props, ...}
end
____exports.Text = __TS__Class()
local Text = ____exports.Text
Text.name = "Text"
__TS__ClassExtends(Text, ____exports.Box)
function Text.prototype.____constructor(self, ...)
    Text.____super.prototype.____constructor(self, ...)
    self.name = "Text"
end
function Text.prototype.translate(self, target)
    local props = self.props
    local children = self.children
    local font = type(props.font) == "string" and fonts[props.font] or (props.font or fonts["5px"])
    local text = font:render(
        props.color or 1,
        table.unpack(__TS__ArrayMap(
            children,
            function(____, c, i) return type(c) == "table" and c.color and c.color or tostring(c) .. (i == #children - 1 and "" or " ") end
        ))
    )
    self.text = text.text
    self.pixels = text.pixels
    local padding = self.props.padding or 0
    self.props.w = (self.props.w or text.w) + padding
    self.props.h = (self.props.h or text.h) + padding
    return Text.____super.prototype.translate(self, target)
end
function Text.prototype.render(self, dt)
    local padding = (self.props.padding or 0) / 2
    self.target:drawPixels(padding, padding, self.pixels)
end
____exports.If = function(props, ...)
    local children = {...}
    local ____opt_result_2
    if props ~= nil then
        ____opt_result_2 = props.condition
    end
    if ____opt_result_2 or props == true then
        return children
    else
        return {}
    end
end
____exports.Button = function(props, ...)
    local children = {...}
    if not props.w or not props.h then
        return UwUi.node(
            ____exports.Text,
            __TS__ObjectAssign({}, props, {padding = props.padding or 6}),
            table.unpack(children)
        )
    end
    return UwUi.node(
        ____exports.Box,
        __TS__ObjectAssign({}, props),
        UwUi.node(
            ____exports.Text,
            {
                align = "middle",
                justify = "center",
                x = 0.5,
                y = 0.5,
                color = props.color,
                font = props.font,
                padding = props.padding or 6
            },
            table.unpack(children)
        )
    )
end
____exports.Columns = function(props, ...)
    local children = {...}
    if #children == 0 then
        return {}
    end
    local w = 1 / #children
    return UwUi.node(
        ____exports.Box,
        __TS__ObjectAssign({}, props),
        table.unpack(__TS__ArrayMap(
            children,
            function(____, child, i) return UwUi.node(____exports.Box, {x = i * w, w = w}, child) end
        ))
    )
end
return ____exports
