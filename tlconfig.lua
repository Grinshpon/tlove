return {
  skip_compat53 = true,
  preload_modules = {
    "love",
  },
  source_dir = "src",
  include_dir = {
    "src",
    "include",
    --"assets",
  },
  include = {"*.tl", "*.d.tl"},
  build_dir = "app",
}
