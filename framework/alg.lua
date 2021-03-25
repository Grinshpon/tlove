local Mod = {Vector3 = {}, Vector3i = {}, }







local Vector3 = Mod.Vector3
local Vector3i = Mod.Vector3i

function Vec3IX(t, key)
   if math.type(key) == "integer" then
      return rawget(t, key)
   else
      if key == "x" then return rawget(t, 1)
      elseif key == "y" then return rawget(t, 2)
      elseif key == "z" then return rawget(t, 3)
      else error("Invalid vector access")
      end
   end
end

function Vector3.new(x, y, z)
   local s = { x, y, z }
   local self = setmetatable(s, { __index = Vec3IX })
   return self
end

function Vec3iIX(t, key)
   if math.type(key) == "integer" then
      return rawget(t, key)
   else
      if key == "x" then return rawget(t, 1)
      elseif key == "y" then return rawget(t, 2)
      elseif key == "z" then return rawget(t, 3)
      else error("Invalid vector access")
      end
   end
end

function Vector3i.new(x, y, z)
   local s = { x, y, z }
   local self = setmetatable(s, { __index = Vec3iIX })
   return self
end

return Mod
