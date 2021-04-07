local sk = require "sidekick"
local GameObject = sk.gameObject.GameObject

local record Cursor
  gameObject: GameObject
end

function Cursor:update(dt: number)
  self.gameObject:moveLocal(sk.input.mouse.dx, sk.input.mouse.dy)
end

local c_mt = {
  __index = Cursor,
}

function Cursor.new(): Cursor
  local res: Cursor = {
    
  }
  res = setmetatable(res, c_mt)
  return res
end

return Cursor
