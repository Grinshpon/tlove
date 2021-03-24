local Stack = require "Stack"

local gameObject = require("gameobject")
local GameObject = gameObject.GameObject

local function noop(...:any): any
end

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
    root: GameObject
    gameObjects: {GameObject}
    --gameObjectIndex: {string:number} -- reason gameObjects isn't a map is because I'm hoping it gets optimized by the JIT by being a list.
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
end
local SResultTy = Mod.SResultTy
local SResult = Mod.SResult
local Scene = Mod.Scene
local SceneStack = Mod.SceneStack

function Mod.initSceneStack(): SceneStack
  local s = {
    stack = Stack.new() as Stack<Scene>,
  }
  setmetatable(s, {__index = SceneStack})
  return s
end

function Mod.cont(): SResult
  return {
    type = "Cont",
    onPush = nil,
  }
end
function Mod.push(s: Scene): SResult
  return {
    type = "Push",
    onPush = s,
  }
end
function Mod.pop(): SResult
  return {
    type = "Pop",
    onPush = nil,
  }
end
function Mod.exit(): SResult
  return {
    type = "Exit",
    onPush = nil,
  }
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
        res = scene:update(dt)
        table.sort(scene.gameObjects, gameObject.zCmp)
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
  scene:drawWorld()
end

function SceneStack:drawUI()
  local scene = self.stack:peek()
  if (not scene) then return end
  scene:drawUI()
end

function SceneStack:drawRaw()
  local scene = self.stack:peek()
  if (not scene) then return end
  scene:drawRaw()
end

-- Scene

function Scene.new(): Scene
  local s: Scene = {
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
  local self = setmetatable(s, {__index = Scene})
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

local mod: Mod = setmetatable({} as Mod, { __index = Mod })

-- todo: scenestack operations

return mod
