local Stack = require "stack"
local config = require "config"
local sk = require "sidekick"
local input = require "input"

local record Game
  load: function()
  update: function(dt: number)
  drawWorld: function()
  drawUI: function()
  drawRaw: function() -- raw
end

local game: Game = {}

local function initCursor()
  --self.cursor = love.graphics.newImage("assets/cursor.png") as love.graphics.Drawable
end

local camActions: input.InputActions = {
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
    sk.camera.x = sk.camera.x + config.panSpeed*love.timer.getDelta()
  end
  camActions.actions.panRight.down = function()
    sk.camera.x = sk.camera.x - config.panSpeed*love.timer.getDelta()
  end
  camActions.actions.panDown.down = function()
    sk.camera.y = sk.camera.y - config.panSpeed*love.timer.getDelta()
  end
  camActions.actions.panUp.down = function()
    sk.camera.y = sk.camera.y + config.panSpeed*love.timer.getDelta()
  end

  input.addInputActions(camActions)
  input.enable(camActions)
end

function game.load()
  initInputCallbacks()
end


function game.update(dt: number)
end

function game.drawWorld()
  love.graphics.print("Hello world",50,50)
  --local s = Stack.init(1);
  --local s1 = Stack.new() as Stack<number>;
  --s:push(2)
  --s1:push(30)
  --love.graphics.print(tostring(s:pop()), 100,100)
  --love.graphics.print(tostring(s1:pop()), 110,110)
end

function game.drawUI()
end

function game.drawRaw()
end

return game
