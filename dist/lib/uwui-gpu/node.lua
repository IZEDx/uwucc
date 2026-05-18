-- lib/uwui-gpu/node.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/uwui-gpu/node.ts"] = _G.__tracetrace["lib/uwui-gpu/node.ts"] or {}
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
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["19"] = 1,["20"] = 1,["21"] = 3,["22"] = 3,["23"] = 6,["24"] = 7,["25"] = 8,["26"] = 9,["27"] = 10,["28"] = 10,["29"] = 10,["30"] = 10,["32"] = 12,["33"] = 13,["35"] = 15,["36"] = 6,["37"] = 18,["38"] = 18,["39"] = 18,["40"] = 38,["41"] = 38,["42"] = 39,["43"] = 41,["44"] = 23,["45"] = 25,["46"] = 26,["47"] = 27,["48"] = 30,["49"] = 32,["50"] = 33,["51"] = 35,["52"] = 52,["53"] = 53,["56"] = 54,["57"] = 55,["59"] = 57,["61"] = 52,["62"] = 43,["63"] = 44,["64"] = 45,["65"] = 45,["67"] = 37,["68"] = 48,["69"] = 49,["70"] = 49,["71"] = 48,["72"] = 61,["73"] = 62,["74"] = 62,["76"] = 63,["77"] = 63,["78"] = 63,["79"] = 64,["80"] = 64,["81"] = 64,["82"] = 64,["83"] = 64,["84"] = 64,["85"] = 65,["86"] = 66,["87"] = 67,["88"] = 68,["89"] = 69,["90"] = 70,["91"] = 71,["94"] = 74,["95"] = 75,["96"] = 76,["98"] = 78,["100"] = 80,["101"] = 61,["102"] = 83,["103"] = 84,["104"] = 85,["105"] = 86,["106"] = 87,["109"] = 88,["110"] = 89,["111"] = 89,["112"] = 86,["115"] = 105,["118"] = 92,["119"] = 93,["120"] = 94,["121"] = 95,["122"] = 95,["123"] = 95,["124"] = 95,["125"] = 96,["127"] = 98,["129"] = 98,["133"] = 99,["134"] = 100,["135"] = 100,["137"] = 101,["139"] = 103,["145"] = 107,["146"] = 108,["149"] = 83,["150"] = 112,["151"] = 113,["152"] = 114,["153"] = 115,["154"] = 116,["155"] = 117,["156"] = 118,["157"] = 118,["159"] = 119,["162"] = 122,["163"] = 123,["164"] = 124,["165"] = 125,["166"] = 126,["167"] = 128,["168"] = 129,["169"] = 130,["170"] = 130,["173"] = 132,["174"] = 132,["175"] = 132,["177"] = 135,["178"] = 136,["179"] = 137,["180"] = 138,["181"] = 139,["182"] = 140,["183"] = 141,["185"] = 143,["186"] = 144,["189"] = 147,["190"] = 147,["193"] = 148,["194"] = 148,["195"] = 148,["196"] = 148,["199"] = 149,["200"] = 149,["202"] = 150,["203"] = 112,["204"] = 153,["205"] = 155,["206"] = 155,["208"] = 156,["209"] = 157,["210"] = 158,["211"] = 158,["213"] = 159,["214"] = 153});
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
    self.forceRender = false
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
return ____exports
