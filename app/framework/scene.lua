local Stack = require("framework/Stack")

local gameObject = require("framework/gameobject")
local GameObject = gameObject.GameObject
local Component = gameObject.Component

local coll = require("framework/components/collider")
local Collider = coll.Collider

local Fixture = love.physics.Fixture
local Contact = love.physics.Contact

local BodyType = love.physics.BodyType
local Shape = love.physics.Shape

local Mod = {SResult = {}, Scene = {}, SceneStack = {}, }
































local SResult = Mod.SResult
local Scene = Mod.Scene
local SceneStack = Mod.SceneStack

local SS_mt = { __index = SceneStack }

function Mod.initSceneStack()
   local s = {
      stack = Stack.new(),
   }
   setmetatable(s, SS_mt)
   return s
end

function SceneStack:handleResult(res)
   if res.type == "Push" then
      self.stack:push(res.onPush)
   elseif res.type == "Pop" then
      self.stack:pop()
   elseif res.type == "Cont" then
      return
   elseif res.type == "Exit" then
      love.event.quit(0)
   end
end

function SceneStack:load(initScene)
   self.stack:push(initScene)
   local res = initScene:load()
   self:handleResult(res)
end

function SceneStack:update(dt)


   for i, scene in ipairs(self.stack.data) do
      local res = nil
      if i == 1 then
         if scene.update then
            for _, g in ipairs(scene.gameObjects) do
               if g.enabled then
                  for _, c in ipairs(g.components) do
                     if c.update then c:update(dt) end
                  end
                  g:quietUpdateTransform()
                  if g.body then
                     if g.body:isActive() and not g.dirty then
                        local t = g:getTransform()
                        local bx, by = t:inverseTransformPoint(g.body:getPosition())
                        if bx ~= g.pos[1] or by ~= g.pos[2] then
                           g.pos[1], g.pos[2] = bx, by
                           g.dirty = true
                        end
                        local brot = g.body:getAngle()
                        local p = g.parent
                        while p do
                           brot = brot - p.rot
                           p = p.parent
                        end

                        if brot ~= g.rot then
                           g.rot = brot
                           g.dirty = true
                        end





                     else
                        local t = g:getGlobalTransform()
                        local x, y = t:transformPoint(0, 0)
                        g.body:setPosition(x, y)
                        local tx, ty = t:transformPoint(1, 0)

                        g.body:setAngle(math.atan2(ty - y, tx - x))
                     end
                  end
                  g:updateTransform()
               end
            end
            table.sort(scene.gameObjects, gameObject.zCmp)
            scene.world:update(dt)
            res = scene:update(dt)
         end
      else
         if scene.supdate then res = scene:supdate(dt) end
      end
      if res then self:handleResult(res) end
   end
end

function SceneStack:drawWorld()
   local scene = self.stack:peek()
   if (not scene) then return end
   for _, g in ipairs(scene.gameObjects) do
      if g.enabled then
         for _, c in ipairs(g.components) do
            if c.drawWorld then c:drawWorld() end
         end
      end
   end
   scene:drawWorld()
end

function SceneStack:drawUI()
   local scene = self.stack:peek()
   if (not scene) then return end
   for _, g in ipairs(scene.gameObjects) do
      if g.enabled then
         for _, c in ipairs(g.components) do
            if c.drawUI then c:drawUI() end
         end
      end
   end
   scene:drawUI()
end

function SceneStack:drawRaw()
   local scene = self.stack:peek()
   if (not scene) then return end
   for _, g in ipairs(scene.gameObjects) do
      if g.enabled then
         for _, c in ipairs(g.components) do
            if c.drawRaw then c:drawRaw() end
         end
      end
   end
   scene:drawRaw()
end



local Scene_mt = { __index = Scene }

local function beginContactCallback(s)
   function callback(f1, f2, contact)
      local collider1 = s._f2c[f1]
      local collider2 = s._f2c[f2]
      if collider1 then collider1.beginContact(collider2, contact) end
      if collider2 then collider2.beginContact(collider1, contact) end
   end
   return callback
end



function Scene.new()
   local s = {
      world = love.physics.newWorld(),
      _f2c = {},
      root = GameObject.new("root"),
      gameObjects = {},








   }
   s.world:setCallbacks(beginContactCallback(s), nil, nil, nil)
   local self = setmetatable(s, Scene_mt)
   return self
end

function Scene:addGameObject(g)
   table.insert(self.gameObjects, g)
   if not g.parent then g.parent = self.root end
end

function Scene:addGameObjectChild(parent, child)
   table.insert(self.gameObjects, child)
   child.parent = parent
   table.insert(parent.children, child)
end

function Scene:addBodyToObject(object, type)
   object:updateTransform()
   local x, y = object:getGlobalTransform():transformPoint(0, 0)

   object.body = love.physics.newBody(self.world, x, y, type)

end

function Scene:addColliderToObject(object, shape, beginContact)
   local fixture = love.physics.newFixture(object.body, shape)
   local collider = Collider.new(fixture, beginContact)
   object:addComponent(collider)
   self._f2c[fixture] = collider
end



local mod = setmetatable({
   cont = {
      type = "Cont",
      onPush = nil,
   },
   pop = {
      type = "Pop",
      onPush = nil,
   },
   exit = {
      type = "Exit",
      onPush = nil,
   },
   push = function(s)
      return {
         type = "Push",
         onPush = s,
      }
   end,
}, { __index = Mod })

return mod
