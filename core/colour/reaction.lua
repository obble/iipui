

	local _, ns = ...
	
	local CUSTOM_FACTION_BAR_COLORS = {
		[1] = {r = 1, g = .2, b = .2},	-- hated
		[2] = {r = 1, g = .2, b = .2},	-- hostile
		[3] = {r = 1, g = .6, b = .2},	-- unfriendly
		[4] = {r = 1, g = .8, b = .1},	-- neutral
		[5] = {r = .4, g = 1, b = .2},	-- friend
		[6]	= {r = .4, g = 1, b = .3},	-- honoured
		[7]	= {r = .3, g = 1, b = .4},	-- revered
		[8]	= {r = .3, g = 1, b = .5},	-- exalted
	}

	ns.CUSTOM_FACTION_BAR_COLORS = CUSTOM_FACTION_BAR_COLORS


	--
