local config = require("config")
local input = require("input")
local state = require("state")

 Camera = {}





 TransformType = {}





local Sidekick = {}


















local sk = {

   camera = nil,
   coroutines = {},
   coCount = 0,
   stateStack = nil,
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



function sk.initStateStack()
   sk.stateStack = state.initStateStack()
end



function sk.load()
   sk.initStateStack()
   sk.initCamera()
end

function sk.update(dt)
   sk.updateInput()
   sk.updateCoroutines()
   sk.stateStack:update(dt)
end

function sk.drawWorld()
   sk.stateStack:drawWorld()
end

function sk.drawUI()
   sk.stateStack:drawUI()
end

function sk.drawRaw()
   sk.stateStack:drawRaw()
end

return sk
