local config = require("config")
local sk = require("sidekick")
local input = require("input")
local state = require("state")

local Stack = require("stack")
local SResult = state.SResult


local init = {
   gameObjects = {},
   gameObjectIndex = {},
}

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
      sk.camera.x = sk.camera.x + config.panSpeed * love.timer.getDelta()
   end
   camActions.actions.panRight.down = function()
      sk.camera.x = sk.camera.x - config.panSpeed * love.timer.getDelta()
   end
   camActions.actions.panDown.down = function()
      sk.camera.y = sk.camera.y - config.panSpeed * love.timer.getDelta()
   end
   camActions.actions.panUp.down = function()
      sk.camera.y = sk.camera.y + config.panSpeed * love.timer.getDelta()
   end

   input.addInputActions(camActions)
   input.enable(camActions)
end

function init:load()
   initInputCallbacks()
   return state.cont()
end


function init:update(dt)
   return state.cont()
end

function init:drawWorld()
   love.graphics.print("Hello world", 50, 50)






end

function init:drawUI()
end

function init:drawRaw()
end

return init
