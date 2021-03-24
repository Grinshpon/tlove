local alg = require "alg"

local record Mod
  record GameObject
    pos: alg.Vector3i
    rot: number
    parent: GameObject
    children: {GameObject}
  end
  zCmp: function(g1: GameObject, g2: GameObject): integer
end
local GameObject = Mod.GameObject

function GameObject.new(): GameObject
  local s: GameObject = {pos=alg.Vector3i.new(0,0,0), rot=0, parent = nil, children = {}}
  local self = setmetatable(s, {__index = GameObject})
  return self
end

function Mod.zCmp(g1: GameObject, g2: GameObject): integer
  if g1.pos[3] > g2.pos[3] then return 1
  elseif g1.pos[3] < g2.pos[3] then return -1
  else return 0
  end
end

return Mod
