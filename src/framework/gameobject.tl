local alg = require "framework/alg"
--local sidekick = import "sidekick"

local record Mod
  record GameObject
    pos: alg.Vector3i
    rot: number
    id: string
    parent: GameObject
    children: {GameObject}
    components: {Component}
    enabled: boolean
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

function GameObject.new(id: string): GameObject
  local s: GameObject = {
    pos=alg.Vector3i.new(0,0,0),
    rot=0,
    id=id,
    parent = nil,
    children = {},
    components = {},
    enabled = true,
  }
  local self = setmetatable(s, {__index = GameObject})
  return self
end

function GameObject:addComponent(c: Component)
  c.gameObject = self
  table.insert(self.components, c)
end

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

function Mod.zCmp(g1: GameObject, g2: GameObject): boolean
  if g1.pos[3] > g2.pos[3] then return true
  else return false
  end
end

return Mod
