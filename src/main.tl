local config = require "config"
local sk = require "sidekick"
--local game = require "game"

--local function noop() end
--local function noop1(dt:number) end

function love.load()
  print("Starting game")
  --print(love.window.getDPIScale())
  sk.load()
  --probably phase out game.tl for states and gameobjects
--  if not game.load then game.load = noop end
--  if not game.update then game.update = noop1 end
--  if not game.drawWorld then game.drawWorld = noop end
--  if not game.drawUI then game.drawUI = noop end
--  if not game.drawRaw then game.drawRaw = noop end
--  game.load()

  local initState = require "skinit"
  sk.stateStack:load(initState)
end

function love.update(dt: number)
  sk.update(dt)
--  game.update(dt)
end

function love.draw()
  love.graphics.push()
    -- window resultion / game resolution scaling
    -- todo: instead of calling getHeight, turn reziable off and store height in an options table
    --sk.setTransform("window")
    love.graphics.push()
      sk.setTransform("world")
      sk.drawWorld()
--      game.drawWorld()
    love.graphics.pop()
    love.graphics.push()
      sk.setTransform("ui")
      sk.drawUI()
--      game.drawUI()
    love.graphics.pop()
  love.graphics.pop()
  sk.drawRaw()
--  game.drawRaw()
end
