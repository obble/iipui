

	local _, ns = ...

	ns.UnitSpecific.targettarget = function(self, ...)
		ns.SharedLayout(self, ...)

		self:SetFrameLevel(5)	-- for layering
		self:SetSize(40, 5)

		local Health, Power, Castbar, RaidIcon = self.Health, self.Power, self.Castbar, self.RaidTargetIndicator

		local Name = self:CreateFontString(nil, 'OVERLAY', 'iipNameFontSmall')
		Name:SetPoint('RIGHT', self, 'LEFT', -15, 0)
		Name:SetJustifyH'RIGHT'
		Name:SetWidth(65)
		Name:SetWordWrap(true)

		Health:SetPoint'BOTTOM'
		ns.BD(Health)
		ns.BDStone(Health, 4, [[Interface\HELPFRAME\Tileable-Parchment]])

		Power:ClearAllPoints()

		local Portrait = self:CreateTexture(nil, 'ARTWORK')
		Portrait:SetSize(18, 18)
		Portrait:SetPoint('LEFT', Health, 'RIGHT', 15, -1)
		Portrait:SetTexCoord(1, 0, 0, 1)

		Portrait.BG = self:CreateTexture(nil, 'BACKGROUND')
		Portrait.BG:SetSize(42, 42)
		Portrait.BG:SetTexture[[Interface\Artifacts\Artifacts]]
		Portrait.BG:SetPoint('CENTER', Portrait)
		Portrait.BG:SetTexCoord(.49, .58, .875, .9625)
		Portrait.BG:SetVertexColor(.666, .666, .666)

		Portrait.Elite = self.Health:CreateTexture(nil, 'OVERLAY')
		Portrait.Elite:SetAtlas'worldquest-questmarker-dragon'
		Portrait.Elite:SetSize(36, 36)
		Portrait.Elite:SetPoint('TOP', Portrait.BG, 3, -3)
		Portrait.Elite:Hide()

		Portrait.shadow = self:CreateTexture(nil, 'BACKGROUND', nil, -7)
		Portrait.shadow:SetSize(36, 36)
		Portrait.shadow:SetPoint('LEFT', Health, 'RIGHT', 6, 0)
		Portrait.shadow:SetTexture[[Interface\MINIMAP\UI-Minimap-Background]]

		Castbar:ClearAllPoints()

		RaidIcon:ClearAllPoints()
		RaidIcon:SetPoint('BOTTOM', Portrait, 'TOP', 0, -10)

		-- register new elements
		self.Name		= Name
		self.Portrait 	= Portrait
	end


	--
