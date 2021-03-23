local config = require("config")
local sk = require("sidekick")


local function noop() end
local function noop1(dt) end

function love.load()
   print("Starting game")

   sk.load()








   local initState = require("skinit")
   sk.stateStack:load(initState)
end

function love.update(dt)
   sk.update(dt)

end

function love.draw()
   love.graphics.push()



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
