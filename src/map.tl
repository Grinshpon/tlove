-- map based on circular grid

local record Map
  record Level
    width: number -- the width of each ring
    size: number --the number of "rings"
  end

  enum Direction
    "cw"    --clockwise
    "ccw"   --counter clockwise
    "down"  --towards center
    "upcw"  --up and clockwise
    "upccw" -- up and counterclockwise
  end

  --cartesian to grid coords and vice versa
  cart2grid: function(Level,number,number): (number,number)
  grid2cart: function(Level,number,number): (number,number)
  grid2polar: function(Level,number,number): (number,number)
  translated: function(Direction, number, number): (number,number)
end

local Level = Map.Level
local Direction = Map.Direction

local map: Map = {}

function quadrant(x:number, y:number): number
  if x > 0 then
    if y > 0 then return 1 else return 4 end
  elseif x < 0 then
    if y > 0 then return 2 else return 3 end
  end
end

local atan = math.atan as function(number):number

function ucAngle(x:number, y:number): number
  if x == 0 then
    if y > 0 then return math.pi/2
    elseif y < 0 then return math.pi*3/2
    else return 0 end
  elseif y == 0 then
    if x >= 0 then return 0 else return math.pi end
  end
  local q = quadrant(x,y)
  if q == 1 then return atan(y/x)
  elseif q == 2 then return atan(y/x)+math.pi
  elseif q == 3 then return atan(y/x)+math.pi
  elseif q == 4 then return atan(y/x)+math.pi*2
  end
end

function map.cart2grid(l: Level,x: number,y:number): (number,number)
  local dist = math.sqrt(math.pow(x,2)+math.pow(y,2))
  if dist < l.width then return 0,0 end
  for i=1, l.size do
    local r = l.width*(i+1)
    if dist < r then
      local rx,ry = i,0
      local theta = ucAngle(x,y)
      --love.graphics.print(tostring(theta),0,-20)
      local angle = math.pi/math.pow(2,i)
      for j=0, math.pow(2,i+1)-1 do
        local t = angle*(j+1)
        if theta < t then ry = j
          love.graphics.print(tostring(rx)..","..tostring(ry),0,0)
          return rx,ry
        end
      end
      return 0,0
    end
  end
  return 0,0
end

function map.grid2polar(l: Level,x: number,y:number): (number,number)
  local r = l.width*(x+0.5)
  local theta = (y+0.5)*math.pi/math.pow(2,x)
  return r,theta
end

function map.grid2cart(l: Level,x: number,y:number): (number,number)
  local r,theta = map.grid2polar(l,x,y)
  return r*math.cos(theta), r*math.sin(theta)
end

local function n2ring(x: number, n: number): number
  local dim = math.pow(2,x+1)
  if n > 0 then
    while n > (dim-1) do
      n = n-dim
      --print("pos",n)
    end
  elseif n < 0 then
    while n < 0 do
      n = n+dim
      --print("neg",n)
    end
  end
  return n
end

function map.translated(dir: Direction, x: number, y: number): (number,number)
  if dir == "cw" then
    return x,n2ring(x,y+1)
  elseif dir == "ccw" then
    return x,n2ring(x,y-1)
  elseif dir == "down" then
    return x-1,n2ring(x-1,math.floor(y/2))
  elseif dir == "upcw" then
    return x+1,n2ring(x+1,2*y+1)
  else --dir == "upccw"
    return x+1,n2ring(x+1,2*y)
  end
end

return map
