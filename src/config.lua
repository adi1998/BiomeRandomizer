local config = {
  enabled = true;
  banned_biomes = {},
  run_length = 4,
}

local configDesc = {
  banned_biomes = "Remove biomes from the pool of available biomes",
  run_length = "configure the number of biomes for the run"
}

return config, configDesc