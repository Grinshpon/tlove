local record Mod
  record Vector3
    {number}
    metamethod __index: function(Vector3i, integer | string): number
  end
  record Vector3i
    {integer}
    metamethod __index: function(Vector3i, integer | string): integer
  end
  record Vector2
    {number}
    metamethod __index: function(Vector2, integer | string): number
  end
  record Vector2i
    {integer}
    metamethod __index: function(Vector2i, integer | string): integer
  end
end
local Vector3 = Mod.Vector3
local Vector3i = Mod.Vector3i
local Vector2i = Mod.Vector2i
local Vector2 = Mod.Vector2
--local Transform = Mod.Transform

function Vec3IX(t: Vector3, key: integer | string): number
  if key is integer then
    return rawget(t,key)
  else
    if key == "x" then return rawget(t,1)
    elseif key == "y" then return rawget(t,2)
    elseif key == "z" then return rawget(t,3)
    else error("Invalid vector access")
    end
  end
end

function Vector3.new(x: number, y: number, z: number): Vector3
  local s: Vector3 = {x,y,z}
  local self = setmetatable(s, {__index=Vec3IX})
  return self
end

function Vec3iIX(t: Vector3i, key: integer | string): integer
  if key is integer then
    return rawget(t,key)
  else
    if key == "x" then return rawget(t,1)
    elseif key == "y" then return rawget(t,2)
    elseif key == "z" then return rawget(t,3)
    else error("Invalid vector access")
    end
  end
end

function Vector3i.new(x: integer, y: integer, z: integer): Vector3i
  local s: Vector3i = {x,y,z}
  local self = setmetatable(s, {__index=Vec3iIX})
  return self
end

-- Vector2

function Vec2IX(t: Vector2, key: integer | string): number
  if key is integer then
    return rawget(t,key)
  else
    if key == "x" then return rawget(t,1)
    elseif key == "y" then return rawget(t,2)
    else error("Invalid vector access")
    end
  end
end

function Vector2.new(x: number, y: number): Vector2
  local s: Vector2 = {x,y}
  local self = setmetatable(s, {__index=Vec2IX})
  return self
end

--function Vector2:add(x: number, y: number | nil)
--  if x is Vector2 then
--    self[1] = self[1] + x[1]
--    self[2] = self[2] + x[2]
--  else
--    self[1] = self[1] + x
--    self[2] = self[2] + y
--  end
--end

function Vec2iIX(t: Vector2i, key: integer | string): integer
  if key is integer then
    return rawget(t,key)
  else
    if key == "x" then return rawget(t,1)
    elseif key == "y" then return rawget(t,2)
    else error("Invalid vector access")
    end
  end
end

function Vector2i.new(x: integer, y: integer): Vector2i
  local s: Vector2i = {x,y}
  local self = setmetatable(s, {__index=Vec2iIX})
  return self
end


-- Transform
--[[
function Mod.tIx(row: integer, col: integer): integer
  return (row-1)*3+col
end

function Transform.new(): Transform
  local res: Transform = setmetatable({1,0,0, 0,1,0, 0,0,1}, {__index=Transform})
  return res
end

function Transform.copy(t: Transform): Transform
  local res: Transform = setmetatable({0,0,0,0,0,0,0,0,0}, {__index = Transform})
  for i=1, 9 do
    res[i] = t[i]
  end
  return res
end

function Transform:get(row: integer, col: integer): number
  return self[(row-1)*3+col]
end
function Transform:set(row: integer, col: integer, val: number): number
  self[(row-1)*3+col] = val
  return val
end

function Transform:translate(dx: number, dy: number)
  self[3] = self[3]+dx
  self[6] = self[6]+dy
end

function Transform:scale(sx: number, sy: number)
  self[1] = self[1]*sx
  self[5] = self[5]*sy
end

function Transform:rotate(r: number)
  self[1] = math.cos(r) * self[1]
  self[2] = -math.sin(r)
  self[4] = math.sin(r)
  self[5] = math.cos(r) * self[5]
end

function Transform.mul(a: Transform, b: Transform): Transform
  local res: Transform = {0,0,0,0,0,0,0,0,0}

  res[1] = a[1]*b[1] + a[2]*b[4] + a[3]*b[7]
  res[2] = a[1]*b[2] + a[2]*b[5] + a[3]*b[8]
  res[3] = a[1]*b[3] + a[2]*b[6] + a[3]*b[9]

  res[4] = a[4]*b[1] + a[5]*b[4] + a[6]*b[7]
  res[5] = a[4]*b[2] + a[5]*b[5] + a[6]*b[8]
  res[6] = a[4]*b[3] + a[5]*b[6] + a[6]*b[9]

  res[7] = a[7]*b[1] + a[8]*b[4] + a[9]*b[7]
  res[8] = a[7]*b[2] + a[8]*b[5] + a[9]*b[8]
  res[9] = a[7]*b[3] + a[8]*b[6] + a[9]*b[9]

  return res
end

function Transform:mulBy(b: Transform)
  local res = self
  local a = self

  res[1] = a[1]*b[1] + a[2]*b[4] + a[3]*b[7]
  res[2] = a[1]*b[2] + a[2]*b[5] + a[3]*b[8]
  res[3] = a[1]*b[3] + a[2]*b[6] + a[3]*b[9]

  res[4] = a[4]*b[1] + a[5]*b[4] + a[6]*b[7]
  res[5] = a[4]*b[2] + a[5]*b[5] + a[6]*b[8]
  res[6] = a[4]*b[3] + a[5]*b[6] + a[6]*b[9]

  res[7] = a[7]*b[1] + a[8]*b[4] + a[9]*b[7]
  res[8] = a[7]*b[2] + a[8]*b[5] + a[9]*b[8]
  res[9] = a[7]*b[3] + a[8]*b[6] + a[9]*b[9]
end
--]]

return Mod
