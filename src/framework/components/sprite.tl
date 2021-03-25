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
      --local t = self.gameObject:getTransform()
      local t = self.gameObject.transform
      local p = self.gameObject.parent
      local i: integer = 0
      --love.graphics.push()
      --love.graphics.translate(self.gameObject.offset[1],self.gameObject.offset[2])
      --love.graphics.applyTransform(t)
      while p do
        i = i+1
        t = p.transform
        love.graphics.push()
        --love.graphics.translate(-p.offset[1],-p.offset[2])
        love.graphics.applyTransform(t)
        p = p.parent
        --if p then t = p.transform end
      end
      --local x,y = t:get(1,1) + t:get(1,2) + t:get(1,3), t:get(2,1) + t:get(2,2) + t:get(2,3)
      --local x,y = t:get(1,3), t:get(2,3)
      --local sx,sy = t:get(1,1), t:get(2,2)
      --rotation is placeholder
      --love.graphics.draw(self.spr as love.graphics.Drawable, x,y, 0, sx,sy, self.origin[1], self.origin[2])
      --love.graphics.draw(self.spr as love.graphics.Drawable, t, self.origin[1], self.origin[2])
      --t:translate(-self.origin[1],-self.origin[2])
      t = self.gameObject.transform:clone()
      t:translate(-self.origin[1], -self.origin[2])
      love.graphics.draw(self.spr as love.graphics.Drawable, t)--self.gameObject.transform)
      --t:translate(self.origin[1],self.origin[2])
      while i > 0 do
        love.graphics.pop()
        i = i - 1
      end
    end,
  }
  local ox,oy = (sprite.spr as love.graphics.Texture):getDimensions()
  sprite.origin[1] = ox/2
  sprite.origin[2] = oy/2
  return sprite as Component
end

return mod
