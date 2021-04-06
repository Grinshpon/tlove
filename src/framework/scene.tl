local Stack <const> = require "framework/Stack"

local gameObject <const> = require "framework/gameobject"
local GameObject <const> = gameObject.GameObject
local Component <const> = gameObject.Component

local coll <const> = require("framework/components/collider")
local Collider <const> = coll.Collider

local Fixture <const> = love.physics.Fixture
local Contact <const> = love.physics.Contact
--local Body <const> = love.physics.Body
local BodyType <const> = love.physics.BodyType
local Shape <const> = love.physics.Shape

local type Mod = record
  type SResultTy = enum
    "Pop"
    "Push"
    "Cont"
    "Exit"
  end
  type SResult = record
    type: SResultTy
    onPush: Scene | nil
  end
  type Scene = record
    world: love.physics.World
    _f2c: {Fixture:Collider} --associates fixtures with gameobjects for callbacks
    root: GameObject
    gameObjects: {GameObject}
    load: function(self: Scene, prev: Scene): SResult --on first time load, called once
    awake: function(self: Scene, prev: Scene): SResult --called whenver scene becomes active
    update: function(self: Scene, dt: number): SResult
    supdate: function(self: Scene, dt: number): SResult --shadow update, called when scene is not on top. push and pop result not allowed
    drawWorld: function(self: Scene)
    drawUI: function(self: Scene)
    drawRaw: function(self: Scene)
  end
  type SceneStack = record
    stack: Stack<Scene>
  end
  cont: SResult
  pop: SResult
  exit: SResult
  push: function(Scene): SResult
end
--local SResultTy = Mod.SResultTy
local SResult = Mod.SResult
local Scene = Mod.Scene
local SceneStack = Mod.SceneStack

local SS_mt = {__index = SceneStack}

function Mod.initSceneStack(): SceneStack
  local s = {
    stack = Stack.new() as Stack<Scene>,
  }
  setmetatable(s, SS_mt)
  return s
end

function SceneStack:handleResult(res: SResult)
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

function SceneStack:load(initScene: Scene)
  self.stack:push(initScene)
  local res = initScene:load()
  self:handleResult(res)
end

function SceneStack:update(dt: number)
  --local scene = self.stack:peek()
  --if (not scene) then return end
  for i,scene in ipairs(self.stack.data) do
    local res: SResult = nil
    if i == 1 then
      if scene.update then
        for _,g in ipairs(scene.gameObjects) do
          if g.enabled then
            for _,c in ipairs(g.components) do
              if c.update then c:update(dt) end
            end
            g:updateTransform()
            if g.body then
              if not g.body:isActive() then --remove `not`
                local t = g:getTransform()
                local bx,by = t:inverseTransformPoint(g.body:getPosition())
                g.transform:translate(bx,by)
              else
                local t = g:getTransform()
                local x,y = t:transformPoint(0,0)
                g.body:setPosition(x,y)
                local tx,ty = t:transformPoint(1,0)
                --print(tx,ty,math.atan2(ty-y,tx-x))
                g.body:setAngle(math.atan2(ty-y,tx-x))
              end
            end
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
  for _,g in ipairs(scene.gameObjects) do
    if g.enabled then
      for _,c in ipairs(g.components) do
        if c.drawWorld then c:drawWorld() end
      end
    end
  end
  scene:drawWorld()
end

function SceneStack:drawUI()
  local scene = self.stack:peek()
  if (not scene) then return end
  for _,g in ipairs(scene.gameObjects) do
    if g.enabled then
      for _,c in ipairs(g.components) do
        if c.drawUI then c:drawUI() end
      end
    end
  end
  scene:drawUI()
end

function SceneStack:drawRaw()
  local scene = self.stack:peek()
  if (not scene) then return end
  for _,g in ipairs(scene.gameObjects) do
    if g.enabled then
      for _,c in ipairs(g.components) do
        if c.drawRaw then c:drawRaw() end
      end
    end
  end
  scene:drawRaw()
end

-- Scene

local Scene_mt = {__index = Scene}

local function beginContactCallback(s: Scene): function(Fixture,Fixture,Contact)
  function callback(f1: Fixture, f2: Fixture, contact: Contact)
    local collider1 = s._f2c[f1]
    local collider2 = s._f2c[f2]
    if collider1 then collider1.beginContact(collider2, contact) end
    if collider2 then collider2.beginContact(collider1, contact) end
  end
  return callback
end

--todo: complete callbacks

function Scene.new(): Scene
  local s: Scene = {
    world = love.physics.newWorld(),
    _f2c = {},
    root = GameObject.new("root"),
    gameObjects = {},
    --gameObjectIndex = {},
    --load = noop,
    --awake = noop,
    --update = noop,
    --supdate = noop,
    --drawWorld = noop,
    --drawUI = noop,
    --drawRaw = noop,
  }
  s.world:setCallbacks(beginContactCallback(s), nil, nil, nil)
  local self = setmetatable(s, Scene_mt)
  return self
end

function Scene:addGameObject(g: GameObject)
  table.insert(self.gameObjects, g)
  if not g.parent then g.parent = self.root end
end

function Scene:addGameObjectChild(parent: GameObject, child: GameObject)
  table.insert(self.gameObjects, child)
  child.parent = parent
  table.insert(parent.children, child)
end

function Scene:addBodyToObject(object: GameObject, type: BodyType)
  local x,y = object:getTransform():transformPoint(0,0)
  print(x,y)
  object.body = love.physics.newBody(self.world,x,y,type)
end

function Scene:addColliderToObject(object: GameObject, shape: Shape, beginContact: coll.Callback)
  local fixture = love.physics.newFixture(object.body,shape)
  local collider = Collider.new(fixture, beginContact)
  object:addComponent(collider as Component)
  self._f2c[fixture] = collider
end

-- mod

local mod: Mod = setmetatable({
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
  push = function(s: Scene): SResult
    return {
      type = "Push",
      onPush = s,
    }
  end
} as Mod, { __index = Mod })

return mod
