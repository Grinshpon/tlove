local alg = require("framework/alg")
local Transform = alg.Transform


local Mod = {GameObject = {}, Component = {}, }























local GameObject = Mod.GameObject
local Component = Mod.Component

function GameObject.new(o)
   local g = nil
   if type(o) == "string" then
      g = {



         transform = Transform.new(),
         z = 0,
         id = o,
         parent = nil,
         children = {},
         components = {},
         enabled = true,
      }
   else
      g = o



      g.transform = g.transform or Transform.new()
      g.z = g.z or 0
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

function GameObject:getTransform()
   local t = self.transform:copy()
   local p = self.parent
   while p do
      t:mulBy(p.transform)
      p = p.parent
   end
   return t
end

































function GameObject:order()
   local z = self.z
   local p = self.parent
   while p do
      z = z + p.z
      p = p.parent
   end
   return z
end

function Mod.zCmp(g1, g2)
   local z1 = g1:order()
   local z2 = g2:order()
   if z1 < z2 then return true
   else return false
   end
end

return Mod
