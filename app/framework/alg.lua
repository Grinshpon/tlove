local Mod = {Vector3 = {}, Vector3i = {}, Transform = {}, }










local Vector3 = Mod.Vector3
local Vector3i = Mod.Vector3i
local Transform = Mod.Transform

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




function Mod.tIx(row, col)
   return (row - 1) * 3 + col
end

function Transform.new()
   local res = setmetatable({ 1, 0, 0, 0, 1, 0, 0, 0, 1 }, { __index = Transform })
   return res
end

function Transform.copy(t)
   local res = setmetatable({ 0, 0, 0, 0, 0, 0, 0, 0, 0 }, { __index = Transform })
   for i = 1, 9 do
      res[i] = t[i]
   end
   return res
end

function Transform:get(row, col)
   return self[(row - 1) * 3 + col]
end
function Transform:set(row, col, val)
   self[(row - 1) * 3 + col] = val
   return val
end

function Transform:translate(dx, dy)
   self[3] = self[3] + dx
   self[6] = self[6] + dy
end

function Transform:scale(sx, sy)
   self[1] = self[1] * sx
   self[5] = self[5] * sy
end

function Transform:rotate(r)
   self[1] = math.cos(r) * self[1]
   self[2] = math.sin(r)
   self[4] = -math.sin(r)
   self[5] = math.cos(r) * self[5]
end

function Transform.mul(a, b)
   local res = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }

   res[1] = a[1] * b[1] + a[2] * b[4] + a[3] * b[7]
   res[2] = a[1] * b[2] + a[2] * b[5] + a[3] * b[8]
   res[3] = a[1] * b[3] + a[2] * b[6] + a[3] * b[9]

   res[4] = a[4] * b[1] + a[5] * b[4] + a[6] * b[7]
   res[5] = a[4] * b[2] + a[5] * b[5] + a[6] * b[8]
   res[6] = a[4] * b[3] + a[5] * b[6] + a[6] * b[9]

   res[7] = a[7] * b[1] + a[8] * b[4] + a[9] * b[7]
   res[8] = a[7] * b[2] + a[8] * b[5] + a[9] * b[8]
   res[9] = a[7] * b[3] + a[8] * b[6] + a[9] * b[9]

   return res
end

function Transform:mulBy(b)
   local res = self
   local a = self

   res[1] = a[1] * b[1] + a[2] * b[4] + a[3] * b[7]
   res[2] = a[1] * b[2] + a[2] * b[5] + a[3] * b[8]
   res[3] = a[1] * b[3] + a[2] * b[6] + a[3] * b[9]

   res[4] = a[4] * b[1] + a[5] * b[4] + a[6] * b[7]
   res[5] = a[4] * b[2] + a[5] * b[5] + a[6] * b[8]
   res[6] = a[4] * b[3] + a[5] * b[6] + a[6] * b[9]

   res[7] = a[7] * b[1] + a[8] * b[4] + a[9] * b[7]
   res[8] = a[7] * b[2] + a[8] * b[5] + a[9] * b[8]
   res[9] = a[7] * b[3] + a[8] * b[6] + a[9] * b[9]
end


return Mod
