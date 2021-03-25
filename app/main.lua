


local sk = require("sidekick")


function love.load()

   sk.load()
   local initScene = require("skinit")
   sk.sceneStack:load(initScene)
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
