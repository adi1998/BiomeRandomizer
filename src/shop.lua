function mod.SpawnShopItemsEarly()
    local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and route and #route == game.CurrentRun.EnteredBiomes then
        local hermesTraits = {}
        for _, trait in pairs( game.CurrentRun.Hero.Traits ) do
            if trait.OnExpire and trait.OnExpire.SpawnShopItem then
                table.insert( hermesTraits, trait )
            end
        end
        for _, trait in pairs( hermesTraits ) do
		    game.RemoveTraitData( game.CurrentRun.Hero, trait, { Silent = true })
        end
    end
end

for biome, biomeData  in pairs(mod.BiomeData) do
    local preBossRoom = biomeData.PreBoss
    if preBossRoom then
        if type(preBossRoom) == "string" then
            game.RoomSetData[biome][preBossRoom].StartThreadedEvents = game.RoomSetData[biome][preBossRoom].StartThreadedEvents or {}
            table.insert( game.RoomSetData[biome][preBossRoom].StartThreadedEvents,
            {
                FunctionName = _PLUGIN.guid .. "." .. "SpawnShopItemsEarly"
            })
        else
            for index, value in ipairs(preBossRoom) do
                game.RoomSetData[biome][value].StartThreadedEvents = game.RoomSetData[biome][value].StartThreadedEvents or {}
                table.insert( game.RoomSetData[biome][value].StartThreadedEvents,
                {
                    FunctionName = _PLUGIN.guid .. "." .. "SpawnShopItemsEarly"
                })
            end
        end
    end
end

function mod.CheckLastBiome(source, args)
    local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
    return game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and route and #route == game.CurrentRun.EnteredBiomes
end

function mod.CheckLastBiomeVanilla(source, args)
    return (game.CurrentRun.EnteredBiomes == game.GameData.FullRunBiomeCount and game.CurrentRun.IsDreamRun) or
           (game.CurrentRun.EnteredBiomes == 4 and not (game.CurrentRun.IsDream or game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty)))
end

if game.RoomData["Q_PreBoss01"].DistanceTriggers[1].GameStateRequirements.OrRequirements then
    table.insert(game.RoomData["Q_PreBoss01"].DistanceTriggers[1].GameStateRequirements.OrRequirements, {
        {
            FunctionName = _PLUGIN.guid .. "." .. "CheckLastBiomeVanilla"
        },
    })
    table.insert(game.RoomData["Q_PreBoss01"].DistanceTriggers[1].GameStateRequirements.OrRequirements, {
        {
            FunctionName = _PLUGIN.guid .. "." .. "CheckLastBiome"
        },
    })
else
    game.RoomData["Q_PreBoss01"].DistanceTriggers[1].GameStateRequirements =
    {
        OrRequirements = {
            {
                {
                    FunctionName = _PLUGIN.guid .. "." .. "CheckLastBiomeVanilla"
                },
            },
            {
                {
                    FunctionName = _PLUGIN.guid .. "." .. "CheckLastBiome"
                },
            }
        }
    }
end