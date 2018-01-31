

	local Difficulty = function()
		for _, v in pairs({
			MiniMapInstanceDifficulty,
			GuildInstanceDifficulty,
			MiniMapChallengeMode
		})  do
			if  v then
				v:SetFrameLevel(16)
				v:ClearAllPoints()
				v:SetPoint('TOPLEFT', Minimap, -2, 14)
			end
		end
	end

	hooksecurefunc('MiniMapInstanceDifficulty_Update', Difficulty)


	--
