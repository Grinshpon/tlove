local config = require("framework/config")
local gameObject = require("framework/gameobject")
local input = require("framework/input")
local scene = require("framework/scene")
local Stack = require("framework/stack")

local sprite = require("framework/components/sprite")

 Camera = {}





 TransformType = {}




























local sk = {
   config = config,
   gameObject = gameObject,
   input = input,
   scene = scene,
   Stack = Stack,

   sprite = sprite,

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
   local width, height = love.graphics.getWidth(), love.graphics.getHeight()
   if ttype == nil or ttype == "window" then

   elseif ttype == "world" then
      love.graphics.translate(sk.camera.x, sk.camera.y)
      if config.worldScaleType == 0 then
         love.graphics.scale(sk.camera.scale)
      elseif config.worldScaleType == 1 then
         love.graphics.scale(sk.camera.scale * width / config.width)
      elseif config.worldScaleType == 2 then
         love.graphics.scale(sk.camera.scale * height / config.height)
      elseif config.worldScaleType == 3 then
         love.graphics.scale(sk.camera.scale * width / config.width, sk.camera.scale * height / config.height)
      end
   elseif ttype == "ui" then
      if config.uiScaleType == 0 then
      elseif config.uiScaleType == 1 then
         love.graphics.scale(width / config.width)
      elseif config.uiScaleType == 2 then
         love.graphics.scale(height / config.height)
      elseif config.uiScaleType == 3 then
         love.graphics.scale(width / config.width, height / config.height)
      end
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
