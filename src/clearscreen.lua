local biomeIconMap = {
    F = {Icon = "GUI\\Screens\\BountyBoard\\Biome_Erebus", Position = 1},
    G = {Icon = "GUI\\Screens\\BountyBoard\\Biome_Oceanus", Position = 2},
    H = {Icon = "GUI\\Screens\\BountyBoard\\Biome_Fields", Position = 3},
    I = {Icon = "GUI\\Screens\\BountyBoard\\Biome_Underworld", Position = 4},
    N = {Icon = "GUI\\Screens\\BountyBoard\\Biome_Ephyra", Position = 1},
    O = {Icon = "GUI\\Screens\\BountyBoard\\Biome_Ships", Position = 2},
    P = {Icon = "GUI\\Screens\\BountyBoard\\Biome_Olympus", Position = 3},
    Q = {Icon = "GUI\\Screens\\BountyBoard\\Biome_Surface", Position = 4},
    Tartarus = {Icon = "GUIModded\\Screens\\BountyBoard\\Biome_Tartarus", Position = 1},
    Asphodel = {Icon = "GUIModded\\Screens\\BountyBoard\\Biome_Asphodel", Position = 2},
    Elysium = {Icon = "GUIModded\\Screens\\BountyBoard\\Biome_Elysium", Position = 3},
    Styx = {Icon =  "GUIModded\\Screens\\BountyBoard\\Biome_Styx", Position = 4},
}

function mod.GetRandomBiomeIconComponents()
    local componentData = {
        {
			Animation = "",
			X = game.ScreenCenterX - 400,
			Y = 50,
			Scale = 0.35
		},
        {
			Animation = "",
			X = game.ScreenCenterX - 280,
			Y = 50,
			Scale = 0.35
		},
        {
			Animation = "",
			X = game.ScreenCenterX + 280,
			Y = 50,
			Scale = 0.35
		},
        {
			Animation = "",
			X = game.ScreenCenterX + 400,
			Y = 50,
			Scale = 0.35
		},
    }
    for biome, value in pairs(game.CurrentRun.BiomesReached) do
        if value then
            local iconMap = biomeIconMap[biome] or biomeIconMap.F
            componentData[iconMap.Position].Animation = iconMap.Icon
        end
    end
    return componentData
end

modutil.mod.Path.Wrap("LoadCurrentRoomResources", function (base, currentRoom)
    if game.CurrentRun and game.CurrentRun.ActiveBounty == RandomBountyName and mod.EndBossEncounterMap[currentRoom.Name] ~= nil then
        game.LoadPackages({Names = {"BiomeHub",}})
        local componentData = mod.GetRandomBiomeIconComponents()
        for index, component in ipairs(componentData) do
            game.ScreenData.RunClear.ComponentData[_PLUGIN.guid .. "BiomeIcon" .. tostring(index)] = component
        end
    end
    base(currentRoom)
end)