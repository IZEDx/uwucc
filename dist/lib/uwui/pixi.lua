package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 3,["12"] = 3,["13"] = 22,["14"] = 22,["15"] = 22,["16"] = 35,["17"] = 36,["18"] = 36,["20"] = 37,["21"] = 37,["23"] = 38,["24"] = 38,["26"] = 39,["27"] = 39,["29"] = 40,["30"] = 40,["32"] = 35,["33"] = 36,["34"] = 37,["35"] = 38,["36"] = 39,["37"] = 40,["38"] = 41,["39"] = 42,["40"] = 44,["41"] = 45,["42"] = 46,["43"] = 47,["44"] = 48,["45"] = 49,["46"] = 50,["47"] = 50,["48"] = 50,["49"] = 50,["50"] = 50,["51"] = 51,["53"] = 53,["55"] = 55,["56"] = 34,["57"] = 24,["58"] = 24,["59"] = 24,["61"] = 25,["62"] = 26,["63"] = 27,["64"] = 28,["65"] = 28,["66"] = 28,["67"] = 28,["68"] = 28,["69"] = 28,["70"] = 28,["71"] = 28,["72"] = 28,["73"] = 24,["74"] = 59,["75"] = 60,["76"] = 59,["77"] = 63,["78"] = 64,["79"] = 64,["81"] = 65,["82"] = 65,["84"] = 66,["85"] = 66,["87"] = 67,["88"] = 67,["90"] = 68,["91"] = 68,["93"] = 70,["94"] = 71,["95"] = 72,["96"] = 73,["97"] = 74,["98"] = 75,["99"] = 76,["100"] = 77,["101"] = 78,["102"] = 78,["103"] = 78,["104"] = 78,["105"] = 78,["106"] = 78,["107"] = 78,["108"] = 78,["109"] = 78,["110"] = 78,["111"] = 78,["112"] = 63,["113"] = 81,["114"] = 82,["115"] = 81,["116"] = 85,["117"] = 86,["118"] = 87,["119"] = 88,["120"] = 89,["121"] = 90,["122"] = 91,["123"] = 92,["125"] = 93,["126"] = 93,["127"] = 94,["129"] = 95,["130"] = 95,["131"] = 96,["132"] = 97,["133"] = 97,["135"] = 95,["138"] = 93,["141"] = 85,["142"] = 102,["143"] = 103,["144"] = 103,["145"] = 103,["146"] = 103,["147"] = 104,["148"] = 102,["149"] = 107,["150"] = 108,["151"] = 109,["152"] = 110,["153"] = 111,["154"] = 112,["155"] = 113,["156"] = 114,["157"] = 115,["158"] = 115,["159"] = 116,["161"] = 117,["162"] = 117,["163"] = 118,["164"] = 119,["165"] = 120,["166"] = 121,["168"] = 122,["169"] = 122,["170"] = 123,["171"] = 124,["172"] = 125,["173"] = 126,["174"] = 127,["177"] = 122,["181"] = 117,["184"] = 107,["185"] = 157,["186"] = 158,["187"] = 158,["188"] = 158,["189"] = 158,["190"] = 158,["191"] = 157,["192"] = 161,["193"] = 162,["194"] = 162,["195"] = 162,["196"] = 162,["197"] = 162,["198"] = 161});
local ____exports = {}
local ____math = require("lib.math")
local clamp = ____math.clamp
local round = ____math.round
local ____helpers = require("lib.uwui.helpers")
local pixelBuffer = ____helpers.pixelBuffer
____exports.Pixels = __TS__Class()
local Pixels = ____exports.Pixels
Pixels.name = "Pixels"
function Pixels.prototype.____constructor(self, buffer, x, y, w, h, bg, parent, root)
    if x == nil then
        x = 0
    end
    if y == nil then
        y = 0
    end
    if w == nil then
        w = 0
    end
    if h == nil then
        h = 0
    end
    if bg == nil then
        bg = 0
    end
    self.buffer = buffer
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.bg = bg
    self.parent = parent
    self.root = root
    self.cache = root and root.cache or __TS__New(Map)
    self.x = math.floor(x)
    self.y = math.floor(y)
    self.w = math.ceil(w)
    self.h = math.ceil(h)
    if type(self.bg) == "number" then
        self.bg = clamp(
            round(self.bg),
            0,
            255
        )
        self.base = function() return self.bg end
    else
        self.base = self.bg
    end
    self:clear()
end
function Pixels.new(w, h, base)
    if base == nil then
        base = 0
    end
    w = math.ceil(w)
    h = math.ceil(h)
    local b = pixelBuffer(w, h, 0)
    return __TS__New(
        ____exports.Pixels,
        b,
        0,
        0,
        w,
        h,
        base
    )
end
function Pixels.prototype.getSize(self, mode)
    return table.unpack({self.w, self.h})
end
function Pixels.prototype.section(self, offsetX, offsetY, width, height, base)
    if offsetX == nil then
        offsetX = 0
    end
    if offsetY == nil then
        offsetY = 0
    end
    if width == nil then
        width = self.w - offsetX
    end
    if height == nil then
        height = self.h - offsetY
    end
    if base == nil then
        base = 0
    end
    local minX = self.x
    local minY = self.y
    local maxX = self.x + self.w
    local maxY = self.y + self.h
    local x = clamp(minX + offsetX, minX, maxX)
    local y = clamp(minY + offsetY, minY, maxY)
    local w = clamp(width, 0, maxX - x)
    local h = clamp(height, 0, maxY - y)
    return __TS__New(
        ____exports.Pixels,
        self.buffer,
        x,
        y,
        w,
        h,
        base,
        self,
        self.root or self
    )
end
function Pixels.prototype.clear(self, col)
    self:drawGradient(type(col) == "number" and (function() return col end) or (col or self.base))
end
function Pixels.prototype.drawGradient(self, fn)
    local minX = self.x
    local minY = self.y
    local w = self.w
    local h = self.h
    local maxX = minX + w
    local maxY = minY + h
    local b = self.buffer
    do
        local y = minY
        while y < maxY do
            local row = b[y + 1]
            do
                local x = minX
                while x < maxX do
                    local col = fn((x - minX) / w, (y - minY) / h)
                    if col > 0 then
                        row[x + 1] = col
                    end
                    x = x + 1
                end
            end
            y = y + 1
        end
    end
end
function Pixels.prototype.getBounds(self)
    local x = self.x
    local y = self.y
    local w = self.w
    local h = self.h
    return {x, y, x + w, y + h}
end
function Pixels.prototype.drawPixels(self, x, y, source)
    local b = self.buffer
    local minX = self.x
    local minY = self.y
    local maxX = self.x + self.w
    local maxY = self.y + self.h
    local offsetX = math.floor(x)
    local offsetY = math.floor(y)
    local ____opt_2 = source[1]
    local sourceW = ____opt_2 and #____opt_2 or 0
    local sourceH = #source
    do
        local sourceY = 0
        while sourceY < sourceH do
            y = minY + offsetY + sourceY
            if y >= minY and y < maxY then
                local row = b[y + 1]
                local srcRow = source[sourceY + 1] or ({})
                do
                    local sourceX = 0
                    while sourceX < sourceW do
                        x = minX + offsetX + sourceX
                        if x >= minX and x < maxX then
                            local col = srcRow[sourceX + 1]
                            if col and col > 0 and b[y + 1][x + 1] ~= col then
                                row[x + 1] = col
                            end
                        end
                        sourceX = sourceX + 1
                    end
                end
            end
            sourceY = sourceY + 1
        end
    end
end
function Pixels.prototype.drawRect(self, x, y, w, h, col)
    self:drawPixels(
        x,
        y,
        pixelBuffer(w, h, col)
    )
end
function Pixels.prototype.drawText(self, x, y, font, ...)
    self:drawPixels(
        x,
        y,
        font:render(...).pixels
    )
end
return ____exports
