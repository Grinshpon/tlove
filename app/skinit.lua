local sk = require("sidekick")

local input = sk.input
local scene = sk.scene


local SResult = scene.SResult


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

function init:load()
   print("Starting game")
   initInputCallbacks()

   local g = sk.gameObject.GameObject.new("test")
   local c = sk.sprite.newSprite("assets/ship1.png")
   g.pos[1] = 0
   g.scale = 2
   g.rot = math.pi / 4
   g:addComponent(c)
   self:addGameObject(g)

   local c1 = sk.sprite.newSprite("assets/ship1.png")
   local g1 = sk.gameObject.GameObject.new({
      id = "test 1",
      pos = { 100, 100, 0 },
      rot = math.pi,
      scale = 0.5,
      components = { c1 },
   })
   self:addGameObjectChild(g, g1)
   return scene.cont
end


function init:update(_dt)
   return scene.cont
end

function init:drawWorld()






end

function init:drawUI()
end

function init:drawRaw()
   love.graphics.print(tostring(love.timer.getFPS()), 0, 0)
end

return init
