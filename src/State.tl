local Stack = require "Stack"

local type GameObject = record end --temporary

local type Mod = record
  type SResultTy = enum
    "Pop"
    "Push"
    "Cont"
  end
  type SResult = record
    type: SResultTy
    onPush: State | nil
  end
  type State = record
    gameObjects: {GameObject}
    gameObjectIndex: {string:number} -- reason gameObjects isn't a map is because I'm hoping it gets optimized by the JIT by being a list.
    load: function(prev: State): SResult --on first time load, called once
    awake: function(prev: State): SResult --called whenver state becomes active
    update: function(dt: number): SResult
    --drawWorld: function()
    --drawUI: function()
    --drawRaw: function()
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

function StateStack:update(dt: number)
end

function StateStack:drawWorld()
end

function StateStack:drawUI()
end

function StateStack:drawRaw()
end

local mod: Mod = setmetatable({} as Mod, { __index = Mod })

-- todo: statestack operations

return mod
