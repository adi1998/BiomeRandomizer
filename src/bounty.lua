local function prefix(key)
    return "Siuhnexus-BountyAPI_" .. key
end

local bountyIcon = _PLUGIN.guid .. "\\Biome_Both"

if rom.mods["NikkelM-Zagreus_Journey"] and rom.mods["NikkelM-Zagreus_Journey"].config.enabled == true then
    bountyIcon = _PLUGIN.guid .. "\\Biome_Trio"
end

if config.true_random then
    bountyIcon = bountyIcon .. "_True"
end

local randomBountyId = _PLUGIN.guid .. "RandomBiomeRun"
RandomBountyName = prefix(randomBountyId)

mod.RegisteredBounties = {}

bountyAPI.RegisterBounty({
    Id = randomBountyId,
    Title = "Random Biomes Run",
    Description = "Fight your way through upto {#ShrineHighlightFormat}4 {#Prev}random {#BoldFormatGraft}{$Keywords.BiomePlural} {#Prev}with your current loadout.",
    Difficulty = 2,
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
        RunOverrides = "nil",
        ModsNikkelMHadesBiomesForceRunClearScreen = true
    },
    RoomTransition = function (BountyRunData, RoomName)
        return mod.ConnectEndBossToBiome(BountyRunData, RoomName)
    end,
    CanEnd = function (BountyRunData, RoomName)
        return mod.CanEndRandom()
    end,
    EndFunctions = function (BountyRunData, Cleared)
        mod.SanitizeKeepsakeCache()
    end
})

table.insert(mod.RegisteredBounties, RandomBountyName)

bountyAPI.RegisterBounty({
    Id = randomBountyId .. "Chaos",
    Title = "Chaos Everywhere",
    Description = "Fight your way through upto {#ShrineHighlightFormat}4 {#Prev}random {#BoldFormatGraft}{$Keywords.BiomePlural} {#Prev} with a {#BoldFormatGraft}random loadout{#Prev}, not including your {#ShrineHighlightFormat}{$GameState.SpentShrinePointsCache}{#Prev}{!Icons.ShrinePointNoTooltip} {#Emph}Fear {#Prev}of currently selected {#Emph}Vows{#Prev}.",
    Difficulty = 3,
    IsStandardBounty = false,
    BiomeChar = "F",
    BaseData = {
		BiomeIcon = bountyIcon,
		BiomeText = "Random Start",
        UnlockGameStateRequirements = {
            NamedRequirements = { "PackageBountyRandom" },
        },
        LootOptions =
		{
			{
				Name = "WeaponPointsRareDrop",
				Overrides =
				{
					CanDuplicate = false,
					AddResources =
					{
						WeaponPointsRare = 1,
					},
				}
			},
		},
        RunOverrides = "nil",
        RandomMetaUpgradeCostTotal = 30,
        RandomWeaponKitNames = game.BountyData.BasePackageBountyRandom.RandomWeaponKitNames,
		UseRandomWeaponUpgrade = true,
		RandomFamiliarNames = game.BountyData.BasePackageBountyRandom.RandomFamiliarNames,
        RandomKeepsakeNames = game.BountyData.BasePackageBountyRandom.RandomKeepsakeNames,
		RandomFatedKeepsakeNames = game.BountyData.BasePackageBountyRandom.RandomFatedKeepsakeNames,
        ModsNikkelMHadesBiomesForceRunClearScreen = true
    },
    RoomTransition = function (BountyRunData, RoomName)
        return mod.ConnectEndBossToBiome(BountyRunData, RoomName)
    end,
    CanEnd = function (BountyRunData, RoomName)
        return mod.CanEndRandom()
    end,
    EndFunctions = function (BountyRunData, Cleared)
        mod.SanitizeKeepsakeCache()
    end
})

table.insert(mod.RegisteredBounties, RandomBountyName .. "Chaos")
table.insert(game.GameData.AllRandomPackagedBounties, RandomBountyName .. "Chaos")

bountyAPI.RegisterBounty({
    Id = randomBountyId .. "GreatChaos",
    Title = "Great Chaos Everywhere",
    Description = "Fight your way through upto {#ShrineHighlightFormat}4 {#Prev}random {#BoldFormatGraft}{$Keywords.BiomePlural} {#Prev} with a {#BoldFormatGraft}random loadout{#Prev}, including {#ShrineHighlightFormat}{$BountyData.PackageBountyRandomUnderworld_Difficulty2.RandomShrineUpgradePointTotal}{#Prev}{!Icons.ShrinePointNoTooltip} {#Emph}Fear {#Prev}of randomly selected {#Emph}Vows{#Prev}.",
    Difficulty = 4,
    IsStandardBounty = false,
    BiomeChar = "F",
    BaseData = {
		BiomeIcon = bountyIcon,
		BiomeText = "Random Start",
        UnlockGameStateRequirements = {
            NamedRequirements = { "PackageBountyRandom" },
        },
        LootOptions =
		{
			{
				Name = "WeaponPointsRareDrop",
				Overrides =
				{
					CanDuplicate = false,
					AddResources =
					{
						WeaponPointsRare = 2,
					},
				}
			},
		},
        RunOverrides = "nil",
        RandomMetaUpgradeCostTotal = 30,
        RandomShrineUpgradePointTotal = 20,
        RandomWeaponKitNames = game.BountyData.BasePackageBountyRandom.RandomWeaponKitNames,
		UseRandomWeaponUpgrade = true,
		RandomFamiliarNames = game.BountyData.BasePackageBountyRandom.RandomFamiliarNames,
        RandomKeepsakeNames = game.BountyData.BasePackageBountyRandom.RandomKeepsakeNames,
		RandomFatedKeepsakeNames = game.BountyData.BasePackageBountyRandom.RandomFatedKeepsakeNames,
        ModsNikkelMHadesBiomesForceRunClearScreen = true
    },
    RoomTransition = function (BountyRunData, RoomName)
        return mod.ConnectEndBossToBiome(BountyRunData, RoomName)
    end,
    CanEnd = function (BountyRunData, RoomName)
        return mod.CanEndRandom()
    end,
    EndFunctions = function (BountyRunData, Cleared)
        mod.SanitizeKeepsakeCache()
    end
})

table.insert(mod.RegisteredBounties, RandomBountyName .. "GreatChaos")
table.insert(game.GameData.AllRandomPackagedBounties, RandomBountyName .. "GreatChaos")

bountyAPI.RegisterBounty({
    Id = randomBountyId .. "GreaterChaos",
    Title = "Greater Chaos Everywhere",
    Description = "Fight your way through upto {#ShrineHighlightFormat}4 {#Prev}random {#BoldFormatGraft}{$Keywords.BiomePlural} {#Prev} with a {#BoldFormatGraft}random loadout{#Prev}, including {#ShrineHighlightFormat}{$BountyData.Siuhnexus-BountyAPI_zerp-BiomeRandomizerRandomBiomeRunGreaterChaos.RandomShrineUpgradePointTotal}{#Prev}{!Icons.ShrinePointNoTooltip} {#Emph}Fear {#Prev}of randomly selected {#Emph}Vows{#Prev}.",
    Difficulty = 5,
    IsStandardBounty = false,
    BiomeChar = "F",
    BaseData = {
		BiomeIcon = bountyIcon,
		BiomeText = "Random Start",
        UnlockGameStateRequirements = {
            NamedRequirements = { "PackageBountyRandom" },
        },
        LootOptions =
		{
			{
				Name = "WeaponPointsRareDrop",
				Overrides =
				{
					CanDuplicate = false,
					AddResources =
					{
						WeaponPointsRare = 3,
					},
				}
			},
		},
        RunOverrides = "nil",
        RandomMetaUpgradeCostTotal = 30,
        RandomShrineUpgradePointTotal = 32,
        RandomWeaponKitNames = game.BountyData.BasePackageBountyRandom.RandomWeaponKitNames,
		UseRandomWeaponUpgrade = true,
		RandomFamiliarNames = game.BountyData.BasePackageBountyRandom.RandomFamiliarNames,
        RandomKeepsakeNames = game.BountyData.BasePackageBountyRandom.RandomKeepsakeNames,
		RandomFatedKeepsakeNames = game.BountyData.BasePackageBountyRandom.RandomFatedKeepsakeNames,
        ModsNikkelMHadesBiomesForceRunClearScreen = true
    },
    RoomTransition = function (BountyRunData, RoomName)
        return mod.ConnectEndBossToBiome(BountyRunData, RoomName)
    end,
    CanEnd = function (BountyRunData, RoomName)
        return mod.CanEndRandom()
    end,
    EndFunctions = function (BountyRunData, Cleared)
        mod.SanitizeKeepsakeCache()
    end
})

table.insert(mod.RegisteredBounties, RandomBountyName .. "GreaterChaos")
table.insert(game.GameData.AllRandomPackagedBounties, RandomBountyName .. "GreaterChaos")

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

-- taken from EndlessNight
function mod.SanitizeKeepsakeCache()
    local shortenedKeepsakes = {}
    for i = 1, 4 do
        shortenedKeepsakes[i] = game.CurrentRun.KeepsakeCache[i]
    end
    game.CurrentRun.KeepsakeCache = shortenedKeepsakes
end