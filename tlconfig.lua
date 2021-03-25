return {
  skip_compat53 = true,
  gen_target = "5.1",
  global_env_def = "love",
  source_dir = "src",
  include_dir = {
    "src",
    "include",
    --"assets",
  },
  build_dir = "app",
}
