
---@param drawTime number
local function debugStats(drawTime)
    love.graphics.push()
    local x, y = CONFIG.debug.stats.position.x, CONFIG.debug.stats.position.y
    local dy = CONFIG.debug.stats.lineHeight
    local stats = love.graphics.getStats()
    local memoryUnit = "KB"
    local ram = collectgarbage("count")
    local vram = stats.texturememory / 1024
    if not CONFIG.debug.stats.kilobytes then
      ram = ram / 1024
      vram = vram / 1024
      memoryUnit = "MB"
    end
    local info = {
      "FPS: " .. ("%3d"):format(love.timer.getFPS()),
      "DRAW: " .. ("%7.3fms"):format(lume.round(drawTime * 1000, .001)),
      "RAM: " .. string.format("%7.2f", lume.round(ram, .01)) .. memoryUnit,
      "VRAM: " .. string.format("%6.2f", lume.round(vram, .01)) .. memoryUnit,
      "Draw calls: " .. stats.drawcalls,
      "Images: " .. stats.images,
      "Canvases: " .. stats.canvases,
      "\tSwitches: " .. stats.canvasswitches,
      "Shader switches: " .. stats.shaderswitches,
      "Fonts: " .. stats.fonts,
    }

    love.graphics.setFont(love.graphics.newFont(12))
    for i, text in ipairs(info) do
      local sx, sy = CONFIG.debug.stats.shadowOffset.x, CONFIG.debug.stats.shadowOffset.y
      love.graphics.setColor(CONFIG.debug.stats.shadow)
      love.graphics.print(text, x + sx, y + sy + (i - 1) * dy)
      love.graphics.setColor(CONFIG.debug.stats.foreground)
      love.graphics.print(text, x, y + (i - 1) * dy)
    end

    love.graphics.pop()
end

return debugStats