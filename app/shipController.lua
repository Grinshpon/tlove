local sk = require("sidekick")
local input = sk.input
local GameObject = sk.gameObject.GameObject

local ShipController = {}





local pInput = {
   actions = {
      zoomIn = input.keyAction("="),
      zoomOut = input.keyAction("-"),
      moveLeft = input.keyAction("a"),
      moveRight = input.keyAction("d"),
      moveUp = input.keyAction("w"),
      moveDown = input.keyAction("s"),
   },
   enabled = false,
}

function ShipController:initInputCallbacks()
   pInput.actions.zoomIn.pressed = function()
      if sk.camera.scale < 3 then
         sk.camera.scale = sk.camera.scale + 1
      end
   end
   pInput.actions.zoomOut.pressed = function()
      if sk.camera.scale > 1 then
         sk.camera.scale = sk.camera.scale - 1
      end
   end
   pInput.actions.moveUp.pressed = function()
      self.moveInput[1] = true
   end
   pInput.actions.moveUp.released = function()
      self.moveInput[1] = false
   end

   pInput.actions.moveDown.pressed = function()
      self.moveInput[2] = true
   end
   pInput.actions.moveDown.released = function()
      self.moveInput[2] = false
   end

   pInput.actions.moveLeft.pressed = function()
      self.moveInput[3] = true
   end
   pInput.actions.moveLeft.released = function()
      self.moveInput[3] = false
   end

   pInput.actions.moveRight.pressed = function()
      self.moveInput[4] = true
   end
   pInput.actions.moveRight.released = function()
      self.moveInput[4] = false
   end

   input.addActionMap(pInput)
   input.enable(pInput)
end

function ShipController:update(dt)
   local mx, my = 0, 0
   if self.moveInput[1] then my = my + 1 end
   if self.moveInput[2] then my = my - 1 end
   if self.moveInput[3] then mx = mx + 1 end
   if self.moveInput[4] then mx = mx - 1 end
   mx = mx * self.speed * dt
   my = my * self.speed * dt
   self.gameObject:moveLocal(mx, my)
end

local sc_mt = {
   __index = ShipController,
}

function ShipController.new(speed)
   local res = {
      moveInput = { false, false, false, false },
      speed = speed,
   }
   res = setmetatable(res, sc_mt)
   res:initInputCallbacks()
   return res
end

return ShipController
