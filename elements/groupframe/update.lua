

    local _, ns = ...

    local OverrideLFD = function(self)
		local LFDRole = self.LFDRole
		if LFDRole then
			local role    = UnitGroupRolesAssigned(self.unit)
			if self.Modifier and self.Modifier:IsShown() or self.RaidTargetIndicator:IsShown() then
				LFDRole:SetTexture''
				LFDRole:Hide()
			elseif role == 'HEALER' then
				LFDRole:SetTexture[[Interface\AddOns\iipui\art\group\role\healer.tga]]
				LFDRole:SetTexCoord(0, 1, 0, 1)
				LFDRole:Show()
			elseif role == 'TANK' then
				LFDRole:SetTexture[[Interface\AddOns\iipui\art\group\role\tank.tga]]
				LFDRole:SetTexCoord(0, 1, 0, 1)
				LFDRole:Show()
			else
				LFDRole:SetTexture''
				LFDRole:Hide()
			end
		end
	end

	local UpdateModifier = function(self, unit)
		if  self.Modifier then
			self.Modifier:Hide()
			if  UnitIsDead(unit) then
				self.Modifier:SetTexture[[Interface\AddOns\iipui\art\group\modifier\dead]]
				self.Modifier:Show()
			elseif UnitIsGhost(unit) then
				self.Modifier:SetTexture[[Interface\AddOns\iipui\art\group\modifier\ghost]]
				self.Modifier:Show()
			elseif UnitIsAFK(unit) then
				self.Modifier:SetTexture[[Interface\AddOns\iipui\art\group\modifier\afk]]
				self.Modifier:Show()
			end
		end
		OverrideLFD(self)
	end

	local UpdateGroupIndicator = function()
		for i = 1, 6 do
			_G['iipRaidGroupNo'..i]:Hide()
		end
		for i = 1, GetNumGroupMembers() do
			local _, _, subgroup = GetRaidRosterInfo(i)
			for j = 1,  subgroup do
				if  _G['iipRaidGroupNo'..j] then
					local GroupNo = _G['iipRaidGroupNo'..j]
					GroupNo:SetText(j)
					GroupNo:Show()
				end
			end
		end
	end

	local PostUpdateHealth = function(Health, unit)
		local _, class = UnitClass(unit)
		local colour   = RAID_CLASS_COLORS[class]
		if  UnitIsPlayer(unit) and colour then
			UpdateModifier(Health:GetParent(), unit)
			Health.back:SetVertexColor(colour.r*.2, colour.g*.2, colour.b*.2)
		end
	end

	local PostUpdateReadyCheckFade = function(self)
		local Health     = self:GetParent()
		local Silhouette = Health:GetParent().Silhouette
		if  LFDRole and not LFDRole:IsShown() then
			LFDRole:Show()
		end
		if  Silhouette and not Silhoutte:IsShown() then
			Silhouette:Show()
		end
	end

	local PostUpdateReadyCheck = function(self, status)
		local Health     = self:GetParent()
		local Silhouette = Health:GetParent().Silhouette
		local LFDRole    = self.LFDRole
		if  self:IsShown() and LFDRole and LFDRole:IsShown() then
			LFDRole:Hide()
		end
		if  self:IsShown() and Silhouette and Silhoutte:IsShown() then
			Silhouette:Hide()
		end
	end

	local AnimName = function(self, unit)
		if  _G['iipRaidStats_GRIDName'] then
			local name     = UnitName(unit)
			local _, class = UnitClass(unit)
			local colour   = RAID_CLASS_COLORS[class]
			local parent   = _G['iipRaidStats']
			local frame    = _G['iipRaidStats_GRIDName']	-- use ns

			if not SlidingGroupName then
				local slideGroup = frame:CreateAnimationGroup'SlidingGroupName'

				local slide = slideGroup:CreateAnimation'Translation'
				slide:SetDuration(.22)
				slide:SetOffset(-18, 0)
				slide:SetSmoothing'OUT'
				slide:SetScript('OnPlay', function()
					frame:ClearAllPoints()
					frame:SetPoint('BOTTOMLEFT', parent, 15, -20)
				end)
				slide:SetScript('OnFinished', function()
					active = false
					frame:ClearAllPoints()
					frame:SetPoint('BOTTOMLEFT', parent, -3, -20)
					slideGroup:Stop()
				end)

				local fade = slideGroup:CreateAnimation'Alpha'
				fade:SetFromAlpha(0)
				fade:SetToAlpha(1)
				fade:SetDuration(.5)
				fade:SetSmoothing'OUT'
			end

			SlidingGroupName:Play()

			if colour then
				frame:SetText(name and '|c'..colour.colorStr..strupper(name)..'|r')
			else
				frame:SetText(name and '|cffffc800'..strupper(name)..'|r')	-- probably a vehicle
			end
		end
	end

	local AnimHover = function(self, unit, enable)
		if not enable then return end
		self.Hover:Show()
		if not pulseGroup then
			local pulseGroup = self.Hover:CreateAnimationGroup(self:GetName()..'pulseGroup')
			pulseGroup:SetLooping'BOUNCE'

			local pulse = pulseGroup:CreateAnimation'Alpha'
			pulse:SetDuration(.75)
			pulse:SetFromAlpha(.8)
			pulse:SetToAlpha(0)
			pulse:SetSmoothing'OUT'
		end
		_G[self:GetName()..'pulseGroup']:Play()
	end

    ns.AddGroupAuraElement = function(frame, unit, enable)
		local auraElementForUnit 		 = ns.auraGroupElement[unit]
		local auraDecurseElementsForUnit = ns.auraGroupDecurseElement[unit]
		if  enable and auraElementForUnit then
            --  buffs [circular tracker]
            local Auras = CreateFrame('Frame', nil, frame)
            Auras:SetPoint('CENTER', 0, -1)
            Auras:SetSize(35, 35)
            ns.SetGroupPosition(Auras)

            Auras['num']              = 3
            Auras.disableCooldown     = true
            Auras.SetPosition	      = enable and ns.SetGroupPosition
            Auras.PostCreateIcon      = enable and ns.PostCreateIcon
            Auras.PostUpdateIcon      = enable and ns.PostUpdateGroupIcon
            Auras.CustomFilter        = enable and ns.CustomGroupAuraFilter

            frame[auraElementForUnit] = Auras
        end
        if enable and auraDecurseElementsForUnit then
			--  debuffs [status icons]
            local Icon = CreateFrame('Frame', nil, frame)
            Icon:SetPoint('TOPLEFT', 2, 12)
            Icon:SetSize(54, 15)

            Icon['num']			= 3
            Icon['initialAnchor']  = 'TOPLEFT'
            Icon['growth-x']	    = 'TOPRIGHT'
            Icon['spacing-x']      = -6
            Icon['size']           = 15

            Icon.disableCooldown     = true
            Icon.PostCreateIcon      = enable and ns.PostCreateDispelIcon
            Icon.PostUpdateIcon      = enable and ns.PostUpdateDispelIcon
            Icon.CustomFilter        = enable and ns.DispelGroupAuraFilter

            frame[auraDecurseElementsForUnit] = Icon
		end
	end

    ns.PreAndPostUpdatesForGroupElements = function(self, unit)
        local Health, LFDRole, ReadyCheck, Hover = self.Health, self.LFDRole, self.ReadyCheck, self.Hover

        Health.PostUpdate                = PostUpdateHealth

        if  LFDRole then
            LFDRole.Override             = OverrideLFD
        end

        if  ReadyCheck then
            ReadyCheck.PostUpdate        = PostUpdateReadyCheck
            ReadyCheck.PostUpdateFadeOut = PostUpdateReadyCheckFade
        end

        -- hover events
        if  Hover then
            self:HookScript('OnLeave', function()
    		    if  _G['iipRaidStats_GRIDName'] then
    				_G['iipRaidStats_GRIDName']:SetText''
    			end
    		    Hover:Hide()
    			_G[self:GetName()..'pulseGroup']:Stop()
    		end)


    		self:HookScript('OnEnter', function()
    			local last = 0
    			AnimName(self,  unit)
    			AnimHover(self, unit, true)
    		end)
        end
    end


    --
