local type Stack = record<T>
  data: {T}
  len: integer
end

local stack_mt = {__index = Stack}

function Stack:push<T>(item: T)
  table.insert(self.data, item)
  self.len = self.len+1
end
function Stack:pop<T>(): T -- | nil
  if self.len > 0 then
    local item = self.data[self.len]
    self.len = self.len-1
    table.remove(self.data)
    return item
  else
    return nil
  end
end
function Stack:peek<T>(): T
  if self.len > 0 then
    return self.data[self.len]
  else
    return nil
  end
end

function Stack.init<T>(item: T): Stack<T>
  local s = {} as Stack<T>
  local self = setmetatable(s, stack_mt)
  self.data = {item}
  self.len = 1
  return s
end

function Stack.new<T>(): Stack<T>
  local s = {} as Stack<T>
  local self = setmetatable(s, stack_mt)
  self.data = {} as {T}
  self.len = 0
  return s
end

return Stack
