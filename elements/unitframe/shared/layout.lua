

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

		Health.Smooth 			= true
		Health.frequentUpdates	= true
		Health.colorTapping 	= true
		Health.colorClass 		= true
		Health.colorReaction 	= true

		Health.BD = Health:CreateTexture(nil, 'BORDER')
		ns.SB(Health.BD)
		Health.BD:SetAllPoints()
		Health.BD:SetVertexColor(.2, .2, .2)
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
		--[[local Predict = CreateFrame('StatusBar', nil, self.Health)
		ns.SB(Predict)
		Predict:SetPoint'TOP'
		Predict:SetPoint'BOTTOM'
		Predict:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		Predict:SetWidth(self:GetWidth())
		Predict:SetStatusBarColor(11/255, 136/255, 105/255)
		Predict:SetFrameLevel(4)]]

		--[[local OtherPredict = CreateFrame('StatusBar', nil, self.Health)
		ns.SB(OtherPredict)
		OtherPredict:SetPoint'TOP'
		OtherPredict:SetPoint'BOTTOM'
		OtherPredict:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		OtherPredict:SetWidth(self:GetWidth())
		OtherPredict:SetStatusBarColor(21/255, 89/255, 72/255)
		OtherPredict:SetFrameLevel(4)]]

		--[[local Absorb = CreateFrame('StatusBar', nil, self.Health)
		Absorb:SetStatusBarTextureInterface\RaidFrame\Shield-Fill
		Absorb:SetPoint'TOP'
		Absorb:SetPoint'BOTTOM'
		Absorb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		Absorb:SetWidth(self:GetWidth())
		Absorb:SetFrameLevel(4)]]

		--[[Absorb.overlay = Absorb:CreateTexture(nil, 'OVERLAY')
		Absorb.overlay:SetTextureInterface\RaidFrame\Shield-Overlay
		Absorb.overlay:SetPoint('TOPLEFT', Absorb:GetStatusBarTexture())
		Absorb.overlay:SetPoint('BOTTOMRIGHT', Absorb:GetStatusBarTexture())

		Absorb.overGlow = Absorb:CreateTexture(nil, 'OVERLAY', 'OverAbsorbGlowTemplate')
		Absorb.overGlow:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', -5, 2)
		Absorb.overGlow:SetPoint('BOTTOMRIGHT', self.Health, 2, -2)
		Absorb.overGlow:SetBlendMode'ADD'
		Absorb.overGlow:Hide()]]

		local HealAbsorb = CreateFrame('StatusBar', nil, self.Health)
		HealAbsorb:SetStatusBarTexture[[Interface\RaidFrame\Absorb-Fill]]
		HealAbsorb:SetPoint'TOP'
		HealAbsorb:SetPoint'BOTTOM'
		HealAbsorb:SetPoint('RIGHT', self.Health:GetStatusBarTexture())
		HealAbsorb:SetWidth(self:GetWidth())
		HealAbsorb:SetReverseFill(true)
		HealAbsorb:SetStatusBarColor(.7, 1, 0)
		HealAbsorb:SetFrameLevel(4)

		local OverAbsorb = self.Health:CreateTexture(nil, "OVERLAY")
    	OverAbsorb:SetPoint('TOP')
    	OverAbsorb:SetPoint('BOTTOM')
    	OverAbsorb:SetPoint('LEFT', self.Health, 'RIGHT')
    	OverAbsorb:SetWidth(10)

		local OverHealAbsorb = self.Health:CreateTexture(nil, "OVERLAY")
    	OverHealAbsorb:SetPoint('TOP')
    	OverHealAbsorb:SetPoint('BOTTOM')
    	OverHealAbsorb:SetPoint('RIGHT', self.Health, 'LEFT')
    	OverHealAbsorb:SetWidth(10)

		return Predict, OtherPredict, Absorb, HealAbsorb, OverAbsorb, OverHealAbsorb
	end

	local AddBuilderSpender = function()
		--
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

		-- TODO:  insert BuilderSpender

		--local Predict, OtherPredict, Absorb, HealAbsorb, OverAbsorb, OverHealAbsorb = AddPrediction(self)
		--[[self.HealPrediction = {
			--myBar           = Predict,
			--otherBar        = OtherPredict,
			--absorbBar       = Absorb,
			--healAbsorbBar   = HealAbsorb,
			overAbsorb      = OverAbsorb,
			overHealAbsorb  = OverHealAbsorb,
			maxOverflow     = 1.05,
			frequentUpdates = true,
		}]]

		-- pull pre- & post- updates
		ns.PreAndPostUpdatesForElements(self)
	end


	--
