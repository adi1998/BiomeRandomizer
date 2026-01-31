function mod.dump(o, depth)
    depth = depth or 0
    if type(o) == 'table' then
        local s = "\n" .. string.rep("\t", depth) .. '{\n'
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. string.rep("\t",(depth+1)) .. '['..k..'] = ' .. mod.dump(v, depth + 1) .. ',\n'
        end
        return s .. string.rep("\t", depth) .. '}'
    elseif type(o) == "string" then
        return "\"" .. o .. "\""
    else
        return tostring(o)
    end
end

mod.EndBossEncounterMap = {
    ["I_Boss01"] = game.BountyData.ChronosEncounters.Encounters,
    ["Q_Boss01"] = game.BountyData.TyphonEncounters.Encounters,
    ["Q_Boss02"] = game.BountyData.TyphonEncounters.Encounters,
    ["D_Boss01"] = { "BossHades" },
}

mod.ZagIntro = {
    "RoomOpening",
    "X_Intro",
    "Y_Intro",
    "D_Intro"
}

function mod.ParseIntro(intro)
    if type(intro) == "table" then
        return intro[math.random(#intro)]
    end
    return intro
end

function mod.CheckPostBoss(postboss, currentRoomName)
    if type(postboss) == "string" then
        return postboss == currentRoomName
    end
    if type(postboss) == "table" then
        return game.Contains(postboss, currentRoomName)
    end
    return false
end

modutil.mod.Path.Wrap("ChooseNextRoomData", function (base, currentRun, args, otherDoors)
    if currentRun.ActiveBounty and game.Contains(mod.RegisteredBounties, currentRun.ActiveBounty) then
        args = args or {}
        local currentRoom = currentRun.CurrentRoom
        local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
        -- print("game.CurrentRun.ClearedBiomes", game.CurrentRun.ClearedBiomes)
        -- print("route[game.CurrentRun.ClearedBiomes]", route[game.CurrentRun.ClearedBiomes])
        if route and route[game.CurrentRun.ClearedBiomes] and mod.CheckPostBoss( mod.BiomeData[ route[game.CurrentRun.ClearedBiomes] ].PostBoss, currentRoom.Name ) then
            local nextBiome = route[game.CurrentRun.ClearedBiomes + 1] or "I"
            local nextBiomeData = mod.BiomeData[nextBiome]
            local nextRoomIntro = mod.ParseIntro(nextBiomeData.Intro)
            args.ForceNextRoom = nextRoomIntro
            if game.Contains(mod.ZagIntro, nextRoomIntro) then
                game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = true
            else
                game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = nil
            end
        end
        if currentRoom.ExitFunctionName == "EndEarlyAccessPresentation" or
                currentRoom.ExitFunctionName == "NikkelM-Zagreus_Journey" .. "." .. "CheckRunEndPresentation" then
            currentRoom.ExitFunctionName = "nil"
            currentRoom.SkipLoadNextMap = false
        end
        local nextRoomData = base(currentRun, args, otherDoors)
        if currentRoom.Name == "F_PostBoss01" and args.ForceNextRoom == "O_Intro" then
            nextRoomData.EntranceDirection = "LeftRight"
            nextRoomData.FlipHorizontalChance = 0.0
        end
        return nextRoomData
    end
    return base(currentRun, args, otherDoors)
end)

function mod.ResetClearScreenData()
    game.LoadPackages({Name = _PLUGIN.guid})

    for index = 1, 4 do
        game.ScreenData.RunClear.ComponentData[_PLUGIN.guid .. "BiomeIcon" .. tostring(index)] = nil
    end
    game.ScreenData.RunClear.ComponentData.BiomeListBack = nil
    game.ScreenData.RunClear.ComponentData.Order = {
        "BackgroundDim",
        "VictoryBackground",
        "ActionBarBackground",
        "StatsBacking",
        "BadgeRankIcon",
    }
end

modutil.mod.Path.Wrap("DeathAreaRoomTransition", function (base, ...)
    mod.ResetClearScreenData()
    return base(...)
end)

modutil.mod.Path.Wrap("HubPostBountyLoad", function (base, ...)
    mod.ResetClearScreenData()
    return base(...)
end)

modutil.mod.Path.Wrap("CheckPackagedBountyCompletion", function(base)
    if game.CurrentRun and game.CurrentRun.ActiveBounty and game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) then
        local currentRoom = game.CurrentRun.CurrentRoom
        local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
        if route and game.CurrentRun.ClearedBiomes == #route then
            print("overriding encounters data for boss room", currentRoom.Name)
            game.BountyData[game.CurrentRun.ActiveBounty].Encounters = mod.BiomeData[route[#route]].Encounters
        else
            game.BountyData[game.CurrentRun.ActiveBounty].Encounters = {}
        end
    end
    return base()
end)

function mod.UpdateRandomBountyOrder(bountyName)
    local bountyOrder = game.ScreenData.BountyBoard.ItemCategories[1]
    -- print(mod.dump(bountyOrder))
    local randomBountyIndex = game.GetIndex(bountyOrder, bountyName)
    if randomBountyIndex ~= 0 then
        for i = randomBountyIndex, 2, -1 do
            bountyOrder[i], bountyOrder[i-1] = bountyOrder[i-1], bountyOrder[i]
        end
    end
    -- print(mod.dump(bountyOrder))
end

for index, bountyName in ipairs(mod.RegisteredBounties) do
    mod.UpdateRandomBountyOrder(bountyName)
end

function mod.SpawnShopItemsEarly()
    local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and route and #route == game.CurrentRun.ClearedBiomes then
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

function mod.CheckPathEquality(path1, path2)
    local flatPath1 = ""
    local flatPath2 = ""
    for key, value in pairs(path1) do
        flatPath1 = flatPath1 .. "." .. tostring(value)
    end
    for key, value in pairs(path2) do
        flatPath2 = flatPath2 .. "." .. tostring(value)
    end
    return flatPath1 == flatPath2
end

function mod.UpdateRoomStartMusicEvents()
    for musicEventIndex, musicEvent in ipairs(game.RoomStartMusicEvents) do
        for requireIndex, requirement in ipairs(musicEvent.GameStateRequirements) do
            if requirement.PathTrue and mod.CheckPathEquality(requirement.PathTrue, { "CurrentRun", "BiomesReached", "F" }) then
                musicEvent.GameStateRequirements[requireIndex] =
                {
					Path = { "CurrentRun", "BiomesReached" },
					HasAny = { "F", "G", "H", "I", },
				}
                table.insert(musicEvent.GameStateRequirements, {
                    Path = { "CurrentRun", "CurrentRoom", "RoomSetName" },
                    IsAny = { "F", "G", "H", "I", },
                })
            end
            if requirement.PathTrue and mod.CheckPathEquality(requirement.PathTrue, { "CurrentRun", "BiomesReached", "N" }) then
                musicEvent.GameStateRequirements[requireIndex] =
                {
					Path = { "CurrentRun", "BiomesReached" },
					HasAny = { "N", "O", "P", "Q", },
				}
                table.insert(musicEvent.GameStateRequirements, {
                    Path = { "CurrentRun", "CurrentRoom", "RoomSetName" },
                    IsAny = { "N", "O", "P", "Q", "N_SubRooms", },
                })
            end
        end
    end
    -- print(mod.dump(game.RoomStartMusicEvents))
end

mod.UpdateRoomStartMusicEvents()

modutil.mod.Path.Wrap("StartNewRun", function (base, prevRun, args)
    args = args or {}
    if game.Contains(mod.RegisteredBounties, args.ActiveBounty) then
        game.CurrentRun = {}
        local route = mod.GenerateRoute()
        if route and #route > 0 then
            args.StartingBiome = route[1]
            args.RoomName = mod.ParseIntro(mod.BiomeData[args.StartingBiome].Intro)
            local currentRun = base(prevRun, args)
            currentRun[_PLUGIN.guid .. "GeneratedRoute"] = route
            if args.StartingBiome == "Q" then
                -- setting depth cache to 1 for starting at Q to ensure a room is found.
                currentRun.BiomeDepthCache = 1
            end
            if game.Contains(mod.ZagIntro, args.RoomName) then
                currentRun.ModsNikkelMHadesBiomesIsModdedRun = true
            end
            return currentRun
        end
    end
    return base(prevRun,args)
end)

modutil.mod.Path.Wrap("CreateRoom", function (base, roomData, args)
    args = args or {}
    if game.CurrentRun and roomData.Name and game.Contains(mod.ZagIntro, roomData.Name) and game.Contains(mod.RegisteredBounties, args.ActiveBounty) then
        game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = true
    end
    return base(roomData, args)
end)

modutil.mod.Path.Wrap("GetBiomeDepth", function (base, currentRun)
    local basedepth = base(currentRun)
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) then
        local depth = 1

        for roomIndex = #currentRun.RoomHistory, 1, -1 do
            local room = currentRun.RoomHistory[roomIndex]
            if mod.EndBossEncounterMap[room.Name] ~= nil then
                break
            end
            depth = depth + 1
        end
        return math.min(depth,basedepth)
    end
    return basedepth
end)