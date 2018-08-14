

	local _, ns 	= ...
	local _, class 	= UnitClass'player'

	local AddCombo = function(self)
		ComboPointPlayerFrame:SetParent(self)
		ComboPointPlayerFrame:ClearAllPoints()
		ComboPointPlayerFrame:SetPoint('TOPLEFT', self, 'BOTTOM', -63, -5)
	end

	local AddPaladinPower = function(self)
		PaladinPowerBarFrame:SetParent(self)
		PaladinPowerBarFrame:ClearAllPoints()
		PaladinPowerBarFrame:SetPoint('TOPLEFT', self, 'BOTTOM', -67, -5)
	end

	local AddMagePower = function(self)
		MageArcaneChargesFrame:SetParent(self)
		MageArcaneChargesFrame:ClearAllPoints()
		MageArcaneChargesFrame:SetPoint('TOPLEFT', self, 'BOTTOM', -62, -6)
	end

	local AddMonkPower = function(self)
		MonkHarmonyBarFrame:SetParent(self)
		MonkHarmonyBarFrame:ClearAllPoints()
		MonkHarmonyBarFrame:SetPoint('TOPLEFT', self, 'BOTTOM', 0, 13)
	end

	local AddWarlockPower = function(self)
		WarlockPowerFrame:SetParent(self)
		WarlockPowerFrame:ClearAllPoints()
		if 	UnitExists'pet' then
			WarlockPowerFrame:SetPoint('TOPLEFT', self, 'BOTTOM', -55, -22)
		else
			WarlockPowerFrame:SetPoint('TOPLEFT', self, 'BOTTOM', -55, -4)
		end
	end

	local AddRunePower = function(self)
		RuneFrame:SetParent(self)
		RuneFrame:ClearAllPoints()
		if 	UnitExists'pet' then
			RuneFrame:SetPoint('TOPLEFT', self, 'BOTTOM', -59, -18)
		else
			RuneFrame:SetPoint('TOPLEFT', self, 'BOTTOM', -59, -6)
		end
	end

	ns.UnitSpecific.player = function(self, ...)
		local _, class = UnitClass'player'
		ns.SharedLayout(self, ...)

		self:SetFrameLevel(1)	-- for layering
		self:SetSize(137, 20)

		local Health, Power, Castbar, RaidIcon = self.Health, self.Power, self.Castbar, self.RaidTargetIndicator

		Health:SetFrameLevel(1)
		Health:SetHeight(9)
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

		Power.pulse = CreateFrame('Frame', nil, Power, 'FullResourcePulseFrame')
		Power.pulse:SetAllPoints(self.Power)
		Power.pulse:SetPoint'TOPRIGHT'

		local AdditionalPower = CreateFrame('StatusBar', nil, self)
		ns.SB(AdditionalPower)
		ns.BD(AdditionalPower)
		AdditionalPower:SetFrameLevel(1)
		AdditionalPower:SetHeight(9)
		AdditionalPower:SetPoint('TOPLEFT', Power, 'BOTTOMLEFT', 10, -10)
		AdditionalPower:SetPoint('TOPRIGHT', Power, 'BOTTOMRIGHT', -10, -10)
		AdditionalPower.colorPower = true

		AdditionalPower.BD = AdditionalPower:CreateTexture(nil, 'BORDER')
		AdditionalPower.BD:SetAllPoints()
		ns.SB(AdditionalPower.BD)
		AdditionalPower.BD:SetVertexColor(.35, .35, .35)

		AdditionalPower.border = AdditionalPower:CreateTexture(nil, 'BORDER')
		AdditionalPower.border:SetSize(0, 16)
		AdditionalPower.border:SetPoint('TOPLEFT', 2, 0)
		AdditionalPower.border:SetPoint('TOPRIGHT', -2, 0)
		AdditionalPower.border:SetTexture[[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]]
		AdditionalPower.border:SetTexCoord(.125, .25, 1, 0)
		AdditionalPower.border:SetVertexColor(.7, .7, .7)

		AdditionalPower.leftborder = AdditionalPower:CreateTexture(nil, 'BORDER')
		AdditionalPower.leftborder:SetSize(16, 16)
		AdditionalPower.leftborder:SetPoint('RIGHT', AdditionalPower.border, 'LEFT')
		AdditionalPower.leftborder:SetTexture[[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]]
		AdditionalPower.leftborder:SetTexCoord(0, .125, 1, 0)
		AdditionalPower.leftborder:SetVertexColor(.7, .7, .7)

		AdditionalPower.rightborder = AdditionalPower:CreateTexture(nil, 'BORDER')
		AdditionalPower.rightborder:SetSize(16, 16)
		AdditionalPower.rightborder:SetPoint('LEFT', AdditionalPower.border, 'RIGHT')
		AdditionalPower.rightborder:SetTexture[[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]]
		AdditionalPower.rightborder:SetTexCoord(.125, 0, 1, 0)
		AdditionalPower.rightborder:SetVertexColor(.7, .7, .7)

	    self.AdditionalPower = AdditionalPower

		local AdditionalPowerPoints = AdditionalPower:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		AdditionalPowerPoints:SetPoint('LEFT', AdditionalPower, 2, 0)
		AdditionalPowerPoints:SetJustifyH'LEFT'
		AdditionalPowerPoints:SetFont(GameFontNormal:GetFont(), 10)
		AdditionalPowerPoints:SetTextColor(1, 1, 1)

		self:Tag(AdditionalPowerPoints, '[iip:_a_pp]')
		AdditionalPower.value = AdditionalPowerPoints

		local AdditionalPowerPercent = AdditionalPower:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		AdditionalPowerPercent:SetPoint('RIGHT', AdditionalPower, -2, 0)
		AdditionalPowerPercent:SetJustifyH'RIGHT'
		AdditionalPowerPercent:SetFont(GameFontNormal:GetFont(), 10)
		AdditionalPowerPercent:SetTextColor(1, 1, 1)

		self:Tag(AdditionalPowerPercent, '[iip:per_a_pp]')
		AdditionalPower.percent = AdditionalPowerPercent

		if  class == 'MONK' then
			local Stagger = CreateFrame('StatusBar', nil, self)
			ns.SB(Stagger)
			ns.BD(Stagger)
			Stagger:SetFrameLevel(1)
			Stagger:SetHeight(9)
	   		Stagger:SetPoint('TOPLEFT', Power, 'BOTTOMLEFT', 10, -10)
			Stagger:SetPoint('TOPRIGHT', Power, 'BOTTOMRIGHT', -10, -10)


			Stagger.BD = Stagger:CreateTexture(nil, 'BORDER')
			Stagger.BD:SetAllPoints()
			ns.SB(Stagger.BD)
			Stagger.BD:SetVertexColor(.35, .35, .35)

			Stagger.border = Stagger:CreateTexture(nil, 'BORDER')
			Stagger.border:SetSize(0, 16)
			Stagger.border:SetPoint('TOPLEFT', 2, 0)
			Stagger.border:SetPoint('TOPRIGHT', -2, 0)
			Stagger.border:SetTexture[[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]]
			Stagger.border:SetTexCoord(.125, .25, 1, 0)
			Stagger.border:SetVertexColor(.7, .7, .7)

			Stagger.leftborder = Stagger:CreateTexture(nil, 'BORDER')
			Stagger.leftborder:SetSize(16, 16)
			Stagger.leftborder:SetPoint('RIGHT', Stagger.border, 'LEFT')
			Stagger.leftborder:SetTexture[[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]]
			Stagger.leftborder:SetTexCoord(0, .125, 1, 0)
			Stagger.leftborder:SetVertexColor(.7, .7, .7)

			Stagger.rightborder = Stagger:CreateTexture(nil, 'BORDER')
			Stagger.rightborder:SetSize(16, 16)
			Stagger.rightborder:SetPoint('LEFT', Stagger.border, 'RIGHT')
			Stagger.rightborder:SetTexture[[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]]
			Stagger.rightborder:SetTexCoord(.125, 0, 1, 0)
			Stagger.rightborder:SetVertexColor(.7, .7, .7)

			self.Stagger = Stagger

			local StaggerPoints = Stagger:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
			StaggerPoints:SetPoint('LEFT', Stagger, 2, 0)
			StaggerPoints:SetJustifyH'LEFT'
			StaggerPoints:SetFont(GameFontNormal:GetFont(), 10)
			StaggerPoints:SetTextColor(1, 1, 1)

			self:Tag(StaggerPoints, '[iip:stagger]')
			Stagger.value = StaggerPoints

			local StaggerPercent = Stagger:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
			StaggerPercent:SetPoint('RIGHT', Stagger, -2, 0)
			StaggerPercent:SetJustifyH'RIGHT'
			StaggerPercent:SetFont(GameFontNormal:GetFont(), 10)
			StaggerPercent:SetTextColor(1, 1, 1)

			self:Tag(StaggerPercent, '[iip:perstagger]')
			Stagger.percent = StaggerPercent
		end

		local Portrait = self.Health:CreateTexture(nil, 'ARTWORK')
		Portrait:SetSize(46, 46)
		Portrait:SetPoint('RIGHT', self, 70, 0)

		Portrait.BG = self.Health:CreateTexture(nil, 'BACKGROUND')
		Portrait.BG:SetSize(128, 128)
		Portrait.BG:SetTexture[[Interface\COMMON\portrait-ring-withbg]]
		Portrait.BG:SetPoint('RIGHT', self, 110, 0)

		local mask = self.Health:CreateMaskTexture()
		mask:SetTexture[[Interface\Minimap\UI-Minimap-Background]]
		mask:SetPoint('TOPLEFT', Portrait, -3, 3)
		mask:SetPoint('BOTTOMRIGHT', Portrait, 3, -3)

		Portrait:AddMaskTexture(mask)

		Portrait.vehicle = self.Health:CreateTexture(nil, 'OVERLAY')
		Portrait.vehicle:SetSize(80, 80)
		Portrait.vehicle:SetTexture[[Interface\Artifacts\RelicForge]]
		Portrait.vehicle:SetPoint('RIGHT', self, 82, 0)
		Portrait.vehicle:SetTexCoord(.59, .66, .49, .56)

		Portrait.feedback = self.Health:CreateFontString(nil, 'OVERLAY', NumberFontNormalHuge)
		Portrait.feedback:SetFont(STANDARD_TEXT_FONT, 20, 'OUTLINE')
		Portrait.feedback:SetPoint('CENTER', Portrait)
		CombatFeedback_Initialize(Portrait, Portrait.feedback, 20)

		self.Border  = {}

		self.Border.left = self:CreateTexture(nil, 'OVERLAY')
		self.Border.left:SetSize(24, 42)
		self.Border.left:SetPoint('LEFT', -13, 0)
		self.Border.left:SetTexture[[Interface\AUCTIONFRAME/UI-AuctionPost-Endcaps]]
		self.Border.left:SetTexCoord(.5, 1, 0, 1)

		self.Border.middle = self:CreateTexture(nil, 'OVERLAY')
		self.Border.middle:SetSize(118, 42)
		self.Border.middle:SetPoint'CENTER'
		self.Border.middle:SetTexture([[Interface\AUCTIONFRAME/UI-AuctionPost-Middle]], true)
		self.Border.middle:SetHorizTile(true)

		self.Border.right = self:CreateTexture(nil, 'OVERLAY')
		self.Border.right:SetSize(24, 42)
		self.Border.right:SetPoint('RIGHT', 13, 0)
		self.Border.right:SetTexture[[Interface\AUCTIONFRAME/UI-AuctionPost-Endcaps]]
		self.Border.right:SetTexCoord(0, .5, 0, 1)

		self.Border.shadow = self:CreateTexture(nil, 'BACKGROUND')
		self.Border.shadow:SetPoint('TOPLEFT', self,  -15, 15)
		self.Border.shadow:SetPoint('BOTTOMRIGHT', self,  15, -15)
		self.Border.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
		self.Border.shadow:SetVertexColor(0, 0, 0, 1)
		self.Border.shadow:SetTexCoord(0, .641, 0, .18)

		local RestingIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
    	RestingIndicator:SetSize(24, 24)
    	RestingIndicator:SetPoint('BOTTOMRIGHT', Portrait, 9, -9)
		self.RestingIndicator = RestingIndicator

		ns.BD(Castbar)
		ns.CLASS_COLOUR(Castbar)
		Castbar:ClearAllPoints()
		Castbar:SetPoint('BOTTOM', UIParent, 0, 270)
		Castbar:SetSize(136, 8)
		Castbar.timeToHold = .4

		Castbar.SafeZone = Castbar:CreateTexture(nil, 'ARTWORK')

		Castbar.IconBD = CreateFrame('Frame', nil, Castbar)
		Castbar.IconBD:SetSize(18, 18)
		Castbar.IconBD:SetPoint('BOTTOMLEFT', Castbar, 'TOPLEFT', 0, 24)
		Castbar.IconBD:SetFrameLevel(2)
		ns.BD(Castbar.IconBD)

		Castbar.Icon = Castbar:CreateTexture(nil, 'OVERLAY', nil, 7)
		Castbar.Icon:SetAllPoints(Castbar.IconBD)
		Castbar.Icon:SetTexCoord(.1, .9, .1, .9)

		Castbar.Icon.Border = Castbar:CreateTexture(nil, 'BACKGROUND', nil, -7)
		Castbar.Icon.Border:SetSize(35, 34)
		Castbar.Icon.Border:SetPoint('TOP', Castbar.Icon, 3, 5)
		Castbar.Icon.Border:SetTexture[[Interface\ACHIEVEMENTFRAME\UI-Achievement-Progressive-IconBorder]]
		Castbar.Icon.Border:SetTexCoord(.1, .65, .1, .6)

		Castbar.text = Castbar:CreateFontString(nil, 'ARTWORK')
		Castbar.text:SetPoint('LEFT', Castbar.Icon, 'RIGHT', 12, 0)
		Castbar.text:SetFont([[Fonts\ARIALN.ttf]], 11)
		Castbar.text:SetWidth(100)
		Castbar.text:SetJustifyH'LEFT'
		Castbar.text:SetWordWrap(true)
		Castbar.text:SetShadowOffset(1, -1)
		Castbar.text:SetShadowColor(0, 0, 0, 1)

		Castbar.left = Castbar:CreateTexture(nil, 'BACKGROUND', nil, -1)
		Castbar.left:SetSize(94, 64)
		Castbar.left:SetPoint('TOPLEFT', -26, 27)
		Castbar.left:SetTexture[[Interface\CastingBar\UI-CastingBar-Border]]
		Castbar.left:SetTexCoord(0, .5, 0, 1)
		Castbar.left:SetVertexColor(.8, .8, .8)

		Castbar.right = Castbar:CreateTexture(nil, 'BACKGROUND', nil, -1)
		Castbar.right:SetSize(95, 64)
		Castbar.right:SetPoint('TOPRIGHT', 26, 27)
		Castbar.right:SetTexture[[Interface\CastingBar\UI-CastingBar-Border]]
		Castbar.right:SetTexCoord(.5, 1, 0, 1)
		Castbar.right:SetVertexColor(.8, .8, .8)

		Castbar.shadow = Castbar:CreateTexture(nil, 'BACKGROUND', nil, -3)
		Castbar.shadow:SetPoint('TOPLEFT', Castbar,  -14, 11)
		Castbar.shadow:SetPoint('BOTTOMRIGHT', Castbar,  14, -11)
		Castbar.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
		Castbar.shadow:SetVertexColor(0, 0, 0, 1)
		Castbar.shadow:SetTexCoord(0, .641, 0, .18)

		RaidIcon:ClearAllPoints()

		-- TODO:  	insert BuilderSpender
		--			add castbar parent to nameplate

			-- register new elements
		self.Portrait 	= Portrait

		-- class specific powers
		AddCombo(self)
		AddPaladinPower(self)
		AddMagePower(self)
		AddMonkPower(self)
		AddWarlockPower(self)
		AddRunePower(self)
	end


	--
