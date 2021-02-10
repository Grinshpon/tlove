local alg = require("alg")

local Mod = {GameObject = {}, }





local GameObject = Mod.GameObject

function GameObject.new()
   local s = { pos = alg.Vector3.new(0, 0, 0), rot = 0 }
   local self = setmetatable(s, { __index = GameObject })
   return self
end

return Mod
