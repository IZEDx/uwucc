package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringAccess = ____lualib.__TS__StringAccess
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["12"] = 1,["13"] = 1,["14"] = 2,["15"] = 2,["16"] = 24,["17"] = 26,["18"] = 26,["19"] = 26,["20"] = 30,["21"] = 31,["22"] = 39,["23"] = 40,["24"] = 41,["25"] = 42,["26"] = 42,["29"] = 44,["31"] = 30,["32"] = 48,["33"] = 49,["34"] = 50,["35"] = 50,["36"] = 50,["37"] = 50,["38"] = 51,["39"] = 51,["40"] = 51,["41"] = 52,["42"] = 53,["43"] = 53,["44"] = 53,["45"] = 53,["46"] = 51,["47"] = 51,["48"] = 48,["49"] = 57,["50"] = 57,["51"] = 58,["52"] = 58,["53"] = 58,["54"] = 58,["55"] = 58,["56"] = 58,["57"] = 58,["58"] = 59,["59"] = 60,["60"] = 61,["61"] = 62,["62"] = 63,["63"] = 64,["64"] = 65,["66"] = 67,["67"] = 68,["69"] = 70,["70"] = 57,["71"] = 73,["72"] = 73,["73"] = 74,["74"] = 74,["75"] = 74,["76"] = 74,["77"] = 74,["78"] = 74,["79"] = 74,["80"] = 75,["81"] = 75,["82"] = 75,["83"] = 75,["84"] = 75,["85"] = 76,["86"] = 77,["87"] = 79,["88"] = 80,["89"] = 81,["91"] = 82,["92"] = 82,["93"] = 83,["94"] = 84,["95"] = 85,["97"] = 87,["99"] = 88,["100"] = 88,["101"] = 89,["102"] = 90,["103"] = 91,["104"] = 92,["106"] = 94,["107"] = 95,["108"] = 95,["109"] = 95,["110"] = 96,["112"] = 98,["114"] = 88,["118"] = 82,["121"] = 104,["122"] = 73});
local ____exports = {}
local ____math = require("lib.math")
local round = ____math.round
local ____helpers = require("lib.uwui.helpers")
local pixelBuffer = ____helpers.pixelBuffer
local placeholderCol = string.char(1)
____exports.Font = __TS__Class()
local Font = ____exports.Font
Font.name = "Font"
function Font.prototype.____constructor(self, options)
    self.options = __TS__ObjectAssign({spacing = {x = 2, y = 2}, file = "disk/static/sigi-pixel-font-master/Sigi-7px-Regular.json"}, options)
    if type(self.options.file) == "string" then
        local fontFile = fs.open(self.options.file, "r")
        self.data = textutils.unserialiseJSON(fontFile and fontFile.readAll() or "")
        if fontFile ~= nil then
            fontFile.close()
        end
    else
        self.data = self.options.file
    end
end
function Font.prototype.getGlyphs(self, s)
    local e = string.byte("#")
    local emptyGlyph = __TS__ArrayFind(
        self.data.glyphs,
        function(____, g) return g.codepoint == e end
    )
    return __TS__ArrayMap(
        __TS__StringSplit(s, ""),
        function(____, c)
            local b = string.byte(c)
            return __TS__ArrayFind(
                self.data.glyphs,
                function(____, g) return g.codepoint == b end
            ) or emptyGlyph
        end
    )
end
function Font.prototype.getSize(self, ...)
    local args = {...}
    local text = table.concat(
        __TS__ArrayFilter(
            args,
            function(____, s) return type(s) == "string" end
        ),
        ""
    )
    local w = 0
    local h = 0
    for ____, line in ipairs(__TS__StringSplit(text, "\n")) do
        local glyphs = self:getGlyphs(string.upper(line))
        local lineWidth = 0
        for ____, g in ipairs(glyphs) do
            lineWidth = lineWidth + (g.width + self.options.spacing.x)
        end
        w = math.max(w, lineWidth)
        h = h + (self.data.height + self.options.spacing.y)
    end
    return {w, h}
end
function Font.prototype.render(self, ...)
    local args = {...}
    local text = table.concat(
        __TS__ArrayFilter(
            args,
            function(____, s) return type(s) == "string" end
        ),
        ""
    )
    local w, h = table.unpack(
        self:getSize(text),
        1,
        2
    )
    local pixels = pixelBuffer(w, h, 0)
    local glyphHeight = self.data.height
    local color = 1
    local offsetX = self.options.spacing.x / 2
    local offsetY = self.options.spacing.y / 2
    do
        local i = 0
        while i < #args do
            local part = args[i + 1]
            if type(part) == "number" then
                color = part
            else
                local glyphs = self:getGlyphs(string.upper(part))
                do
                    local pos = 0
                    while pos < #part do
                        local char = __TS__StringAccess(part, pos)
                        if char == "\n" then
                            offsetX = 0
                            offsetY = offsetY + (self.data.height + self.options.spacing.y)
                        else
                            local glyph = glyphs[pos + 1]
                            for ____, ____value in ipairs(glyph.coords) do
                                local x = ____value[1]
                                local y = ____value[2]
                                pixels[round(y + offsetY) + 1][round(x + offsetX) + 1] = color
                            end
                            offsetX = offsetX + (glyph.width + self.options.spacing.x)
                        end
                        pos = pos + 1
                    end
                end
            end
            i = i + 1
        end
    end
    return {pixels = pixels, w = w, h = h, text = text}
end
return ____exports
