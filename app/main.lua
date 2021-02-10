local config = require("config")
local sk = require("sidekick")
local game = require("game")

local function noop() end
local function noop1(dt) end

function love.load()
   print("Starting game")

   sk.load()

   if not game.load then game.load = noop end
   if not game.update then game.update = noop1 end
   if not game.drawWorld then game.drawWorld = noop end
   if not game.drawUI then game.drawUI = noop end
   if not game.drawRaw then game.drawRaw = noop end
   game.load()
end

function love.update(dt)
   sk.update(dt)
   game.update(dt)
end

function love.draw()
   love.graphics.push()



   love.graphics.push()
   sk.setTransform("world")
   sk.drawWorld()
   game.drawWorld()
   love.graphics.pop()
   love.graphics.push()
   sk.setTransform("ui")
   sk.drawUI()
   game.drawUI()
   love.graphics.pop()
   love.graphics.pop()
   sk.drawRaw()
   game.drawRaw()
end
