local config = require("config")
require("camera")
local sk = require("sidekick")
local game = require("game")

local function noop() end

function love.load()
   if not game.load then game.load = noop end
   if not game.update then game.update = noop end
   if not game.drawWorld then game.drawWorld = noop end
   if not game.drawUI then game.drawUI = noop end
   if not game.drawRaw then game.drawRaw = noop end

   sk.initCamera()
   game.load()
end

function love.update(dt)
   sk.updateInput()
   sk.updateCoroutines()
   game.update()
end

function love.draw()
   love.graphics.push()



   love.graphics.push()
   sk.setTransform("world")
   game.drawWorld()
   love.graphics.pop()
   love.graphics.push()
   sk.setTransform("ui")
   game.drawUI()
   love.graphics.pop()
   love.graphics.pop()
   game.drawRaw()
end
