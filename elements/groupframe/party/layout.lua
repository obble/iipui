

	local _, ns = ...

	--  TODO:  write most of this into a shared layout

	local range = {
		insideAlpha 	= 1,
		outsideAlpha 	= .4,
	}

	local AddBorder = function(self)
		local BD = CreateFrame('Frame', nil, self)
        ns.BD(BD)
        BD:SetBackdropColor(.05, .05, .05)
		BD:SetPoint('TOPLEFT', self, -4, 4)
		BD:SetPoint('BOTTOMRIGHT', self, 4, -4)
        BD:SetFrameLevel(0)

		BD.t = BD:CreateTexture(nil, 'ARTWORK')
		BD.t:SetPoint('TOPLEFT', -8, 8)
		BD.t:SetPoint('BOTTOMRIGHT', 7, -8)
		BD.t:SetTexture[[Interface/Glues/CHARACTERCREATE/UI-CharacterCreatePatchwerk]]
		BD.t:SetTexCoord(0, .42, .6, .69)

		local border = self:CreateTexture(nil, 'OVERLAY')
		border:SetPoint('TOPLEFT', -4, 4)
		border:SetPoint('BOTTOMRIGHT', 4, -4)
		border:SetTexture[[Interface/Glues/CHARACTERCREATE/UI-CharacterCreatePatchwerk]]
		border:SetTexCoord(.6505, .835, .33825, .425)
		return BD, border
	end

	local AddHealth = function(self)
		local Health = CreateFrame('StatusBar', nil, self)
		Health:SetPoint'TOP'
		Health:SetPoint'LEFT'
		Health:SetPoint'RIGHT'
		ns.BD(Health)
		ns.SB(Health)
		Health:SetHeight(9)
		Health:SetStatusBarColor(.25, .25, .25)

		Health.Smooth 			= true
		Health.frequentUpdates 	= true
		Health.colorTapping		= true
		Health.colorClass 		= true
		Health.colorReaction 	= true

		Health.back = Health:CreateTexture(nil, 'BORDER')
		Health.back:SetAllPoints(Health)
		ns.SB(Health.back)
		Health.back:SetVertexColor(.2, .2, .2)

		local HealthPoints = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		HealthPoints:SetPoint('LEFT', Health, 'RIGHT', 16, 0)
		HealthPoints:SetJustifyH'LEFT'
		HealthPoints:SetFont(GameFontNormal:GetFont(), 10)
		HealthPoints:SetTextColor(1, 1, 1)

		self:Tag(HealthPoints, '[iip:hp]')
		Health.value = HealthPoints

		local HealthPercent = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		HealthPercent:SetPoint('RIGHT', Health, -2, 0)
		HealthPercent:SetJustifyH'LEFT'
		HealthPercent:SetFont(GameFontNormal:GetFont(), 10)
		HealthPercent:SetTextColor(1, 1, 1)

		self:Tag(HealthPercent, '[iip:perhp]')
		Health.percent = HealthPercent

		return Health
	end

	local AddPower = function(self)
		local Power = CreateFrame('StatusBar', nil, self)
		Power:SetPoint('TOP', self.Health, 'BOTTOM',0, -3)
		Power:SetPoint'LEFT'
		Power:SetPoint'RIGHT'
		ns.BD(Power)
		ns.SB(Power)
		Power:SetHeight(9)

		Power.Smooth			= true
		Power.frequentUpdates 	= true
		Power.colorPower 		= true

		Power.back = Power:CreateTexture(nil, 'BORDER')
		Power.back:SetAllPoints(Power)
		ns.SB(Power.back)
		Power.back:SetVertexColor(.35, .35, .35)

		local PowerPoints = Power:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		PowerPoints:SetPoint('LEFT', Power, 'RIGHT', 16, 0)
		PowerPoints:SetJustifyH'LEFT'
		PowerPoints:SetFont(GameFontNormal:GetFont(), 10)
		PowerPoints:SetTextColor(1, 1, 1)

		self:Tag(PowerPoints, '[iip:pp]')
		Power.value = PowerPoints

		local PowerPercent = Power:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		PowerPercent:SetPoint('RIGHT', Power, -2, 0)
		PowerPercent:SetJustifyH'LEFT'
		PowerPercent:SetFont(GameFontNormal:GetFont(), 10)
		PowerPercent:SetTextColor(1, 1, 1)

		self:Tag(PowerPercent, '[iip:perpp]')
		Power.percent = PowerPercent

		return Power
	end

	local AddName = function(self)
		local Name = self.Health:CreateFontString(nil, 'OVERLAY', 'iipNameFont')
		Name:SetJustifyH'LEFT'
		Name:SetWidth(150)
		Name:SetWordWrap(true)
		Name:SetFont([[Fonts\skurri.ttf]], 12)
		Name:SetPoint('LEFT', self.Health, 2, 0)
		self:Tag(Name, '[iip:name]')
		return Name
	end

	local AddModifier = function(self)
		local Modifier = self:CreateTexture(nil, 'OVERLAY')
		Modifier:SetSize(26, 26)
		Modifier:SetPoint'CENTER'
		Modifier:Hide()
		return Modifier
	end

	local AddResurrectIcon = function(self)
		local ResurrectIcon = self:CreateTexture(nil, 'OVERLAY', nil, 7)
		ResurrectIcon:SetSize(28, 28)
		ResurrectIcon:SetPoint'CENTER'
		ResurrectIcon:Hide()
		return ResurrectIcon
	end

	local AddLFDRole = function(self)
		local LFDRole = self:CreateTexture(nil, 'OVERLAY')
		LFDRole:SetSize(22, 22)
		LFDRole:SetPoint('CENTER', 0, 1)
		LFDRole:Hide()
		return LFDRole
	end

	local AddRaidIcon = function(self)
		local RaidIcon = self:CreateTexture(nil, 'OVERLAY')
		RaidIcon:SetTexture[[Interface\AddOns\iipui\art\raidicons\raidicons]]
		RaidIcon:SetSize(24, 24)
		RaidIcon:SetPoint'CENTER'
		return RaidIcon
	end

	local AddPhaseIcon = function(self)
   		local PhaseIcon = self:CreateTexture(nil, 'OVERLAY')
   		PhaseIcon:SetSize(28, 28)
   		PhaseIcon:SetPoint('LEFT', self, 'RIGHT', 47, 0)
   		return PhaseIcon
	end

	local AddPortrait = function(self)
		local Portrait = self.Health:CreateTexture(nil, 'OVERLAY')
		Portrait:SetSize(38, 38)
		Portrait:SetPoint('RIGHT', self.Health, 'LEFT', -16, -4)

		Portrait.BG = self.Health:CreateTexture(nil, 'OVERLAY', nil, 7)
		Portrait.BG:SetSize(54, 54)
		Portrait.BG:SetTexture[[Interface\Artifacts\Artifacts]]
		Portrait.BG:SetPoint('CENTER', Portrait)
		Portrait.BG:SetTexCoord(.25, .3385, .9075, .995)
		-- Portrait.BG:SetVertexColor(.666, .666, .666)

		return Portrait
	end

	local AddPrediction = function(self)
		local Predict = CreateFrame('StatusBar', nil, self.Health)
		ns.SB(Predict)
		Predict:SetPoint'TOP'
		Predict:SetPoint'BOTTOM'
		Predict:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		Predict:SetWidth(self:GetWidth())
		Predict:SetStatusBarColor(11/255, 136/255, 105/255)
		Predict:SetFrameLevel(4)

		local OtherPredict = CreateFrame('StatusBar', nil, self.Health)
		ns.SB(OtherPredict)
		OtherPredict:SetPoint'TOP'
		OtherPredict:SetPoint'BOTTOM'
		OtherPredict:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		OtherPredict:SetWidth(self:GetWidth())
		OtherPredict:SetStatusBarColor(21/255, 89/255, 72/255)
		OtherPredict:SetFrameLevel(4)

		local Absorb = CreateFrame('StatusBar', nil, self.Health)
		Absorb:SetStatusBarTexture[[Interface\RaidFrame\Shield-Fill]]
		Absorb:SetPoint'TOP'
		Absorb:SetPoint'BOTTOM'
		Absorb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		Absorb:SetWidth(self:GetWidth())
		Absorb:SetFrameLevel(4)

		Absorb.overlay = Absorb:CreateTexture(nil, 'OVERLAY')
		Absorb.overlay:SetTexture[[Interface\RaidFrame\Shield-Overlay]]
		Absorb.overlay:SetPoint('TOPLEFT', Absorb:GetStatusBarTexture())
		Absorb.overlay:SetPoint('BOTTOMRIGHT', Absorb:GetStatusBarTexture())

		Absorb.overGlow = Absorb:CreateTexture(nil, 'OVERLAY', 'OverAbsorbGlowTemplate')
		Absorb.overGlow:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', -5, 2)
		Absorb.overGlow:SetPoint('BOTTOMRIGHT', self.Health, 2, -2)
		Absorb.overGlow:SetBlendMode'ADD'
		Absorb.overGlow:Hide()

		local HealAbsorb = CreateFrame('StatusBar', nil, self.Health)
		HealAbsorb:SetStatusBarTexture[[Interface\RaidFrame\Absorb-Fill]]
		HealAbsorb:SetPoint'TOP'
		HealAbsorb:SetPoint'BOTTOM'
		HealAbsorb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		HealAbsorb:SetWidth(self:GetWidth())
		HealAbsorb:SetStatusBarColor(.7, 1, 0)
		HealAbsorb:SetFrameLevel(4)
		return Predict, OtherPredict, Absorb, HealAbsorb
	end

	ns.UnitSpecific.party = function(self, ...)
		--
		self:SetSize(137, 20)
		-- self:SetResizable(true)
		self:SetScript('OnEnter', UnitFrame_OnEnter)
		self:SetScript('OnLeave', UnitFrame_OnLeave)
		self:RegisterForClicks'AnyUp'

		self.Health 				= AddHealth(self)
		self.Power 					= AddPower(self)
		self.Name 					= AddName(self)
		self.BD, self.Border 		= AddBorder(self)
		self.Modifier				= AddModifier(self)
		self.ResurrectIcon 			= AddResurrectIcon(self)
		self.RaidTargetIndicator	= AddRaidIcon(self)
		self.PhaseIndicator 		= AddPhaseIcon(self)
		self.Portrait 				= AddPortrait(self)
		self.LFDRole 				= AddLFDRole(self)
		self.Range					= range

		--local Predict, OtherPredict, Absorb, HealAbsorb, OverAbsorb, OverHealAbsorb = AddPrediction(self)
		--[[self.HealthPrediction = {
			myBar           = Predict,
			otherBar        = OtherPredict,
			absorbBar       = Absorb,
			healAbsorbBar   = HealAbsorb,
			overAbsorb		= OverAbsorb,
			overHealAbsorb  = OverHealAbsorb,
			maxOverflow     = 1,
			frequentUpdates = true,
		}]]

		ns.AddAuraElement(self, unit, {'LEFT', self, 'RIGHT', 80, 0}, 'LEFT', 'RIGHT', 'UP')

		--  pull pre- & post- updates
		ns.PreAndPostUpdatesForGroupElements(self)
		--  introduce resizing function
		ns.CreateSizingFrame()
	end


	--
