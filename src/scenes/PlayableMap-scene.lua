local Net       = require("src.utils.Net")

---@class IScene
local PlayableMapScene = {}

---@class IGM_Base
local gamemode


function PlayableMapScene:enter(prev, role)
    love.window.setTitle(role)
    gamemode = require("mods.base.gamemode.BASE")
    
    if role == "listen" then
        Net.InitServer("localhost", 420,6)  -- crea Net.serverHost
        Net.InitClient("localhost", 420)  -- crea Net.clientHost + Net.clientPeer
    else
        if role == "server" then Net.InitServer("localhost", 420,6) end
        if role == "client" then Net.InitClient("localhost", 420) end
    end
    
    _G.Net = Net
    gamemode:Init()
    gamemode:OnMapStart()
end


function PlayableMapScene:leave()
    Net.Exit()
    _G.Net = nil
end

function PlayableMapScene:pause()
    
end

function PlayableMapScene:resume()
    
end

function PlayableMapScene:mousepressed()
    
end

function PlayableMapScene:update()
    if _G.Net then
        gamemode:OnUpdate()
    end
end

function PlayableMapScene:draw()
    if _G.Net then
        gamemode:OnDraw()
    end
end

return PlayableMapScene