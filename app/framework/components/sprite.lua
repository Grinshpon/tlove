local gameobject = require("framework/gameobject")
local GameObject = gameobject.GameObject
local Component = gameobject.Component

local mod = {}

local SpriteComp = {}




function mod.newSprite(fp)
   local sprite = {
      gameObject = nil,
      spr = love.graphics.newImage(fp),
      drawWorld = function(self)
         local x, y = self.gameObject:position()
         love.graphics.draw(self.spr, x, y, self.gameObject:rotation())
      end,
   }
   return sprite
end

return mod
