local gameobject = require("framework/gameobject")
local GameObject = gameobject.GameObject
local Component = gameobject.Component


local SpriteComp = {}





local mod = {
   SpriteComp = SpriteComp,
}


function mod.newSprite(fp)
   local sprite = {
      gameObject = nil,
      spr = love.graphics.newImage(fp),
      origin = { 0.0, 0.0 },
      drawWorld = function(self)
         local t = self.gameObject.transform
         local p = self.gameObject.parent
         local i = 0
         while p do
            i = i + 1
            t = p.transform
            love.graphics.push()
            love.graphics.applyTransform(t)
            p = p.parent
         end
         t = self.gameObject.transform:clone()
         t:translate(-self.origin[1], -self.origin[2])
         love.graphics.draw(self.spr, t)
         while i > 0 do
            love.graphics.pop()
            i = i - 1
         end
      end,
   }
   local ox, oy = (sprite.spr):getDimensions()
   sprite.origin[1] = ox / 2
   sprite.origin[2] = oy / 2
   return sprite
end

return mod
