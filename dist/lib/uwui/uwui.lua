package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["16"] = 1,["17"] = 1,["18"] = 2,["19"] = 2,["20"] = 3,["21"] = 3,["22"] = 4,["23"] = 4,["24"] = 4,["25"] = 5,["26"] = 5,["27"] = 6,["28"] = 6,["29"] = 7,["30"] = 7,["31"] = 9,["32"] = 56,["33"] = 56,["34"] = 56,["35"] = 63,["36"] = 59,["37"] = 60,["38"] = 61,["39"] = 95,["40"] = 64,["41"] = 65,["42"] = 66,["43"] = 67,["44"] = 68,["45"] = 69,["46"] = 70,["47"] = 64,["48"] = 75,["49"] = 76,["50"] = 78,["51"] = 81,["52"] = 82,["53"] = 85,["54"] = 86,["55"] = 89,["56"] = 89,["58"] = 90,["59"] = 90,["61"] = 92,["62"] = 63,["63"] = 96,["64"] = 96,["65"] = 96,["67"] = 97,["68"] = 97,["69"] = 97,["70"] = 97,["71"] = 97,["72"] = 98,["73"] = 99,["74"] = 100,["75"] = 101,["76"] = 102,["77"] = 103,["78"] = 103,["79"] = 103,["80"] = 103,["81"] = 103,["82"] = 103,["83"] = 103,["85"] = 105,["86"] = 96,["87"] = 108,["88"] = 109,["89"] = 108,["90"] = 112,["91"] = 113,["92"] = 112,["93"] = 116,["94"] = 117,["95"] = 118,["96"] = 119,["97"] = 120,["98"] = 121,["99"] = 122,["100"] = 123,["101"] = 124,["102"] = 116,["103"] = 127,["104"] = 128,["106"] = 128,["110"] = 129,["111"] = 131,["112"] = 132,["113"] = 133,["114"] = 134,["116"] = 136,["117"] = 137,["118"] = 138,["119"] = 139,["120"] = 140,["121"] = 140,["122"] = 140,["123"] = 139,["124"] = 139,["125"] = 139,["127"] = 132,["128"] = 146,["129"] = 147,["130"] = 148,["131"] = 149,["133"] = 146,["134"] = 152,["135"] = 153,["136"] = 154,["137"] = 155,["138"] = 156,["141"] = 157,["142"] = 158,["143"] = 158,["144"] = 158,["145"] = 158,["146"] = 158,["148"] = 154,["150"] = 146,["151"] = 146,["152"] = 127,["156"] = 167,["157"] = 173,["158"] = 174,["159"] = 175,["160"] = 176,["161"] = 177,["162"] = 178,["163"] = 178,["164"] = 178,["165"] = 178,["167"] = 180,["168"] = 181,["169"] = 181,["170"] = 181,["171"] = 181,["172"] = 181,["173"] = 182,["174"] = 183,["175"] = 184,["176"] = 182,["178"] = 169,["179"] = 167,["180"] = 167,["181"] = 189,["182"] = 195,["183"] = 195,["184"] = 190,["185"] = 196,["186"] = 197,["187"] = 195,["188"] = 200,["189"] = 201,["190"] = 200,["191"] = 204,["192"] = 205,["193"] = 206,["196"] = 209,["197"] = 210,["198"] = 211,["199"] = 212,["201"] = 214,["202"] = 214,["203"] = 214,["204"] = 214,["205"] = 214,["206"] = 204,["207"] = 217,["208"] = 218,["209"] = 218,["210"] = 218,["211"] = 218,["212"] = 218,["213"] = 219,["214"] = 220,["215"] = 221,["216"] = 222,["217"] = 223,["219"] = 221,["220"] = 226,["221"] = 227,["222"] = 228,["224"] = 230,["226"] = 232,["227"] = 217,["228"] = 235,["229"] = 236,["230"] = 237,["231"] = 237,["232"] = 237,["233"] = 237,["234"] = 237,["235"] = 236,["236"] = 235});
local ____exports = {}
local ____math = require("lib.math")
local clamp = ____math.clamp
local ____pixi = require("lib.uwui.pixi")
local Pixels = ____pixi.Pixels
local ____helpers = require("lib.uwui.helpers")
local normalizeChildren = ____helpers.normalizeChildren
local ____events = require("lib.events")
local MouseEvent = ____events.MouseEvent
local pullEventAs = ____events.pullEventAs
local ____chalk = require("lib.chalk")
local showHeader = ____chalk.showHeader
local ____font = require("lib.uwui.font")
local Font = ____font.Font
local ____program = require("lib.program")
local runSafe = ____program.runSafe
local fpsFont = __TS__New(Font, {file = "disk/static/sigi-pixel-font-master/Sigi-5px-Condensed-Regular.json"})
____exports.UwUi = __TS__Class()
local UwUi = ____exports.UwUi
UwUi.name = "UwUi"
function UwUi.prototype.____constructor(self, options)
    self.colorDepth = 20
    self.stopped = true
    self.paused = false
    self._lastFps = 0
    self.options = __TS__ObjectAssign({
        term = term,
        x = 0,
        y = 0,
        w = 0,
        h = 0,
        bg = 15
    }, options)
    self.options.term.setGraphicsMode(2)
    self.options.term.clear()
    local W, H = self.options.term.getSize(2)
    self.options.x = clamp(self.options.x, 0, W)
    self.options.y = clamp(self.options.y, 0, H)
    self.options.w = clamp(self.options.w, 0, W - self.options.x)
    self.options.h = clamp(self.options.h, 0, H - self.options.y)
    if self.options.w == 0 then
        self.options.w = W - self.options.x
    end
    if self.options.h == 0 then
        self.options.h = H - self.options.y
    end
    self.target = Pixels.new(self.options.w, self.options.h, self.options.bg)
end
function UwUi.prototype.render(self, root, dt)
    if dt == nil then
        dt = 0
    end
    local ____self_options_0 = self.options
    local x = ____self_options_0.x
    local y = ____self_options_0.y
    local term = ____self_options_0.term
    local showFps = ____self_options_0.showFps
    local node = root(self.target)
    node:render(dt)
    if showFps and dt > 0 then
        local fps = self._lastFps + (1 / dt - self._lastFps) * 0.9
        self._lastFps = fps
        self.target:drawText(
            x + 5,
            y + 5,
            fpsFont,
            10,
            string.format("FPS: %.1f", fps)
        )
    end
    term.drawPixels(x, y, self.target.buffer)
end
function UwUi.prototype.click(self, root, x, y)
    root(self.target):click(x, y)
end
function UwUi.prototype.stop(self)
    self.stopped = true
end
function UwUi.prototype.defer(self, fn)
    self.paused = true
    self.options.term.setGraphicsMode(false)
    term.clear()
    term.setCursorPos(1, 1)
    showHeader(":3")
    fn()
    self.options.term.setGraphicsMode(2)
    self.paused = false
end
function UwUi.prototype.run(self, root)
    if not self.stopped then
        error(
            __TS__New(Error, "already running :3"),
            0
        )
    end
    self.stopped = false
    local last = os.clock()
    local function render()
        if self.paused then
            sleep(0.1)
        else
            local now = os.clock()
            local dt = math.min(now - last, 1)
            last = now
            parallel.waitForAll(
                function() return self:render(
                    root(),
                    dt
                ) end,
                function() return sleep(0) end
            )
        end
    end
    parallel.waitForAny(
        function()
            while not self.stopped do
                runSafe(render)
            end
        end,
        function()
            while not self.stopped do
                runSafe(function()
                    local event = pullEventAs(MouseEvent, "mouse_click")
                    if self.stopped then
                        return
                    end
                    if (event and event.button) == 1 and not self.paused then
                        self:click(
                            root(),
                            event.x,
                            event.y
                        )
                    end
                end)
            end
        end
    )
end
do
    ---
    -- @noSelf
    function UwUi.node(component, props, ...)
        local children = {...}
        props = __TS__ObjectAssign({}, props)
        children = normalizeChildren(children)
        if type(component) == "function" then
            local funComp = component
            return funComp(
                props,
                table.unpack(children)
            )
        else
            local ClassComp = component
            local comp = __TS__New(
                ClassComp,
                props,
                table.unpack(children)
            )
            return function(target)
                comp.target = comp:translate(target)
                return comp
            end
        end
    end
    UwUi.ClassComponent = __TS__Class()
    local ClassComponent = UwUi.ClassComponent
    ClassComponent.name = "ClassComponent"
    function ClassComponent.prototype.____constructor(self, props, ...)
        local children = {...}
        self.type = "Component"
        self.props = props
        self.children = children
    end
    function ClassComponent.prototype.translate(self, target)
        return target
    end
    function ClassComponent.prototype.render(self, dt)
        if not self.props.stale then
            self:forEachChild(function(child) return child(self.target):render(dt) end)
            return
        end
        if not self.target.cache:has(self.props.stale) then
            local buf = Pixels.new(self.target.w, self.target.h, self.target.base)
            self:forEachChild(function(child) return child(buf):render(dt) end)
            self.target.cache:set(self.props.stale, buf.buffer)
        end
        self.target:drawPixels(
            0,
            0,
            self.target.cache:get(self.props.stale)
        )
    end
    function ClassComponent.prototype.click(self, x, y)
        local minX, minY, maxX, maxY = table.unpack(
            self.target:getBounds(),
            1,
            4
        )
        if x > minX and x < maxX and y > minY and y < maxY then
            local wasHandled = false
            self:forEachChild(function(c)
                if c(self.target):click(x, y) then
                    wasHandled = true
                end
            end)
            if not wasHandled and self.props.onClick then
                self.props:onClick()
                return true
            end
            return wasHandled
        end
        return false
    end
    function ClassComponent.prototype.forEachChild(self, fn)
        parallel.waitForAll(table.unpack(__TS__ArrayMap(
            __TS__ArrayFilter(
                self.children,
                function(____, c) return type(c) == "function" end
            ),
            function(____, c) return function() return fn(c) end end
        )))
    end
end
return ____exports
