local Stack = require("framework/Stack")

local gameObject = require("framework/gameobject")
local GameObject = gameObject.GameObject

local function noop(...)
end

local Mod = {SResult = {}, Scene = {}, SceneStack = {}, }






























local SResultTy = Mod.SResultTy
local SResult = Mod.SResult
local Scene = Mod.Scene
local SceneStack = Mod.SceneStack

function Mod.initSceneStack()
   local s = {
      stack = Stack.new(),
   }
   setmetatable(s, { __index = SceneStack })
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
               for _, c in ipairs(g.components) do
                  if c.update then c:update(dt) end
               end
            end
            table.sort(scene.gameObjects, gameObject.zCmp)
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
      for _, c in ipairs(g.components) do
         if c.drawWorld then c:drawWorld() end
      end
   end
   scene:drawWorld()
end

function SceneStack:drawUI()
   local scene = self.stack:peek()
   if (not scene) then return end
   for _, g in ipairs(scene.gameObjects) do
      for _, c in ipairs(g.components) do
         if c.drawUI then c:drawUI() end
      end
   end
   scene:drawUI()
end

function SceneStack:drawRaw()
   local scene = self.stack:peek()
   if (not scene) then return end
   for _, g in ipairs(scene.gameObjects) do
      for _, c in ipairs(g.components) do
         if c.drawRaw then c:drawRaw() end
      end
   end
   scene:drawRaw()
end



function Scene.new()
   local s = {
      root = GameObject.new("root"),
      gameObjects = {},








   }
   local self = setmetatable(s, { __index = Scene })
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
