local alg = require("framework/alg")


local Mod = {GameObject = {}, Component = {}, }




















local GameObject = Mod.GameObject
local Component = Mod.Component

function GameObject.new(id)
   local s = {
      pos = alg.Vector3i.new(0, 0, 0),
      rot = 0,
      id = id,
      parent = nil,
      children = {},
      components = {},
      enabled = true,
   }
   local self = setmetatable(s, { __index = GameObject })
   return self
end

function GameObject:addComponent(c)
   c.gameObject = self
   table.insert(self.components, c)
end

function GameObject:position()
   local x, y, z = self.pos[1], self.pos[2], self.pos[3]
   local p = self.parent
   while p do
      x, y, z = x + p.pos[1], y + p.pos[2], z + p.pos[3]
      p = p.parent
   end
   return x, y, z
end

function GameObject:rotation()
   local r = self.rot
   local p = self.parent
   while p do
      r = r + p.rot
      p = p.parent
   end
   return r
end

function Mod.zCmp(g1, g2)
   if g1.pos[3] > g2.pos[3] then return true
   else return false
   end
end

return Mod
