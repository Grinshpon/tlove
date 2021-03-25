global function noop() end

-- types

local record Input
  record KeyAction
    binding: love.keyboard.KeyConstant
    pressed: function()
    released: function()
    down: function()
    isDown: boolean
  end

  record ActionMap
    actions: {string:KeyAction}
    enabled: boolean
  end
  keyAction: function(love.keyboard.KeyConstant): KeyAction
  addActionMap: function(ActionMap)
  update: function()
  enable: function(ActionMap)
  disable: function(ActionMap)


  record Mouse
    x: number
    y: number
    dx: number
    dy: number
    --buttons
  end
  mouse: Mouse
end
local KeyAction = Input.KeyAction
local ActionMap = Input.ActionMap
--local Mouse = Input.Mouse

--function KeyAction.new(o: KeyAction): KeyAction
  --return setmetatable(o,{__index=KeyAction})
  --local self: KeyAction = setmetatable({}, { __index = KeyAction })
  --self.binding = o.binding
  --self.pressed = o.pressed or noop
  --self.released = o.released or noop
  --self.down = o.down or noop
  --self.isDown = o.isDown or false
  --return self
--end

--global record ActionMap
  --actions: {string:KeyAction}
  --enabled: boolean
--end

local function updateActionMap(ia: ActionMap)
  for _,action in pairs(ia.actions) do
    if action.isDown then
      action.down()
    end
  end
end

--function ActionMap.new(o: ActionMap): ActionMap
   --return setmetatable(o, { __index = ActionMap })
   --local self: ActionMap = setmetatable({}, { __index = ActionMap })
   --self.actions = o.actions
   --self.enabled = o.enabled or false
   --return self
--end

-- module

local inputActionsList: {ActionMap} = {}

local input: Input = {}

input.mouse = {
  x=0,
  y=0,
  dx=0,
  dy=0,
}

function input.keyAction(k: love.keyboard.KeyConstant): KeyAction
  local ka: KeyAction = {
    binding = k,
    pressed = noop,
    released = noop,
    down = noop,
    isDown = false,
  }
  return ka
end

function input.addActionMap(ia: ActionMap)
  table.insert(inputActionsList,ia)
end

function input.update()
  local mx,my = love.mouse.getPosition()
  input.mouse.dx, input.mouse.dy = mx-input.mouse.x, my-input.mouse.y
  input.mouse.x,input.mouse.y = mx,my
  for _,ia in ipairs(inputActionsList) do
    if ia.enabled then updateActionMap(ia) end
  end
end

function input.enable(ia: ActionMap)
  ia.enabled = true
end

function input.disable(ia: ActionMap)
  ia.enabled = false
end

function love.keypressed(key: love.keyboard.KeyConstant)
  for _,ia in ipairs(inputActionsList) do
    if ia.enabled then
      for _,action in pairs(ia.actions) do
        if key == action.binding then
          action.pressed()
          action.isDown = true
        end
      end
    end
  end
end
function love.keyreleased(key: love.keyboard.KeyConstant)
  for _,ia in ipairs(inputActionsList) do
    if ia.enabled then
      for _,action in pairs(ia.actions) do
        if key == action.binding then
          action.released()
          action.isDown = false
        end
      end
    end
  end
end

return input
