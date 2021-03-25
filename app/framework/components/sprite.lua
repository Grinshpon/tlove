local gameobject = require("framework/gameobject")
local GameObject = gameobject.GameObject
local Component = gameobject.Component

local mod = {}

local SpriteComp = {}





function mod.newSprite(fp)
   local sprite = {
      gameObject = nil,
      spr = love.graphics.newImage(fp),
      origin = { 0.0, 0.0 },
      drawWorld = function(self)
         local t = self.gameObject:getTransform()
         local x, y = t:get(1, 3), t:get(2, 3)
         local sx, sy = t:get(1, 1), t:get(2, 2)

         love.graphics.draw(self.spr, x, y, 0, sx, sy, self.origin[1], self.origin[2])
      end,
   }
   local ox, oy = (sprite.spr):getDimensions()
   sprite.origin[1] = ox / 2
   sprite.origin[2] = oy / 2
   return sprite
end

return mod
