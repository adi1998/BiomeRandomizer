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

    local value, checked = rom.ImGui.Checkbox("Custom run", config.custom_run)
    if checked and value ~= previousConfig.custom_run then
        config.custom_run = value
        previousConfig.custom_run = value
    end

    if value then
        for i = 1, config.run_length do
            rom.ImGui.Text("Biome "..tostring(i)..":")
            rom.ImGui.SameLine()
            if rom.ImGui.BeginCombo("###biome"..tostring(i), config.custom_order[tostring(i)]) then
                for biome, _ in pairs(mod.BiomeData) do
                    if rom.ImGui.Selectable(biome, (biome == config.custom_order[tostring(i)])) then
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
    end
end