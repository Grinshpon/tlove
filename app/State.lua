local Stack = require("Stack")

local GameObject = require("gameobject").GameObject

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

function Mod.cont()
   return {
      type = "Cont",
      onPush = nil,
   }
end
function Mod.push(s)
   return {
      type = "Push",
      onPush = s,
   }
end
function Mod.pop()
   return {
      type = "Pop",
      onPush = nil,
   }
end
function Mod.exit()
   return {
      type = "Exit",
      onPush = nil,
   }
end

function StateStack:handleResult(res)
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

function StateStack:load(initState)
   self.stack:push(initState)
   local res = initState:load()
   self:handleResult(res)
end

function StateStack:update(dt)


   for i, state in ipairs(self.stack.data) do
      local res = nil
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

local mod = setmetatable({}, { __index = Mod })



return mod
