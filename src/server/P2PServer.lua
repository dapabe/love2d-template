local Net  = require("src.utils.Net")

local P2PServer = {}


function P2PServer.init(role)
    if role == "server" then
        Net.InitServer(22122, 4)
        Net.On("PlayerMove", function(payload, peer)
            local r = Net.Reader(payload)
            local pos = r:readVec2()
            print("[Server] PlayerMove", pos.x, pos.y)
            -- reenvía a todos
            Net.Start("PlayerMove")
            Net.WriteVector2(pos)
            Net.Broadcast()
        end)
    end
    if role == "client" then
        Net.On("PlayerMove", function(payload, peer)
            local r = Net.Reader(payload)
            local pos = r:readVec2()
            print("[Client] Posición recibida:", pos.x, pos.y)
        end)

        Net.InitClient("localhost", 22122)
    end
    if role == "listen" then
        Net.InitServer(22122, 4)
        
        Net.On("PlayerMove", function(payload, peer)
            local r = Net.Reader(payload)
            local pos = r:readVec2()
            print(("[Server] PlayerMove %s"):format(peer), pos.x, pos.y)
            Net.Start("PlayerMove")
            Net.WriteVector2(pos)
            Net.Broadcast()
        end)
        
        -- Net.On("PlayerMove", function(payload, peer)
        --     local r = Net.Reader(payload)
        --     local pos = r:readVec2()
        --     print("[S+C] Posición recibida:", pos.x, pos.y)
        -- end)

        Net.InitClient("localhost", 22122)
    end
end


return P2PServer