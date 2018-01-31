

	local _, ns = ...

	local FONT_BOLD = ns.FONT_BOLD

	ns.UnitSpecific.boss = function(self, ...)
		ns.SharedLayout(self, ...)

		self:SetFrameLevel(1)	-- for layering
		self:SetSize(137, 20)

		local Health, Castbar, RaidIcon, Power = self.Health, self.Castbar, self.RaidTargetIndicator, self.Power

		Health:SetHeight(5)
		Power:SetHeight(5)

		local Name = self:CreateFontString(nil, 'OVERLAY', 'iipNameFont')
		Name:SetJustifyH'LEFT'
		Name:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 15)
		Name:SetWidth(90)
		Name:SetWordWrap(true)

		local Portrait = self:CreateTexture(nil, 'ARTWORK', nil, -2)
		Portrait:SetSize(39, 39)
		Portrait:SetPoint('RIGHT', self, 58, -1)

		Portrait.Border = self:CreateTexture(nil, 'BACKGROUND')
		Portrait.Border:SetSize(65, 65)
		Portrait.Border:SetTexture[[Interface\Artifacts\Artifacts-PerkRing-Final-Mask]]
		Portrait.Border:SetPoint('CENTER', Portrait)
		Portrait.Border:SetVertexColor(1, .65, 0)

		Castbar:SetFrameLevel(4)
		Castbar:SetToplevel(false)

		RaidIcon:ClearAllPoints()
		RaidIcon:SetPoint('CENTER', self, 'TOPLEFT', 11, 0)

		self.Border = self:CreateTexture(nil, 'OVERLAY')
		self.Border:SetPoint('TOPLEFT', -13, 13)
		self.Border:SetPoint('BOTTOMRIGHT', 13, -14)
		self.Border:SetTexture[[Interface\Glues\AccountUpgrade\golden-main]]
		self.Border:SetTexCoord(.135, .97, 0, .28)

		self:SetSize(70, 10)

		-- register new elements
		self.Name 		= Name
		self.Portrait	= Portrait
	end


	--
