local alg = require "alg"

local record Mod
  record GameObject
    pos: alg.Vector3
    rot: number
  end
end
local GameObject = Mod.GameObject

function GameObject.new(): GameObject
  local s: GameObject = {pos=alg.Vector3.new(0,0,0), rot=0}
  local self = setmetatable(s, {__index = GameObject})
  return self
end

return Mod
