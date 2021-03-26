local Stack = {}




local stack_mt = { __index = Stack }

function Stack:push(item)
   table.insert(self.data, item)
   self.len = self.len + 1
end
function Stack:pop()
   if self.len > 0 then
      local item = self.data[self.len]
      self.len = self.len - 1
      table.remove(self.data)
      return item
   else
      return nil
   end
end
function Stack:peek()
   if self.len > 0 then
      return self.data[self.len]
   else
      return nil
   end
end

function Stack.init(item)
   local s = {}
   local self = setmetatable(s, stack_mt)
   self.data = { item }
   self.len = 1
   return s
end

function Stack.new()
   local s = {}
   local self = setmetatable(s, stack_mt)
   self.data = {}
   self.len = 0
   return s
end

return Stack
