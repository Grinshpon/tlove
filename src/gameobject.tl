local alg = require "alg"
--local sidekick = require "sidekick"

local record Mod
  record GameObject
    pos: alg.Vector3i
    rot: number
    id: string
    parent: GameObject
    children: {GameObject}
    enabled: boolean
  end
  zCmp: function(g1: GameObject, g2: GameObject): boolean
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
