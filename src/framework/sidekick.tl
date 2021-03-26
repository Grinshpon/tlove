local config = require "framework/config"
local gameObject = require "framework/gameobject"
local input = require "framework/input"
--local phys = require "framework/phys"
local scene = require "framework/scene"
local Stack = require "framework/stack"
local collider = require "framework/components/collider"

local sprite = require "framework/components/sprite"

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

--[[
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
--]]

--local sk: Sidekick = {
local sk = {
  config = config,
  gameObject = gameObject,
  input = input,
  --phys = phys,
  scene = scene,
  Stack = Stack,
  collider = collider,

  sprite = sprite,

  camera: Camera = nil,
  coroutines: {thread} = {},
  coCount = 0,
  sceneStack: scene.SceneStack = nil,
  currentScene: scene.Scene = nil,
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
  local width, height = love.graphics.getWidth(), love.graphics.getHeight()
  if ttype == nil or ttype == "window" then
    --love.graphics.scale(1)
  elseif ttype == "world" then
    love.graphics.translate(sk.camera.x,sk.camera.y)
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
