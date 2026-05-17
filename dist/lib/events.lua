-- lib/events.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/events.ts"] = _G.__tracetrace["lib/events.ts"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ArrayConcat = ____lualib.__TS__ArrayConcat
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["10"] = 9,["11"] = 9,["12"] = 9,["14"] = 10,["15"] = 9,["16"] = 11,["17"] = 12,["18"] = 11,["19"] = 14,["20"] = 15,["21"] = 14,["22"] = 17,["23"] = 18,["24"] = 18,["26"] = 19,["27"] = 20,["28"] = 21,["29"] = 17,["30"] = 25,["31"] = 25,["32"] = 25,["34"] = 26,["35"] = 27,["36"] = 28,["37"] = 25,["38"] = 29,["39"] = 30,["40"] = 29,["41"] = 32,["42"] = 33,["43"] = 33,["44"] = 33,["45"] = 33,["47"] = 33,["49"] = 33,["50"] = 32,["51"] = 35,["52"] = 37,["53"] = 40,["55"] = 41,["56"] = 42,["57"] = 43,["58"] = 44,["59"] = 44,["60"] = 44,["61"] = 44,["63"] = 44,["65"] = 44,["66"] = 45,["67"] = 35,["68"] = 49,["69"] = 49,["70"] = 49,["72"] = 50,["73"] = 49,["74"] = 51,["75"] = 52,["76"] = 51,["77"] = 54,["78"] = 55,["79"] = 54,["80"] = 57,["81"] = 58,["82"] = 58,["84"] = 59,["85"] = 60,["86"] = 61,["87"] = 57,["88"] = 65,["89"] = 65,["90"] = 65,["92"] = 66,["93"] = 67,["94"] = 65,["95"] = 68,["96"] = 69,["97"] = 68,["98"] = 71,["99"] = 72,["100"] = 71,["101"] = 74,["102"] = 76,["103"] = 79,["105"] = 80,["106"] = 81,["107"] = 82,["108"] = 83,["109"] = 74,["110"] = 87,["111"] = 87,["112"] = 87,["114"] = 88,["115"] = 89,["116"] = 90,["117"] = 91,["118"] = 87,["119"] = 92,["120"] = 93,["121"] = 92,["122"] = 95,["123"] = 96,["124"] = 96,["126"] = 97,["128"] = 95,["129"] = 99,["130"] = 100,["131"] = 100,["133"] = 101,["134"] = 102,["135"] = 103,["136"] = 104,["137"] = 105,["138"] = 106,["140"] = 108,["141"] = 109,["143"] = 111,["144"] = 99,["145"] = 115,["146"] = 115,["147"] = 115,["149"] = 115,["150"] = 116,["151"] = 117,["152"] = 116,["153"] = 119,["154"] = 120,["155"] = 119,["156"] = 122,["157"] = 123,["158"] = 123,["160"] = 124,["161"] = 125,["162"] = 122,["163"] = 129,["164"] = 129,["165"] = 129,["167"] = 129,["168"] = 130,["169"] = 131,["170"] = 130,["171"] = 133,["172"] = 134,["173"] = 133,["174"] = 136,["175"] = 137,["176"] = 137,["178"] = 138,["179"] = 139,["180"] = 136,["181"] = 143,["182"] = 143,["183"] = 143,["185"] = 144,["186"] = 145,["187"] = 143,["188"] = 146,["189"] = 147,["190"] = 146,["191"] = 149,["192"] = 150,["193"] = 149,["194"] = 152,["195"] = 154,["196"] = 157,["198"] = 158,["199"] = 159,["200"] = 160,["201"] = 161,["202"] = 152,["203"] = 165,["204"] = 165,["205"] = 165,["207"] = 166,["208"] = 167,["209"] = 165,["210"] = 168,["211"] = 169,["212"] = 168,["213"] = 171,["214"] = 172,["215"] = 171,["216"] = 174,["217"] = 176,["218"] = 179,["220"] = 180,["221"] = 181,["222"] = 182,["223"] = 183,["224"] = 174,["225"] = 187,["226"] = 187,["227"] = 187,["229"] = 188,["230"] = 190,["231"] = 187,["232"] = 191,["233"] = 192,["234"] = 191,["235"] = 194,["236"] = 195,["237"] = 194,["238"] = 197,["239"] = 198,["240"] = 198,["242"] = 199,["243"] = 200,["244"] = 201,["245"] = 202,["246"] = 203,["247"] = 197,["248"] = 207,["249"] = 207,["250"] = 207,["252"] = 208,["253"] = 209,["254"] = 210,["255"] = 212,["256"] = 207,["257"] = 213,["258"] = 214,["259"] = 213,["260"] = 216,["261"] = 217,["262"] = 217,["263"] = 217,["264"] = 217,["265"] = 217,["266"] = 217,["267"] = 217,["268"] = 216,["269"] = 219,["270"] = 220,["271"] = 220,["273"] = 221,["274"] = 222,["275"] = 223,["276"] = 224,["277"] = 225,["278"] = 226,["279"] = 227,["280"] = 219,["281"] = 231,["282"] = 231,["283"] = 231,["285"] = 232,["286"] = 233,["287"] = 234,["288"] = 231,["289"] = 235,["290"] = 236,["291"] = 235,["292"] = 238,["293"] = 240,["294"] = 241,["295"] = 241,["296"] = 241,["298"] = 241,["300"] = 242,["301"] = 242,["302"] = 242,["304"] = 242,["306"] = 239,["307"] = 238,["308"] = 245,["309"] = 247,["310"] = 250,["312"] = 251,["313"] = 252,["314"] = 253,["315"] = 254,["316"] = 255,["318"] = 257,["319"] = 258,["320"] = 258,["322"] = 259,["324"] = 261,["325"] = 245,["326"] = 265,["327"] = 265,["328"] = 265,["330"] = 266,["331"] = 267,["332"] = 265,["333"] = 268,["334"] = 269,["335"] = 268,["336"] = 271,["337"] = 272,["338"] = 272,["339"] = 272,["341"] = 272,["343"] = 272,["344"] = 271,["345"] = 274,["346"] = 276,["347"] = 280,["349"] = 281,["350"] = 282,["351"] = 283,["352"] = 284,["354"] = 286,["355"] = 287,["357"] = 289,["358"] = 274,["359"] = 293,["360"] = 294,["361"] = 294,["362"] = 295,["363"] = 295,["364"] = 296,["365"] = 296,["366"] = 297,["367"] = 297,["368"] = 298,["369"] = 298,["370"] = 299,["371"] = 299,["372"] = 302,["373"] = 302,["374"] = 302,["376"] = 303,["377"] = 304,["378"] = 305,["379"] = 306,["380"] = 307,["381"] = 302,["382"] = 308,["383"] = 309,["384"] = 309,["385"] = 309,["386"] = 309,["387"] = 309,["388"] = 309,["389"] = 309,["390"] = 309,["391"] = 308,["392"] = 318,["393"] = 319,["394"] = 319,["395"] = 319,["397"] = 319,["399"] = 319,["400"] = 318,["401"] = 321,["402"] = 322,["403"] = 322,["405"] = 323,["406"] = 324,["407"] = 325,["408"] = 326,["409"] = 327,["410"] = 328,["411"] = 329,["412"] = 330,["413"] = 331,["414"] = 332,["415"] = 333,["416"] = 334,["417"] = 335,["418"] = 336,["419"] = 337,["420"] = 338,["421"] = 339,["422"] = 340,["423"] = 341,["424"] = 342,["425"] = 343,["426"] = 344,["427"] = 345,["428"] = 346,["429"] = 347,["430"] = 348,["432"] = 349,["434"] = 350,["435"] = 351,["436"] = 352,["437"] = 321,["438"] = 356,["439"] = 356,["440"] = 356,["442"] = 357,["443"] = 356,["444"] = 358,["445"] = 359,["446"] = 358,["447"] = 361,["448"] = 362,["449"] = 361,["450"] = 364,["451"] = 366,["452"] = 369,["454"] = 370,["455"] = 371,["456"] = 371,["458"] = 372,["460"] = 373,["461"] = 364,["462"] = 377,["463"] = 377,["464"] = 377,["466"] = 377,["467"] = 378,["468"] = 379,["469"] = 378,["470"] = 381,["471"] = 382,["472"] = 381,["473"] = 384,["474"] = 385,["475"] = 386,["477"] = 387,["478"] = 388,["479"] = 384,["480"] = 392,["481"] = 392,["483"] = 393,["484"] = 392,["485"] = 394,["486"] = 395,["487"] = 394,["488"] = 397,["489"] = 398,["490"] = 397,["491"] = 400,["492"] = 401,["493"] = 402,["495"] = 403,["496"] = 404,["497"] = 405,["498"] = 400,["499"] = 409,["500"] = 409,["502"] = 410,["503"] = 409,["504"] = 411,["505"] = 412,["506"] = 411,["507"] = 414,["508"] = 415,["509"] = 414,["510"] = 417,["511"] = 418,["512"] = 419,["514"] = 420,["515"] = 421,["516"] = 422,["517"] = 417,["518"] = 440,["519"] = 440,["520"] = 440,["522"] = 441,["523"] = 440,["524"] = 442,["525"] = 443,["526"] = 442,["527"] = 445,["528"] = 446,["529"] = 445,["530"] = 448,["531"] = 449,["532"] = 450,["533"] = 451,["534"] = 448,["535"] = 455,["536"] = 455,["537"] = 455,["538"] = 455,["539"] = 455,["540"] = 455,["541"] = 455,["542"] = 455,["543"] = 455,["544"] = 455,["545"] = 455,["546"] = 455,["547"] = 455,["548"] = 455,["549"] = 455,["550"] = 455,["551"] = 455,["552"] = 455,["553"] = 455,["554"] = 455,["555"] = 455,["556"] = 478,["557"] = 479,["558"] = 480,["559"] = 481,["560"] = 482,["561"] = 482,["564"] = 484,["565"] = 478,["566"] = 486,["567"] = 487,["568"] = 488,["569"] = 488,["571"] = 489,["572"] = 486,["573"] = 491,["574"] = 495,["575"] = 496,["576"] = 496,["578"] = 497,["580"] = 491,["581"] = 499,["582"] = 503,["583"] = 504,["584"] = 504,["586"] = 505,["588"] = 499});
local ____exports = {}
____exports.CharEvent = __TS__Class()
local CharEvent = ____exports.CharEvent
CharEvent.name = "CharEvent"
function CharEvent.prototype.____constructor(self)
    self.character = ""
end
function CharEvent.prototype.get_name(self)
    return "char"
end
function CharEvent.prototype.get_args(self)
    return {self.character}
end
function CharEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "char" then
        return nil
    end
    local ev = __TS__New(____exports.CharEvent)
    ev.character = args[2]
    return ev
end
____exports.KeyEvent = __TS__Class()
local KeyEvent = ____exports.KeyEvent
KeyEvent.name = "KeyEvent"
function KeyEvent.prototype.____constructor(self)
    self.key = 0
    self.isHeld = false
    self.isUp = false
end
function KeyEvent.prototype.get_name(self)
    return self.isUp and "key_up" or "key"
end
function KeyEvent.prototype.get_args(self)
    local ____self_key_1 = self.key
    local ____table_isUp_0
    if self.isUp then
        ____table_isUp_0 = nil
    else
        ____table_isUp_0 = self.isHeld
    end
    return {____self_key_1, ____table_isUp_0}
end
function KeyEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "key" and args[1] ~= "key_up" then
        return nil
    end
    local ev = __TS__New(____exports.KeyEvent)
    ev.key = args[2]
    ev.isUp = args[1] == "key_up"
    local ____ev_3 = ev
    local ____ev_isUp_2
    if ev.isUp then
        ____ev_isUp_2 = false
    else
        ____ev_isUp_2 = args[3]
    end
    ____ev_3.isHeld = ____ev_isUp_2
    return ev
end
____exports.PasteEvent = __TS__Class()
local PasteEvent = ____exports.PasteEvent
PasteEvent.name = "PasteEvent"
function PasteEvent.prototype.____constructor(self)
    self.text = ""
end
function PasteEvent.prototype.get_name(self)
    return "paste"
end
function PasteEvent.prototype.get_args(self)
    return {self.text}
end
function PasteEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "paste" then
        return nil
    end
    local ev = __TS__New(____exports.PasteEvent)
    ev.text = args[2]
    return ev
end
____exports.TimerEvent = __TS__Class()
local TimerEvent = ____exports.TimerEvent
TimerEvent.name = "TimerEvent"
function TimerEvent.prototype.____constructor(self)
    self.id = 0
    self.isAlarm = false
end
function TimerEvent.prototype.get_name(self)
    return self.isAlarm and "alarm" or "timer"
end
function TimerEvent.prototype.get_args(self)
    return {self.id}
end
function TimerEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "timer" and args[1] ~= "alarm" then
        return nil
    end
    local ev = __TS__New(____exports.TimerEvent)
    ev.id = args[2]
    ev.isAlarm = args[1] == "alarm"
    return ev
end
____exports.TaskCompleteEvent = __TS__Class()
local TaskCompleteEvent = ____exports.TaskCompleteEvent
TaskCompleteEvent.name = "TaskCompleteEvent"
function TaskCompleteEvent.prototype.____constructor(self)
    self.id = 0
    self.success = false
    self.error = nil
    self.params = {}
end
function TaskCompleteEvent.prototype.get_name(self)
    return "task_complete"
end
function TaskCompleteEvent.prototype.get_args(self)
    if self.success then
        return __TS__ArrayConcat({self.id, self.success}, self.params)
    else
        return {self.id, self.success, self.error}
    end
end
function TaskCompleteEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "task_complete" then
        return nil
    end
    local ev = __TS__New(____exports.TaskCompleteEvent)
    ev.id = args[2]
    ev.success = args[3]
    if ev.success then
        ev.error = nil
        ev.params = __TS__ArraySlice(args, 3)
    else
        ev.error = args[4]
        ev.params = {}
    end
    return ev
end
____exports.RedstoneEvent = __TS__Class()
local RedstoneEvent = ____exports.RedstoneEvent
RedstoneEvent.name = "RedstoneEvent"
function RedstoneEvent.prototype.____constructor(self)
end
function RedstoneEvent.prototype.get_name(self)
    return "redstone"
end
function RedstoneEvent.prototype.get_args(self)
    return {}
end
function RedstoneEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "redstone" then
        return nil
    end
    local ev = __TS__New(____exports.RedstoneEvent)
    return ev
end
____exports.TerminateEvent = __TS__Class()
local TerminateEvent = ____exports.TerminateEvent
TerminateEvent.name = "TerminateEvent"
function TerminateEvent.prototype.____constructor(self)
end
function TerminateEvent.prototype.get_name(self)
    return "terminate"
end
function TerminateEvent.prototype.get_args(self)
    return {}
end
function TerminateEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "terminate" then
        return nil
    end
    local ev = __TS__New(____exports.TerminateEvent)
    return ev
end
____exports.DiskEvent = __TS__Class()
local DiskEvent = ____exports.DiskEvent
DiskEvent.name = "DiskEvent"
function DiskEvent.prototype.____constructor(self)
    self.side = ""
    self.eject = false
end
function DiskEvent.prototype.get_name(self)
    return self.eject and "disk_eject" or "disk"
end
function DiskEvent.prototype.get_args(self)
    return {self.side}
end
function DiskEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "disk" and args[1] ~= "disk_eject" then
        return nil
    end
    local ev = __TS__New(____exports.DiskEvent)
    ev.side = args[2]
    ev.eject = args[1] == "disk_eject"
    return ev
end
____exports.PeripheralEvent = __TS__Class()
local PeripheralEvent = ____exports.PeripheralEvent
PeripheralEvent.name = "PeripheralEvent"
function PeripheralEvent.prototype.____constructor(self)
    self.side = ""
    self.detach = false
end
function PeripheralEvent.prototype.get_name(self)
    return self.detach and "peripheral_detach" or "peripheral"
end
function PeripheralEvent.prototype.get_args(self)
    return {self.side}
end
function PeripheralEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "peripheral" and args[1] ~= "peripheral_detach" then
        return nil
    end
    local ev = __TS__New(____exports.PeripheralEvent)
    ev.side = args[2]
    ev.detach = args[1] == "peripheral_detach"
    return ev
end
____exports.RednetMessageEvent = __TS__Class()
local RednetMessageEvent = ____exports.RednetMessageEvent
RednetMessageEvent.name = "RednetMessageEvent"
function RednetMessageEvent.prototype.____constructor(self)
    self.sender = 0
    self.protocol = nil
end
function RednetMessageEvent.prototype.get_name(self)
    return "rednet_message"
end
function RednetMessageEvent.prototype.get_args(self)
    return {self.sender, self.message, self.protocol}
end
function RednetMessageEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "rednet_message" then
        return nil
    end
    local ev = __TS__New(____exports.RednetMessageEvent)
    ev.sender = args[2]
    ev.message = args[3]
    ev.protocol = args[4]
    return ev
end
____exports.ModemMessageEvent = __TS__Class()
local ModemMessageEvent = ____exports.ModemMessageEvent
ModemMessageEvent.name = "ModemMessageEvent"
function ModemMessageEvent.prototype.____constructor(self)
    self.side = ""
    self.channel = 0
    self.replyChannel = 0
    self.distance = 0
end
function ModemMessageEvent.prototype.get_name(self)
    return "modem_message"
end
function ModemMessageEvent.prototype.get_args(self)
    return {
        self.side,
        self.channel,
        self.replyChannel,
        self.message,
        self.distance
    }
end
function ModemMessageEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "modem_message" then
        return nil
    end
    local ev = __TS__New(____exports.ModemMessageEvent)
    ev.side = args[2]
    ev.channel = args[3]
    ev.replyChannel = args[4]
    ev.message = args[5]
    ev.distance = args[6]
    return ev
end
____exports.HTTPEvent = __TS__Class()
local HTTPEvent = ____exports.HTTPEvent
HTTPEvent.name = "HTTPEvent"
function HTTPEvent.prototype.____constructor(self)
    self.url = ""
    self.handle = nil
    self.error = nil
end
function HTTPEvent.prototype.get_name(self)
    return self.error == nil and "http_success" or "http_failure"
end
function HTTPEvent.prototype.get_args(self)
    local ____self_url_6 = self.url
    local ____temp_4
    if self.error == nil then
        ____temp_4 = self.handle
    else
        ____temp_4 = self.error
    end
    local ____temp_5
    if self.error ~= nil then
        ____temp_5 = self.handle
    else
        ____temp_5 = nil
    end
    return {____self_url_6, ____temp_4, ____temp_5}
end
function HTTPEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "http_success" and args[1] ~= "http_failure" then
        return nil
    end
    local ev = __TS__New(____exports.HTTPEvent)
    ev.url = args[2]
    if args[1] == "http_success" then
        ev.error = nil
        ev.handle = args[3]
    else
        ev.error = args[3]
        if ev.error == nil then
            ev.error = ""
        end
        ev.handle = args[4]
    end
    return ev
end
____exports.WebSocketEvent = __TS__Class()
local WebSocketEvent = ____exports.WebSocketEvent
WebSocketEvent.name = "WebSocketEvent"
function WebSocketEvent.prototype.____constructor(self)
    self.handle = nil
    self.error = nil
end
function WebSocketEvent.prototype.get_name(self)
    return self.error == nil and "websocket_success" or "websocket_failure"
end
function WebSocketEvent.prototype.get_args(self)
    local ____temp_7
    if self.handle == nil then
        ____temp_7 = self.error
    else
        ____temp_7 = self.handle
    end
    return {____temp_7}
end
function WebSocketEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "websocket_success" and args[1] ~= "websocket_failure" then
        return nil
    end
    local ev = __TS__New(____exports.WebSocketEvent)
    if args[1] == "websocket_success" then
        ev.handle = args[2]
        ev.error = nil
    else
        ev.error = args[2]
        ev.handle = nil
    end
    return ev
end
____exports.MouseEventType = MouseEventType or ({})
____exports.MouseEventType.Click = 0
____exports.MouseEventType[____exports.MouseEventType.Click] = "Click"
____exports.MouseEventType.Up = 1
____exports.MouseEventType[____exports.MouseEventType.Up] = "Up"
____exports.MouseEventType.Scroll = 2
____exports.MouseEventType[____exports.MouseEventType.Scroll] = "Scroll"
____exports.MouseEventType.Drag = 3
____exports.MouseEventType[____exports.MouseEventType.Drag] = "Drag"
____exports.MouseEventType.Touch = 4
____exports.MouseEventType[____exports.MouseEventType.Touch] = "Touch"
____exports.MouseEventType.Move = 5
____exports.MouseEventType[____exports.MouseEventType.Move] = "Move"
____exports.MouseEvent = __TS__Class()
local MouseEvent = ____exports.MouseEvent
MouseEvent.name = "MouseEvent"
function MouseEvent.prototype.____constructor(self)
    self.button = 0
    self.x = 0
    self.y = 0
    self.side = nil
    self.type = ____exports.MouseEventType.Click
end
function MouseEvent.prototype.get_name(self)
    return ({
        [____exports.MouseEventType.Click] = "mouse_click",
        [____exports.MouseEventType.Up] = "mouse_up",
        [____exports.MouseEventType.Scroll] = "mouse_scroll",
        [____exports.MouseEventType.Drag] = "mouse_drag",
        [____exports.MouseEventType.Touch] = "monitor_touch",
        [____exports.MouseEventType.Move] = "mouse_move"
    })[self.type]
end
function MouseEvent.prototype.get_args(self)
    local ____temp_8
    if self.type == ____exports.MouseEventType.Touch then
        ____temp_8 = self.side
    else
        ____temp_8 = self.button
    end
    return {____temp_8, self.x, self.y}
end
function MouseEvent.init(args)
    if not (type(args[1]) == "string") then
        return nil
    end
    local ev = __TS__New(____exports.MouseEvent)
    local ____type = args[1]
    if ____type == "mouse_click" then
        ev.type = ____exports.MouseEventType.Click
        ev.button = args[2]
        ev.side = nil
    elseif ____type == "mouse_up" then
        ev.type = ____exports.MouseEventType.Up
        ev.button = args[2]
        ev.side = nil
    elseif ____type == "mouse_scroll" then
        ev.type = ____exports.MouseEventType.Scroll
        ev.button = args[2]
        ev.side = nil
    elseif ____type == "mouse_drag" then
        ev.type = ____exports.MouseEventType.Drag
        ev.button = args[2]
        ev.side = nil
    elseif ____type == "monitor_touch" then
        ev.type = ____exports.MouseEventType.Touch
        ev.button = 0
        ev.side = args[2]
    elseif ____type == "mouse_move" then
        ev.type = ____exports.MouseEventType.Move
        ev.button = args[2]
        ev.side = nil
    else
        return nil
    end
    ev.x = args[3]
    ev.y = args[4]
    return ev
end
____exports.ResizeEvent = __TS__Class()
local ResizeEvent = ____exports.ResizeEvent
ResizeEvent.name = "ResizeEvent"
function ResizeEvent.prototype.____constructor(self)
    self.side = nil
end
function ResizeEvent.prototype.get_name(self)
    return self.side == nil and "term_resize" or "monitor_resize"
end
function ResizeEvent.prototype.get_args(self)
    return {self.side}
end
function ResizeEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "term_resize" and args[1] ~= "monitor_resize" then
        return nil
    end
    local ev = __TS__New(____exports.ResizeEvent)
    if args[1] == "monitor_resize" then
        ev.side = args[2]
    else
        ev.side = nil
    end
    return ev
end
____exports.TurtleInventoryEvent = __TS__Class()
local TurtleInventoryEvent = ____exports.TurtleInventoryEvent
TurtleInventoryEvent.name = "TurtleInventoryEvent"
function TurtleInventoryEvent.prototype.____constructor(self)
end
function TurtleInventoryEvent.prototype.get_name(self)
    return "turtle_inventory"
end
function TurtleInventoryEvent.prototype.get_args(self)
    return {}
end
function TurtleInventoryEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "turtle_inventory" then
        return nil
    end
    local ev = __TS__New(____exports.TurtleInventoryEvent)
    return ev
end
local SpeakerAudioEmptyEvent = __TS__Class()
SpeakerAudioEmptyEvent.name = "SpeakerAudioEmptyEvent"
function SpeakerAudioEmptyEvent.prototype.____constructor(self)
    self.side = ""
end
function SpeakerAudioEmptyEvent.prototype.get_name(self)
    return "speaker_audio_empty"
end
function SpeakerAudioEmptyEvent.prototype.get_args(self)
    return {self.side}
end
function SpeakerAudioEmptyEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "speaker_audio_empty" then
        return nil
    end
    local ev = __TS__New(SpeakerAudioEmptyEvent)
    ev.side = args[2]
    return ev
end
local ComputerCommandEvent = __TS__Class()
ComputerCommandEvent.name = "ComputerCommandEvent"
function ComputerCommandEvent.prototype.____constructor(self)
    self.args = {}
end
function ComputerCommandEvent.prototype.get_name(self)
    return "computer_command"
end
function ComputerCommandEvent.prototype.get_args(self)
    return self.args
end
function ComputerCommandEvent.init(args)
    if not (type(args[1]) == "string") or args[1] ~= "computer_command" then
        return nil
    end
    local ev = __TS__New(ComputerCommandEvent)
    ev.args = __TS__ArraySlice(args, 1)
    return ev
end
____exports.GenericEvent = __TS__Class()
local GenericEvent = ____exports.GenericEvent
GenericEvent.name = "GenericEvent"
function GenericEvent.prototype.____constructor(self)
    self.args = {}
end
function GenericEvent.prototype.get_name(self)
    return self.args[1]
end
function GenericEvent.prototype.get_args(self)
    return __TS__ArraySlice(self.args, 1)
end
function GenericEvent.init(args)
    local ev = __TS__New(____exports.GenericEvent)
    ev.args = args
    return ev
end
local eventInitializers = {
    ____exports.CharEvent.init,
    ____exports.KeyEvent.init,
    ____exports.PasteEvent.init,
    ____exports.TimerEvent.init,
    ____exports.TaskCompleteEvent.init,
    ____exports.RedstoneEvent.init,
    ____exports.TerminateEvent.init,
    ____exports.DiskEvent.init,
    ____exports.PeripheralEvent.init,
    ____exports.RednetMessageEvent.init,
    ____exports.ModemMessageEvent.init,
    ____exports.HTTPEvent.init,
    ____exports.WebSocketEvent.init,
    ____exports.MouseEvent.init,
    ____exports.ResizeEvent.init,
    ____exports.TurtleInventoryEvent.init,
    SpeakerAudioEmptyEvent.init,
    ComputerCommandEvent.init,
    ____exports.GenericEvent.init
}
function ____exports.pullEventRaw(filter)
    local args = table.pack(coroutine.yield(filter))
    for ____, init in ipairs(eventInitializers) do
        local ev = init(args)
        if ev ~= nil then
            return ev
        end
    end
    return ____exports.GenericEvent.init(args)
end
function ____exports.pullEvent(filter)
    local ev = ____exports.pullEventRaw(filter)
    if __TS__InstanceOf(ev, ____exports.TerminateEvent) then
        error("Terminated", 0)
    end
    return ev
end
function ____exports.pullEventRawAs(____type, filter)
    local ev = ____exports.pullEventRaw(filter)
    if __TS__InstanceOf(ev, ____type) then
        return ev
    else
        return nil
    end
end
function ____exports.pullEventAs(____type, filter)
    local ev = ____exports.pullEvent(filter)
    if __TS__InstanceOf(ev, ____type) then
        return ev
    else
        return nil
    end
end
return ____exports
