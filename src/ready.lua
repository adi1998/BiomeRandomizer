function mod.dump(o, depth)
   depth = depth or 0
   if type(o) == 'table' then
      local s = string.rep("\t", depth) .. '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. string.rep("\t",(depth+1)) .. '['..k..'] = ' .. mod.dump(v, depth + 1) .. ',\n'
      end
      return s .. string.rep("\t", depth) .. '} \n'
   else
      return tostring(o)
   end
end

local function prefix(key)
    return "Siuhnexus-BountyAPI_" .. key
end

mod.RandomPostBossSets = {
    {"F_PostBoss01", "N_PostBoss01"},
    {"G_PostBoss01", "O_PostBoss01"},
    {"H_PostBoss01", "P_PostBoss01"}
}

mod.RandomIntroSets = {
    {"G_Intro", "O_Intro"},
    {"H_Intro", "P_Intro"},
    {"I_Intro", "Q_Intro"},
}

mod.RandomStartingBiomeSet = {
    "F",
    "N",
}

mod.EndBossEncounterMap = {
    ["I_Boss01"] = game.BountyData.ChronosEncounters.Encounters,
    ["Q_Boss01"] = game.BountyData.TyphonEncounters.Encounters,
    ["Q_Boss02"] = game.BountyData.TyphonEncounters.Encounters,
    ["D_Boss01"] = { "BossHades" },
}

local zagPostBoss = {
    "A_PostBoss01",
    "X_PostBoss01",
    "Y_PostBoss01",
}

local zagIntro = {
    "X_Intro",
    "Y_Intro",
    "D_Intro"
}

local bountyIcon = _PLUGIN.guid .. "\\Biome_Both"

if rom.mods["NikkelM-Zagreus_Journey"] and rom.mods["NikkelM-Zagreus_Journey"].config.enabled == true then
    bountyIcon = _PLUGIN.guid .. "\\Biome_Trio"
    table.insert(mod.RandomStartingBiomeSet, "Tartarus")
    for i = 1, 3 do
        table.insert(mod.RandomPostBossSets[i], zagPostBoss[i])
        table.insert(mod.RandomIntroSets[i], zagIntro[i])
    end
end

function mod.GetNextRandomBiomeIntro(currentRoomName)
    for i = 1, 3 do
        if game.Contains(mod.RandomPostBossSets[i], currentRoomName) then
            local introSet = mod.RandomIntroSets[i]
            -- only allow styx after one H1 clear
            if (not game.GameState.TextLinesRecord["PersephoneFirstMeeting"]) and i == 3 then
                introSet = {"I_Intro", "Q_Intro"}
            end
            print("intro set", mod.dump(introSet))
            return game.GetRandomValue(introSet)
        end
    end
    return nil
end

local randomBountyId = _PLUGIN.guid .. "RandomBiomeRun"
RandomBountyName = prefix(randomBountyId)

bountyAPI.RegisterBounty({
    Id = randomBountyId,
    Title = "Random Biomes Run",
    Description = "Traverse through {#ShrineHighlightFormat}4 {#Prev}{#BoldFormatGraft}{$Keywords.BiomePlural} {#Prev}chosen at random. Each {#BoldFormatGraft}{$Keywords.Biome} {#Prev}will be selected based on the number of {#BoldFormatGraft}{$Keywords.BossPlural} {#Prev}defeated.",
    Difficulty = 3,
    IsStandardBounty = false,
    BiomeChar = "F",
    BaseData = {
		BiomeIcon = bountyIcon,
		BiomeText = "Random Start",
        UnlockGameStateRequirements = {
            {
                PathTrue = { "GameState", "ReachedTrueEnding" },
            }
        },
        ModsNikkelMHadesBiomesForceRunClearScreen = true
    },
})

modutil.mod.Path.Wrap("ChooseNextRoomData", function (base, currentRun, args, otherDoors)
    if currentRun.ActiveBounty == RandomBountyName then
        args = args or {}
        local currentRoom = currentRun.CurrentRoom
        local nextRandomBiomeIntro = mod.GetNextRandomBiomeIntro(currentRoom.Name)
        print("Post boss room:", currentRoom.Name)
        print("Next intro room:", nextRandomBiomeIntro)
        if nextRandomBiomeIntro then
            args.ForceNextRoom = mod.testnextroom or nextRandomBiomeIntro

            if game.Contains(zagIntro, nextRandomBiomeIntro) then
                game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = true
            else
                game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = nil
            end
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
    game.BountyData[RandomBountyName].StartingBiome = mod.RandomStartingBiomeSet[math.random(#mod.RandomStartingBiomeSet)]
    game.LoadPackages({Name = _PLUGIN.guid})
    print("Random start:", game.BountyData[RandomBountyName].StartingBiome)
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

modutil.mod.Path.Wrap("DeathPresentation", function (base, ...)
    if game.CurrentRun.ActiveBounty == RandomBountyName then
        game.GameState.PackagedBountyClears[game.CurrentRun.ActiveBounty] = game.GameState.PackagedBountyClears[game.CurrentRun.ActiveBounty] or 0
        game.GameState.PackagedBountyClearRecordTime[game.CurrentRun.ActiveBounty] = game.GameState.PackagedBountyClearRecordTime[game.CurrentRun.ActiveBounty] or game.CurrentRun.GameplayTime
    end
    return base(...)
end)

modutil.mod.Path.Wrap("MouseOverBounty", function (base, button)
    local bountyName = button.Data.Name
    if bountyName == RandomBountyName then
        game.GameState.PackagedBountyClearRecordTime[bountyName] = game.GameState.PackagedBountyClearRecordTime[bountyName] or 99999
    end
    return base(button)
end)

modutil.mod.Path.Wrap("CheckPackagedBountyCompletion", function(base)
    if game.CurrentRun and game.CurrentRun.ActiveBounty == RandomBountyName then
        local currentRoom = game.CurrentRun.CurrentRoom
        print("overriding encounters data for boss room", currentRoom.Name)
        if currentRoom and currentRoom.Name and mod.EndBossEncounterMap[currentRoom.Name] then
            game.BountyData[RandomBountyName].Encounters = mod.EndBossEncounterMap[currentRoom.Name]
        end
    end
    return base()
end)

function mod.UpdateRandomBountyOrder()
    local bountyOrder = game.ScreenData.BountyBoard.ItemCategories[1]
    -- print(mod.dump(bountyOrder))
    local randomBountyIndex = game.GetIndex(bountyOrder, RandomBountyName)
    if randomBountyIndex ~= 0 then
        for i = randomBountyIndex, 2, -1 do
            bountyOrder[i], bountyOrder[i-1] = bountyOrder[i-1], bountyOrder[i]
        end
    end
    -- print(mod.dump(bountyOrder))
end

mod.UpdateRandomBountyOrder()