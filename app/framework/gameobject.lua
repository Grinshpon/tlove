
local Transform = love.math.Transform


local Mod = {GameObject = {}, Component = {}, }
























local GameObject = Mod.GameObject
local Component = Mod.Component

local GO_mt = { __index = GameObject }

function GameObject.new(o)
   local g = nil
   if type(o) == "string" then
      g = {
         transform = love.math.newTransform(),
         z = 0,
         id = o,
         body = nil,
         parent = nil,
         children = {},
         components = {},
         enabled = true,
      }
   else
      g = o
      g.transform = g.transform or love.math.newTransform()
      g.z = g.z or 0
      g.id = g.id or "game object"
      g.children = g.children or {}
      g.components = g.components or {}
      g.enabled = g.enabled or true
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
   local t = love.math.newTransform()
   local p = self.parent
   while p do
      t:apply(p.transform)
      p = p.parent
   end
   t:apply(self.transform)
   return t
end

function GameObject:move(dx, dy)
   if self.body then
      local x, y = self.body:getPosition()
      self.body:setPosition(x + dx, y + dy)
   end
   self.transform:translate(dx, dy)
end

function GameObject:rotate(theta)
   if self.body then
      local angle = self.body:getAngle()
      self.body:setAngle(angle + theta)
   end
   self.transform:rotate(theta)
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
