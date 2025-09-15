local KeyboardNetKey = require "src.utils.KeyboardNetKey"

---@class IGM_Base
local GM_BASE = Class{}

local players = {}

function GM_BASE:Init()
    -- Net.On("KeyboardMove", function (buf, peer)
    --     local user = players[peer:connect_id()]
    --     if not user then return end
    --     print(buf)
    --     local r = Net.Reader(buf)
    --     local _, netKey = r:readInt(8)
    --     print(netKey)

    --     -- Mueve al jugador en el servidor
    --     if netKey == KeyboardNetKey["UP"] then
    --         user.y = user.y - 5
    --     elseif netKey == KeyboardNetKey["DOWN"] then
    --         user.y = user.y + 5
    --     elseif netKey == KeyboardNetKey["LEFT"] then
    --         user.x = user.x - 5
    --     elseif netKey == KeyboardNetKey["RIGHT"] then
    --         user.x = user.x + 5
    --     end

    --     -- Reenvía al resto de clientes el estado actualizado
    --     Net.Start("n_KeyboardMove")
    --     Net.WriteVector2({ x = user.x, y = user.y })
    --     Net.SendToClient(peer)    -- le contesta al que movió
    --     Net.Broadcast()           -- y además a todos los demás
    -- end)
    -- Net.On("n_KeyboardMove", function (buf, peer)
    --     local user = players[peer:connect_id()]
    --     if not user then return end
    --     local r = Net.Reader(buf)
    --     local x, y = r:readVec2()
    --     user.x = x
    --     user.y = y
    -- end)
    self:OnPlayerEnter(nil)
end

function GM_BASE:OnMapStart()
end

function GM_BASE:BeforeMapExit()
    
end

function GM_BASE:OnPlayerEnter(peer)
    table.insert(players, 1, {x=0,y=0})
end

function GM_BASE:OnPlayerLeave(peer)
    local user = players[peer:index()]
    if not user then return end
    table.remove(players, peer:index())
end

function GM_BASE:OnPlayerSpawn()

end

function GM_BASE:OnPlayerKill()
end

function GM_BASE:OnUpdate()
    -- Net.Update({
    --     ["connect"] = function (event)
    --         print("[Server] Player connected: ", event.peer)
    --         self:OnPlayerEnter(event.peer)
    --     end,
    --     ["disconnect"] = function (event)
    --         print("[Server] Player disconnected: ", event.peer)
    --         self:OnPlayerLeave(event.peer)
    --     end,
    --     ["receive"] = function (event)
    --         Net.HandlePayload(event)
    --     end
    -- })

    -- if Net.peer:state() ~= "connected" then return end
    local u = players[1]
    if not u then return end
    if love.keyboard.isDown("w") then
        u.y = u.y - 3
        -- Net.Start("KeyboardMove")
        -- Net.WriteInt(KeyboardNetKey["UP"], 8, true)
        -- Net.SendToServer()
    elseif love.keyboard.isDown("s") then
        u.y = u.y + 3
        -- Net.Start("KeyboardMove")
        -- Net.WriteInt(KeyboardNetKey["DOWN"], 8, true)
        -- Net.SendToServer()
    elseif love.keyboard.isDown("a") then
        u.x = u.x - 3
        -- Net.Start("KeyboardMove")
        -- Net.WriteInt(KeyboardNetKey["LEFT"], 8, true)
        -- Net.SendToServer()
    elseif love.keyboard.isDown("d") then
        u.x = u.x + 3
        -- Net.Start("KeyboardMove")
        -- Net.WriteInt(KeyboardNetKey["RIGHT"], 8, true)
        -- Net.SendToServer()
     end

end

function GM_BASE:OnDraw()
    for key, user in pairs(players) do
        love.graphics.setColor(colors.rgbForGraphics(colors.Red600))
        -- printTable(user)
        love.graphics.circle("fill", user.x, user.y, 20)
    end
end


return GM_BASE