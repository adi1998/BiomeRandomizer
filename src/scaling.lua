mod.ScaledEnemySets = {
    F = {
        "BiomeF",
    },
    G = {
        "BiomeG",
    },
    H = {
        "BiomeH",
        "BiomeHPassive",
        "BiomeHDebugSpawnScreen",
    },
    I = {
        "BiomeI",
    },
    N = {
        "BiomeN",
    },
    O = {
        "BiomeO",
        "BiomeOIntro",
    },
    P = {
        "BiomeP",
        "BiomePIntro",
    },
    Q = {
        "BiomeQ",
        "TyphonEggSpawnOptions",
    },
    Tartarus = {
        "EnemiesBiome1",
        "EnemiesBiome1MiniBoss"
    },
    Asphodel = {
        "EnemiesBiome2",
    },
    Elysium = {
        "EnemiesBiome3",
    },
    Styx = {
        "EnemiesBiome4",
        "EnemiesBiome4MiniBoss",
        "EnemiesHadesLarge",
        "EnemiesHadesSmall",
        "EnemiesHadesEMLarge",
        "EnemiesHadesEMSmall",
    }
}

mod.ScaledMiniBosses = {
    F = {
        "ZombieAssassin_Miniboss",
        "ZombieAssassin_Shadow",

        "Treant",
        "TreantTail",
        "TreantTail_Shadow",
        "Treant_Shadow",

        "FogEmitter_Elite",
        "FogEmitter_Shadow",
        "Screamer_Shadow",
    },
    G = {
        "WaterUnitMiniboss",
        "WaterUnitMiniboss_Shadow",

        "Octofish_Miniboss",
        "Octofish_Shadow",
        "Jellyfish",

        "CrawlerMiniboss",
    },
    H = {
        "Vampire",
        "Mourner_Shadow",

        "Lamia_Miniboss",
        "Lovesick_Shadow",
        "Lamia_Support",
    },
    I = {
        "SatyrRatCatcher_Miniboss",
        "SatyrLancer_Shadow",

        "GoldElemental_MiniBoss",
        "GoldElemental_Shadow",
    },
    N = {
        "SatyrCrossbow",
        "SatyrCrossbow_Shadow",

        "Boar",
        "Boar_Shadow",
    },
    O = {
        "Charybdis",
        "CharybdisTentacle",
        "Swab_Shadow",

        "Captain",
        "Captain_Shadow",
    },
    P = {
        "Talos",
        "AutomatonBeamer_Shadow",
        "AutomatonEnforcer_Shadow",

        "Dragon_MiniBoss",
        "Dragon_Shadow",
    },
    Q = {
        "TyphonEye",
        "Eyeball",
        "Mudman_Shadow",
        "MudmanEye_Elite",

        "TyphonTail",
        "TyphonTailMine",
        "DragonBurrower_Shadow",

        "Brute_Miniboss",
        "Brute_Shadow",

        "EarthElemental",
        "EarthElemental_Shadow",
        "Stalker_Miniboss",
    },
    Tartarus = {
        "WretchAssassin",
        "HeavyRangedSplitterMiniboss",
        "HeavyRangedSplitterFragment",
    },
    Asphodel = {
        "ShieldRangedMiniBoss",
        "SpreadShotUnitMiniboss",
        "HitAndRunUnit",
        "CrusherUnitElite"
    },
    Elysium = {
        "FlurrySpawnerElite",
    },
    Styx = {
        "SatyrRangedMiniboss",
        "RatThugMiniboss",
        "HeavyRangedForkedMiniboss",
        "ThiefImpulseMineLayerMiniboss",
        "HadesCrawlerMiniBoss"
    }
}

mod.ScaledBosses = {
    F = {
        "Hecate",
        "HecateCopy",
        "HecateCopyEM",
    },
    G = {
        "Scylla",
        "SirenDrummer",
        "SirenKeytarist",
        "Charybdis_ScyllaFight",
    },
    H = {
        "InfestedCerberus",
    },
    I = {
        "Chronos",
        "Chronos_EMShadow",

        "Screamer2_SuperElite",
        "Treant2_SuperElite",
        "Octofish_SuperElite",
        "Vampire_SuperElite",
        "Lamia_SuperElite",
        "ClockworkHeavyMelee_SuperElite",
        "SatyrRatCatcher_SuperElite",
    },
    N = {
        "Polyphemus",
    },
    O = {
        "Eris",
        "GunBombUnit",
    },
    P = {
        "Prometheus",
        "Eagle",
        "Heracles",
    },
    Q = {
        "TyphonHead",
        "TyphonHeadAdd",
        "TyphonHeadStaggeredDummy",
        "TyphonTail_Incursion",
        "TyphonArm",
        "TyphonArm_Incursion",

        "TyphonHeadEgg01",
        "TyphonHeadEgg02",
        "TyphonHeadEgg03",
        "TyphonHeadEgg04",
        "TyphonHeadEgg05",
        "TyphonHeadEggCaptain",
        "TyphonHeadEggBoar",
        "TyphonHeadEggDragon",

        "Simple2",
        "Brute2",
        "Mudman2",
        "LycanSwarmer2",
        "FishmanMelee2",
        "Captain_SuperElite",
        "Boar_SuperElite",
        "Dragon_SuperElite",

        "Chronos_TyphonFight",
    },
    Tartarus = {
        "HarpySupportUnit",
        "Harpy",
        "Harpy2",
        "Harpy3",
    },
    Asphodel = {
        "HydraHeadImmortal",
        "HydraHeadImmortalLavamaker",
        "HydraHeadImmortalSummoner",
        "HydraHeadImmortalSlammer",
        "HydraHeadImmortalWavemaker",
        "HydraHeadDartmaker",
        "HydraHeadLavamaker",
        "HydraHeadSummoner",
        "HydraHeadSlammer",
        "HydraHeadWavemaker",
        "HydraTooth",
        "HydraTooth2",
    },
    Elysium = {
        "Theseus",
        "Theseus2",
        "Minotaur",
        "Minotaur2",
    },
    Styx = {
        "Hades",
        "CerberusAssistUnit",
    }
}

mod.EnemyBiomeMap = {}

for biome, enemySets in pairs(mod.ScaledEnemySets) do
    for _, enemySet in ipairs(enemySets) do
        if game.EnemySets[enemySet] then
            for _, enemy in ipairs(game.EnemySets[enemySet]) do
                mod.EnemyBiomeMap[enemy] = biome
            end
        end
    end
end

for biome, enemies in pairs(mod.ScaledMiniBosses) do
    for _, enemy in ipairs(enemies) do
        mod.EnemyBiomeMap[enemy] = biome
    end
end

for biome, enemies in pairs(mod.ScaledBosses) do
    for _, enemy in ipairs(enemies) do
        mod.EnemyBiomeMap[enemy] = biome
    end
end

function mod.IsUnitMenace(currentBiome, attackerBiome)
    local biomeData = mod.BiomeData[currentBiome] or {}
    local next = biomeData.Next
    return next ~= nil and next == attackerBiome
end

mod.DamageScaling = {
    1.0,
    1.3,
    1.8,
    2.5,
}

function mod.ScaleDamage(damage, attackerBiome)
    local currentDepth = game.CurrentRun.ClearedBiomes
    local biomeDepth = (mod.BiomeData[attackerBiome] or {}).Position or currentDepth
    local newDamage = damage*mod.DamageScaling[currentDepth] / mod.DamageScaling[biomeDepth]
    return newDamage
end

modutil.mod.Path.Wrap("DamageHero", function (base, victim, triggerArgs)
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and config.scaling then
        local attacker = (triggerArgs or {}).AttackerTable or {}
        local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
        local currentBiome = route[game.CurrentRun.ClearedBiomes]
        if mod.EnemyBiomeMap[attacker.Name or "Unknown"] then
            local attackerName = attacker.Name or "Unknown"
            local attackerBiome = mod.EnemyBiomeMap[attackerName]
            print("Attacker name:", attackerName)
            print("Attacker biome:", mod.EnemyBiomeMap[attacker.Name])

            if attackerBiome and currentBiome and (not mod.IsUnitMenace(currentBiome, attackerBiome) ) and
                    triggerArgs.DamageAmount ~= nil and triggerArgs.DamageAmount > 0 then
                triggerArgs.DamageAmount =  mod.ScaleDamage(triggerArgs.DamageAmount, attackerBiome)
            end
        else
            print("Attacker name:", attacker.Name)
            print("Attacker biome not found")
        end
    end
    return base(victim, triggerArgs)
end)

modutil.mod.Path.Wrap("SetupUnit", function (base, unit, currentRun, args)
    base(unit, currentRun, args)
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and config.scaling then
        local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
        local currentBiome = route[game.CurrentRun.ClearedBiomes]
        if mod.EnemyBiomeMap[unit.Name or "Unknown"] then
            local unitName = unit.Name or "Unknown"
            local unitBiome = mod.EnemyBiomeMap[unitName]
            if unitBiome and currentBiome and (not mod.IsUnitMenace(currentBiome, unitBiome) ) then
                if unit.MaxHealth ~= nil then
                    unit.MaxHealth = mod.ScaleDamage(unit.MaxHealth, unitBiome)
                    unit.Health = unit.MaxHealth
                end
                if unit.HealthBuffer ~= nil and unit.HealthBuffer > 0 then
                    unit.HealthBuffer = mod.ScaleDamage(unit.HealthBuffer, unitBiome)
                end
                if unit.AIStages ~= nil and type(unit.AIStages) == "table" then
                    for _, stage in ipairs(unit.AIStages) do
                        if stage.NewMaxHealth ~= nil then
                            stage.NewMaxHealth = mod.ScaleDamage(stage.NewMaxHealth, unitBiome)
                        end
                    end
                end
                if unit.ShrineDataOverwrites ~= nil and unit.ShrineDataOverwrites.MaxHealth ~= nil then
                    unit.ShrineDataOverwrites.MaxHealth = mod.ScaleDamage(unit.ShrineDataOverwrites.MaxHealth, unitBiome)
                end
            end
        elseif unit.MaxHealth ~= nil and unit.MaxHealth ~= 0 then
            print("Unable to scale health for:", unit.Name)
        end
    end
end)