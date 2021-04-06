local alg = require "framework/alg"
local Transform = love.math.Transform
--local sidekick = import "sidekick"

local record Mod
  record GameObject
    pos: alg.Vector2 --local position
    rot: number -- local rotation
    scale: number -- local scale
    z: integer
    transform: Transform -- local transformation matrix
    id: string
    body: love.physics.Body
    parent: GameObject
    children: {GameObject}
    components: {Component}
    enabled: boolean
    dirty: boolean
  end
  zCmp: function(g1: GameObject, g2: GameObject): boolean

  record Component
    gameObject: GameObject
    load: function<T>(T)
    update: function<T>(T, number)
    drawWorld: function<T>(T)
    drawUI: function<T>(T)
    drawRaw: function<T>(T)
  end
end
local GameObject = Mod.GameObject
local Component = Mod.Component

local GO_mt = {__index = GameObject}

function GameObject.new(o: string | GameObject): GameObject
  local g: GameObject = nil
  if o is string then
    g = {
      pos = alg.Vector2.new(0,0),
      rot = 0,
      scale = 1,
      z = 0,
      transform = love.math.newTransform(),
      id=o,
      body = nil,
      parent = nil,
      children = {},
      components = {},
      enabled = true,
      dirty = true,
    }
  else
    g = o
    g.pos = g.pos or alg.Vector2.new(0,0)
    g.scale = g.scale or 1
    g.z = g.z or 0
    g.transform = g.transform or love.math.newTransform()
    g.id = g.id or "game object"
    g.children = g.children or {}
    g.components = g.components or {}
    g.enabled = g.enabled or true
    g.dirty = true
    for _,c in ipairs(g.components) do
      c.gameObject = g
    end
  end
  local self = setmetatable(g, GO_mt)
  return self
end

function GameObject:addComponent(c: Component)
  c.gameObject = self
  table.insert(self.components, c)
end

function GameObject:addBody(body: love.physics.Body)
  self.body = body
end

function GameObject:getTransform(): Transform
  --return self.transform
  --local t = love.math.newTransform()
  local t = self.transform:clone()
  local p = self.parent
  --t:apply(self.transform)
  while p do
    t:apply(p.transform)
    p = p.parent
  end
  return t
end

function GameObject:getGlobalTransform(t: Transform): Transform
  if not t then t = love.math.newTransform() end
  if self.parent then
    t = self.parent:getGlobalTransform(t)
  end
  t:apply(self.transform)
  return t
end

function GameObject:move(dx: number, dy: number)
  self.pos[1], self.pos[2] = self.pos[1]+dx, self.pos[2]+dy
  if self.body then
    local x,y = self.body:getPosition()
    self.body:setPosition(x,y)
  end
  self.dirty = true
  --self.transform:translate(dx,dy)
end

function GameObject:moveLocal(dx: number, dy: number)
  local t = self:getTransform()
  local x,y = t:transformPoint(0,0)
  dx,dy = t:inverseTransformPoint(x+dx,y+dy)
  self:move(dx,dy)
  --self.transform:translate(dx,dy)
end

function GameObject:rotate(theta: number)
  self.rot = self.rot + theta
  if self.body then
    local angle = self.body:getAngle()
    self.body:setAngle(angle+theta)
  end
  self.dirty = true
  --self.transform:rotate(theta)
end

function GameObject:updateTransform()
  if self.dirty then
    self.transform:setTransformation(self.pos[1], self.pos[2], self.rot, self.scale, self.scale)
    self.dirty = false
  end
end

function GameObject:globalPos(): number,number
  self:updateTransform()
  return self:getTransform():transformPoint(0,0)
end

--[[
function GameObject:position(): integer, integer, integer
  local x,y,z = self.pos[1], self.pos[2], self.pos[3]
  local p = self.parent
  while p do
    x,y,z = x+p.pos[1], y+p.pos[2], z+p.pos[3]
    p = p.parent
  end
  return x,y,z
end

function GameObject:rotation(): number
  local r = self.rot
  local p = self.parent
  while p do
    r = r+p.rot
    p = p.parent
  end
  return r
end

function GameObject:getScale(): number
  local s = self.scale
  local p = self.parent
  while p do
    s = s*p.scale
    p = p.parent
  end
  return s
end
--]]

function GameObject:order(): integer
  local z = self.z
  local p = self.parent
  while p do
    z = z+p.z
    p = p.parent
  end
  return z
end

function Mod.zCmp(g1: GameObject, g2: GameObject): boolean
  local z1 = g1:order()
  local z2 = g2:order()
  if z1 < z2 then return true
  else return false
  end
end

return Mod
