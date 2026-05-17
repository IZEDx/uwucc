-- lib/uwui-gpu/gpu-view.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/uwui-gpu/gpu-view.ts"] = _G.__tracetrace["lib/uwui-gpu/gpu-view.ts"] or {}
package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 2,["9"] = 2,["10"] = 131,["11"] = 132,["12"] = 131,["13"] = 135,["14"] = 136,["15"] = 137,["16"] = 138,["17"] = 139,["18"] = 140,["19"] = 140,["20"] = 140,["21"] = 140,["22"] = 140,["23"] = 140,["24"] = 135,["25"] = 143,["26"] = 143,["27"] = 143,["28"] = 145,["29"] = 145,["30"] = 146,["31"] = 147,["32"] = 144,["33"] = 151,["34"] = 152,["35"] = 153,["36"] = 153,["37"] = 153,["38"] = 153,["39"] = 153,["40"] = 153,["41"] = 151,["42"] = 156,["43"] = 157,["44"] = 156,["45"] = 160,["46"] = 161,["47"] = 160,["48"] = 164,["49"] = 164,["50"] = 164,["51"] = 164,["52"] = 164,["53"] = 165,["54"] = 164,["55"] = 168,["56"] = 168,["57"] = 168,["59"] = 168,["60"] = 168,["62"] = 168,["63"] = 168,["65"] = 169,["66"] = 168,["67"] = 172,["68"] = 172,["69"] = 172,["70"] = 172,["71"] = 172,["72"] = 173,["73"] = 172,["74"] = 179,["75"] = 180,["76"] = 180,["77"] = 180,["78"] = 180,["79"] = 180,["80"] = 179,["81"] = 183,["82"] = 184,["83"] = 185,["84"] = 186,["85"] = 186,["86"] = 186,["87"] = 186,["88"] = 186,["89"] = 187,["90"] = 187,["91"] = 187,["92"] = 187,["93"] = 187,["94"] = 187,["95"] = 187,["96"] = 187,["97"] = 187,["98"] = 187,["100"] = 183,["101"] = 191,["102"] = 191,["103"] = 191,["104"] = 191,["105"] = 191,["106"] = 191,["107"] = 191,["108"] = 192,["109"] = 193,["110"] = 194,["111"] = 194,["112"] = 194,["113"] = 194,["114"] = 194,["115"] = 195,["116"] = 195,["117"] = 195,["118"] = 195,["119"] = 195,["120"] = 195,["121"] = 195,["122"] = 195,["123"] = 195,["124"] = 195,["125"] = 195,["126"] = 195,["128"] = 191,["129"] = 198,["130"] = 199,["131"] = 200,["132"] = 201,["135"] = 202,["136"] = 202,["137"] = 202,["138"] = 202,["139"] = 202,["140"] = 202,["141"] = 202,["142"] = 202,["143"] = 202,["144"] = 202,["145"] = 203,["146"] = 203,["147"] = 203,["148"] = 203,["149"] = 203,["150"] = 203,["151"] = 203,["152"] = 203,["153"] = 203,["154"] = 203,["155"] = 204,["156"] = 204,["157"] = 204,["158"] = 204,["159"] = 204,["160"] = 204,["161"] = 204,["162"] = 204,["163"] = 204,["164"] = 204,["165"] = 205,["166"] = 205,["167"] = 205,["168"] = 205,["169"] = 205,["170"] = 205,["171"] = 205,["172"] = 205,["173"] = 205,["174"] = 205,["175"] = 198,["176"] = 207,["177"] = 208,["178"] = 209,["179"] = 210,["180"] = 211,["181"] = 212,["182"] = 212,["183"] = 212,["184"] = 212,["185"] = 212,["186"] = 212,["187"] = 212,["188"] = 212,["189"] = 212,["190"] = 212,["191"] = 207,["192"] = 214,["193"] = 223,["194"] = 223,["195"] = 223,["196"] = 223,["197"] = 223,["198"] = 223,["199"] = 223,["200"] = 223,["201"] = 223,["202"] = 223,["203"] = 214,["204"] = 225,["205"] = 235,["206"] = 235,["207"] = 235,["208"] = 235,["209"] = 235,["210"] = 235,["211"] = 235,["212"] = 235,["213"] = 235,["214"] = 235,["215"] = 235,["216"] = 225,["217"] = 237,["218"] = 238,["219"] = 238,["220"] = 238,["221"] = 238,["222"] = 238,["223"] = 238,["224"] = 238,["225"] = 238,["226"] = 238,["227"] = 238,["228"] = 237,["229"] = 240,["230"] = 241,["231"] = 241,["232"] = 241,["233"] = 241,["234"] = 241,["235"] = 241,["236"] = 241,["237"] = 240,["238"] = 243,["239"] = 244,["240"] = 244,["241"] = 244,["242"] = 244,["243"] = 244,["244"] = 244,["245"] = 244,["246"] = 243,["247"] = 246,["248"] = 257,["249"] = 257,["250"] = 257,["251"] = 257,["252"] = 257,["253"] = 257,["254"] = 257,["255"] = 257,["256"] = 257,["257"] = 257,["258"] = 257,["259"] = 257,["260"] = 246,["261"] = 271,["262"] = 280,["263"] = 280,["264"] = 280,["265"] = 280,["266"] = 280,["267"] = 280,["268"] = 280,["269"] = 280,["270"] = 280,["271"] = 280,["272"] = 271,["273"] = 291,["274"] = 294,["275"] = 294,["276"] = 294,["277"] = 294,["278"] = 294,["279"] = 294,["280"] = 301,["281"] = 301,["282"] = 301,["283"] = 302,["284"] = 302,["285"] = 302,["286"] = 302,["287"] = 302,["288"] = 302,["289"] = 302,["290"] = 302,["291"] = 302,["292"] = 302,["293"] = 302,["294"] = 302,["295"] = 302,["296"] = 302,["297"] = 291,["298"] = 318,["299"] = 328,["300"] = 328,["301"] = 328,["302"] = 328,["303"] = 328,["304"] = 328,["305"] = 328,["306"] = 328,["307"] = 328,["308"] = 328,["309"] = 328,["310"] = 318,["311"] = 341,["312"] = 352,["313"] = 352,["314"] = 352,["315"] = 352,["316"] = 352,["317"] = 352,["318"] = 352,["319"] = 352,["320"] = 352,["321"] = 352,["322"] = 352,["323"] = 352,["324"] = 341,["325"] = 365,["326"] = 374,["327"] = 374,["328"] = 374,["329"] = 374,["330"] = 374,["331"] = 374,["332"] = 374,["333"] = 374,["334"] = 374,["335"] = 374,["336"] = 365,["337"] = 385,["338"] = 386,["339"] = 386,["340"] = 386,["341"] = 386,["342"] = 386,["343"] = 386,["344"] = 386,["345"] = 386,["346"] = 385,["347"] = 388,["348"] = 389,["349"] = 389,["350"] = 389,["351"] = 389,["352"] = 389,["353"] = 388,["354"] = 391,["355"] = 392,["356"] = 392,["357"] = 392,["358"] = 392,["359"] = 392,["360"] = 392,["361"] = 392,["362"] = 392,["363"] = 391});
local ____exports = {}
local ____math = require("lib.math")
local clamp = ____math.clamp
local function intersects(a, b)
    return a.x < b.x + b.w and a.x + a.w > b.x and a.y < b.y + b.h and a.y + a.h > b.y
end
local function clampRect(parent, child)
    local x = math.max(parent.x, child.x)
    local y = math.max(parent.y, child.y)
    local maxX = math.min(parent.x + parent.w, child.x + child.w)
    local maxY = math.min(parent.y + parent.h, child.y + child.h)
    return {
        x = x,
        y = y,
        w = math.max(0, maxX - x),
        h = math.max(0, maxY - y)
    }
end
____exports.GPUView = __TS__Class()
local GPUView = ____exports.GPUView
GPUView.name = "GPUView"
function GPUView.prototype.____constructor(self, gpu, display, clip)
    self.gpu = gpu
    self.display = display
    self.clip = clip
end
function GPUView.prototype.createView(self, rect)
    rect = __TS__ObjectAssign({}, rect, {x = self.clip.x + rect.x, y = self.clip.y + rect.y})
    return __TS__New(
        ____exports.GPUView,
        self.gpu,
        self.display,
        clampRect(self.clip, rect)
    )
end
function GPUView.prototype.translateX(self, x)
    return x + self.clip.x
end
function GPUView.prototype.translateY(self, y)
    return y + self.clip.y
end
function GPUView.prototype.translatePoint(self, ____bindingPattern0)
    local y
    local x
    x = ____bindingPattern0[1]
    y = ____bindingPattern0[2]
    return {x + self.clip.x, y + self.clip.y}
end
function GPUView.prototype.clear(self, r, g, b)
    if r == nil then
        r = 0
    end
    if g == nil then
        g = 0
    end
    if b == nil then
        b = 0
    end
    self.gpu.clear(self.display, r, g, b)
end
function GPUView.prototype.translatePos(self, ____bindingPattern0)
    local y
    local x
    x = ____bindingPattern0.x
    y = ____bindingPattern0.y
    return {x = x + self.clip.x, y = y + self.clip.y}
end
function GPUView.prototype.translateRect(self, rect)
    return __TS__ObjectAssign(
        {},
        rect,
        self:translatePos(rect)
    )
end
function GPUView.prototype.fillRect(self, rect, r, g, b)
    rect = self:translateRect(rect)
    if intersects(self.clip, rect) then
        local ____clampRect_result_0 = clampRect(self.clip, rect)
        local x = ____clampRect_result_0.x
        local y = ____clampRect_result_0.y
        local w = ____clampRect_result_0.w
        local h = ____clampRect_result_0.h
        self.gpu.fillRect(
            self.display,
            x,
            y,
            w,
            h,
            r,
            g,
            b
        )
    end
end
function GPUView.prototype.drawRoundedRect(self, rect, radius, ____bindingPattern0, filled)
    local b
    local g
    local r
    r = ____bindingPattern0.r
    g = ____bindingPattern0.g
    b = ____bindingPattern0.b
    rect = self:translateRect(rect)
    if intersects(self.clip, rect) then
        local ____clampRect_result_1 = clampRect(self.clip, rect)
        local x = ____clampRect_result_1.x
        local y = ____clampRect_result_1.y
        local w = ____clampRect_result_1.w
        local h = ____clampRect_result_1.h
        self.gpu.drawRoundedRect(
            self.display,
            x,
            y,
            w,
            h,
            radius,
            r,
            g,
            b,
            filled
        )
    end
end
function GPUView.prototype.drawRect(self, x, y, w, h, r, g, b)
    local xx = self:translateX(x)
    local yy = self:translateY(y)
    if not intersects(self.clip, {x = xx, y = yy, w = w, h = h}) then
        return
    end
    self.gpu.fillRect(
        self.display,
        xx,
        yy,
        w,
        1,
        r,
        g,
        b
    )
    self.gpu.fillRect(
        self.display,
        xx,
        yy + h - 1,
        w,
        1,
        r,
        g,
        b
    )
    self.gpu.fillRect(
        self.display,
        xx,
        yy,
        1,
        h,
        r,
        g,
        b
    )
    self.gpu.fillRect(
        self.display,
        xx + w - 1,
        yy,
        1,
        h,
        r,
        g,
        b
    )
end
function GPUView.prototype.drawLine(self, x1, y1, x2, y2, r, g, b)
    x1 = self:translateX(clamp(x1, 1, self.clip.w - 1))
    y1 = self:translateY(clamp(y1, 1, self.clip.h - 1))
    x2 = self:translateX(clamp(x2, 1, self.clip.w - 1))
    y2 = self:translateY(clamp(y2, 1, self.clip.h - 1))
    self.gpu.drawLine(
        self.display,
        x1,
        y1,
        x2,
        y2,
        r,
        g,
        b
    )
end
function GPUView.prototype.drawCircle(self, cx, cy, radius, r, g, b, filled)
    self.gpu.drawCircle(
        self.display,
        cx,
        cy,
        radius,
        r,
        g,
        b,
        filled
    )
end
function GPUView.prototype.drawEllipse(self, cx, cy, rx, ry, r, g, b, filled)
    self.gpu.drawEllipse(
        self.display,
        cx,
        cy,
        rx,
        ry,
        r,
        g,
        b,
        filled
    )
end
function GPUView.prototype.fillEllipse(self, cx, cy, rx, ry, r, g, b)
    self.gpu.fillEllipse(
        self.display,
        cx,
        cy,
        rx,
        ry,
        r,
        g,
        b
    )
end
function GPUView.prototype.drawPolygon(self, points, r, g, b)
    self.gpu.drawPolygon(
        self.display,
        points,
        r,
        g,
        b
    )
end
function GPUView.prototype.drawPolylines(self, points, r, g, b)
    self.gpu.drawPolylines(
        self.display,
        points,
        r,
        g,
        b
    )
end
function GPUView.prototype.drawText(self, text, x, y, r, g, b, fontName, fontSize, style)
    return self.gpu.drawText(
        self.display,
        text,
        self:translateX(x),
        self:translateY(y),
        r,
        g,
        b,
        fontName,
        fontSize,
        style
    )
end
function GPUView.prototype.drawTextFast(self, text, x, y, r, g, b, fontSize)
    return self.gpu.drawTextFast(
        self.display,
        text,
        self:translateX(x),
        self:translateY(y),
        r,
        g,
        b,
        fontSize
    )
end
function GPUView.prototype.drawTextWrapped(self, text, pos, ____bindingPattern0, maxWidth, lineSpacing, fontName, fontSize, style)
    local b
    local g
    local r
    r = ____bindingPattern0.r
    g = ____bindingPattern0.g
    b = ____bindingPattern0.b
    local ____temp_2 = self:translatePos(pos)
    local x = ____temp_2.x
    local y = ____temp_2.y
    return self.gpu.drawTextWrapped(
        self.display,
        text,
        x,
        y,
        maxWidth,
        r,
        g,
        b,
        lineSpacing,
        fontName,
        fontSize,
        style
    )
end
function GPUView.prototype.drawTextWrappedFast(self, text, x, y, maxWidth, r, g, b, fontSize)
    return self.gpu.drawTextWrappedFast(
        self.display,
        text,
        self:translateX(x),
        self:translateY(y),
        maxWidth,
        r,
        g,
        b,
        fontSize
    )
end
function GPUView.prototype.drawStar(self, cx, cy, pointCount, outerRadius, innerRadius, r, g, b, filled)
    self.gpu.drawStar(
        self.display,
        self:translateX(cx),
        self:translateY(cy),
        pointCount,
        outerRadius,
        innerRadius,
        r,
        g,
        b,
        filled
    )
end
function GPUView.prototype.drawSVGPath(self, pathData, x, y, scale, r, g, b)
    self.gpu.drawSVGPath(
        self.display,
        pathData,
        self:translateX(x),
        self:translateY(y),
        scale,
        r,
        g,
        b
    )
end
function GPUView.prototype.setPixel(self, x, y, r, g, b)
    self.gpu.setPixel(
        self.display,
        self:translateX(x),
        self:translateY(y),
        r,
        g,
        b
    )
end
function GPUView.prototype.getPixel(self, x, y)
    return self.gpu.getPixel(
        self.display,
        self:translateX(x),
        self:translateY(y)
    )
end
function GPUView.prototype.drawBezierCurve(self, points, r, g, b, segments)
    self.gpu.drawBezierCurve(
        self.display,
        points,
        r,
        g,
        b,
        segments
    )
end
return ____exports
