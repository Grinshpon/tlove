local Stack = require("Stack")

local GameObject = {}

local Mod = {SResult = {}, State = {}, StateStack = {}, }


















local SResultTy = Mod.SResultTy
local SResult = Mod.SResult
local State = Mod.State
local StateStack = Mod.StateStack

function Mod.initStateStack()
   return {
      stack = Stack.new(),
   }
end

local mod = setmetatable({}, { __index = Mod })



return mod
