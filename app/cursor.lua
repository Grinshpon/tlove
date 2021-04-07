local sk = require("sidekick")
local GameObject = sk.gameObject.GameObject

local Cursor = {}



function Cursor:update(dt)
   self.gameObject:moveLocal(sk.input.mouse.dx, sk.input.mouse.dy)
end

local c_mt = {
   __index = Cursor,
}

function Cursor.new()
   local res = {}


   res = setmetatable(res, c_mt)
   return res
end

return Cursor
