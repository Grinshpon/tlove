local record Mod
  record Vector3
    {number}
  end
  record Vector3i
    {integer}
  end
end
local Vector3 = Mod.Vector3
local Vector3i = Mod.Vector3i

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

return Mod
