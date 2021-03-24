function noop() end



local Input = {KeyAction = {}, ActionMap = {}, Mouse = {}, }




























local KeyAction = Input.KeyAction
local ActionMap = Input.ActionMap
local Mouse = Input.Mouse
















local function updateActionMap(ia)
   for _, action in pairs(ia.actions) do
      if action.isDown then
         action.down()
      end
   end
end











local inputActionsList = {}

local input = {}

input.mouse = {
   x = 0,
   y = 0,
   dx = 0,
   dy = 0,
}

function input.keyAction(k)
   local ka = {
      binding = k,
      pressed = noop,
      released = noop,
      down = noop,
      isDown = false,
   }
   return ka
end

function input.addActionMap(ia)
   table.insert(inputActionsList, ia)
end

function input.update()
   local mx, my = love.mouse.getPosition()
   input.mouse.dx, input.mouse.dy = mx - input.mouse.x, my - input.mouse.y
   input.mouse.x, input.mouse.y = mx, my
   for _, ia in ipairs(inputActionsList) do
      if ia.enabled then updateActionMap(ia) end
   end
end

function input.enable(ia)
   ia.enabled = true
end

function input.disable(ia)
   ia.enabled = false
end

function love.keypressed(key)
   for _, ia in ipairs(inputActionsList) do
      if ia.enabled then
         for _, action in pairs(ia.actions) do
            if key == action.binding then
               action.pressed()
               action.isDown = true
            end
         end
      end
   end
end
function love.keyreleased(key)
   for _, ia in ipairs(inputActionsList) do
      if ia.enabled then
         for _, action in pairs(ia.actions) do
            if key == action.binding then
               action.released()
               action.isDown = false
            end
         end
      end
   end
end

return input
