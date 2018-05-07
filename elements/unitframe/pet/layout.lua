

	local _, ns = ...

	local FONT_BOLD = ns.FONT_BOLD

	ns.UnitSpecific.pet = function(self, ...)
		ns.SharedLayout(self, ...)

		self:SetFrameLevel(5)	-- for layering
		self:SetFrameStrata'HIGH'
		self:SetSize(80, 10)

		local Health, Power, Castbar = self.Health, self.Power, self.Castbar

		Health:SetPoint'TOP'
		Health:SetHeight(4)
		ns.BD(Health)
		ns.BDStone(Health, 4, [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Horizontal]])

		local HealthPoints = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		HealthPoints:SetPoint('RIGHT', Health, 'LEFT', -11, -4)
		HealthPoints:SetJustifyH'RIGHT'
		HealthPoints:SetFont(GameFontNormal:GetFont(), 9)
		HealthPoints:SetTextColor(1, 1, 1)

		self:Tag(HealthPoints, '[iip:hp]')
		Health.value = HealthPoints

		Power:SetPoint('TOP', Health, 'BOTTOM',0, -3)
		Power:SetHeight(4)
		ns.BD(Power)
		ns.BDStone(Power, 4, [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Horizontal]])

		local Portrait = self:CreateTexture(nil, 'ARTWORK')
		Portrait:SetSize(18, 18)
		Portrait:SetPoint('LEFT', Health, 'RIGHT', 15, -3)

		Portrait.BG = self:CreateTexture(nil, 'BACKGROUND')
		Portrait.BG:SetSize(42, 42)
		Portrait.BG:SetTexture[[Interface\Artifacts\Artifacts]]
		Portrait.BG:SetPoint('CENTER', Portrait)
		Portrait.BG:SetTexCoord(.49, .58, .875, .9625)
		Portrait.BG:SetVertexColor(.666, .666, .666)

		Portrait.shadow = self:CreateTexture(nil, 'BACKGROUND', nil, -7)
		Portrait.shadow:SetSize(36, 36)
		Portrait.shadow:SetPoint('LEFT', Health, 'RIGHT', 6, -4)
		Portrait.shadow:SetTexture[[Interface\MINIMAP\UI-Minimap-Background]]

		-- register new elements
		self.Portrait 	= Portrait
	end


	--
