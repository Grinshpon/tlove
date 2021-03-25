local alg = require("framework/alg")


local Mod = {GameObject = {}, Component = {}, }





















local GameObject = Mod.GameObject
local Component = Mod.Component

function GameObject.new(o)
   local g = nil
   if type(o) == "string" then
      g = {
         pos = alg.Vector3i.new(0, 0, 0),
         rot = 0,
         scale = 1,
         id = o,
         parent = nil,
         children = {},
         components = {},
         enabled = true,
      }
   else
      g = o
      g.pos = g.pos or alg.Vector3i.new(0, 0, 0)
      g.rot = g.rot or 0
      g.scale = g.scale or 1
      g.id = g.id or "game object"
      g.children = g.children or {}
      g.components = g.components or {}
      g.enabled = g.enabled or true
      for _, c in ipairs(g.components) do
         c.gameObject = g
      end
   end
   local self = setmetatable(g, { __index = GameObject })
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

function GameObject:getScale()
   local s = self.scale
   local p = self.parent
   while p do
      s = s * p.scale
      p = p.parent
   end
   return s
end

function Mod.zCmp(g1, g2)
   local _, _, z1 = g1:position()
   local _, _, z2 = g2:position()
   if z1 > z2 then return true
   else return false
   end
end

return Mod
