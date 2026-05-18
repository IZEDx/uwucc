package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["11"] = 1,["12"] = 1,["13"] = 2,["14"] = 2,["15"] = 3,["16"] = 3,["17"] = 4,["18"] = 4,["19"] = 4,["20"] = 39,["21"] = 39,["22"] = 39,["23"] = 45,["24"] = 45,["25"] = 45,["27"] = 46,["28"] = 46,["30"] = 47,["31"] = 47,["33"] = 48,["34"] = 48,["36"] = 49,["37"] = 49,["39"] = 50,["40"] = 50,["42"] = 46,["43"] = 47,["44"] = 48,["45"] = 49,["46"] = 50,["47"] = 42,["48"] = 52,["49"] = 53,["50"] = 54,["51"] = 55,["52"] = 56,["53"] = 57,["54"] = 58,["55"] = 59,["56"] = 59,["58"] = 60,["59"] = 60,["61"] = 61,["62"] = 44,["63"] = 80,["64"] = 80,["65"] = 80,["67"] = 82,["68"] = 83,["69"] = 84,["70"] = 85,["73"] = 88,["75"] = 91,["76"] = 80,["77"] = 94,["78"] = 95,["79"] = 96,["80"] = 97,["81"] = 98,["82"] = 99,["83"] = 100,["84"] = 101,["85"] = 102,["86"] = 102,["87"] = 102,["88"] = 101,["89"] = 101,["90"] = 101,["92"] = 95,["93"] = 107,["94"] = 108,["95"] = 109,["96"] = 110,["97"] = 111,["98"] = 112,["99"] = 113,["100"] = 114,["103"] = 117,["107"] = 95,["108"] = 95,["109"] = 94,["113"] = 126,["114"] = 132,["115"] = 133,["116"] = 134,["117"] = 135,["118"] = 136,["119"] = 137,["120"] = 137,["121"] = 137,["122"] = 137,["124"] = 139,["125"] = 140,["126"] = 140,["127"] = 140,["128"] = 140,["129"] = 140,["130"] = 141,["131"] = 142,["132"] = 143,["133"] = 141,["135"] = 128,["136"] = 126,["137"] = 126,["138"] = 148,["139"] = 154,["140"] = 154,["141"] = 149,["142"] = 155,["143"] = 156,["144"] = 154,["145"] = 159,["146"] = 160,["147"] = 159,["148"] = 163,["149"] = 164,["150"] = 165,["151"] = 166,["152"] = 167,["153"] = 168,["155"] = 164,["156"] = 163,["157"] = 173,["158"] = 174,["159"] = 174,["160"] = 174,["161"] = 174,["162"] = 174,["163"] = 175,["164"] = 176,["165"] = 177,["166"] = 178,["167"] = 179,["168"] = 180,["169"] = 181,["170"] = 182,["173"] = 177,["174"] = 186,["175"] = 187,["176"] = 188,["178"] = 190,["180"] = 192,["181"] = 173,["182"] = 195,["183"] = 196,["184"] = 197,["185"] = 197,["186"] = 197,["187"] = 197,["188"] = 197,["189"] = 196,["190"] = 195});
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
____exports.UwUi = __TS__Class()
local UwUi = ____exports.UwUi
UwUi.name = "UwUi"
function UwUi.prototype.____constructor(self, _term, x, y, w, h, bg)
    if _term == nil then
        _term = term
    end
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
        bg = 16
    end
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.bg = bg
    self.colorDepth = 20
    self.term = _term
    self.term.setGraphicsMode(2)
    local W, H = self.term.getSize(2)
    self.x = clamp(x, 0, W)
    self.y = clamp(y, 0, H)
    self.w = clamp(w, 0, W - self.x)
    self.h = clamp(h, 0, H - self.y)
    if self.w == 0 then
        self.w = W - self.x
    end
    if self.h == 0 then
        self.h = H - self.y
    end
    self.target = Pixels.new(self.w, self.h, bg)
end
function UwUi.prototype.render(self, root, dt)
    if dt == nil then
        dt = 0
    end
    local nodes = root(self.target)
    if __TS__ArrayIsArray(nodes) then
        for ____, node in ipairs(nodes) do
            node:render(dt)
        end
    else
        nodes:render(dt)
    end
    self.term.drawPixels(self.x, self.y, self.target.buffer)
end
function UwUi.prototype.run(self, root)
    parallel.waitForAny(
        function()
            local last = os.clock()
            while true do
                local now = os.clock()
                local dt = now - last
                parallel.waitForAll(
                    function() return self:render(
                        root(),
                        dt
                    ) end,
                    function() return sleep(0) end
                )
            end
        end,
        function()
            while true do
                local event = pullEventAs(MouseEvent, "mouse_click")
                if (event and event.button) == 1 then
                    local nodes = root()(self.target)
                    if __TS__ArrayIsArray(nodes) then
                        for ____, node in ipairs(nodes) do
                            node:click(event.x, event.y)
                        end
                    else
                        nodes:click(event.x, event.y)
                    end
                end
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
        self:forEachChild(function(c)
            local _nodes = c(self.target)
            local nodes = __TS__ArrayIsArray(_nodes) and _nodes or ({_nodes})
            for ____, node in ipairs(nodes) do
                node:render(dt)
            end
        end)
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
                local _nodes = c(self.target)
                local nodes = __TS__ArrayIsArray(_nodes) and _nodes or ({_nodes})
                for ____, node in ipairs(nodes) do
                    if node:click(x, y) then
                        wasHandled = true
                    end
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
