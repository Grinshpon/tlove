love.graphics.setDefaultFilter("nearest","nearest")

local config = {
  -- intended game resolution differs from window resolution
  width = 1280,
  height = 720,
  worldScaleType = 3, --0: neither, 1: width, 2: height, 3: both
  uiScaleType = 2, --0: neither, 1: width, 2: height, 3: both
}

return config
