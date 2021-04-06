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
         scale = 1,
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
      g.scale = g.scale or 1
      g.z = g.z or 0
      g.transform = g.transform or love.math.newTransform()
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
   if self.body then
      local x, y = self.body:getPosition()
      self.body:setPosition(x, y)
   end
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
   if self.body then
      local angle = self.body:getAngle()
      self.body:setAngle(angle + theta)
   end
   self.dirty = true

end

function GameObject:updateTransform()
   if self.dirty then
      self.transform:setTransformation(self.pos[1], self.pos[2], self.rot, self.scale, self.scale)
      self.dirty = false
   end
end

function GameObject:globalPos()
   self:updateTransform()
   return self:getTransform():transformPoint(0, 0)
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
