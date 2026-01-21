mod.testnextroom = nil

local function trigger_Gift()
    -- game.CurrentRun.BiomesReached = {
    --     Tartarus = true,
    --     G = true,
    --     Elysium = true,
    --     Styx = true
    -- }
    print(mod.dump(game.CurrentRun.BiomesReached))
	game.OpenRunClearScreen()
end

game.OnControlPressed({'Gift', function()
	return trigger_Gift()
end})