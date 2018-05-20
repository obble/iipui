

	local _, ns = ...

	--  TODO:  write most of this into a shared layout

	local range = {
		insideAlpha 	= 1,
		outsideAlpha 	= .4,
	}

	local AddBorder = function(self)
		local BD = CreateFrame('Frame', nil, self)
        BD:SetBackdropColor(.05, .05, .05)
		BD:SetPoint('TOPLEFT', self, -4, 4)
		BD:SetPoint('BOTTOMRIGHT', self, 4, -4)
        BD:SetFrameLevel(0)

		BD.t = BD:CreateTexture(nil, 'ARTWORK')
		BD.t:SetPoint('TOPLEFT', -10, 19)
		BD.t:SetPoint('BOTTOMRIGHT', 10, -19)
		BD.t:SetTexture[[Interface\Glues\CHARACTERCREATE\CharacterCreate-LabelFrame]]

		local border = self:CreateTexture(nil, 'OVERLAY')
		border:SetPoint('TOPLEFT', -4, 4)
		border:SetPoint('BOTTOMRIGHT', 4, -4)
		border:SetTexture[[Interface\GuildBankFrame\UI-TabNameBorder]]
		border:SetTexCoord(0, .6, 0, .6)

		border.t = self:CreateTexture(nil, 'OVERLAY', nil, 7)
		border.t:SetPoint('TOPLEFT', -4, 4)
		border.t:SetPoint('BOTTOMRIGHT', 4, -4)
		border.t:SetTexture[[Interface\Artifacts/\rtifactPower-QuestBorder]]

		return BD, border
	end

	local AddHealth = function(self)
		local Health = CreateFrame('StatusBar', nil, self)
		ns.BD(Health)
		ns.SB(Health)
		ns.BDStone(Health, 5)
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

		local HealthPoints = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		HealthPoints:SetPoint'CENTER'
		HealthPoints:SetJustifyH'CENTER'
		HealthPoints:SetFont(GameFontNormal:GetFont(), 10)
		HealthPoints:SetTextColor(1, 1, 1)

		self:Tag(HealthPoints, '[iip:grouphp]')
		Health.value = HealthPoints

		local HealthPercent = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		HealthPercent:SetPoint('BOTTOM', 0, 4)
		HealthPercent:SetJustifyH'CENTER'
		HealthPercent:SetFont(GameFontNormal:GetFont(), 10)
		HealthPercent:SetTextColor(1, 1, 1)

		self:Tag(HealthPercent, '[iip:groupperhp]')
		Health.percent = HealthPercent

		return Health
	end

	local AddName = function(self)
		local Name = self.Health:CreateFontString(nil, 'OVERLAY', 'iipNameFont')
		Name:SetFont(STANDARD_TEXT_FONT, 11)
		Name:SetTextColor(1, .8, 0)
		Name:SetJustifyH'CENTER'
		Name:SetWidth(40)
		Name:SetPoint('CENTER', 0, 2)
		self:Tag(Name, '[iip:groupname]')
		return Name
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

	local AddLeader = function(self)
		local LeaderIndicator = self:CreateTexture(nil, 'OVERLAY')
    	LeaderIndicator:SetSize(16, 16)
    	LeaderIndicator:SetPoint('BOTTOM', self, 'TOP', 0, -4)
		return LeaderIndicator
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

	ns.UnitSpecific.dps = function(self, unit, ...)
		--
		ns.BD(self)
		ns.BDStone(self)
		-- self:SetResizable(true)
		self:SetScript('OnEnter', UnitFrame_OnEnter)
		self:SetScript('OnLeave', UnitFrame_OnLeave)
		self:RegisterForClicks'AnyUp'

		self.Health 				= AddHealth(self)
		self.Name					= AddName(self)
		self.Modifier				= AddModifier(self)
		self.ResurrectIcon 			= AddResurrectIcon(self)
		self.RaidTargetIndicator	= AddRaidIcon(self)
		self.Range					= range
		self.LeaderIndicator 		= AddLeader(self)

		ns.AddGroupAuraElement(self, unit, true)

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
		
		--  pull pre- & post- updates
		ns.PreAndPostUpdatesForGroupElements(self)
		--  introduce resizing function
		ns.CreateSizingFrame()
	end


	--
