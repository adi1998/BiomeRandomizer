mod.BiomeData = {
    -- underworld
    F =
    {
        Position = 1,
        PostBoss = "F_PostBoss01",
        Intro = {"F_Opening01", "F_Opening02", "F_Opening03"},
        Icon = "GUI\\Screens\\BountyBoard\\Biome_Erebus",
        Encounters = game.BountyData.HecateEncounters.Encounters,
    },
    G =
    {
        Position = 2,
        PostBoss = "G_PostBoss01",
        Intro = "G_Intro",
        Icon = "GUI\\Screens\\BountyBoard\\Biome_Oceanus",
        Encounters = game.BountyData.ScyllaEncounters.Encounters,
    },
    H =
    {
        Position = 3,
        PostBoss = "H_PostBoss01",
        Intro = "H_Intro",
        Icon = "GUI\\Screens\\BountyBoard\\Biome_Fields",
        Encounters = game.BountyData.InfestedCerberusEncounters.Encounters,
    },
    I =
    {
        Position = 4,
        PostBoss = "I_Boss01",
        Intro = "I_Intro",
        Icon = "GUI\\Screens\\BountyBoard\\Biome_Underworld",
        Encounters = game.BountyData.ChronosEncounters.Encounters,
    },

    -- surface
    N =
    {
        Position = 1,
        PostBoss = "N_PostBoss01",
        Intro = "N_Opening01",
        Icon = "GUI\\Screens\\BountyBoard\\Biome_Elysium",
        Encounters = game.BountyData.PolyphemusEncounters.Encounters,
    },
    O =
    {
        Position = 2,
        PostBoss = "O_PostBoss01",
        Intro = "O_Intro",
        Icon = "GUI\\Screens\\BountyBoard\\Biome_Ships",
        Encounters = game.BountyData.ErisEncounters.Encounters,
    },
    P =
    {
        Position = 3,
        PostBoss = "P_PostBoss01",
        Intro = "P_Intro",
        Icon = "GUI\\Screens\\BountyBoard\\Biome_Olympus",
        Encounters = game.BountyData.PrometheusEncounters.Encounters,
    },
    Q =
    {
        Position = 4,
        PostBoss = { "Q_Boss01", "Q_Boss02" },
        Intro = "Q_Intro",
        Icon = "GUI\\Screens\\BountyBoard\\Biome_Surface",
        Encounters = game.BountyData.TyphonEncounters.Encounters,
    },
}

if rom.mods["NikkelM-Zagreus_Journey"] and rom.mods["NikkelM-Zagreus_Journey"].config.enabled == true then
    game.OverwriteTableKeys(mod.BiomeData, {
        -- nightmare
        Tartarus =
        {
            Position = 1,
            PostBoss = "A_PostBoss01",
            Intro = "RoomOpening",
            Icon = "GUIModded\\Screens\\BountyBoard\\Biome_Tartarus",
            Encounters = game.BountyData.ModsNikkelMHadesBiomesMegaeraEncounters.Encounters,
        },
        Asphodel =
        {
            Position = 2,
            PostBoss = "X_PostBoss01",
            Intro = "X_Intro",
            Icon = "GUIModded\\Screens\\BountyBoard\\Biome_Asphodel",
            Encounters = game.BountyData.ModsNikkelMHadesBiomesHydraEncounters.Encounters,
        },
        Elysium =
        {
            Position = 3,
            PostBoss = "Y_PostBoss01",
            Intro = "Y_Intro",
            Icon = "GUIModded\\Screens\\BountyBoard\\Biome_Elysium",
            Encounters = game.BountyData.ModsNikkelMHadesBiomesTheseusAndMinotaurEncounters.Encounters,
        },
        Styx =
        {
            Position = 4,
            PostBoss = nil,
            Intro = "D_Intro",
            Icon = "GUIModded\\Screens\\BountyBoard\\Biome_Styx",
            GameStateRequirements =
            {
                PathTrue = { "GameState", "TextLinesRecord", "PersephoneFirstMeeting" }
            },
            Encounters = game.BountyData.ModsNikkelMHadesBiomesHadesEncounters.Encounters,
        },
    })
end

function mod.GenerateRoute()
    local route = {}
    config.run_length = ( (config.run_length <= 4 and config.run_length >= 1) and config.run_length ) or 4
    for position = 1, config.run_length do
        local biomeList = {}
        for biome, modBiomeData in pairs(mod.BiomeData) do
            if modBiomeData.Position == position and game.IsGameStateEligible(modBiomeData, modBiomeData.GameStateRequirements) then
                table.insert(biomeList, biome)
            end
        end
        table.insert(route, biomeList[ math.random( #biomeList ) ])
    end
    print("Generated route", mod.dump(route))
    return route
end