
---@class IRegistry
---@field entities table<string, IEntity>
---@field maps table<string, IMap>

---@class IRegistry
local Registry = {
    entities = {},
    maps = {},
}

---@param id string
---@param def IEntity
function Registry:registerEntity(id, def)
    self.entities[id] = def
end

---@param id string
---@param def IMap
function Registry:registerMap(id, def)
    self.maps[id] = def
end

---@param id string
---@return IEntity
function Registry:getEntity(id)
    return self.entities[id]
end

---@param id string
---@return IMap
function Registry:getMap(id)
    return self.maps[id]
end


return Registry
