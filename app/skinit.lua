local sk = require("sidekick")

local input = sk.input
local scene = sk.scene


local SResult = scene.SResult

local coll = sk.collider


local init = scene.Scene.new();





local camActions = {
   actions = {
      zoomIn = input.keyAction("="),
      zoomOut = input.keyAction("-"),
      panLeft = input.keyAction("left"),
      panRight = input.keyAction("right"),
      panUp = input.keyAction("up"),
      panDown = input.keyAction("down"),
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
      sk.camera.x = sk.camera.x + panSpeed * love.timer.getDelta()
   end
   camActions.actions.panRight.down = function()
      sk.camera.x = sk.camera.x - panSpeed * love.timer.getDelta()
   end
   camActions.actions.panDown.down = function()
      sk.camera.y = sk.camera.y - panSpeed * love.timer.getDelta()
   end
   camActions.actions.panUp.down = function()
      sk.camera.y = sk.camera.y + panSpeed * love.timer.getDelta()
   end

   input.addActionMap(camActions)
   input.enable(camActions)
end


local g0 = sk.gameObject.GameObject.new("test 0")
local g1
function init:load()
   print("Starting game")
   initInputCallbacks()

   local g = sk.gameObject.GameObject.new("test")
   local c = sk.sprite.newSprite("assets/ship1.png")
   g:addComponent(c)
   self:addBodyToObject(g, "dynamic")
   self:addColliderToObject(g, love.physics.newRectangleShape(30, 30))
   self:addGameObject(g)
   g:scaleBy(2, 2)

   local c0 = sk.sprite.newSprite("assets/center.png")
   g0.z = 2
   g0:addComponent(c0)
   self:addGameObjectChild(g, g0)

   local c1 = sk.sprite.newSprite("assets/center.png")
   g1 = sk.gameObject.GameObject.new({
      id = "test 1",
      z = -1,
      components = { c1 },
      scale = sk.alg.Vector2.new(0.5, 0.5),
   })



   self:addGameObjectChild(g0, g1)
   g1:move(50, 50)

   c1 = sk.sprite.newSprite("assets/center.png")
   local g3 = sk.gameObject.GameObject.new({
      id = "ttest 3",
      z = 1,
      components = { c1 },
   })

   self:addGameObjectChild(g1, g3)
   g3:move(50, 50)

   local g2 = sk.gameObject.GameObject.new({
      id = "test 2",
   })
   g2:move(100, 20)
   self:addGameObject(g2)
   self:addBodyToObject(g2, "dynamic")
   local function cb(_other, _contact)
      print("begin contact")
   end
   self:addColliderToObject(g2, love.physics.newRectangleShape(30, 30), cb)
   g2.body:setLinearVelocity(-20, 0)

   return scene.cont
end


function init:update(dt)

   g1:rotate(dt)
   return scene.cont
end

function init:drawWorld()
   for _, b in ipairs(self.world:getBodies()) do

      local x, y = b:getPosition()
      local s = b:getFixtures()[1]:getShape()
      if s:getType() == "polygon" then

         love.graphics.polygon("fill", b:getWorldPoints((s):getPoints()))
      else
         love.graphics.circle("fill", x, y, 10)
      end
   end
end

function init:drawUI()
   for i, g in ipairs(self.gameObjects) do
      local x, y = g:globalPos()
      love.graphics.print(g.id .. ": " .. tostring(x) .. ", " .. tostring(y), 200, 20 * i)










   end
end

function init:drawRaw()
   love.graphics.print(tostring(love.timer.getFPS()), 0, 0)
end

return init
