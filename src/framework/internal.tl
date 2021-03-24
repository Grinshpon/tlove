--[[
local internal: {string:any} = {
  config = require "config",
  alg = require "alg",
  input = require "input",
  scene = require "scene",
  Stack = require "Stack",
  gameObject = require "gameobject",
  sidekick = require "sidekick",
}


global function import<T>(mod: string): T
  return internal[mod] as T-- or require(mod)
end
--]]
