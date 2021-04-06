local sk = require "sidekick"
--local config = sk.config
local input = sk.input
local scene = sk.scene

--local Stack = sk.Stack
local SResult = scene.SResult

local coll = sk.collider

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
local g1: sk.gameObject.GameObject
function init:load(): SResult
  print("Starting game")
  initInputCallbacks()

  local g = sk.gameObject.GameObject.new("test")
  local c = sk.sprite.newSprite("assets/ship1.png")
  g:addComponent(c)
  self:addBodyToObject(g,"dynamic")
  self:addColliderToObject(g,love.physics.newRectangleShape(20,20) as love.physics.Shape)
  self:addGameObject(g)
  g.transform:scale(2,2)

  local c0 = sk.sprite.newSprite("assets/center.png")
  g0.z = 2
  g0:addComponent(c0)
  self:addGameObjectChild(g,g0)

  local c1 = sk.sprite.newSprite("assets/center.png")
  g1 = sk.gameObject.GameObject.new {
    id = "test 1",
    z = -1,
    components = {c1},
  }
  g1.transform:scale(0.5,0.5)
  --g1.transform:translate(70,70)
  --self:addBodyToObject(g1,"dynamic")
  --self:addColliderToObject(g1,love.physics.newRectangleShape(20,20) as love.physics.Shape)
  self:addGameObjectChild(g0,g1)
  g1:move(50,50)

  c1 = sk.sprite.newSprite("assets/center.png")
  local g3 = sk.gameObject.GameObject.new {
    id = "ttest 3",
    z = 1,
    components = {c1},
  }
  --g3.transform:translate(70,70)
  self:addGameObjectChild(g1,g3)
  g3:move(50,50)

  local g2 = sk.gameObject.GameObject.new {
    id = "test 2",
  }
  g2:move(100,20)
  self:addGameObject(g2)
  self:addBodyToObject(g2, "dynamic")
  local function cb(other: coll.Collider, contact: love.physics.Contact)
    print("begin contact")
  end
  self:addColliderToObject(g2, love.physics.newRectangleShape(20,20) as love.physics.Shape, cb)
  --g2.body:setLinearVelocity(-20,0)

  return scene.cont
end


function init:update(dt: number): SResult
  g0:move(10*dt,0)
  g1:rotate(dt)
  return scene.cont
end

function init:drawWorld()
  for _,b in ipairs(self.world:getBodies()) do
    --print(b:isAwake(), b:isActive())
    local x,y = b:getPosition()
    local s = b:getFixtures()[1]:getShape()
    if s:getType() == "polygon" then
      --print(b:getWorldPoints((s as love.physics.PolygonShape):getPoints()))
      love.graphics.polygon("fill",b:getWorldPoints((s as love.physics.PolygonShape):getPoints()))
    else
      love.graphics.circle("fill",x,y,10)
    end
  end
end

function init:drawUI()
  for i,g in ipairs(self.gameObjects) do
    local t = g:getGlobalTransform()
    --local t = g:getTransform()
    local x,y = t:transformPoint(0,0)
    love.graphics.print(g.id..": "..tostring(x)..", "..tostring(y), 200,20*i)
  end
end

function init:drawRaw()
  love.graphics.print(tostring(love.timer.getFPS()),0,0)
end

return init
