package.path = package.path .. ";../../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__ArrayPushArray = ____lualib.__TS__ArrayPushArray
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local __TS__Class = ____lualib.__TS__Class
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["20"] = 1,["21"] = 1,["22"] = 3,["23"] = 3,["24"] = 6,["25"] = 7,["26"] = 8,["27"] = 9,["28"] = 10,["29"] = 10,["30"] = 10,["31"] = 10,["33"] = 12,["34"] = 13,["36"] = 15,["37"] = 6,["38"] = 18,["39"] = 18,["40"] = 18,["41"] = 38,["42"] = 38,["43"] = 39,["44"] = 41,["45"] = 23,["46"] = 25,["47"] = 26,["48"] = 27,["49"] = 30,["50"] = 32,["51"] = 34,["52"] = 35,["53"] = 63,["54"] = 64,["57"] = 65,["58"] = 66,["60"] = 68,["62"] = 63,["63"] = 43,["64"] = 44,["65"] = 45,["66"] = 45,["68"] = 37,["69"] = 59,["70"] = 60,["71"] = 60,["72"] = 59,["73"] = 72,["74"] = 73,["75"] = 73,["77"] = 74,["78"] = 74,["79"] = 74,["80"] = 75,["81"] = 75,["82"] = 75,["83"] = 75,["84"] = 75,["85"] = 75,["86"] = 76,["87"] = 77,["88"] = 78,["89"] = 79,["90"] = 80,["91"] = 81,["92"] = 82,["95"] = 85,["96"] = 86,["97"] = 87,["99"] = 89,["101"] = 91,["102"] = 72,["103"] = 94,["104"] = 95,["105"] = 96,["106"] = 97,["107"] = 98,["110"] = 99,["111"] = 100,["112"] = 100,["113"] = 97,["116"] = 116,["119"] = 103,["120"] = 104,["121"] = 105,["122"] = 106,["123"] = 106,["124"] = 106,["125"] = 106,["126"] = 107,["128"] = 109,["130"] = 109,["134"] = 110,["135"] = 111,["136"] = 111,["138"] = 112,["140"] = 114,["146"] = 118,["147"] = 119,["150"] = 94,["151"] = 123,["152"] = 124,["153"] = 125,["154"] = 126,["155"] = 127,["156"] = 128,["157"] = 129,["158"] = 129,["160"] = 130,["163"] = 133,["164"] = 134,["165"] = 135,["166"] = 136,["167"] = 137,["168"] = 139,["169"] = 140,["170"] = 141,["171"] = 141,["174"] = 143,["175"] = 143,["176"] = 143,["178"] = 146,["179"] = 147,["180"] = 148,["181"] = 149,["182"] = 150,["183"] = 151,["184"] = 152,["186"] = 154,["187"] = 155,["190"] = 158,["191"] = 158,["194"] = 159,["195"] = 159,["196"] = 159,["197"] = 159,["200"] = 160,["201"] = 160,["203"] = 161,["204"] = 123,["205"] = 164,["206"] = 166,["207"] = 166,["209"] = 167,["210"] = 168,["211"] = 169,["212"] = 169,["214"] = 170,["215"] = 164,["221"] = 49,["223"] = 52,["224"] = 53,["225"] = 54,["227"] = 56});
local ____exports = {}
local ____signal = require("lib.uwui-gpu.signal")
local Signal = ____signal.Signal
local ____chalk = require("lib.chalk")
local printError = ____chalk.printError
local function flatten(children)
    local out = {}
    if __TS__ArrayIsArray(children) then
        for ____, child in ipairs(children) do
            __TS__ArrayPushArray(
                out,
                flatten(child)
            )
        end
    elseif children and __TS__InstanceOf(children, ____exports.Node) then
        out[#out + 1] = children
    end
    return out
end
____exports.Node = __TS__Class()
local Node = ____exports.Node
Node.name = "Node"
function Node.prototype.____constructor(self, component, props, children, key)
    self.component = component
    self.props = props
    self.key = key
    self.children = {}
    self.deps = __TS__New(Set)
    self.hooks = {}
    self.hookIndex = 0
    self.dirty = true
    self.opaque = false
    self._forceRender = false
    self.disposers = {}
    self.invalidate = function()
        if self.dirty then
            return
        end
        if self.parent and not self.opaque then
            self.parent:invalidate()
        else
            self.dirty = true
        end
    end
    self.inputChildren = children
    self.children = flatten(children)
    for ____, child in ipairs(self.children) do
        child.parent = self
    end
end
function Node.prototype.keyOf(self)
    local ____opt_0 = self.props
    return ____opt_0 and ____opt_0.key or self.key
end
function Node.prototype.input(self, event)
    if not self.gpu then
        return false
    end
    local ____event_2 = event
    local x = ____event_2.x
    local y = ____event_2.y
    local ____opt_3 = self.gpu
    local ____temp_5 = ____opt_3 and ____opt_3.clip
    local minX = ____temp_5.x
    local minY = ____temp_5.y
    local w = ____temp_5.w
    local h = ____temp_5.h
    local maxX = minX + w
    local maxY = minY + h
    if x > minX and x < maxX and y > minY and y < maxY then
        local wasHandled = false
        for ____, child in ipairs(self.children) do
            if child:input(event) then
                wasHandled = true
            end
        end
        if not wasHandled and self.props.onInput then
            self.props:onInput(event)
            return true
        end
        return wasHandled
    end
    return false
end
function Node.prototype.render(self, gpu)
    local prevNode = ____exports.Node.current
    ____exports.Node.current = self
    Signal:hook(function(signal)
        if self.deps:has(signal) then
            return
        end
        self.deps:add(signal)
        local ____self_disposers_6 = self.disposers
        ____self_disposers_6[#____self_disposers_6 + 1] = signal:subscribe(function() return self:invalidate() end)
    end)
    do
        local function ____catch(e)
            printError(e)
        end
        local ____try, ____hasReturned = pcall(function()
            if self.dirty or self.forceRender then
                self.gpu = gpu
                self.hookIndex = 0
                local output = self.component(
                    self.props,
                    table.unpack(self.inputChildren)
                )
                self:reconcile(output)
            end
            if not self.gpu then
                error(
                    __TS__New(Error, "Uh oh gpu is gone"),
                    0
                )
            end
            for ____, child in ipairs(self.children) do
                if self.dirty or self.forceRender then
                    child.dirty = true
                end
                child:render(self.gpu)
            end
            self.dirty = false
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
        do
            ____exports.Node.current = prevNode
            Signal:unhook()
        end
    end
end
function Node.prototype.reconcile(self, output)
    local nextChildren = flatten(output)
    local prevByKey = __TS__New(Map)
    local prevUnkeyed = {}
    for ____, child in ipairs(self.children) do
        local key = child:keyOf()
        if key == nil then
            prevUnkeyed[#prevUnkeyed + 1] = child
        else
            prevByKey:set(key, child)
        end
    end
    local unkeyedIndex = 0
    local merged = {}
    for ____, next in ipairs(nextChildren) do
        local nextKey = next:keyOf()
        local prev
        if nextKey ~= nil then
            prev = prevByKey:get(nextKey)
            if prev then
                prevByKey:delete(nextKey)
            end
        else
            local ____unkeyedIndex_7 = unkeyedIndex
            unkeyedIndex = ____unkeyedIndex_7 + 1
            prev = prevUnkeyed[____unkeyedIndex_7 + 1]
        end
        if prev and prev.component == next.component then
            prev.props = next.props
            prev.key = next.key
            prev.inputChildren = next.inputChildren
            prev.dirty = true
            prev:reconcile(next.children)
            merged[#merged + 1] = prev
        else
            next.parent = self
            merged[#merged + 1] = next
        end
    end
    for ____, orphan in __TS__Iterator(prevByKey:values()) do
        orphan:dispose()
    end
    do
        local i = unkeyedIndex
        while i < #prevUnkeyed do
            prevUnkeyed[i + 1]:dispose()
            i = i + 1
        end
    end
    for ____, child in ipairs(merged) do
        child.parent = self
    end
    self.children = merged
end
function Node.prototype.dispose(self)
    for ____, dispose in ipairs(self.disposers) do
        dispose()
    end
    self.disposers = {}
    self.deps:clear()
    for ____, child in ipairs(self.children) do
        child:dispose()
    end
    self.children = {}
end
__TS__SetDescriptor(
    Node.prototype,
    "forceRender",
    {
        get = function(self)
            return self._forceRender
        end,
        set = function(self, v)
            if v and self.parent and not self.opaque then
                self.parent.forceRender = true
            end
            self._forceRender = v
        end
    },
    true
)
return ____exports
