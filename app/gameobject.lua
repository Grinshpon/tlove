local alg = require("alg")


local Mod = {GameObject = {}, }










local GameObject = Mod.GameObject

function GameObject.new(id)
   local s = {
      pos = alg.Vector3i.new(0, 0, 0),
      rot = 0,
      id = id,
      parent = nil,
      children = {},
      enabled = true,
   }
   local self = setmetatable(s, { __index = GameObject })
   return self
end

function Mod.zCmp(g1, g2)
   if g1.pos[3] > g2.pos[3] then return true
   else return false
   end
end

return Mod
