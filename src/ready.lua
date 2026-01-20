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

local encounterMap = {
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

if rom.mods["NikkelM-Zagreus_Journey"] then
    table.insert(mod.RandomStartingBiomeSet, "Tartarus")
    for i = 1, 3 do
        table.insert(mod.RandomPostBossSets[i], zagPostBoss[i])
        table.insert(mod.RandomIntroSets[i], zagIntro[i])
    end
end

function mod.GetNextRandomBiomeIntro(currentRoomName)
    for i = 1, 3 do
        if game.Contains(mod.RandomPostBossSets[i], currentRoomName) then
            return game.GetRandomValue(mod.RandomIntroSets[i])
        end
    end
    return nil
end

local randomBountyId = _PLUGIN.guid .. "RandomBiomeRun"
RandomBountyName = prefix(randomBountyId)

bountyAPI.RegisterBounty({
    Id = randomBountyId,
    Title = "Random Biome Run",
    Description = "Each biome will selected at random based on the number of bosses defeated.",
    Difficulty = 3,
    IsStandardBounty = false,
    BiomeChar = "F",
    BaseData = {
		BiomeIcon = _PLUGIN.guid .. "\\Biome_Both",
		BiomeText = "Random Start",
        UnlockGameStateRequirements = {
            {
                PathTrue = { "GameState", "ReachedTrueEnding" },
            }
        }
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
    end
    return base(currentRun, args, otherDoors)
end)

modutil.mod.Path.Wrap("DeathAreaRoomTransition", function (base, ...)
    game.BountyData[RandomBountyName].StartingBiome = mod.RandomStartingBiomeSet[math.random(#mod.RandomStartingBiomeSet)]
    game.LoadPackages({Name = _PLUGIN.guid})
    print("Random start:", game.BountyData[RandomBountyName].StartingBiome)
    return base(...)
end)

modutil.mod.Path.Wrap("HubPostBountyLoad", function (base, ...)
    game.BountyData[RandomBountyName].StartingBiome = mod.RandomStartingBiomeSet[math.random(#mod.RandomStartingBiomeSet)]
    game.LoadPackages({Name = _PLUGIN.guid})
    print("Random start:", game.BountyData[RandomBountyName].StartingBiome)
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
        if currentRoom and currentRoom.Name and encounterMap[currentRoom.Name] then
            game.BountyData[RandomBountyName].Encounters = encounterMap[currentRoom.Name]
        end
    end
    return base()
end)

function mod.UpdateRandomBountyOrder()
    local bountyOrder = game.ScreenData.BountyBoard.ItemCategories[1]
    print(mod.dump(bountyOrder))
    local randomBountyIndex = game.GetIndex(bountyOrder, RandomBountyName)
    if randomBountyIndex ~= 0 then
        for i = randomBountyIndex, 2, -1 do
            bountyOrder[i], bountyOrder[i-1] = bountyOrder[i-1], bountyOrder[i]
        end
    end
    print(mod.dump(bountyOrder))
end

mod.UpdateRandomBountyOrder()