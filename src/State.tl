local Stack = require "Stack"

local GameObject = require("gameobject").GameObject

local type Mod = record
  type SResultTy = enum
    "Pop"
    "Push"
    "Cont"
    "Exit"
  end
  type SResult = record
    type: SResultTy
    onPush: State | nil
  end
  type State = record
    gameObjects: {GameObject}
    gameObjectIndex: {string:number} -- reason gameObjects isn't a map is because I'm hoping it gets optimized by the JIT by being a list.
    load: function(self: State, prev: State): SResult --on first time load, called once
    awake: function(self: State, prev: State): SResult --called whenver state becomes active
    update: function(self: State, dt: number): SResult
    supdate: function(self: State, dt: number): SResult --shadow update, called when state is not on top. push and pop result not allowed
    drawWorld: function(self: State)
    drawUI: function(self: State)
    drawRaw: function(self: State)
  end
  type StateStack = record
    stack: Stack<State>
  end
end
local SResultTy = Mod.SResultTy
local SResult = Mod.SResult
local State = Mod.State
local StateStack = Mod.StateStack

function Mod.initStateStack(): StateStack
  local s = {
    stack = Stack.new() as Stack<State>,
  }
  setmetatable(s, {__index = StateStack})
  return s
end

function Mod.cont(): SResult
  return {
    type = "Cont",
    onPush = nil,
  }
end
function Mod.push(s: State): SResult
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

function StateStack:handleResult(res: SResult)
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

function StateStack:load(initState: State)
  self.stack:push(initState)
  local res = initState:load()
  self:handleResult(res)
end

function StateStack:update(dt: number)
  --local state = self.stack:peek()
  --if (not state) then return end
  for i,state in ipairs(self.stack.data) do
    local res: SResult = nil
    if i == 1 then
      if state.update then res = state:update(dt) end
    else
      if state.supdate then res = state:supdate(dt) end
    end
    if res then self:handleResult(res) end
  end
end

function StateStack:drawWorld()
  local state = self.stack:peek()
  if (not state) then return end
  state:drawWorld()
end

function StateStack:drawUI()
  local state = self.stack:peek()
  if (not state) then return end
  state:drawUI()
end

function StateStack:drawRaw()
  local state = self.stack:peek()
  if (not state) then return end
  state:drawRaw()
end

local mod: Mod = setmetatable({} as Mod, { __index = Mod })

-- todo: statestack operations

return mod
