mod.testnextroom = nil

-- local function trigger_Gift()
--     game.CurrentRun.BiomesReached = {
--         Tartarus = true,
--         G = true,
--         Elysium = true,
--         Styx = true
--     }
--     print(mod.dump(game.CurrentRun.BiomesReached))
--     local componentData = mod.GetRandomBiomeIconComponents()
--     for index, component in ipairs(componentData) do
--         game.ScreenData.RunClear.ComponentData[_PLUGIN.guid .. "BiomeIcon" .. tostring(index)] = component
--     end
--     game.ScreenData.RunClear.ComponentData.BiomeListBack = {
--         Animation = _PLUGIN.guid .. "\\BiomeListBack",
--         X = game.ScreenWidth - 303,
--         Y = 119
--     }
--     table.insert(game.ScreenData.RunClear.ComponentData.Order, "BiomeListBack")
--     game.LoadPackages({Name = "NikkelM-HadesBiomesGUIModded"})
-- 	rom.mods["NikkelM-Zagreus_Journey"].ModsNikkelMHadesBiomesOpenRunClearScreen()
-- end

-- game.OnControlPressed({'Gift', function()
-- 	return trigger_Gift()
-- end})