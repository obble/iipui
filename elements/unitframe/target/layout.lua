

	local _, ns = ...

	local FONT_BOLD = ns.FONT_BOLD

	ns.UnitSpecific.target = function(self, ...)
		ns.SharedLayout(self, ...)

		self:SetFrameLevel(0)	-- for layering
		self:SetSize(137, 20)

		local Health, Power, Castbar, RaidIcon, Border = self.Health, self.Power, self.Castbar, self.RaidTargetIndicator, {}

		Health:SetHeight(9)
		Health:SetFrameStrata'MEDIUM'

		Power:SetFrameStrata'MEDIUM'

		local Name = self:CreateFontString(nil, 'OVERLAY', 'iipNameFont')
		Name:SetJustifyH'RIGHT'
		Name:SetWidth(150)
		Name:SetWordWrap(true)

		local Portrait = self:CreateTexture(nil, 'ARTWORK', nil, -2)
		Portrait:SetSize(46, 46)
		Portrait:SetPoint('LEFT', self, -70, 0)

		Portrait.BG = self:CreateTexture(nil, 'BACKGROUND', nil, -3)
		Portrait.BG:SetSize(128, 128)
		Portrait.BG:SetTexture[[Interface\COMMON\portrait-ring-withbg]]
		Portrait.BG:SetPoint('LEFT', self, -110, 0)

		Portrait.Elite = self.Health:CreateTexture(nil, 'ARTWORK')
		Portrait.Elite:SetSize(100, 100)
		Portrait.Elite:SetPoint('LEFT', self, -90, -11)
		Portrait.Elite:Hide()

		Border.left = self:CreateTexture(nil, 'OVERLAY')
		Border.left:SetSize(24, 42)
		Border.left:SetPoint('LEFT', -13, 0)
		Border.left:SetTexture[[Interface\AUCTIONFRAME/UI-AuctionPost-Endcaps]]
		Border.left:SetTexCoord(.5, 1, 0, 1)

		Border.middle = self:CreateTexture(nil, 'OVERLAY')
		Border.middle:SetSize(118, 42)
		Border.middle:SetPoint'CENTER'
		Border.middle:SetTexture([[Interface\AUCTIONFRAME/UI-AuctionPost-Middle]], true)
		Border.middle:SetHorizTile(true)

		Border.right = self:CreateTexture(nil, 'OVERLAY')
		Border.right:SetSize(24, 42)
		Border.right:SetPoint('RIGHT', 13, 0)
		Border.right:SetTexture[[Interface\AUCTIONFRAME/UI-AuctionPost-Endcaps]]
		Border.right:SetTexCoord(0, .5, 0, 1)

		Border.shadow = self:CreateTexture(nil, 'BACKGROUND')
		Border.shadow:SetPoint('TOPLEFT', self,  -15, 15)
		Border.shadow:SetPoint('BOTTOMRIGHT', self,  15, -15)
		Border.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
		Border.shadow:SetVertexColor(0, 0, 0, 1)
		Border.shadow:SetTexCoord(0, .641, 0, .18)

		ns.BD(Castbar)
		Castbar:ClearAllPoints()
		Castbar:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 50)
		Castbar:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 50)
		Castbar:SetHeight(6)
		Castbar.timeToHold = .4

		Castbar.IconBD = CreateFrame('Frame', nil, Castbar)
		Castbar.IconBD:SetSize(18, 18)
		Castbar.IconBD:SetPoint('BOTTOMRIGHT', Castbar, 'TOPRIGHT', -3, 24)
		Castbar.IconBD:SetFrameLevel(2)
		ns.BD(Castbar.IconBD)

		Castbar.Icon = Castbar.IconBD:CreateTexture(nil, 'OVERLAY', nil, 7)
		Castbar.Icon:SetAllPoints(Castbar.IconBD)
		Castbar.Icon:SetTexCoord(.1, .9, .1, .9)

		Castbar.Icon.Border = Castbar.IconBD:CreateTexture(nil, 'BACKGROUND', nil, -7)
		Castbar.Icon.Border:SetSize(45, 45)
		Castbar.Icon.Border:SetPoint('TOP', Castbar.Icon, 0, 14)
		Castbar.Icon.Border:SetTexture[[Interface\Transmogrify\Textures]]
		Castbar.Icon.Border:SetTexCoord(.5, 1, .12, .25)

		Castbar.text = Castbar:CreateFontString(nil, 'ARTWORK')
		Castbar.text:SetPoint('RIGHT', Castbar.Icon, 'LEFT', -12, 0)
		Castbar.text:SetFont([[Fonts\ARIALN.ttf]], 11)
		Castbar.text:SetWidth(80)
		Castbar.text:SetJustifyH'RIGHT'
		Castbar.text:SetWordWrap(true)
		Castbar.text:SetShadowOffset(1, -1)
		Castbar.text:SetShadowColor(0, 0, 0, 1)

		Castbar.left = Castbar:CreateTexture(nil, 'BACKGROUND', nil, -1)
		Castbar.left:SetPoint('TOPLEFT', -5, 5)
		Castbar.left:SetPoint('BOTTOMRIGHT', 5, -5)
		Castbar.left:SetTexture[[Interface\ACHIEVEMENTFRAME/UI-ACHIEVEMENT-ACHIEVEMENTBACKGROUND]]
		Castbar.left:SetTexCoord(0, 1, .5, 1)
		Castbar.left:SetVertexColor(.7, .6, .5)

		Castbar.shadow = Castbar:CreateTexture(nil, 'BACKGROUND', nil, -3)
		Castbar.shadow:SetPoint('TOPLEFT', Castbar,  -12, 9)
		Castbar.shadow:SetPoint('BOTTOMRIGHT', Castbar,  12, -7)
		Castbar.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
		Castbar.shadow:SetVertexColor(0, 0, 0, 1)
		Castbar.shadow:SetTexCoord(0, .641, 0, .18)

		local Level = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal', 7)
		Level:SetFont(STANDARD_TEXT_FONT, 11)
		Level:SetPoint('RIGHT', Portrait, 'BOTTOMLEFT', 14, 6)
		Level:SetJustifyH'CENTER'
		self:Tag(Level, '[iip:level]')

		Level.ring = self.Health:CreateTexture(nil, 'OVERLAY', nil, 5)
		Level.ring:SetSize(32, 32)
		Level.ring:SetPoint('CENTER', Portrait, 'BOTTOMLEFT', 4, 5)
		Level.ring:SetTexture[[Interface\MINIMAP\MiniMap-TrackingBorder]]
		Level.ring:SetTexCoord(0, .6, 0, .6)

		Level.BD = self.Health:CreateTexture(nil, 'OVERLAY', nil, 3)
		Level.BD:SetSize(36, 36)
		Level.BD:SetPoint('CENTER', Portrait, 'BOTTOMLEFT', 4, 5)
		Level.BD:SetTexture[[Interface\MINIMAP\UI-Minimap-Background]]

		RaidIcon:ClearAllPoints()
		RaidIcon:SetPoint('CENTER', self, 'TOPLEFT', 11, 0)

		ns.AddAuraElement(self, unit, isSingle)

		-- register new elements
		self.Name 		= Name
		self.Portrait	= Portrait
		self.Level		= Level
	end


	--
