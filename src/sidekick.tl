--[[
local sidekick = {
  config = require "framework/config",
  gameObject = require "framework/gameObject",
  input = require "framework/input",
  scene = require "framework/scene",
  Stack = require "framework/stack"
}

sidekick = setmetatable(sidekick, require "framework/sidekick")
--]]
local sidekick = require "framework/sidekick"
return sidekick
