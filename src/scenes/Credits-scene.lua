
---@class IScene
local CreditsScene = {}

local font
local screenWidth
local screenHeight

local startingPosition = { y = 0 }

-- `previous` - the previously active scene, or `false` if there was no previously active scene
-- `...` - additional arguments passed to `manager.enter` or `manager.push`
function CreditsScene:enter(previous, ...)
  -- set up the level
  love.graphics.setBackgroundColor(colors.rgbForGraphics(colors.Gray700))

  font = love.graphics.newFont(24)
  love.graphics.setFont(font)

  -- Store screen dimensions
  screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

  startingPosition.y = screenHeight / 3
end

function CreditsScene:update(dt)
  -- update entities
  flux.update(dt)
end

function CreditsScene:keypressed(key)
  -- someone pressed a key
  -- pressing any key closes the CreditsScene
  if key then
    SceneManager:push(SceneList.MainMenu)
  end
end

function CreditsScene:mousepressed()
  -- skip on click
  SceneManager:push(SceneList.MainMenu)
end

-- `next` - the scene that will be active next
-- `...` - additional arguments passed to `manager.enter` or `manager.pop`
function CreditsScene:leave(next, ...)
  -- destroy entities and cleanup resources
  font, screenWidth, screenHeight, startingPosition = nil, nil, nil, nil
end

-- `next` - the scene that was pushed on top of this scene
-- `...` - additional arguments passed to `manager.push`
function CreditsScene:pause(next, ...)
  -- destroy entities and cleanup resources
end

-- `previous` - the scene that was popped
-- `...` - additional arguments passed to `manager.pop`
function CreditsScene:resume(previous, ...)
  -- Called when a scene is popped and this scene becomes active again.
end

function CreditsScene:draw()
  flux.to(startingPosition, 30, { y = -1000 }):ease("linear"):delay(2):oncomplete(function ()
    SceneManager:push(SceneList.MainMenu)
  end)

  -- Print centered text
  love.graphics.printf(
    "Credits",
    0, startingPosition.y - font:getHeight() / 2,
    screenWidth, "center"
  )
end

return CreditsScene