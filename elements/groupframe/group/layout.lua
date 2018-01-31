

	local _, ns = ...

	if not ns.UnitSpecific then --  someone has deleted the unitframes
		ns.UnitSpecific = {}    --  but not the groupframe
	end

	local range = {
		insideAlpha 	= 1,
		outsideAlpha 	= .4,
	}

	for i = 1, 6 do
		local no = CompactRaidFrameManager:CreateFontString('iipRaidGroupNo'..i, 'OVERLAY', 'GameFontNormal')
		no:SetPoint(
			'BOTTOMLEFT',
			i == 1 and ChatFrame1 or  _G['iipRaidGroupNo'..(i - 1)],
			'TOPLEFT',
			0,
			i == 1 and 70 or 35
		)
	end

	local AddBorder = function(self)
		local BD = CreateFrame('Frame', nil, self)
        ns.BD(BD)
        BD:SetBackdropColor(.05, .05, .05)
		BD:SetPoint('TOPLEFT', self, -4, 4)
		BD:SetPoint('BOTTOMRIGHT', self, 4, -4)
        BD:SetFrameLevel(0)

		BD.t = BD:CreateTexture(nil, 'ARTWORK')
		BD.t:SetPoint('TOPLEFT', -1, 1)
		BD.t:SetPoint('BOTTOMRIGHT', 1, -1)
		BD.t:SetTexture[[Interface/BankFrame/Bank-Background]]
		BD.t:SetTexCoord(0, 1, .18, .3)
		BD.t:SetVertexColor(.8, .8, .8)

		local border = self:CreateTexture(nil, 'OVERLAY')
		border:SetPoint('TOPLEFT', -4, 4)
		border:SetPoint('BOTTOMRIGHT', 4, -4)
		border:SetTexture[[Interface/Glues/CHARACTERCREATE/UI-CharacterCreatePatchwerk]]
		border:SetTexCoord(.6505, .835, .33825, .425)
		return BD, border
	end

	local AddHealth = function(self)
		local Health = CreateFrame('StatusBar', nil, self)
		ns.BD(Health)
		ns.SB(Health)
		Health:SetHeight(35)
		Health:SetStatusBarColor(.25, .25, .25)
		Health:SetAllPoints()

		Health.Smooth 			= true
		Health.frequentUpdates 	= true
		Health.colorTapping		= true
		Health.colorClass 		= true
		Health.colorReaction 	= true

		Health.back = Health:CreateTexture(nil, 'BORDER')
		Health.back:SetAllPoints(Health)
		ns.SB(Health.back)
		Health.back:SetVertexColor(.2, .2, .2)
		return Health
	end

	local AddHover = function(self)
		local Hover = CreateFrame('Frame', nil, self.Health)
		Hover:SetAllPoints()
		Hover:Hide()

		Hover.t = Hover:CreateTexture(nil, 'OVERLAY')
		Hover.t:SetPoint('TOPLEFT', -1, 1)
		Hover.t:SetPoint('BOTTOMRIGHT', 1, -1)
		Hover.t:SetTexture[[Interface/Glues/CHARACTERCREATE/UI-CharacterCreatePatchwerk]]
		Hover.t:SetTexCoord(.43, .62, .4375, .5325)
		Hover.t:SetVertexColor(1, 1, 1)
		return Hover
	end

	local AddLFDRole = function(self)
		local LFDRole = self.Health:CreateTexture(nil, 'OVERLAY')
		LFDRole:SetSize(22, 22)
		LFDRole:SetPoint('CENTER', 0, 1)
		LFDRole:Hide()
		return LFDRole
	end

	local AddModifier = function(self)
		local Modifier = self.Health:CreateTexture(nil, 'OVERLAY')
		Modifier:SetSize(26, 26)
		Modifier:SetPoint'CENTER'
		Modifier:Hide()
		return Modifier
	end

	local AddResurrectIcon = function(self)
		local ResurrectIcon = self.Health:CreateTexture(nil, 'OVERLAY', nil, 7)
		ResurrectIcon:SetSize(28, 28)
		ResurrectIcon:SetPoint'CENTER'
		ResurrectIcon:Hide()
		return ResurrectIcon
	end

	local AddRaidIcon = function(self)
		local RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:SetTexture[[Interface\AddOns\iipui\art\raidicons\raidicons]]
		RaidIcon:SetSize(24, 24)
		RaidIcon:SetPoint'CENTER'
		return RaidIcon
	end

	local AddReadyCheck = function(self)
		local ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
		ReadyCheck:SetPoint'CENTER'
		ReadyCheck:SetSize(18, 18)
		return ReadyCheck
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

	ns.UnitSpecific.party = function(self, unit, ...)
		--
		self:SetSize(30, 25)
		self:SetResizable(false)
		self:SetScript('OnEnter', UnitFrame_OnEnter)
		self:SetScript('OnLeave', UnitFrame_OnLeave)
		self:RegisterForClicks'AnyUp'

		self.BD, self.Border 		= AddBorder(self)
		self.Health 				= AddHealth(self)
		self.Hover 					= AddHover(self)
		self.LFDRole 				= AddLFDRole(self)
		self.Modifier				= AddModifier(self)
		self.ResurrectIcon 			= AddResurrectIcon(self)
		self.RaidTargetIndicator	= AddRaidIcon(self)
		self.ReadyCheck				= AddReadyCheck(self)
		self.Range					= range

		--  TODO:  insert BuilderSpender

		--[[local Predict, OtherPredict, Absorb, HealAbsorb = AddPrediction(self)
		self.HealPrediction = {
			myBar           = Predict,
			otherBar        = OtherPredict,
			absorbBar       = Absorb,
			healAbsorbBar   = HealAbsorb,
			maxOverflow     = 1.05,
			frequentUpdates = true,
		}]]

		ns.AddGroupAuraElement(self, unit, true)

		--  pull pre- & post- updates
		ns.PreAndPostUpdatesForGroupElements(self, unit)

		--  introduce resizing function
		if  unit == 'raid1' then
			ns.CreateSizingFrame()
		end
	end


	--
