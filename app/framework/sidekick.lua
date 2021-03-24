local config = require("framework/config")
local gameObject = require("framework/gameObject")
local input = require("framework/input")
local scene = require("framework/scene")
local Stack = require("framework/stack")

 Camera = {}





 TransformType = {}




























local sk = {
   config = config,
   gameObject = gameObject,
   input = input,
   scene = scene,
   Stack = Stack,

   camera = nil,
   coroutines = {},
   coCount = 0,
   sceneStack = nil,
   currentScene = nil,
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



function sk.initSceneStack()
   sk.sceneStack = scene.initSceneStack()
end



function sk.load()
   sk.initSceneStack()
   sk.initCamera()
end

function sk.update(dt)
   sk.currentScene = sk.sceneStack.stack:peek()
   sk.updateInput()
   sk.updateCoroutines()
   sk.sceneStack:update(dt)
end

function sk.drawWorld()
   sk.sceneStack:drawWorld()
end

function sk.drawUI()
   sk.sceneStack:drawUI()
end

function sk.drawRaw()
   sk.sceneStack:drawRaw()
end

return sk
