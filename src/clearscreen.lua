function mod.GetRandomBiomeIconComponents()
    local locationY = 60
    local offsetX = 70
    local gap = 100
    local componentData = {}
    local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"] or {}
    for position = #route, 1, -1 do
        local biomeData = mod.BiomeData[route[position]]
        if biomeData then
            local component =
            {
                Animation = biomeData.Icon,
                X = game.ScreenWidth - offsetX - gap*( #route - position ),
                Y = locationY,
                Scale = 0.35
            }
            table.insert(componentData, component)
        end
    end
    return componentData
end

function mod.IsCurrentEncounterLast()
    local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
	if route and game.CurrentRun.ClearedBiomes == #route and game.Contains( mod.BiomeData[route[#route]].Encounters, game.CurrentRun.CurrentRoom.Encounter.Name ) then
		return true
	end
    return false
end

modutil.mod.Path.Wrap("LoadCurrentRoomResources", function (base, currentRoom)
    if game.CurrentRun and game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and mod.IsCurrentEncounterLast() then
        game.LoadPackages({ Names = { "BiomeHub", _PLUGIN.guid } })
        local componentData = mod.GetRandomBiomeIconComponents()
        for index, component in ipairs(componentData) do
            game.ScreenData.RunClear.ComponentData[_PLUGIN.guid .. "BiomeIcon" .. tostring(index)] = component
        end
        game.ScreenData.RunClear.ComponentData.BiomeListBack = {
            Animation = _PLUGIN.guid .. "\\BiomeListBack",
            X = game.ScreenWidth - 303,
            Y = 119
        }
        table.insert(game.ScreenData.RunClear.ComponentData.Order, "BiomeListBack")
    end

    if game.CurrentRun and game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and not mod.CanEndRandom() and mod.EndBossEncounterMap[currentRoom.Name] then
        game.LoadPackages({ Name = "BiomeI" })
    end

    base(currentRoom)
end)

-- resetting clearscreen data in hub
function mod.ResetClearScreenData()
    game.LoadPackages({Name = _PLUGIN.guid})

    for index = 1, 6 do
        game.ScreenData.RunClear.ComponentData[_PLUGIN.guid .. "BiomeIcon" .. tostring(index)] = nil
    end
    game.ScreenData.RunClear.ComponentData.BiomeListBack = nil
    game.ScreenData.RunClear.ComponentData.Order =
    {
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

-- arbitrary final boss clear screen
local killPresentaionWrapList = {
    "HecateKillPresentation",
    "ScyllaKillPresentation",
    "InfestedCerberusKillPresentation",
    "ErisKillPresentation",
    "PrometheusKillPresentation"
}

for _, killPresFunc in ipairs(killPresentaionWrapList) do
    modutil.mod.Path.Wrap(killPresFunc, function (base, unit, args)
        base(unit, args)
        local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
        if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and mod.IsCurrentEncounterLast() and route and #route > 1 then
            game.SetPlayerInvulnerable(_PLUGIN.guid .. "RandomClearScreen")
            game.OpenRunClearScreen()
        end
    end)
end

modutil.mod.Path.Wrap("GenericBossKillPresentation", function (base, unit, args)
    base(unit, args)
    local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and mod.IsCurrentEncounterLast() and unit.Name == "Polyphemus" and route and #route > 1 then
        game.wait(0.5)
        game.SetPlayerInvulnerable(_PLUGIN.guid .. "RandomClearScreen")
        game.OpenRunClearScreen()
    end
end)

modutil.mod.Path.Wrap("OpenRunClearScreen", function (base)
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) then
        local qReached = game.CurrentRun.BiomesReached.Q
        local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"] or { "F" }
        local lastBiome = route[#route]
        if game.Contains({"F", "G", "H", "I"}, lastBiome) then
            game.CurrentRun.BiomesReached.Q = nil
        elseif game.Contains({"N", "O", "P", "Q"}, lastBiome) then
            game.CurrentRun.BiomesReached.Q = true
        end
        base()
        game.CurrentRun.BiomesReached.Q = qReached
        return
    end
    base()
end)

if rom.mods["NikkelM-Zagreus_Journey"] and rom.mods["NikkelM-Zagreus_Journey"].config and rom.mods["NikkelM-Zagreus_Journey"].config.enabled then
    modutil.mod.Path.Wrap("NikkelM-Zagreus_Journey" .. "." .. "HarpyKillPresentation", function (base, unit, args)
        base(unit, args)

        local blockedUnits = {
            "CrawlerMiniBoss",
            "HadesCrawlerMiniBoss",
            "Hades"
        }
        local route = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
        if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and mod.IsCurrentEncounterLast() and
                route and #route > 1 and not game.Contains(blockedUnits, unit.Name) then
            game.SetPlayerInvulnerable(_PLUGIN.guid .. "RandomClearScreen")
            game.CallFunctionName("NikkelM-Zagreus_Journey" .. "." .. "ModsNikkelMHadesBiomesOpenRunClearScreen")
        end
    end)

    modutil.mod.Path.Wrap("NikkelM-Zagreus_Journey" .. "." .. "ModsNikkelMHadesBiomesOpenRunClearScreen", function (base, ...)
        if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and not mod.IsCurrentEncounterLast() then
            return
        end

        base(...)
    end)
end