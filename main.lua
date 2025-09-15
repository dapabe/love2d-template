local loadTimeStart = love.timer.getTime()

require('globals')

local args = {...}
local mode = args[1] or "client"

_G.IS_SERVER = mode == "server"
_G.IS_CLIENT = not _G.IS_SERVER


function love.load()
  if CONFIG.window.icon ~= nil then
    love.window.setIcon(love.image.newImageData(CONFIG.window.icon))
  end

  SceneManager:hook()

  if CONFIG.showSplash then
    SceneManager:enter(SceneList.Splash)
  end

  if not CONFIG.showSplash then
    SceneManager:enter(SceneList.MainMenu)
  end

  if DEBUG then
    local loadTimeEnd = love.timer.getTime()
    local loadTime = (loadTimeEnd - loadTimeStart)
    print(("Loaded game in %.3f seconds."):format(loadTime))
  end
end

-- useful for dev
HMR.postswap = function(fileName)
  love.event.quit("restart")
end

function love.update(dt)
  HMR.update()
end

function love.draw()
  local drawTimeStart = love.timer.getTime()
  -- call draw?
  local drawTimeEnd = love.timer.getTime()
  local drawTime = drawTimeEnd - drawTimeStart

  if DEBUG then require("src.utils.debugStats")(drawTime) end
end

function love.keypressed(key, code, isRepeat)
  if not RELEASE and code == CONFIG.debug.key then
    DEBUG = not DEBUG
  end
end

function love.threaderror(thread, errorMessage)
  print("Thread error!\n" .. errorMessage)
end
