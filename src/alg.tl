local record Mod
  record Vector3
    {number}
  end
end
local Vector3 = Mod.Vector3

function Vec3IX(t: Vector3, key: number | string): number
  if key is number then
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

return Mod
