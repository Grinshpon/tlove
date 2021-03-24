return {
  skip_compat53 = true,
  global_env_def = "love",
  source_dir = "src",
  include_dir = {
    "src",
    --"src/framework",
    "include",
    --"assets",
  },
--  include = {
--    "**",
--    "**/*.tl",
--    "*.tl",
--    "*.d.tl",
--  },
  build_dir = "app",
}
