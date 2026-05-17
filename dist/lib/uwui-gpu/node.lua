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
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["19"] = 1,["20"] = 1,["21"] = 3,["22"] = 3,["23"] = 6,["24"] = 7,["25"] = 8,["26"] = 9,["27"] = 10,["28"] = 10,["29"] = 10,["30"] = 10,["32"] = 12,["33"] = 13,["35"] = 15,["36"] = 6,["37"] = 18,["38"] = 18,["39"] = 18,["40"] = 38,["41"] = 38,["42"] = 39,["43"] = 41,["44"] = 23,["45"] = 25,["46"] = 26,["47"] = 27,["48"] = 30,["49"] = 32,["50"] = 33,["51"] = 35,["52"] = 52,["53"] = 53,["56"] = 54,["57"] = 55,["59"] = 57,["61"] = 52,["62"] = 43,["63"] = 44,["64"] = 45,["65"] = 45,["67"] = 37,["68"] = 48,["69"] = 49,["70"] = 49,["71"] = 48,["72"] = 61,["73"] = 62,["74"] = 63,["75"] = 64,["76"] = 65,["79"] = 66,["80"] = 67,["81"] = 67,["82"] = 64,["85"] = 83,["88"] = 70,["89"] = 71,["90"] = 72,["91"] = 73,["92"] = 73,["93"] = 73,["94"] = 73,["95"] = 74,["97"] = 76,["99"] = 76,["103"] = 77,["104"] = 78,["105"] = 78,["107"] = 79,["109"] = 81,["115"] = 85,["116"] = 86,["119"] = 61,["120"] = 90,["121"] = 91,["122"] = 92,["123"] = 93,["124"] = 94,["125"] = 95,["126"] = 96,["127"] = 96,["129"] = 97,["132"] = 100,["133"] = 101,["134"] = 102,["135"] = 103,["136"] = 104,["137"] = 106,["138"] = 107,["139"] = 108,["140"] = 108,["143"] = 110,["144"] = 110,["145"] = 110,["147"] = 113,["148"] = 114,["149"] = 115,["150"] = 116,["151"] = 117,["152"] = 118,["153"] = 119,["155"] = 121,["156"] = 122,["159"] = 125,["160"] = 125,["163"] = 126,["164"] = 126,["165"] = 126,["166"] = 126,["169"] = 127,["170"] = 127,["172"] = 128,["173"] = 90,["174"] = 131,["175"] = 133,["176"] = 133,["178"] = 134,["179"] = 135,["180"] = 136,["181"] = 136,["183"] = 137,["184"] = 131});
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
function Node.prototype.render(self, gpu)
    local prevNode = ____exports.Node.current
    ____exports.Node.current = self
    Signal:hook(function(signal)
        if self.deps:has(signal) then
            return
        end
        self.deps:add(signal)
        local ____self_disposers_2 = self.disposers
        ____self_disposers_2[#____self_disposers_2 + 1] = signal:subscribe(function() return self:invalidate() end)
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
            local ____unkeyedIndex_3 = unkeyedIndex
            unkeyedIndex = ____unkeyedIndex_3 + 1
            prev = prevUnkeyed[____unkeyedIndex_3 + 1]
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
