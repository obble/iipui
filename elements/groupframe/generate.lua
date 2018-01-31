

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
            'columnSpacing',    20,
            'groupBy',          'GROUP',
            'roleFilter',      	'MAINTANK,MAINASSIST,TANK',
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
            'xOffset',          15,
            'columnSpacing',    20,
			'roleFilter', 		'HEALER',
            'point',            'LEFT',
            'oUF-initialConfigFunction', [[
				self:SetHeight(25)
				self:SetWidth(100)	
			]]
        )

        self:SetActiveStyle'iip - DPS'
        local dps = self:SpawnHeader(
            'oUF_dps', nil, 'raid',
            'showRaid',         true,
            'showParty', 		true,
            'showPlayer', 		true,
            'xOffset',          0,
            'columnSpacing',    20,
			'roleFilter', 		'DAMAGER,NONE',
            'point',            'LEFT',
            'oUF-initialConfigFunction', [[
				self:SetHeight(25)
				self:SetWidth(100)	
			]]
        )

        party:SetPoint('TOP', UIParent)
        tanks:SetPoint('TOPLEFT', 	ChatFrame1, 'BOTTOMLEFT', 0, -20)
		support:SetPoint('TOPLEFT', tank, 		'BOTTOMLEFT', 0, -20)
		dps:SetPoint('TOPLEFT', 	support, 	'BOTTOMLEFT', 0, -20)
	end)


    --
