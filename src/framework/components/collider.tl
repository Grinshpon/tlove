local Contact <const> = love.physics.Contact
local go = require "framework/gameobject"


local type Callback = function(Collider, Contact)

local function noop(_o: Collider, _c: Contact)
end

local record Collider
  gameObject: go.GameObject
  --shape: love.physics.Shape
  fixture: love.physics.Fixture
  beginContact: Callback --function(other: Collider, contact: Contact)
end

local Collider_mt = {__index = Collider}

function Collider.new(fixture: love.physics.Fixture, beginContact: Callback): Collider
  local self: Collider = {
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
