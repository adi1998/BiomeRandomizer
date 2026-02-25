local config = {
  enabled = true;
  banned_biomes = { },
  run_length = 4,
  custom_order = {
    ["1"] = "F",
    ["2"] = "G",
    ["3"] = "H",
    ["4"] = "I",
    ["5"] = "Unknown",
    ["6"] = "Unknown",
  },
  custom_run = false,
  starting_biome_position = 1,
  scaling = true,
  true_random = false,
  final_biome_last = false,
  final_biome_only_last = false,
}

local configDesc = {
  -- banned_biomes = "Remove biomes from the pool of available biomes",
  run_length = "Configure the number of biomes for the run (1-4)",
  custom_order = "Set your own biome order instead of random",
  custom_run = "Use custom order",
  starting_biome_position = "Starting biome depth when run_length < 4",
  scaling = "Enable scaling for out of order biomes",
  true_random = "Randomize biomes without considering biome depth",
  final_biome_last = "The final biome will always be one of Tartarus(H2), Summit or Styx",
  final_biome_only_last = "Non final biome cannot be Tartarus(H2), Summit or Styx",
}

return config, configDesc