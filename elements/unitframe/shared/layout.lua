

	local _, ns = ...

	ns.UnitSpecific = {}

	local colours = setmetatable({
		tapped = {.9, .9, .9},
		reaction = setmetatable({
			[1] = {1, 0, 0},
			[2] = {1, 0, 0},
			[3] = {1, 0, 0},
			[4] = {1, 1, 0},
			[5] = {0, 1, 0},
			[6] = {0, 1, 0},
			[7] = {0, 1, 0},
			[8] = {0, 1, 0},
		}, {__index = oUF.colors.reaction}),
	}, {__index = oUF.colors})

	local AddHealth = function(self)
		local Health = CreateFrame('StatusBar', nil, self)
		ns.BD(Health)
		ns.SB(Health)
		Health:SetStatusBarColor(.25, .25, .25)
		Health:SetPoint'TOP'
		Health:SetPoint'LEFT'
		Health:SetPoint'RIGHT'

		-- Health.Smooth 			= true
		Health.frequentUpdates	= true
		Health.colorTapping 	= true
		Health.colorClass 		= true
		Health.colorReaction 	= true

		Health.BD = Health:CreateTexture(nil, 'BORDER')
		ns.SB(Health.BD)
		Health.BD:SetAllPoints()
		Health.BD:SetVertexColor(.2, .2, .2)

		local Gain = Health:CreateTexture(nil, 'OVERLAY')
		Gain:SetPoint('TOPRIGHT', Health:GetStatusBarTexture())
		Gain:SetPoint('BOTTOMRIGHT', Health:GetStatusBarTexture())
		Gain:SetColorTexture(0, 1, 0)
		Gain:SetAlpha(0)
		Health.Gain = Gain

		local Loss = Health:CreateTexture(nil, 'OVERLAY')
		Loss:SetPoint('TOPLEFT', Health:GetStatusBarTexture(), 'TOPRIGHT')
		Loss:SetPoint('BOTTOMLEFT', Health:GetStatusBarTexture(), 'BOTTOMRIGHT')
		Loss:SetColorTexture(1, 0, 0)
		Loss:SetAlpha(0)
		Health.Loss = Loss

		local AG = Gain:CreateAnimationGroup()
		AG:SetToFinalAlpha(true)
		Gain.FadeOut = AG

		local anim1 = AG:CreateAnimation'Alpha'
		anim1:SetFromAlpha(1)
		anim1:SetToAlpha(0)
		anim1:SetStartDelay(.6)
		anim1:SetDuration(.2)

		AG = Loss:CreateAnimationGroup()
		AG:SetToFinalAlpha(true)
		Loss.FadeOut = AG

		anim1 = AG:CreateAnimation'Alpha'
		anim1:SetFromAlpha(1)
		anim1:SetToAlpha(0)
		anim1:SetStartDelay(.6)
		anim1:SetDuration(.2)

		return Health
	end

	local AddPower = function(self)
		local Power = CreateFrame('StatusBar', nil, self)
		ns.BD(Power)
		ns.SB(Power)
		Power:SetHeight(9)
		Power:SetPoint'LEFT'
		Power:SetPoint'RIGHT'
		Power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -3)

		Power.Smooth			= true
		Power.frequentUpdates 	= true
		Power.colorPower 		= true

		Power.BD = Power:CreateTexture(nil, 'BORDER')
		Power.BD:SetAllPoints()
		ns.SB(Power.BD)
		Power.BD:SetVertexColor(.35, .35, .35)

		local Gain = Power:CreateTexture(nil, 'OVERLAY')
		Gain:SetPoint('TOPRIGHT', Power:GetStatusBarTexture())
		Gain:SetPoint('BOTTOMRIGHT', Power:GetStatusBarTexture())
		Gain:SetTexture[[Interface\TargetingFrame\UI-StatusBar-Glow]]
		Gain:SetAlpha(0)
		Power.Gain = Gain

		local Loss = Power:CreateTexture(nil, 'OVERLAY')
		Loss:SetPoint('TOPLEFT', Power:GetStatusBarTexture(), 'TOPRIGHT')
		Loss:SetPoint('BOTTOMLEFT', Power:GetStatusBarTexture(), 'BOTTOMRIGHT')
		Loss:SetTexture[[Interface\TargetingFrame\UI-StatusBar-Glow]]
		Loss:SetAlpha(0)
		Power.Loss = Loss

		local AG = Gain:CreateAnimationGroup()
		AG:SetToFinalAlpha(true)
		Gain.FadeInOut = AG

		local anim1 = AG:CreateAnimation'Alpha'
		anim1:SetFromAlpha(0)
		anim1:SetToAlpha(.8)
		anim1:SetStartDelay(0)
		anim1:SetSmoothing'IN'
		anim1:SetDuration(.2)

		local anim2 = AG:CreateAnimation'Alpha'
		anim2:SetFromAlpha(.6)
		anim2:SetToAlpha(0)
		anim2:SetStartDelay(.6)
		anim2:SetDuration(.2)

		AG = Loss:CreateAnimationGroup()
		AG:SetToFinalAlpha(true)
		Loss.FadeInOut = AG

		local anim1 = AG:CreateAnimation'Alpha'
		anim1:SetFromAlpha(0)
		anim1:SetToAlpha(.8)
		anim1:SetStartDelay(0)
		anim1:SetSmoothing'IN'
		anim1:SetDuration(.2)

		local anim2 = AG:CreateAnimation'Alpha'
		anim2:SetFromAlpha(.6)
		anim2:SetToAlpha(0)
		anim2:SetStartDelay(.6)
		anim2:SetDuration(.2)

		return Power
	end

	local AddCastbar = function(self)
		local Castbar = CreateFrame('StatusBar', nil, self)
		ns.SB(Castbar)
		Castbar:SetStatusBarColor(1, .95, 0, .6)
		Castbar:SetAllPoints(self.Health)
		Castbar:SetToplevel(true)
		return Castbar
	end

	local AddRaidIcon = function(self)
		local RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:SetSize(32, 32)
		RaidIcon:SetPoint('CENTER', 0, -5)
		RaidIcon:SetTexture[[Interface\AddOns\iipui\art\raidicons\raidicons]]
		return RaidIcon
	end

	local AddReadyCheck = function(self)
		local ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY', nil, 7)
		ReadyCheck:SetSize(16, 16)
		ReadyCheck:SetPoint('CENTER', 0, -5)
		return ReadyCheck
	end

	local AddQuestIndicator = function(self)
		local QuestIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
		QuestIndicator:SetSize(16, 16)
		QuestIndicator:SetPoint('LEFT', -15, 0)
		return QuestIndicator
	end

	local AddPrediction = function(self)
		local l = self:GetFrameLevel()
		local x = self.Health:GetWidth()
		x = x > 0 and x or self:GetWidth()

		local Predict = CreateFrame('StatusBar', nil, self.Health)
		ns.SB(Predict)
		Predict:SetPoint'TOP'
		Predict:SetPoint'BOTTOM'
		Predict:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		Predict:SetWidth(x)
		Predict:SetFrameLevel(l)
		Predict:SetStatusBarColor(11/255, 136/255, 105/255)

		local OtherPredict = CreateFrame('StatusBar', nil, self.Health)
		ns.SB(OtherPredict)
		OtherPredict:SetPoint'TOP'
		OtherPredict:SetPoint'BOTTOM'
		OtherPredict:SetPoint('LEFT', Predict:GetStatusBarTexture(), 'RIGHT')
		OtherPredict:SetWidth(x)
		OtherPredict:SetFrameLevel(l)
		OtherPredict:SetStatusBarColor(21/255, 89/255, 72/255)

		local Absorb = CreateFrame('StatusBar', nil, self.Health)
		Absorb:SetStatusBarTexture[[Interface\RaidFrame\Shield-Fill]]
		Absorb:SetPoint'TOP'
		Absorb:SetPoint'BOTTOM'
		Absorb:SetPoint('LEFT', OtherPredict:GetStatusBarTexture(), 'RIGHT')
		Absorb:SetFrameLevel(l + 1)
		Absorb:SetWidth(x)

		Absorb.overlay = Absorb:CreateTexture(nil, 'OVERLAY')
		Absorb.overlay:SetTexture[[Interface\RaidFrame\Shield-Overlay]]
		Absorb.overlay:SetAllPoints(Absorb:GetStatusBarTexture())

		Absorb.overGlow = Absorb:CreateTexture(nil, 'OVERLAY', 'OverAbsorbGlowTemplate')
		Absorb.overGlow:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', -5, 2)
		Absorb.overGlow:SetPoint('BOTTOMRIGHT', self.Health, 2, -2)
		Absorb.overGlow:SetBlendMode'ADD'
		Absorb.overGlow:Hide()

		local HealAbsorb = CreateFrame('StatusBar', nil, self.Health)
		HealAbsorb:SetStatusBarTexture[[Interface\RaidFrame\Absorb-Fill]]
		HealAbsorb:SetPoint'TOP'
		HealAbsorb:SetPoint'BOTTOM'
		HealAbsorb:SetPoint('RIGHT', self.Health:GetStatusBarTexture())
		HealAbsorb:SetWidth(x)
		HealAbsorb:SetFrameLevel(l + 1)
		HealAbsorb:SetReverseFill(true)

		HealAbsorb:SetStatusBarColor(.7, 1, 0)

		local OverAbsorb = self.Health:CreateTexture(nil, 'OVERLAY')
    	OverAbsorb:SetPoint'TOP'
    	OverAbsorb:SetPoint'BOTTOM'
    	OverAbsorb:SetPoint('LEFT', self.Health, 'RIGHT')
    	OverAbsorb:SetWidth(10)

		local OverHealAbsorb = self.Health:CreateTexture(nil, 'OVERLAY')
    	OverHealAbsorb:SetPoint'TOP'
    	OverHealAbsorb:SetPoint'BOTTOM'
    	OverHealAbsorb:SetPoint('RIGHT', self.Health, 'LEFT')
    	OverHealAbsorb:SetWidth(10)

		return Predict, OtherPredict, Absorb, HealAbsorb, OverAbsorb, OverHealAbsorb
	end

	ns.SharedLayout = function(self, ...)
		self:SetScript('OnEnter', UnitFrame_OnEnter)
		self:SetScript('OnLeave', UnitFrame_OnLeave)
		self:RegisterForClicks'AnyUp'

		self.Health 				= AddHealth(self)
		self.Power 					= AddPower(self)
		self.Castbar 				= AddCastbar(self)
		self.RaidTargetIndicator 	= AddRaidIcon(self)
		self.ReadyCheckIndicator 	= AddReadyCheck(self)
		self.QuestIndicator 		= AddQuestIndicator(self)

		--	insert nameplate-matching reaction colours
		self.colors 				= colours

		local Predict, OtherPredict, Absorb, HealAbsorb, OverAbsorb, OverHealAbsorb = AddPrediction(self)
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

		-- pull pre- & post- updates
		ns.PreAndPostUpdatesForElements(self)
	end


	--
