local Stack = require("Stack")

local GameObject = {}

local Mod = {SResult = {}, State = {}, StateStack = {}, }























local SResultTy = Mod.SResultTy
local SResult = Mod.SResult
local State = Mod.State
local StateStack = Mod.StateStack

function Mod.initStateStack()
   local s = {
      stack = Stack.new(),
   }
   setmetatable(s, { __index = StateStack })
   return s
end

function StateStack:update(dt)
end

function StateStack:drawWorld()
end

function StateStack:drawUI()
end

function StateStack:drawRaw()
end

local mod = setmetatable({}, { __index = Mod })



return mod
