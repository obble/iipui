

	local _, ns = ...

	local FONT_BOLD = ns.FONT_BOLD

	ns.UnitSpecific.target = function(self, ...)
		ns.SharedLayout(self, ...)

		self:SetFrameLevel(0)	-- for layering
		self:SetSize(137, 20)

		local Health, Power, Castbar, RaidIcon, Border = self.Health, self.Power, self.Castbar, self.RaidTargetIndicator, {}

		Health:SetHeight(9)
		Health:SetFrameLevel(0)
		Health:SetFrameStrata'MEDIUM'

		local HealthPoints = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		HealthPoints:SetPoint('RIGHT', Health, 'LEFT', -16, 0)
		HealthPoints:SetJustifyH'RIGHT'
		HealthPoints:SetFont(GameFontNormal:GetFont(), 10)
		HealthPoints:SetTextColor(1, 1, 1)

		self:Tag(HealthPoints, '[iip:hp]')
		Health.value = HealthPoints

		local HealthPercent = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		HealthPercent:SetPoint('LEFT', Health, 2, 0)
		HealthPercent:SetJustifyH'RIGHT'
		HealthPercent:SetFont(GameFontNormal:GetFont(), 10)
		HealthPercent:SetTextColor(1, 1, 1)

		self:Tag(HealthPercent, '[iip:perhp]')
		Health.percent = HealthPercent

		Power:SetFrameStrata'LOW'

		local PowerPoints = Power:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		PowerPoints:SetPoint('RIGHT', Power, 'LEFT', -16, 0)
		PowerPoints:SetJustifyH'RIGHT'
		PowerPoints:SetFont(GameFontNormal:GetFont(), 10)
		PowerPoints:SetTextColor(1, 1, 1)

		self:Tag(PowerPoints, '[iip:pp]')
		Power.value = PowerPoints

		local PowerPercent = Power:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		PowerPercent:SetPoint('LEFT', Power, 2, 0)
		PowerPercent:SetJustifyH'RIGHT'
		PowerPercent:SetFont(GameFontNormal:GetFont(), 10)
		PowerPercent:SetTextColor(1, 1, 1)

		self:Tag(PowerPercent, '[iip:perpp]')
		Power.percent = PowerPercent

		local Name = self:CreateFontString(nil, 'OVERLAY', 'iipNameFont')
		Name:SetJustifyH'RIGHT'
		Name:SetWidth(150)
		Name:SetWordWrap(true)
		self:Tag(Name, '[iip:name]')

		local Portrait = self:CreateTexture(nil, 'ARTWORK', nil, -2)
		Portrait:SetSize(46, 46)
		Portrait:SetPoint('RIGHT', self, 70, 0)

		local mask = self.Health:CreateMaskTexture()
		mask:SetTexture[[Interface\Minimap\UI-Minimap-Background]]
		mask:SetPoint('TOPLEFT', Portrait, -3, 3)
		mask:SetPoint('BOTTOMRIGHT', Portrait, 3, -3)

		Portrait:AddMaskTexture(mask)

		Portrait.BG = self:CreateTexture(nil, 'BACKGROUND', nil, -3)
		Portrait.BG:SetSize(128, 128)
		Portrait.BG:SetTexture[[Interface\COMMON\portrait-ring-withbg]]
		Portrait.BG:SetPoint('RIGHT', self, 110, 0)

		Portrait.Elite = self.Health:CreateTexture(nil, 'ARTWORK')
		Portrait.Elite:SetSize(100, 100)
		Portrait.Elite:SetPoint('RIGHT', self, 104, -11)
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
		Castbar:SetFrameStrata'HIGH'
		Castbar:ClearAllPoints()
		Castbar:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 10, 22)
		Castbar:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', -10, 22)
		Castbar:SetHeight(6)
		Castbar.timeToHold = .4

		Castbar.IconBD = CreateFrame('Frame', nil, Castbar)
		Castbar.IconBD:SetSize(22, 22)
		Castbar.IconBD:SetPoint('BOTTOMRIGHT', Castbar, 'BOTTOMLEFT', -18, 0)
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
		Castbar.text:SetPoint('BOTTOM', Castbar, 'TOP', 0, 12)
		Castbar.text:SetFont([[Fonts\ARIALN.ttf]], 11)
		Castbar.text:SetWidth(80)
		Castbar.text:SetJustifyH'CENTER'
		--Castbar.text:SetWordWrap(true)
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

		self.LvLParent = CreateFrame('Frame', nil, self)
		self.LvLParent:SetSize(32, 32)
		self.LvLParent:SetPoint('CENTER', Portrait, 'BOTTOMLEFT', 4, 5)
		self.LvLParent:SetFrameStrata'HIGH'
		self.LvLParent:SetFrameLevel(2)

		local Level = self.LvLParent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal', 7)
		Level:SetFont(STANDARD_TEXT_FONT, 10)
		Level:SetPoint('CENTER', self.LvLParent)
		Level:SetJustifyH'CENTER'
		self:Tag(Level, '[iip:level]')

		Level.ring = self.LvLParent:CreateTexture(nil, 'OVERLAY', nil, 5)
		Level.ring:SetSize(32, 32)
		Level.ring:SetPoint('CENTER', Portrait, 'BOTTOMLEFT', 4, 5)
		Level.ring:SetTexture[[Interface\MINIMAP\MiniMap-TrackingBorder]]
		Level.ring:SetTexCoord(0, .6, 0, .6)

		Level.BD = self.LvLParent:CreateTexture(nil, 'OVERLAY', nil, 3)
		Level.BD:SetSize(36, 36)
		Level.BD:SetPoint('CENTER', Portrait, 'BOTTOMLEFT', 4, 5)
		Level.BD:SetTexture[[Interface\MINIMAP\UI-Minimap-Background]]

		local PvPIndicator = self.Health:CreateTexture(nil, 'OVERLAY', nil, 1)
	    PvPIndicator:SetSize(32, 32)
	    PvPIndicator:SetPoint('CENTER', Portrait, 'LEFT', 4, 20)

	    local Prestige = self.Health:CreateTexture(nil, 'OVERLAY')
	    Prestige:SetSize(38, 40)
	    Prestige:SetPoint('CENTER', PvPIndicator)

		PvPIndicator.Prestige = Prestige

		local QuestIndicator = self:CreateTexture(nil, 'OVERLAY')
	    QuestIndicator:SetSize(36, 36)
	    QuestIndicator:SetPoint('CENTER', Portrait, 'RIGHT')

	    self.QuestIndicator = QuestIndicator

		RaidIcon:ClearAllPoints()
		RaidIcon:SetPoint('RIGHT', Name, 'LEFT')

		ns.AddAuraElement(self, unit, {'BOTTOMRIGHT', self, 'TOPRIGHT', -44, 100}, 'RIGHT', 'LEFT', 'UP')

		-- register new elements
		self.Name 			= Name
		self.Portrait		= Portrait
		self.Level			= Level
		self.PvPIndicator 	= PvPIndicator
	end


	--
