

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
        self:SetActiveStyle'iip - Party'
        local party = self:SpawnHeader(
            'oUF_party', nil, 'party',
            'showParty', 		true,
            'showPlayer', 		true,
            'xOffset',          55,
            'yOffset',			36,
            'maxColumns',       5,
            'unitsPerColumn',	1,
            'columnSpacing',    32,
            'point',           	'LEFT',
            'columnAnchorPoint', 'TOP',
            'oUF-initialConfigFunction', [[
				self:SetWidth(100)
				self:SetHeight(40)
			]]
        )

		self:SetActiveStyle'iip - Tank'
        local tanks = self:SpawnHeader(
            'oUF_tank', nil, 'raid',
            'showRaid',         true,
            'showParty', 		true,
            'showPlayer', 		true,
            'xOffset',          55,
            'yOffset',			36,
            'maxColumns',        5,
            'unitsPerColumn',		2,
            'columnSpacing',    32,
            'roleFilter',      	'MAINTANK,MAINASSIST,TANK',
            'point',           	'LEFT',
            'columnAnchorPoint', 'TOP',
            'oUF-initialConfigFunction', [[
				self:SetWidth(75)
				self:SetHeight(17)
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
				self:SetWidth(60)
				self:SetHeight(22)
			]]
        )

        self:SetActiveStyle'iip - Dps'
        local dps = self:SpawnHeader(
            'oUF_dps', nil, 'raid',
            'showRaid',         true,
            'showParty', 		true,
            'showPlayer', 		true,
            'xOffset',          8,
            'yOffset',			3,
            'maxColumns',        6,
            'unitsPerColumn',    4,
            'columnSpacing',     8,
			'roleFilter', 		'DAMAGER,NONE',
            'point',             'LEFT',
            'columnAnchorPoint', 'TOP',
            'oUF-initialConfigFunction', [[
				self:SetWidth(47)
				self:SetHeight(30)
			]]
        )

        party:SetPoint('TOPLEFT', 	UIParent, 110, -87)

        party.header = party:CreateTexture(nil, 'OVERLAY')
        party.header:SetPoint('TOPLEFT', party, -90, 80)
        party.header:SetTexture[[Interface\QuestFrame\AutoQuest-Parts]]
        party.header:SetTexCoord(.42, .96, 1, 0)
        party.header:SetSize(300, 42)
        party.header:SetAlpha(.9)
        party.header:Hide()

        party.header.t = party:CreateFontString(nil, 'OVERLAY', 'ObjectiveFont')
		party.header.t:SetFont(STANDARD_TEXT_FONT, 14)
        party.header.t:SetTextColor(.75, .61, 0)
		party.header.t:SetPoint('TOPLEFT', party.header, 30, -18)
        party.header.t:SetText(PARTY)

        tanks:SetPoint('TOPLEFT', 	UIParent, 60, -67)

        tanks.header = tanks:CreateTexture(nil, 'OVERLAY')
        tanks.header:SetPoint('TOPLEFT', tanks, -40, 60)
        tanks.header:SetTexture[[Interface\QuestFrame\AutoQuest-Parts]]
        tanks.header:SetTexCoord(.42, .96, 1, 0)
        tanks.header:SetSize(300, 42)
        tanks.header:SetAlpha(.9)
        tanks.header:Hide()

        tanks.header.t = tanks:CreateFontString(nil, 'OVERLAY', 'ObjectiveFont')
		tanks.header.t:SetFont(STANDARD_TEXT_FONT, 14)
        tanks.header.t:SetTextColor(.75, .61, 0)
		tanks.header.t:SetPoint('TOPLEFT', tanks.header, 30, -18)
        tanks.header.t:SetText(TANK)

		support:SetPoint('TOPLEFT', tanks, 'BOTTOMLEFT', -10, -60)

        support.header = support:CreateTexture(nil, 'OVERLAY')
        support.header:SetPoint('TOPLEFT', support, -30, 60)
        support.header:SetTexture[[Interface\QuestFrame\AutoQuest-Parts]]
        support.header:SetTexCoord(.42, .96, 1, 0)
        support.header:SetSize(300, 42)
        support.header:SetAlpha(.7)
        support.header:Hide()

        support.header.t = support:CreateFontString(nil, 'OVERLAY', 'ObjectiveFont')
		support.header.t:SetFont(STANDARD_TEXT_FONT, 14)
        support.header.t:SetTextColor(.75, .61, 0)
		support.header.t:SetPoint('TOPLEFT', support.header, 30, -18)
        support.header.t:SetText(HEALER)

		dps:SetPoint('TOPLEFT', 	support, 'BOTTOMLEFT', 0, -60)

        dps.header = dps:CreateTexture(nil, 'OVERLAY')
        dps.header:SetPoint('TOPLEFT', dps, -30, 60)
        dps.header:SetTexture[[Interface\QuestFrame\AutoQuest-Parts]]
        dps.header:SetTexCoord(.42, .96, 1, 0)
        dps.header:SetSize(300, 42)
        dps.header:SetAlpha(.7)
        dps.header:Hide()

        dps.header.t = dps:CreateFontString(nil, 'OVERLAY', 'ObjectiveFont')
		dps.header.t:SetFont(STANDARD_TEXT_FONT, 14)
        dps.header.t:SetTextColor(.75, .61, 0)
		dps.header.t:SetPoint('TOPLEFT', dps.header, 30, -18)
        dps.header.t:SetText(DAMAGER)
	end)


    --
