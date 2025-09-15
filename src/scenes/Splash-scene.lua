
---@class IScene
local SplashScene = {}

local font
local screenWidth
local screenHeight

local timer = step.after(3)

function SplashScene:enter(previous, ...)
  love.graphics.setBackgroundColor(colors.black)

  font = love.graphics.newFont(24)
  love.graphics.setFont(font)

  -- Store screen dimensions
  screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
end

function SplashScene:update(dt)
  -- update entities
  if timer:update(dt) then
    SceneManager:push(SceneList.MainMenu)
  end
end

function SplashScene:keypressed(key)
  -- pressing any key skips the SplashScene
  if key then
    SceneManager:push(SceneList.MainMenu)
  end
end

function SplashScene:mousepressed()
  -- skip on click
  SceneManager:push(SceneList.MainMenu)
end


function SplashScene:leave(next, ...)
  -- destroy entities and cleanup resources
  font, screenWidth, screenHeight, timer = nil, nil, nil, nil
end


function SplashScene:pause(next, ...)
  -- destroy entities and cleanup resources
end


function SplashScene:resume(previous, ...)

end

function SplashScene:draw()
  -- Calculate center position
  local centerY = screenHeight / 2

  -- Print centered text
  love.graphics.printf(
    "Splash Screen",
    0, centerY - font:getHeight() / 2,
    screenWidth, "center"
  )
end

return SplashScene