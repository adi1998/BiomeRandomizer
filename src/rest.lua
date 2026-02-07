
mod.ShopTypes = {
    Well = {
        Animation = "WellShopLocked",
        ObstacleName = "WellShop",
    },
    Surface = {
        Animation = "SurfaceShopLocked",
        ObstacleName = "SurfaceShop",
    },
    Sell = {
        Animation = "SellTraitShopLocked",
        ObstacleName = "SellTraitShop"
    }
}
Ids = Ids or {}
function mod.DeleteAllSpawned()
    game.Destroy({Ids = Ids})
end

function mod.SpawnFountain(destId, offsetX, offsetY, flipped)
    local healthFountain = game.DeepCopyTable(game.ObstacleData.HealthFountain)
    healthFountain.ObjectId = game.SpawnObstacle({Name="HealthFountain", DestinationId=destId, OffsetY=offsetY, OffsetX = offsetX, Group = "Standing"})
    game.SetupObstacle(healthFountain)
    game.SetColor({ Id = healthFountain.ObjectId, Color = game.Color.White })
    game.SetScale({Id = healthFountain.ObjectId, Fraction = 0.34})
    if flipped then
        game.FlipHorizontal({ Id = healthFountain.ObjectId })
    end

    table.insert(Ids, healthFountain.ObjectId)
end

function mod.SpawnGiftRack(destId, offsetX, offsetY, flipped)
    local newGiftRack = game.DeepCopyTable(game.ObstacleData.GiftRack)
    newGiftRack.ObjectId = game.SpawnObstacle({Name="GiftRack", DestinationId=destId, OffsetY=offsetY, OffsetX = offsetX, AttachedTable = newGiftRack, Group = "Standing"})
    newGiftRack.ActivateIds = { newGiftRack.ObjectId }
    game.SetupObstacle(newGiftRack)
    game.SetScale({Id = newGiftRack.ObjectId, Fraction = 0.2})
    game.SetThingProperty({Property = "AddColor", Value = true, DestinationId = newGiftRack.ObjectId })
    game.SetColor({ Id = newGiftRack.ObjectId, Color = {0,0,0,1} }) -- it just works
    if flipped then
        game.FlipHorizontal({ Id = newGiftRack.ObjectId })
    end

    table.insert(Ids, newGiftRack.ObjectId)

end

function mod.SpawnShop(destId, offsetX, offsetY, shopType, flipped)
    shopType = shopType or "Well"
    local shopData = mod.ShopTypes[shopType] or mod.ShopTypes.Well
    local shop = game.DeepCopyTable(game.ObstacleData[shopData.ObstacleName])

    shop.ObjectId = game.SpawnObstacle({Name="ChallengeSwitchBase", DestinationId=destId, OffsetY=offsetY, OffsetX = offsetX, Group = "Standing"})
    game.SetupObstacle(shop)
    shop.ReadyToUse = false
    game.RefreshUseButton( shop.ObjectId, shop )
    game.SetAnimation({ Name = shopData.Animation, DestinationId = shop.ObjectId })
    game.UseableOn({ Id = shop.ObjectId })

    if flipped then
        game.FlipHorizontal({Id = shop.ObjectId})
    end

    game.CurrentRun.CurrentRoom[shopData.ObstacleName] = shop

    table.insert(Ids, shop.ObjectId)
end

function mod.SpawnPostChronosRestSpot()
    local offsetY = -420
    local offsetX = -470
    local destId = 626310 -- SpawnRewardOnId = 626310,
    mod.SpawnFountain(destId, offsetX, offsetY, true)

    offsetY = offsetY - 40
    offsetX = offsetX + 180
    if game.GameState.WorldUpgradesAdded.WorldUpgradePostBossGiftRack then
        mod.SpawnGiftRack(destId, offsetX, offsetY)
    end

    offsetY = offsetY - 130
    offsetX = offsetX + 200
    if game.GameState.WorldUpgradesAdded.WorldUpgradePostBossWellShops then
        mod.SpawnShop(destId, offsetX, offsetY, "Well", true)
    end

    offsetY = offsetY - 20
    offsetX = offsetX + 340
    if game.GameState.WorldUpgradesAdded.WorldUpgradePostBossSellTraitShops then
        mod.SpawnShop(destId, offsetX, offsetY, "Sell", false)
    end

    game.LiveFillInShopOptions()
end

function mod.SpawnPostTyphonRestSpot()
    local offsetY = 460
    local offsetX = -3840
    local destId = 768210 -- UseableOn({ Id = 768210 }) - Exit door
    mod.SpawnFountain(destId, offsetX, offsetY, true)

    offsetY = offsetY - 40
    offsetX = offsetX + 180
    if game.GameState.WorldUpgradesAdded.WorldUpgradePostBossGiftRack then
        mod.SpawnGiftRack(destId, offsetX, offsetY)
    end

    offsetY = offsetY - 120
    offsetX = offsetX + 170
    if game.GameState.WorldUpgradesAdded.WorldUpgradePostBossSurfaceShops then
        mod.SpawnShop(destId, offsetX, offsetY, "Surface", true)
    end
end

modutil.mod.Path.Wrap("ChronosKillPresentation", function (base, ...)
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and not mod.CanEndRandom() then
        mod.SpawnPostChronosRestSpot()
    end
    base(...)
end)

modutil.mod.Path.Wrap("TyphonHeadKillPresentation", function (base, ...)
    if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and not mod.CanEndRandom() then
        mod.SpawnPostTyphonRestSpot()
    end
    base(...)
end)

if rom.mods["NikkelM-Zagreus_Journey"] and rom.mods["NikkelM-Zagreus_Journey"].config and rom.mods["NikkelM-Zagreus_Journey"].config.enabled then

    function mod.SpawnPostHadesRestSpot()
        local offsetY = 560
        local offsetX = -1570
        local destId = 552590 -- D_Boss01 FinalBossExitDoor
        mod.SpawnFountain(destId, offsetX, offsetY, true)

        offsetY = offsetY - 40
        offsetX = offsetX + 180
        if game.GameState.WorldUpgrades.ModsNikkelMHadesBiomes_UnlockPostBossGiftRackIncantation then
            mod.SpawnGiftRack(destId, offsetX, offsetY)
        end

        offsetY = offsetY - 10
        offsetX = offsetX + 700
        if game.GameState.WorldUpgradesAdded.ModsNikkelMHadesBiomes_UnlockPostBossWellShopsIncantation then
            mod.SpawnShop(destId, offsetX, offsetY, "Well", true)
        end

        offsetY = offsetY - 100
        offsetX = offsetX + 190
        if game.GameState.WorldUpgrades.ModsNikkelMHadesBiomes_UnlockPostBossSellShopsIncantation then
            mod.SpawnShop(destId, offsetX, offsetY, "Sell", true)
        end

        game.LiveFillInShopOptions()
    end

    modutil.mod.Path.Wrap("NikkelM-Zagreus_Journey" .. "." .. "HadesKillPresentation", function (base, ...)
        if game.Contains(mod.RegisteredBounties, game.CurrentRun.ActiveBounty) and not mod.CanEndRandom() then
            mod.SpawnPostHadesRestSpot()
        end
        base(...)
    end)
end