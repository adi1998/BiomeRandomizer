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

modutil.mod.Path.Wrap("OlympusSkyExitPresentation", function (base, currentRun, exitDoor)
    base(currentRun, exitDoor)
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and
            game.CurrentRun.CurrentRoom and game.CurrentRun.CurrentRoom.Name == "P_PostBoss01" and
            exitDoor.Room.Name ~= "Q_Intro" then
        game.CurrentRun.CurrentRoom.NextRoomEntranceFunctionNameOverride = nil
        game.CurrentRun.CurrentRoom.NextRoomEntranceFunctionArgsOverride = nil
    end
end)

modutil.mod.Path.Wrap("OlympusChronosPortalExitPresentation", function (base, currentRun, exitDoor)
    base(currentRun, exitDoor)
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and
            game.CurrentRun.CurrentRoom and game.CurrentRun.CurrentRoom.Name == "P_PostBoss01" and
            exitDoor.Room.Name ~= "Q_Intro" then
        game.CurrentRun.CurrentRoom.NextRoomEntranceFunctionNameOverride = nil
        game.CurrentRun.CurrentRoom.NextRoomEntranceFunctionArgsOverride = nil
    end
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

modutil.mod.Path.Wrap("CalcMetaProgressRatio", function (base, run)
    local ratio = base(run)
    if ratio and game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) then
        local targetMetaRewardsRatio = (run.TargetMetaRewardsRatio or run.CurrentRoom.TargetMetaRewardsRatio or run.Hero.TargetMetaRewardsRatio)
        local minorRunProgressChance = targetMetaRewardsRatio
        minorRunProgressChance = minorRunProgressChance + (run.Hero.TargetMetaRewardsAdjustSpeed * (targetMetaRewardsRatio - ratio))
        if minorRunProgressChance > 0.8 then
            return nil
        end
    end
    return ratio
end)

modutil.mod.Path.Wrap("ChronosKillPresentation", function (base, ...)
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and not mod.IsCurrentEncounterLast() then
        game.thread(mod.ObstacleTest2)
    end
    base(...)
end)

modutil.mod.Path.Wrap("TyphonHeadKillPresentation", function (base, ...)
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and not mod.IsCurrentEncounterLast() then
        game.thread(mod.ObstacleTest3)
    end
    base(...)
end)