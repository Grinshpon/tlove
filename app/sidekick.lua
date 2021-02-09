require("camera")
local config = require("config")
local input = require("input")

local sk = {
   camera = {},
   coroutines = {},
   coCount = 0,
}



local AnyFn = {}

function sk.startCoroutine(f, ...)
   local co = coroutine.create(f)
   coroutine.resume(co, ...)
   table.insert(sk.coroutines, co)
   sk.coCount = sk.coCount + 1
   return co
end

function sk.stopCoroutine(cox)
   for i, coy in ipairs(sk.coroutines) do
      if cox == coy then
         table.remove(sk.coroutines, i)
         sk.coCount = sk.coCount - 1
         return
      end
   end
end





function sk.updateCoroutines()
   local co
   for i = sk.coCount, 1, -1 do
      co = sk.coroutines[i]
      coroutine.resume(co)
      if coroutine.status(co) == "dead" then
         table.remove(sk.coroutines)
         sk.coCount = sk.coCount - 1
      end
   end
end



function sk.updateInput()
   input.update()
end



 TransformType = {}





function sk.initCamera()
   sk.camera = {
      x = 0,
      y = 0,
      scale = 1.0,
   }
end

function sk.setTransform(ttype)
   if ttype == nil or ttype == "window" then

   elseif ttype == "world" then
      love.graphics.translate(sk.camera.x + config.width / 2, sk.camera.y + config.height / 2)
      love.graphics.scale(sk.camera.scale)
   elseif ttype == "ui" then
      love.graphics.scale(love.graphics.getHeight() / config.height)
   end
end


return sk
