local Contact = love.physics.Contact
local go = require("framework/gameobject")


local Callback = {}

local function noop(_o, _c)
end

local Collider = {}






local Collider_mt = { __index = Collider }

function Collider.new(fixture, beginContact)
   local self = {
      gameObject = nil,
      fixture = fixture,
      beginContact = beginContact or noop,
   }
   self = setmetatable(self, Collider_mt)
   return self
end

local mod = {
   Callback = Callback,
   Collider = Collider,
}

return mod
