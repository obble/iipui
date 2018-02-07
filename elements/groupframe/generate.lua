

    local _, ns = ...

    local UnitSpecific = ns.UnitSpecific

	for unit, layout in next, UnitSpecific do
		oUF:RegisterStyle('iip - ' .. unit:gsub('^%l', string.upper), layout)
	end

	local spawnHelper = function(self, unit, ...)
        self:SetActiveStyle('iip - ' .. unit:match('%D+'):gsub('^%l', string.upper))
		local object = self:Spawn(unit)
		object:SetPoint(...)
		return object
	end

	oUF:Factory(function(self)
		self:SetActiveStyle'iip - Tank'
        local tanks = self:SpawnHeader(
            'oUF_tank', nil, 'raid',
            'showRaid',         true,
            'showParty', 		true,
            'showPlayer', 		true,
            'xOffset',          30,
            'yOffset',			30,
            'columnSpacing',    20,
            'roleFilter',      	'MAINTANK,MAINASSIST,TANK',
            'unitsPerColumn',	2,
            'point',           	'LEFT',
            'oUF-initialConfigFunction', [[
				self:SetHeight(25)
				self:SetWidth(100)	
			]]
        )

        self:SetActiveStyle'iip - Support'
        local support = self:SpawnHeader(
            'oUF_support', nil, 'raid',
            'showRaid',         true,
            'showParty', 		true,
            'showPlayer', 		true,
            'xOffset',          16,
            'yOffset',          16,
            'maxColumns',        6,
            'unitsPerColumn',    3,
            'columnSpacing',     20,
			'roleFilter', 		'HEALER',
            'point',            'LEFT',
            'columnAnchorPoint', 'TOP',
            'oUF-initialConfigFunction', [[
				self:SetHeight(25)
				self:SetWidth(100)	
			]]
        )

        self:SetActiveStyle'iip - Dps'
        local dps = self:SpawnHeader(
            'oUF_dps', nil, 'raid',
            'showRaid',         true,
            'showParty', 		true,
            'showPlayer', 		true,
            'xOffset',          22,
            'yOffset',			23,
            'maxColumns',        6,
            'unitsPerColumn',    4,
            'columnSpacing',     20,
			'roleFilter', 		'DAMAGER,NONE',
            'point',             'LEFT',
            'columnAnchorPoint', 'TOP',
            'oUF-initialConfigFunction', [[
				self:SetHeight(25)
				self:SetWidth(100)	
			]]
        )

        tanks:SetPoint('TOPLEFT', 	ChatFrame1, 'BOTTOMLEFT', 0, -20)
		support:SetPoint('TOPLEFT', tanks, 'BOTTOMLEFT', 0, -30)
		dps:SetPoint('TOPLEFT', 	support, 'BOTTOMLEFT', 0, -30)
	end)


    --
