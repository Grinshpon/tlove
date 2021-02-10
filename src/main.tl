local config = require "config"
local sk = require "sidekick"
local game = require "game"

local function noop() end

function love.load()
  print("Starting game")
  if not game.load then game.load = noop end
  if not game.update then game.update = noop end
  if not game.drawWorld then game.drawWorld = noop end
  if not game.drawUI then game.drawUI = noop end
  if not game.drawRaw then game.drawRaw = noop end
  --print(love.window.getDPIScale())
  sk.initCamera()
  game.load()
end

function love.update(dt: number)
  sk.updateInput()
  sk.updateCoroutines()
  game.update()
end

function love.draw()
  love.graphics.push()
    -- window resultion / game resolution scaling
    -- todo: instead of calling getHeight, turn reziable off and store height in an options table
    --sk.setTransform("window")
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
