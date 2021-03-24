local config = require "config"
local input = require "input"
local scene = require "scene"

global record Camera
  x: number
  y: number
  scale: number
end

global enum TransformType
  "world"
  "ui"
  "window"
end

local record Sidekick
  camera: Camera
  coroutines: {thread}
  coCount: integer
  sceneStack: scene.SceneStack
  currentScene: scene.Scene
  startCoroutine: function(f: AnyFn, ...: any): thread
  stopCoroutine: function(cox: thread)
  updateCoroutines: function()
  updateInput: function()
  initCamera: function()
  setTransform: function(ttype: TransformType)
  initSceneStack: function()
  load: function()
  update: function(dt: number)
  drawWorld: function()
  drawUI: function()
  drawRaw: function()
end

local sk: Sidekick = {
--local sk = {
  camera: Camera = nil,
  coroutines: {thread} = {},
  coCount = 0,
  sceneStack: scene.SceneStack = nil,
}

-- Coroutine Handler --

local type AnyFn = function(...: any)

function sk.startCoroutine(f: AnyFn, ...: any): thread
  local co = coroutine.create(f)
  coroutine.resume(co,...)
  table.insert(sk.coroutines, co)
  sk.coCount = sk.coCount+1
  return co
end

function sk.stopCoroutine(cox: thread)
  for i,coy in ipairs(sk.coroutines) do
    if cox == coy then
      table.remove(sk.coroutines,i)
      sk.coCount = sk.coCount-1
      return
    end
  end
end

--global function compose<A,B,C>(f: (function(B):C), g: (function(A):B)): (function(A):C)
  --return (function(x: A):C return f(g(x)) end)
--end

function sk.updateCoroutines()
  local co: thread
  for i=sk.coCount,1,-1 do
    co = sk.coroutines[i]
    coroutine.resume(co)
    if coroutine.status(co) == "dead" then
      table.remove(sk.coroutines)
      sk.coCount = sk.coCount-1
    end
  end
end

-- Input Updating --

function sk.updateInput()
  input.update()
end

-- Camera and Transform --

function sk.initCamera()
  sk.camera = {
    x = 0,
    y = 0,
    scale = 1.0,
  }
end

function sk.setTransform(ttype: TransformType)
  if ttype == nil or ttype == "window" then
    --love.graphics.scale(1)
  elseif ttype == "world" then
    love.graphics.translate(sk.camera.x+config.width/2,sk.camera.y+config.height/2)
    love.graphics.scale(sk.camera.scale)
  elseif ttype == "ui" then
    love.graphics.scale(love.graphics.getHeight()/config.height) -- scales with height only
  end
end

-- Scene Stack --

function sk.initSceneStack()
  sk.sceneStack = scene.initSceneStack()
end

-- Load, Update, Draw --

function sk.load()
  sk.initSceneStack()
  sk.initCamera()
end

function sk.update(dt: number)
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
