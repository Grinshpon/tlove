local gameobject = require "framework/gameobject"
local GameObject = gameobject.GameObject
local Component = gameobject.Component

local mod = {}

local record SpriteComp
  gameObject: GameObject
  spr: love.graphics.Texture
 end

function mod.newSprite(fp: string): Component
  local sprite = {
    gameObject = nil,
    spr = love.graphics.newImage(fp),
    drawWorld = function(self: SpriteComp)
      local x,y = self.gameObject:position()
      love.graphics.draw(self.spr as love.graphics.Drawable, x,y, self.gameObject:rotation(), self.gameObject:getScale())
    end,
  }
  return sprite as Component
end

return mod
