local sk = require("sidekick")

local input = sk.input
local scene = sk.scene

local GameObject = sk.gameObject.GameObject
local Component = sk.gameObject.Component


local SResult = scene.SResult

local coll = sk.collider


local init = scene.Scene.new();

local player
local ship
local cursor

function init:load()

   player = sk.gameObject.GameObject.new("player")
   player:addComponent(require("shipController").new(50))


   self:addGameObject(player)
   player:move(100, 100)
   player:rotate(math.pi / 2)

   ship = sk.gameObject.GameObject.new("ship")
   local c = sk.sprite.newSprite("assets/ship1.png")
   ship:addComponent(c)
   ship:scaleBy(2, 2)
   self:addGameObjectChild(player, ship)

   local c1 = sk.sprite.newSprite("assets/center.png")
   local c2 = require("cursor").new()
   cursor = sk.gameObject.GameObject.new({
      id = "cursor",
      z = 10,
      components = { c1, c2 },
      scale = sk.alg.Vector2.new(2, 2),
   })
   self:addGameObjectChild(player, cursor)
   cursor:move(0, -300)

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
