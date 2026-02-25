function mod.UpdateRoomStartMusicEvents()
    for musicEventIndex, musicEvent in ipairs(game.RoomStartMusicEvents) do
        for requireIndex, requirement in ipairs(musicEvent.GameStateRequirements) do
            if requirement.PathTrue and mod.CheckPathEquality(requirement.PathTrue, { "CurrentRun", "BiomesReached", "F" }) then
                musicEvent.GameStateRequirements[requireIndex] =
                {
					Path = { "CurrentRun", "BiomesReached" },
					HasAny = { "F", "G", "H", "I", },
				}
                table.insert(musicEvent.GameStateRequirements, {
                    Path = { "CurrentRun", "CurrentRoom", "RoomSetName" },
                    IsAny = { "F", "G", "H", "I", },
                })
            end
            if requirement.PathTrue and mod.CheckPathEquality(requirement.PathTrue, { "CurrentRun", "BiomesReached", "N" }) then
                musicEvent.GameStateRequirements[requireIndex] =
                {
					Path = { "CurrentRun", "BiomesReached" },
					HasAny = { "N", "O", "P", "Q", },
				}
                table.insert(musicEvent.GameStateRequirements, {
                    Path = { "CurrentRun", "CurrentRoom", "RoomSetName" },
                    IsAny = { "N", "O", "P", "Q", "N_SubRooms", },
                })
            end
        end
    end
    -- print(mod.dump(game.RoomStartMusicEvents))
end

mod.UpdateRoomStartMusicEvents()