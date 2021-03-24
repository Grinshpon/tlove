local alg = require "alg"
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
    load: function(Component)
    update: function(Component, number)
    drawWorld: function(Component)
    drawUI: function(Component)
    drawRaw: function(Component)
  end
end
local GameObject = Mod.GameObject

function GameObject.new(id: string): GameObject
  local s: GameObject = {
    pos=alg.Vector3i.new(0,0,0),
    rot=0,
    id=id,
    parent = nil,
    children = {},
    enabled = true,
  }
  local self = setmetatable(s, {__index = GameObject})
  return self
end

function Mod.zCmp(g1: GameObject, g2: GameObject): boolean
  if g1.pos[3] > g2.pos[3] then return true
  else return false
  end
end

return Mod
