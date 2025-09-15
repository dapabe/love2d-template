local Entity = require("src.shared.Entity")


local JUMP_FORCE = -400
local MOVE_SPEED = 200
local FLOOR_Y = 500

---@class IPlayerEntity
local PlayerEntity = Class{
    __includes = Entity
}


function PlayerEntity:init()
    
    self.position = spawnPos or Vector.zero
    self.velocity = Vector.zero
    self.onGround = false
    
    if IS_CLIENT then
        self.spriteData = love.graphics.newImage("assets/sprites/player.png")
    end
end

function PlayerEntity:Update()
end

if IS_SERVER then
    function PlayerEntity:PhysicsUpdate(dt)
        -- Server-side physics update
        -- Apply gravity
        self.velocity = self.velocity + Vector(0, 400 * dt)
        self.position = self.position + (self.velocity * dt)
        
        -- Floor collision
        if self.position.y + self.size.y >= FLOOR_Y then
            self.position.y = FLOOR_Y - self.size.y
            self.velocity.y = 0
            self.onGround = true
        else 
            self.onGround = false
        end
    end

    function PlayerEntity:PerformUserCommand(cmd)
        if cmd.moveLeft then
            self.velocity.x = -MOVE_SPEED
        elseif cmd.moveRight then
            self.velocity.x = MOVE_SPEED
        else
            self.velocity.x = 0
        end

        if cmd.jump and self.onGround then
            self.velocity.y = JUMP_FORCE
            self.onGround = false
        end
    end
end

-- Client-side methods
if IS_CLIENT then
    function PlayerEntity:Draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.spriteData, self.position.x, self.position.y, 0, 2, 2)
    end

    function PlayerEntity:CreateUserCommand()
        -- Create command to send to server
        local cmd = {
            moveLeft = love.keyboard.isDown("a"),
            moveRight = love.keyboard.isDown("d"),
            jump = love.keyboard.isDown("space")
        }
        return cmd
    end
end

return PlayerEntity