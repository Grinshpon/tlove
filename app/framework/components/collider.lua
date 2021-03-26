local Contact = love.physics.Contact
local go = require("framework/gameobject")

local Collider = {}






local Collider_mt = { __index = Collider }

function Collider.new(fixture)
   local self = {
      gameObject = nil,
      fixture = fixture,
   }
   self = setmetatable(self, Collider_mt)
   return self
end

local mod = {
   Collider = Collider,
}

return mod
