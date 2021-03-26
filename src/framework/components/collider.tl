local Contact <const> = love.physics.Contact
local go = require "framework/gameobject"

local record Collider
  gameObject: go.GameObject
  --shape: love.physics.Shape
  fixture: love.physics.Fixture
  beginContact: function(other: Collider, contact: Contact)
end

local Collider_mt = {__index = Collider}

function Collider.new(fixture: love.physics.Fixture): Collider
  local self: Collider = {
    gameObject = nil,
    fixture = fixture,
  }
  self = setmetatable(self, Collider_mt)
  return self
end

local mod = {
  Collider = Collider
}

return mod
