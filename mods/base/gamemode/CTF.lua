local GM_BASE = require("BASE")

---@class IGM_CTF
local GM_CTF = Class{
    __includes = GM_BASE
}

GM_CTF.FlagEnt = nil

function GM_CTF:init()
    
end

function GM_CTF:OnMapStart()

end

function GM_CTF:BeforeMapExit()
    
end

function GM_CTF:OnPlayerEnter()

end

function GM_CTF:OnPlayerLeave()

end

function GM_CTF:OnPlayerSpawn()

end

function GM_CTF:OnPlayerKill()
end

--- GM specific events

function GM_CTF:OnFlagCapture()

end

function GM_CTF:OnFlagDrop()
    
end

function GM_CTF:OnFlagScore()
    
end


return GM_CTF