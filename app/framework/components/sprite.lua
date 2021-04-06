local gameobject = require("framework/gameobject")
local GameObject = gameobject.GameObject
local Component = gameobject.Component


local SpriteComp = {}





local mod = {
   SpriteComp = SpriteComp,
}

local function applyTransforms(g)
   if not g then return end
   if g.parent then
      applyTransforms(g.parent)
   end
   love.graphics.applyTransform(g.transform)
end


function mod.newSprite(fp)
   local sprite = {
      gameObject = nil,
      spr = love.graphics.newImage(fp),
      origin = { 0.0, 0.0 },
      drawWorld = function(self)
         love.graphics.push()
         applyTransforms(self.gameObject.parent)
         local t = self.gameObject.transform:clone()
         t:translate(-self.origin[1], -self.origin[2])
         love.graphics.applyTransform(t)
         love.graphics.draw(self.spr)
         love.graphics.pop()
      end,
   }
   local ox, oy = (sprite.spr):getDimensions()
   sprite.origin[1] = ox / 2
   sprite.origin[2] = oy / 2
   return sprite
end

return mod
