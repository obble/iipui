

	local _, ns = ...

	local FONT_BOLD = ns.FONT_BOLD

	ns.UnitSpecific.pet = function(self, ...)
		ns.SharedLayout(self, ...)

		self:SetFrameLevel(5)	-- for layering
		self:SetSize(40, 5)

		local Health, Power, Castbar = self.Health, self.Power, self.Castbar

		Health:SetPoint'BOTTOM'
		ns.BD(Health)
		ns.BDStone(Health, 4, [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Horizontal]])

		Power:ClearAllPoints()

		local Portrait = self:CreateTexture(nil, 'ARTWORK')
		Portrait:SetSize(18, 18)
		Portrait:SetPoint('RIGHT', Health, 'LEFT', -15, 1)

		Portrait.BG = self:CreateTexture(nil, 'BACKGROUND')
		Portrait.BG:SetSize(42, 42)
		Portrait.BG:SetTexture[[Interface\Artifacts\Artifacts]]
		Portrait.BG:SetPoint('CENTER', Portrait)
		Portrait.BG:SetTexCoord(.49, .58, .875, .9625)
		Portrait.BG:SetVertexColor(.666, .666, .666)

		Portrait.shadow = self:CreateTexture(nil, 'BACKGROUND', nil, -7)
		Portrait.shadow:SetSize(36, 36)
		Portrait.shadow:SetPoint('RIGHT', Health, 'LEFT', -6, 0)
		Portrait.shadow:SetTexture[[Interface\MINIMAP\UI-Minimap-Background]]

		-- register new elements
		self.Portrait 	= Portrait
	end


	--
