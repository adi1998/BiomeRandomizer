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

modutil.mod.Path.Wrap("ChooseNextRoomData", function (base, currentRun, args, otherDoors)
    if currentRun.ActiveBounty == prefix(_PLUGIN.guid .. "RandomBiomeRun") then
        args = args or {}
        local currentRoom = currentRun.CurrentRoom
        local nextRandomBiomeIntro = mod.GetNextRandomBiomeIntro(currentRoom.Name)
        if nextRandomBiomeIntro then
            print("Post boss room:", currentRoom.Name)
            print("Next intro room:", nextRandomBiomeIntro)
            args.ForceNextRoom = nextRandomBiomeIntro
            args.ForceNextRoom = mod.testnextroom or args.ForceNextRoom
            if game.Contains(zagIntro, nextRandomBiomeIntro) then
                game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = true
            else
                game.CurrentRun.ModsNikkelMHadesBiomesIsModdedRun = nil
            end
        end
    end
    return base(currentRun, args, otherDoors)
end)

bountyAPI.RegisterBounty({
    Id = _PLUGIN.guid .. "RandomBiomeRun",
    Title = "Random Biome Run",
    Description = "Each biome will selected at random based on the number of bosses defeated.",
    Difficulty = 3,
    IsStandardBounty = false,
    BiomeChar = "F",
    BaseData = {
		BiomeIcon = "GUI\\Screens\\BountyBoard\\Biome_Underworld",
		BiomeText = "Random Start",
        UnlockGameStateRequirements = {
            {
                PathTrue = { "GameState", "ReachedTrueEnding" },
            }
        }
    },
})

modutil.mod.Path.Wrap("DeathAreaRoomTransition", function (base, ...)
    game.BountyData[prefix(_PLUGIN.guid .. "RandomBiomeRun")].StartingBiome = mod.RandomStartingBiomeSet[math.random(#mod.RandomStartingBiomeSet)]
    print("Random start:", game.BountyData[prefix(_PLUGIN.guid .. "RandomBiomeRun")].StartingBiome)
    return base(...)
end)

modutil.mod.Path.Wrap("HubPostBountyLoad", function (base, ...)
    game.BountyData[prefix(_PLUGIN.guid .. "RandomBiomeRun")].StartingBiome = mod.RandomStartingBiomeSet[math.random(#mod.RandomStartingBiomeSet)]
    print("Random start:", game.BountyData[prefix(_PLUGIN.guid .. "RandomBiomeRun")].StartingBiome)
    return base(...)
end)