local alg = require("framework/alg")
local Transform = love.math.Transform


local Mod = {GameObject = {}, Component = {}, }

























local GameObject = Mod.GameObject
local Component = Mod.Component

local GO_mt = { __index = GameObject }

function GameObject.new(o)
   local g = nil
   if type(o) == "string" then
      g = {
         pos = alg.Vector2.new(0, 0),
         rot = 0,
         scale = alg.Vector2.new(1, 1),
         z = 0,
         transform = love.math.newTransform(),
         id = o,
         body = nil,
         parent = nil,
         children = {},
         components = {},
         enabled = true,
         dirty = true,
      }
   else
      g = o
      g.pos = g.pos or alg.Vector2.new(0, 0)
      g.rot = g.rot or 0
      g.scale = g.scale or alg.Vector2.new(1, 1)
      g.z = g.z or 0
      g.transform = love.math.newTransform(g.pos[1], g.pos[2], g.rot, g.scale[1], g.scale[2])
      g.id = g.id or "game object"
      g.children = g.children or {}
      g.components = g.components or {}
      g.enabled = g.enabled or true
      g.dirty = true
      for _, c in ipairs(g.components) do
         c.gameObject = g
      end
   end
   local self = setmetatable(g, GO_mt)
   return self
end

function GameObject:addComponent(c)
   c.gameObject = self
   table.insert(self.components, c)
end

function GameObject:addBody(body)
   self.body = body
end


function GameObject:getTransform()
   print("Do not use getTransform, it is incorrect. use getGlobalTransform instead")


   local t = self.transform:clone()
   local p = self.parent

   while p do
      t:apply(p.transform)
      p = p.parent
   end
   return t
end

function GameObject:getGlobalTransform(t)
   if not t then t = love.math.newTransform() end
   if self.parent then
      t = self.parent:getGlobalTransform(t)
   end
   t:apply(self.transform)
   return t
end

function GameObject:move(dx, dy)
   self.pos[1], self.pos[2] = self.pos[1] + dx, self.pos[2] + dy




   self.dirty = true
end

function GameObject:moveLocal(dx, dy)
   local t = self:getTransform()
   local x, y = t:transformPoint(0, 0)
   dx, dy = t:inverseTransformPoint(x + dx, y + dy)
   self:move(dx, dy)
end

function GameObject:rotate(theta)
   self.rot = self.rot + theta




   self.dirty = true
end

function GameObject:scaleBy(sx, sy)
   self.scale[1] = self.scale[1] * sx
   self.scale[2] = self.scale[2] * sy
   self.dirty = true
end

function GameObject:updateTransform()
   if self.dirty then
      self.transform:setTransformation(self.pos[1], self.pos[2], self.rot, self.scale[1], self.scale[2])
      self.dirty = false
   end
end

function GameObject:globalPos()
   if self.dirty then
      self.transform:setTransformation(self.pos[1], self.pos[2], self.rot, self.scale[1], self.scale[2])
   end
   return self:getGlobalTransform():transformPoint(0, 0)
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
   return z1 < z2
end

return Mod
