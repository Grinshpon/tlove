local gameobject = require "framework/gameobject"
local GameObject = gameobject.GameObject
local Component = gameobject.Component


local record SpriteComp
  gameObject: GameObject
  spr: love.graphics.Texture
  origin: {number}
end

local mod = {
  SpriteComp = SpriteComp
}

local function applyTransforms(g: GameObject)
  if not g then return end
  if g.parent then
    applyTransforms(g.parent)
  end
  love.graphics.applyTransform(g.transform)
end

-- TODO: pull out draw logic into generic drawTexture function
function mod.newSprite(fp: string): Component
  local sprite = {
    gameObject = nil,
    spr = love.graphics.newImage(fp),
    origin = {0.0,0.0},
    drawWorld = function(self: SpriteComp)
      love.graphics.push()
      applyTransforms(self.gameObject.parent)
      local t = self.gameObject.transform:clone()
      t:translate(-self.origin[1], -self.origin[2])
      love.graphics.applyTransform(t)
      love.graphics.draw(self.spr as love.graphics.Drawable)--, t)
      love.graphics.pop()
    end,
  }
  local ox,oy = (sprite.spr as love.graphics.Texture):getDimensions()
  sprite.origin[1] = ox/2
  sprite.origin[2] = oy/2
  return sprite as Component
end

return mod
