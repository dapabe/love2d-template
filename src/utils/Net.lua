
---@type enet
local enet = require("enet")

--- GMod like Net Api
---@class Net
---@field serverHost enet_host
---@field clientHost enet_host
---@field private peer enet_peer
---@field handlers table<string, fun(buf: string, peer: enet_peer)>
---@field current nil | table
---@field currentName string
local Net = {
    serverHost = nil,      -- ENet host (server or client)
    clientHost = nil,
    peer = nil,      -- ENet peer (si sos cliente conectado a un server)
    handlers = {},   -- tabla de callbacks registrados
    current = nil,   -- buffer temporal del mensaje en construcción
    currentName = "", -- nombre del mensaje actual
}
Net.__index = Net

---@param n integer
local function packUint16(n)
  return love.data.pack("string", "H", n)
end

---@param s string
local function unpackUint16(s)
  return love.data.unpack("H", s)
end

local function concatPacket()
  local payload = table.concat(Net.current)
  local name = Net.currentName
  local packet = packUint16(#name) .. name .. payload
  return packet
end

--- [SERVER]
---@param host string
---@param port integer
---@param maxClients integer
function Net.InitServer(host, port, maxClients)
    Net.serverHost = enet.host_create(host..":" .. port, maxClients or 32)
    print("[Net] Servidor escuchando en puerto " .. port)
end

--- [CLIENT]
---@param host string
---@param port integer
function Net.InitClient(host, port)
  Net.clientHost = enet.host_create()
  Net.peer = Net.clientHost:connect(host .. ":" .. port)
  print("[Net] Cliente conectando a " .. host .. ":" .. port)
end

--- [SERVER]
--- Sends msg to all connected clients
function Net.Broadcast()
    if not Net.serverHost then return end
    Net.serverHost:broadcast(concatPacket())
end


--- [SHARED]
--- Register callbacks
---@param name string
---@param callback fun(buf: string, peer: enet_peer)
function Net.On(name, callback)
    Net.handlers[name:lower()] = callback
end


--- [SHARED]
--- Start a message
---@param name string
function Net.Start(name)
    Net.current = {}
    Net.currentName = name:lower()
end

--- [SHARED]
--- (bits=8|16|32, signed)
---@param value integer
---@param bits integer
---@param signed boolean
function Net.WriteInt(value, bits, signed)
  bits = bits or 32
  signed = signed or false
  local fmtmap = {
    [8]  = { signed = "b", unsigned = "B" },
    [16] = { signed = "h", unsigned = "H" },
    [32] = { signed = "i", unsigned = "I" },
  }
  local fmt = (signed and fmtmap[bits].signed) or fmtmap[bits].unsigned
  table.insert(Net.current, love.data.pack("string", fmt, value))
end

--- [SHARED]
---@param value number
function Net.WriteFloat(value)
  table.insert(Net.current, love.data.pack("string", "f", value))
end

--- [SHARED]
---@param b boolean
function Net.WriteBool(b)
  Net.WriteInt(b and 1 or 0, 8, false)
end

--- [SHARED]
---@param s string
function Net.WriteString(s)
  s = s or ""
  local len = #s
  if len > 65535 then error("Net.WriteString demasiado largo") end
  table.insert(Net.current, packUint16(len))
  table.insert(Net.current, s)
end

--- [SHARED]
---@param v {x:number,y:number}
function Net.WriteVector2(v)
  Net.WriteFloat(v.x)
  Net.WriteFloat(v.y)
end

--- [CLIENT]
function Net.SendToServer()
  if not Net.current then return error("Net.SendToServer: no se llamó a Net.Start") end
  if Net.peer == nil then return error("Net.SendToServer: localPeer non existent") end
  Net.peer:send(concatPacket())
  Net.current = nil
  Net.currentName = ""
end

--- [SERVER]
---@param peer enet_peer
function Net.SendToClient(peer)
  if not Net.current then return error("Net.SendToClient: no se llamó a Net.Start") end
  peer:send(concatPacket())
  Net.current = nil
  Net.currentName = ""
end



--- Update loop
---@param callbacks table<ENET_EVENT_TYPE, fun(event: enet_event)>
function Net.Update(callbacks)
  -- server host events
  if Net.serverHost then
    local event = Net.serverHost:service(0)
    while event do
      -- if event.type == "receive" then Net.HandlePayload(event) 
      callbacks[event.type](event)
      event = Net.serverHost:service()
    end
  end

  -- client host events (separado)
  if Net.clientHost then
    local event = Net.clientHost:service(0)
    while event do
      callbacks[event.type](event)
      event = Net.clientHost:service()
    end
  end
end

--- [CLIENT]
function Net.Exit()
  if not Net.peer then return end
  Net.peer:disconnect_now()
end

---@param event enet_event
function Net.HandlePayload(event)
  local nameLen = unpackUint16(event.data:sub(1, 2))
  local name = event.data:sub(3, 2 + nameLen)
  local payload = event.data:sub(3 + nameLen)
  local handler = Net.handlers[name]
  if handler then handler(payload, event.peer) end
end

---@param s string
function Net.Reader(s)
  ---@class R
  local r = { data = s, pos = 1 }

  function r:readInt(bits, signed)
    bits = bits or 32
    local fmtmap = {
      [8]  = { signed = "b", unsigned = "B" },
      [16] = { signed = "h", unsigned = "H" },
      [32] = { signed = "i", unsigned = "I" },
    }
    local fmt = (signed and fmtmap[bits].signed) or fmtmap[bits].unsigned
    local byteCount = bits / 8
    local chunk = self.data:sub(self.pos, self.pos + byteCount - 1)
    self.pos = self.pos + byteCount
    return love.data.unpack(fmt, chunk)
  end

  function r:readFloat()
    local chunk = self.data:sub(self.pos, self.pos + 3)
    self.pos = self.pos + 4
    return love.data.unpack("f", chunk)
  end

  function r:readBool()
    return self:readInt(8, false) ~= 0
  end

  function r:readString()
    local len = self:readInt(16, false)
    local chunk = self.data:sub(self.pos, self.pos + len - 1)
    self.pos = self.pos + len
    return chunk
  end

  function r:readVec2()
    local x = self:readFloat()
    local y = self:readFloat()
    return { x = x, y = y }
  end

  return r
end


return Net