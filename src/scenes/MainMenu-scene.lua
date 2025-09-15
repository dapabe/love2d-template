local button = require 'src.ui.components.button'
local label  = require 'src.ui.components.label'

---@class IScene
local MainMenuScene = {}
local menu

function MainMenuScene:enter(previous, ...)
  -- set up the level
  love.graphics.setBackgroundColor(colors.rgbForGraphics(colors.Slate800))

  local clicks = 0
  menu = GUI { column = true, gap = 10 }
      + label({ text = "Main Menu", width = 200 })
      + button {
        text = 'New game',
        width = 200,
        onClick = function()
          SceneManager:push(require("src.scenes.PlayableMap-scene"), "listen")
        end,
        -- onHover = function()
        --   print 'mouse entered'
        --   return function()
        --     print('mouse exited')
        --   end
        -- end
      }
      + button {
        text = 'Connect',
        width = 200,
        onClick = function()
          SceneManager:push(require("src.scenes.PlayableMap-scene"), "client")
        end
      }
      + button { text = 'Settings', width = 200, onClick = function()
        local success = love.window.showMessageBox("Settings", "Not implemented", "info")
        if success then
          print("Settings message box closed")
        end
      end }
      + button { text = 'Credits', width = 200, onClick = function()
        SceneManager:push(SceneList.Credits)
      end }
      + button { text = 'Quit', width = 200, onClick = function() love.event.quit() end }
      + button {
        text = 'Clicked: 0',
        width = 200,
        onClick = function(self)
          clicks = clicks + 1
          self.text = 'Clicked: ' .. clicks
        end
      }
      + button {
        text = 'Click to remove',
        onClick = function(self)
          self.parent = self.parent - self
          love.mouse.setCursor()
        end
      }

  menu:updatePosition(
    love.graphics.getWidth() * 0.5 - menu.width * 0.5,
    love.graphics.getHeight() * 0.5 - menu.height * 0.5
  )
end

function MainMenuScene:update(dt)
  -- update entities
  menu:update()
end

function MainMenuScene:keypressed(key)
  -- someone pressed a key
end

function MainMenuScene:leave(next, ...)
  -- destroy entities and cleanup resources
end

function MainMenuScene:pause(next, ...)
  -- destroy entities and cleanup resources
end

function MainMenuScene:resume(previous, ...)
  -- Called when a scene is popped and this scene becomes active again.
end

function MainMenuScene:draw()
  -- draw the level
  menu:draw()
end

return MainMenuScene
