local previousConfig = {
    custom_order = {"F", "G", "H", "I"},
    banned_biomes = {}
}

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

    rom.ImGui.Text("Run length")
    if rom.ImGui.BeginCombo("###length", tostring(config.run_length)) then
        for i = 1,4 do
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

    local max_start = 4-config.run_length+1

    if config.starting_biome_position > max_start then
        config.starting_biome_position = max_start
    end

    if not config.custom_run then
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

    local value, checked = rom.ImGui.Checkbox("Custom run", config.custom_run)
    if checked and value ~= previousConfig.custom_run then
        config.custom_run = value
        previousConfig.custom_run = value
    end

    if value then
        for i = 1, config.run_length do
            rom.ImGui.Text("Biome "..tostring(i)..":")
            rom.ImGui.SameLine()
            if rom.ImGui.BeginCombo("###biome"..tostring(i), mod.BiomeData[config.custom_order[tostring(i)]].Name) then
                for biome, _ in pairs(mod.BiomeData) do
                    if rom.ImGui.Selectable(mod.BiomeData[biome].Name, (biome == config.custom_order[tostring(i)])) then
                        if biome ~= previousConfig.custom_order[tostring(i)] then
                            config.custom_order[tostring(i)] = biome
                            previousConfig.custom_order[tostring(i)] = biome
                        end
                        rom.ImGui.SetItemDefaultFocus()
                    end
                end
                rom.ImGui.EndCombo()
            end
        end
        if not mod.IsCustomRouteValid() then
            rom.ImGui.Text("Warning!! Duplicate biomes detected.\nRun will use default route.")
        end
    end
end