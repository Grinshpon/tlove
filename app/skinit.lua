local sk = require("sidekick")
local config = sk.config
local input = sk.input
local scene = sk.scene

local Stack = sk.Stack
local SResult = scene.SResult


local init = scene.Scene.new();

local function initCursor()

end

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
   initInputCallbacks()

   local g = sk.gameObject.GameObject.new("test")
   local c = sk.sprite.newSprite("assets/ship1.png")
   g:addComponent(c)
   self:addGameObject(g)
   return scene.cont
end


function init:update(dt)
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
