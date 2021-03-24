--require "internal"

--local config = require "config"
local sk = require "sidekick"
local config = sk.config

function love.load()
  print("Starting game")
  --print(love.window.getDPIScale())
  sk.load()
  local initScene = require "skinit"
  sk.sceneStack:load(initScene)
end

function love.update(dt: number)
  sk.update(dt)
end

function love.draw()
  love.graphics.push()
    -- window resultion / game resolution scaling
    -- todo: instead of calling getHeight, turn reziable off and store height in an options table
    --sk.setTransform("window")
    love.graphics.push()
      sk.setTransform("world")
      sk.drawWorld()
    love.graphics.pop()
    love.graphics.push()
      sk.setTransform("ui")
      sk.drawUI()
    love.graphics.pop()
  love.graphics.pop()
  sk.drawRaw()
end
