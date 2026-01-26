function mod.GetRandomBiomeIconComponents()
    local locationY = 60
    local offsetX = 70
    local gap = 100
    local componentData = {
        {
			Animation = "",
			X = game.ScreenWidth - offsetX - 3*gap,
			Y = locationY,
			Scale = 0.35
		},
        {
			Animation = "",
			X = game.ScreenWidth - offsetX - 2*gap,
			Y = locationY,
			Scale = 0.35
		},
        {
			Animation = "",
			X = game.ScreenWidth - offsetX - gap,
			Y = locationY,
			Scale = 0.35
		},
        {
			Animation = "",
			X = game.ScreenWidth - offsetX,
			Y = locationY,
			Scale = 0.35
		},
    }
    for biome, value in pairs(game.CurrentRun.BiomesReached) do
        if value then
            local iconMap = mod.BiomeData[biome]
            if iconMap then
                componentData[iconMap.Position].Animation = iconMap.Icon
            end
        end
    end
    return componentData
end

modutil.mod.Path.Wrap("LoadCurrentRoomResources", function (base, currentRoom)
    if game.CurrentRun and game.CurrentRun.ActiveBounty and game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and mod.EndBossEncounterMap[currentRoom.Name] ~= nil then
        game.LoadPackages({Names = {"BiomeHub", _PLUGIN.guid}})
        local componentData = mod.GetRandomBiomeIconComponents()
        for index, component in ipairs(componentData) do
            game.ScreenData.RunClear.ComponentData[_PLUGIN.guid .. "BiomeIcon" .. tostring(index)] = component
        end
        game.ScreenData.RunClear.ComponentData.BiomeListBack = {
            Animation = _PLUGIN.guid .. "\\BiomeListBack",
            X = game.ScreenWidth - 303,
            Y = 119
        }
        table.insert(game.ScreenData.RunClear.ComponentData.Order, "BiomeListBack")
    end
    base(currentRoom)
end)