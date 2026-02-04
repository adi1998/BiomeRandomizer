mod.testnextroom = nil

-- local function trigger_Gift()
--     -- game.CurrentRun.BiomesReached = {
--     --     Tartarus = true,
--     --     G = true,
--     --     Elysium = true,
--     --     Styx = true
--     -- }
--     print(mod.dump(game.CurrentRun.BiomesReached))
--     local componentData = mod.GetRandomBiomeIconComponents()
--     for index, component in ipairs(componentData) do
--         game.ScreenData.RunClear.ComponentData[_PLUGIN.guid .. "BiomeIcon" .. tostring(index)] = component
--     end
--     game.ScreenData.RunClear.ComponentData.BiomeListBack = {
--         Animation = _PLUGIN.guid .. "\\BiomeListBack",
--         X = game.ScreenWidth - 303,
--         Y = 119
--     }
--     table.insert(game.ScreenData.RunClear.ComponentData.Order, "BiomeListBack")
--     -- game.LoadPackages({Name = "NikkelM-HadesBiomesGUIModded"})
--     game.LoadPackages({Name = _PLUGIN.guid})
-- 	game.OpenRunClearScreen()
-- end

-- game.OnControlPressed({'Gift', function()
-- 	return trigger_Gift()
-- end})

function mod.UseHealthFountain(used, user)
    if used.HealingSpentAnimation then
        -- game.SetThingProperty({Property = "AddColor", Value = false, DestinationId = used.ObjectId })
    end
    game.CallFunctionName("UseHealthFountain", used, user)
end

function mod.ObstacleTest()
    game.LoadPackages({Name = "BiomeI"})
    local offsetY = -400
    local offsetX = -400
    local destId = 589694 -- game.GetIdsByType({Name = "Shrine"})
    local healthFountain = game.DeepCopyTable(game.ObstacleData.HealthFountain)
    healthFountain.ObjectId = game.SpawnObstacle({Name="HealthFountain", DestinationId=destId, OffsetY=offsetY, OffsetX = offsetX, Group = "Standing"})
    healthFountain.OnUsedFunctionName = _PLUGIN.guid .. "." .. "UseHealthFountain"
    game.SetupObstacle(healthFountain)
    -- game.SetThingProperty({Property = "AddColor", Value = false, DestinationId = healthFountain.ObjectId })
    -- game.SetColor({ Id = healthFountain.ObjectId, Color = {0,0,0,1} })
    game.SetColor({ Id = healthFountain.ObjectId, Color = game.Color.White })
    -- game.SetThingProperty({Property = "AddColor", Value = false, DestinationId = healthFountain.ObjectId })
    game.SetScale({Id = healthFountain.ObjectId, Fraction = 0.3})

    offsetX = -400
    offsetY = -0
    local newGiftRack = game.DeepCopyTable(game.ObstacleData.GiftRack)

    newGiftRack.ObjectId = game.SpawnObstacle({Name="GiftRack", DestinationId=destId, OffsetY=offsetY, OffsetX = offsetX, AttachedTable = newGiftRack, Group = "Standing"})
    newGiftRack.ActivateIds = { newGiftRack.ObjectId }
    game.SetupObstacle(newGiftRack)
    game.SetScale({Id = newGiftRack.ObjectId, Fraction = 0.2})
    print("material", newGiftRack.Material)
    -- game.SetThingProperty({ Property = "Ambient", Value = 1, DestinationId = newGiftRack.ObjectId })
    game.SetThingProperty({Property = "AddColor", Value = true, DestinationId = newGiftRack.ObjectId })
    -- game.SetThingProperty({Property = "Material", Value = "null", DestinationId = newGiftRack.ObjectId})
    game.SetColor({ Id = newGiftRack.ObjectId, Color = {0,0,0,1} })
    -- game.AddToGroup({ Id = newGiftRack.ObjectId, Name = "Standing", DrawGroup = true })
    -- local giftShine = game.SpawnObstacle({ Name = "BlankObstacle", Group = "FX_Standing_Top"})
    -- game.SetThingProperty({ Property = "SortMode", Value = "Id", DestinationId = giftShine })
    -- game.Attach({ Id = giftShine, DestinationId = newGiftRack.ObjectId })
    -- game.SetAnimation({ Name = "GiftRackGlean", DestinationId = giftShine })
    local thingPropList = {
        "Material",
        "Ambient",
        "AddColor",
        "Graphic",
        "Scale"
    }
    local obstacles = game.GetIdsByType({ Name = "GiftRack" })
    print(mod.dump(obstacles))
    print(obstacles[1])
    for index, value in ipairs(thingPropList) do
        print(value, mod.dump(game.GetThingDataValue({ Id = obstacles[1], Property = value })))
    end
    print(obstacles[2])
    for index, value in ipairs(thingPropList) do
        print(value, mod.dump(game.GetThingDataValue({ Id = obstacles[2], Property = value })))
    end

    offsetX = -1200
    offsetY = -800
    local wellShop = game.DeepCopyTable(game.ObstacleData.SurfaceShop)
    -- local wellShop = game.DeepCopyTable(game.ObstacleData.WellShop)
    wellShop.ObjectId = game.SpawnObstacle({Name="ChallengeSwitchBase", DestinationId=destId, OffsetY=offsetY, OffsetX = offsetX, Group = "Standing"})

    game.SetupObstacle(wellShop)
    wellShop.UseText = wellShop.AvailableUseText
    wellShop.OnUsedFunctionName = wellShop.ChallengeSwitchUseFunctionName
    wellShop.ReadyToUse = true
    game.CurrentRun.CurrentRoom.Store = nil
    game.RefreshUseButton( wellShop.ObjectId, wellShop )
    game.SetAnimation({ Name = "SurfaceShopUnlocked", DestinationId = wellShop.ObjectId })
    game.UseableOn({ Id = wellShop.ObjectId })
end