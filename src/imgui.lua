local previousConfig = {
    custom_order = {
        ["1"] = "F",
        ["2"] = "G",
        ["3"] = "H",
        ["4"] = "I",
    },
    banned_biomes = {}
}

local biomeDisplayOrder = {
    "F",
    "G",
    "H",
    "I",

    "N",
    "O",
    "P",
    "Q",
}

if rom.mods["NikkelM-Zagreus_Journey"] and rom.mods["NikkelM-Zagreus_Journey"].config and rom.mods["NikkelM-Zagreus_Journey"].config.enabled then
    game.ConcatTableValuesIPairs(biomeDisplayOrder,{
        "Tartarus",
        "Asphodel",
        "Elysium",
        "Styx"
    })
end

rom.gui.add_imgui(function()
    if rom.ImGui.Begin("Biome Randomizer") then
        DrawMenu()
        rom.ImGui.End()
    end
end)

rom.gui.add_to_menu_bar(function()
    if rom.ImGui.BeginMenu("Biome Randomizer") then
        DrawMenu()
        rom.ImGui.EndMenu()
    end
end)

function DrawMenu()

    local max_run_length = ((config.custom_run or config.true_random) and 6) or 4

    config.run_length = ((config.run_length <= max_run_length) and config.run_length) or max_run_length

    rom.ImGui.Text("Run length")
    if rom.ImGui.BeginCombo("###length", tostring(config.run_length)) then
        for i = 1, max_run_length do
            if rom.ImGui.Selectable(tostring(i), (i == config.run_length)) then
                if i ~= previousConfig.run_length then
                    previousConfig.run_length = i
                    config.run_length = i
                end
                rom.ImGui.SetItemDefaultFocus()
            end
        end
        rom.ImGui.EndCombo()
    end
    rom.ImGui.SameLine()
    rom.ImGui.Text("Biome(s)")

    local value, checked = rom.ImGui.Checkbox("Custom run", config.custom_run)
    if checked then
        config.custom_run = value
    end

    if not (config.custom_run or config.true_random) then
        local max_start = 4-config.run_length+1

        if config.starting_biome_position > max_start then
            config.starting_biome_position = max_start
        end

        rom.ImGui.Text("Starting Depth")
        if rom.ImGui.BeginCombo("###start", tostring(config.starting_biome_position)) then
            for i = 1, max_start do
                if rom.ImGui.Selectable(tostring(i), (i == config.starting_biome_position)) then
                    if i ~= previousConfig.starting_biome_position then
                        previousConfig.starting_biome_position = i
                        config.starting_biome_position = i
                    end
                    rom.ImGui.SetItemDefaultFocus()
                end
            end
            rom.ImGui.EndCombo()
        end
    end

    if config.custom_run then
        for i = 1, config.run_length do
            rom.ImGui.Text("Biome "..tostring(i)..":")
            rom.ImGui.SameLine()
            if rom.ImGui.BeginCombo("###biome"..tostring(i), (mod.BiomeData[config.custom_order[tostring(i)]] or {}).Name or "Unknown") then
                for _, biome in ipairs(biomeDisplayOrder) do
                    local biomeData = mod.BiomeData[biome]
                    if game.IsGameStateEligible(biomeData, biomeData.GameStateRequirements) then
                        if rom.ImGui.Selectable(biomeData.Name, (biome == config.custom_order[tostring(i)])) then
                            if biome ~= previousConfig.custom_order[tostring(i)] then
                                config.custom_order[tostring(i)] = biome
                                previousConfig.custom_order[tostring(i)] = biome
                            end
                            rom.ImGui.SetItemDefaultFocus()
                        end
                    end
                end
                rom.ImGui.EndCombo()
            end
        end
        if not mod.IsCustomRouteValid() then
            rom.ImGui.Text("Warning!! Duplicate or unknown biomes detected.\nRun will use default route.")
        end
    end

    value, checked = rom.ImGui.Checkbox("Enable damage/health scaling\nfor out of order biomes", config.scaling)
    if checked and value ~= previousConfig.scaling then
        config.scaling = value
        previousConfig.scaling = value
    end

    value, checked = rom.ImGui.Checkbox("Enable true randomization of biomes.\nBiomes will be selected independent\nof their original depth", config.true_random)
    if checked then
        config.true_random = value
        previousConfig.true_random = value
        mod.UpdateBiomeIcons()
    end

    if config.true_random then
        value, checked = rom.ImGui.Checkbox("The final biome will always be one of\nTartarus(H2), Summit or Styx", config.final_biome_last)
        if checked then
            config.final_biome_last = value
        end

        value, checked = rom.ImGui.Checkbox("Non-final biome cannot be Tartarus(H2),\nSummit or Styx", config.final_biome_only_last)
        if checked then
            config.final_biome_only_last = value
        end
    end

end

function  mod.UpdateBiomeIcons()
    local bountyIcon = _PLUGIN.guid .. "\\Biome_Both"
    if rom.mods["NikkelM-Zagreus_Journey"] and rom.mods["NikkelM-Zagreus_Journey"].config.enabled == true then
        bountyIcon = _PLUGIN.guid .. "\\Biome_Trio"
    end

    if config.true_random then
        bountyIcon = bountyIcon .. "_True"
    end

    for index, bounty in ipairs(mod.RegisteredBounties) do
        game.BountyData[bounty].BiomeIcon = bountyIcon
    end
end