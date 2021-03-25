local sk = require "sidekick"
--local config = sk.config
local input = sk.input
local scene = sk.scene

--local Stack = sk.Stack
local SResult = scene.SResult

-- initial scene
local init = scene.Scene.new();

--local function initCursor()
--  self.cursor = love.graphics.newImage("assets/cursor.png") as love.graphics.Drawable
--end

local camActions: input.ActionMap = {
  actions = {
    zoomIn   = input.keyAction("="),
    zoomOut  = input.keyAction("-"),
    panLeft  = input.keyAction("left"),
    panRight = input.keyAction("right"),
    panUp    = input.keyAction("up"),
    panDown  = input.keyAction("down"),
  },
  enabled = false,
}

local function initInputCallbacks()
  local panSpeed = 400
  camActions.actions.zoomIn.pressed = function()
    if sk.camera.scale < 3 then
      sk.camera.scale = sk.camera.scale + 1
    end
  end
  camActions.actions.zoomOut.pressed = function()
    if sk.camera.scale > 1 then
      sk.camera.scale = sk.camera.scale - 1
    end
  end
  camActions.actions.panLeft.down = function()
    sk.camera.x = sk.camera.x + panSpeed*love.timer.getDelta()
  end
  camActions.actions.panRight.down = function()
    sk.camera.x = sk.camera.x - panSpeed*love.timer.getDelta()
  end
  camActions.actions.panDown.down = function()
    sk.camera.y = sk.camera.y - panSpeed*love.timer.getDelta()
  end
  camActions.actions.panUp.down = function()
    sk.camera.y = sk.camera.y + panSpeed*love.timer.getDelta()
  end

  input.addActionMap(camActions)
  input.enable(camActions)
end


local g0 = sk.gameObject.GameObject.new("test 0")
function init:load(): SResult
  print("Starting game")
  initInputCallbacks()

  local g = sk.gameObject.GameObject.new("test")
  local c = sk.sprite.newSprite("assets/ship1.png")
  --g.scale = 2
  --g.rot = 0--math.pi/4
  g:addComponent(c)
  self:addGameObject(g)
  g.transform:scale(2,2)

  local c0 = sk.sprite.newSprite("assets/center.png")
  g0.z = 2
  g0:addComponent(c0)
  g0.transform:rotate(math.pi/4)
  self:addGameObjectChild(g,g0)

  local c1 = sk.sprite.newSprite("assets/center.png")
  local g1 = sk.gameObject.GameObject.new {
    id = "test 1",
    --pos = {30, 30, -1},
    --rot = math.pi,
    --scale = 0.5,
    z = -1,
    components = {c1},
  }
  self:addGameObjectChild(g0,g1)
  g1.transform:scale(0.5,0.5)
  g1.transform:translate(70,0)
  return scene.cont
end


function init:update(_dt: number): SResult
  --g.rot = g.rot + _dt
  g0.transform:rotate(_dt)
  return scene.cont
end

function init:drawWorld()
  --local s = Stack.init(1);
  --local s1 = Stack.new() as Stack<number>;
  --s:push(2)
  --s1:push(30)
  --love.graphics.print(tostring(s:pop()), 100,100)
  --love.graphics.print(tostring(s1:pop()), 110,110)
end

function init:drawUI()
end

function init:drawRaw()
  love.graphics.print(tostring(love.timer.getFPS()),0,0)
end

return init
