local alg = require "framework/alg"
local Transform = love.math.Transform
--local sidekick = import "sidekick"

local record Mod
  record GameObject
    pos: alg.Vector2 --local position
    rot: number -- local rotation
    scale: alg.Vector2 -- local scale
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
      scale = alg.Vector2.new(1,1),
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
    g.rot = g.rot or 0
    g.scale = g.scale or alg.Vector2.new(1,1)
    g.z = g.z or 0
    g.transform = love.math.newTransform(g.pos[1],g.pos[2], g.rot, g.scale[1], g.scale[2])
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

--rename to TotalTransform?
function GameObject:getGlobalTransform(t: Transform): Transform
  if not t then t = love.math.newTransform() end
  if self.parent then
    t = self.parent:getGlobalTransform(t)
  end
  t:apply(self.transform)
  return t
end

function GameObject:getTransform(): Transform
  local t = love.math.newTransform()
  if self.parent then
    t = self.parent:getGlobalTransform(t)
  end
  return t
end

function GameObject:move(dx: number, dy: number)
  self.pos[1], self.pos[2] = self.pos[1]+dx, self.pos[2]+dy
  self.dirty = true
end

function GameObject:setPos(x: number, y: number)
  self.pos[1] = x
  self.pos[2] = y
  self.dirty = true
end

function GameObject:moveLocal(dx: number, dy: number)
  local t = self:getGlobalTransform()
  local x,y = t:transformPoint(0,0)
  dx,dy = t:inverseTransformPoint(x+dx,y+dy)
  self:move(dx,dy)
end

function GameObject:rotate(theta: number)
  self.rot = self.rot + theta
  self.dirty = true
end

function GameObject:scaleBy(sx: number, sy: number)
  self.scale[1] = self.scale[1] * sx
  self.scale[2] = self.scale[2] * sy
  self.dirty = true
end

function GameObject:updateTransform()
  if self.dirty then
    self.transform:setTransformation(self.pos[1], self.pos[2], self.rot, self.scale[1], self.scale[2])
    for _,c in ipairs(self.children) do
      c.dirty = true
      c:updateTransform()
    end
    self.dirty = false
  end
end

function GameObject:quietUpdateTransform()
  if self.dirty then
    self.transform:setTransformation(self.pos[1], self.pos[2], self.rot, self.scale[1], self.scale[2])
  end
end

function GameObject:globalPos(): number,number
  self:quietUpdateTransform()
  return self:getGlobalTransform():transformPoint(0,0)
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
  return z1 < z2
end

return Mod
