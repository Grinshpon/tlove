local gameobject = require "framework/gameobject"
local GameObject = gameobject.GameObject
local Component = gameobject.Component

local mod = {}

local record SpriteComp
  gameObject: GameObject
  spr: love.graphics.Texture
  origin: {number}
 end

function mod.newSprite(fp: string): Component
  local sprite = {
    gameObject = nil,
    spr = love.graphics.newImage(fp),
    origin = {0.0,0.0},
    drawWorld = function(self: SpriteComp)
      local t = self.gameObject:getTransform()
      local x,y = t:get(1,3), t:get(2,3)
      local sx,sy = t:get(1,1), t:get(2,2)
      --rotation is placeholder
      love.graphics.draw(self.spr as love.graphics.Drawable, x,y, 0, sx,sy, self.origin[1], self.origin[2])
    end,
  }
  local ox,oy = (sprite.spr as love.graphics.Texture):getDimensions()
  sprite.origin[1] = ox/2
  sprite.origin[2] = oy/2
  return sprite as Component
end

return mod
