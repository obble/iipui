

    local _, ns = ...
    local e = CreateFrame'Frame'

    local OverrideLFD = function(self, override)
		local LFDRole = self.LFDRole
		if  LFDRole then
			local role = UnitGroupRolesAssigned(self.unit)
			if  (self.Modifier and self.Modifier:IsShown()) or self.RaidTargetIndicator:IsShown() or override then
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

    local UpdateName = function(self, unit, show)
        local v, max = UnitHealth(unit), UnitHealthMax(unit)
        if not self.Name then return end
        self.Name:Hide()
        if  show and (not self.Name.locked) and (v == max or v == 0) then
            self.Name:Show()
        end
    end

	local UpdateModifier = function(self, unit)
		if  self.Modifier then
			self.Modifier:Hide()
            UpdateName(self, unit, true)
            if self.Health.percent then self.Health.percent:Show() end
			if  UnitIsDead(unit) then
				self.Modifier:SetTexture[[Interface\AddOns\iipui\art\group\modifier\dead]]
				self.Modifier:Show()
                UpdateName(self, unit, false)
                if self.Health.percent then self.Health.percent:Hide() end
			elseif UnitIsGhost(unit) then
				self.Modifier:SetTexture[[Interface\AddOns\iipui\art\group\modifier\ghost]]
				self.Modifier:Show()
                UpdateName(self, unit, false)
                if self.Health.percent then self.Health.percent:Hide() end
			elseif UnitIsAFK(unit) then
				self.Modifier:SetTexture[[Interface\AddOns\iipui\art\group\modifier\afk]]
				self.Modifier:Show()
                UpdateName(self, unit, false)
                if self.Health.percent then self.Health.percent:Hide() end
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
		local _, class  = UnitClass(unit)
		local colour    = RAID_CLASS_COLORS[class]
        local parent    = Health:GetParent()
        local v, max    = UnitHealth(unit), UnitHealthMax(unit)
        local cv = GetCVar'statusTextDisplay'
        if  cv and cv == 'BOTH' then
            if  string.find(parent:GetName(), 'tank') then
                Health.value:ClearAllPoints()
                Health.value:SetPoint('LEFT', 7, 0)
            elseif string.find(parent:GetName(), 'dps') then
                Health.value:ClearAllPoints()
                Health.value:SetPoint('TOP', 0, -4)
            end
        else
            if  string.find(parent:GetName(), 'tank') then
                Health.value:ClearAllPoints()
                Health.value:SetPoint'CENTER'
            elseif string.find(parent:GetName(), 'dps') then
                Health.value:ClearAllPoints()
                Health.value:SetPoint('TOP', 0, -4)
            end
        end
        if  UnitIsPlayer(unit) and colour then
            UpdateModifier(parent, unit)
            Health.back:SetVertexColor(colour.r*.2, colour.g*.2, colour.b*.2)
        end
        if  v < max then
            OverrideLFD(parent, true)
            UpdateName(parent, unit, false)
            if  parent.Auras and parent.Auras.visibleBuffs > 0 then
                Health.value:Hide()
                if Health.percent then Health.percent:Hide() end
            else
                Health.value:Show()
                if Health.percent then Health.percent:Show() end
            end
        end
	end

	local PostUpdateReadyCheckFade = function(self)
		local Health     = self:GetParent()
		local LFDRole    = self.LFDRole
		if  LFDRole and not LFDRole:IsShown() then
			LFDRole:Show()
		end
	end

	local PostUpdateReadyCheck = function(self, status)
		local Health     = self:GetParent()
		local Silhouette = Health:GetParent().Silhouette
		local LFDRole    = self.LFDRole
		if  self:IsShown() and LFDRole and LFDRole:IsShown() then
			LFDRole:Hide()
		end
	end

    local auraGroupElement = {
        party   = 'Buffs',
        raid    = 'Buffs'
    }
    local auraGroupDecurseElement = {
        party   = 'Debuffs',
        raid    = 'Debuffs'
    }

    ns.AddGroupAuraElement = function(frame, unit, enable)
		local auraElementForUnit 		 = auraGroupElement[unit]
		local auraDecurseElementsForUnit = auraGroupDecurseElement[unit]
		if  enable and auraElementForUnit then
            --  buffs [circular tracker]
            local Auras = CreateFrame('Frame', nil, frame)
            Auras:SetPoint('CENTER', 0, -1)
            Auras:SetSize(50, 50)
            ns.SetGroupPosition(Auras)

            Auras['num']              = 3
            Auras.disableCooldown     = true
            Auras.SetPosition	      = enable and ns.SetGroupPosition
            Auras.PostCreateIcon      = enable and ns.PostCreateIcon
            Auras.PostUpdateIcon      = enable and ns.PostUpdateGroupIcon
            Auras.PostUpdate          = enable and ns.PostUpdateGroupAuras
            Auras.CustomFilter        = enable and ns.CustomGroupAuraFilter

            frame.Auras = Auras
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
    end

    local OnEvent = function(self, event)
        local frames = {
            ['tank']    = 'TANK',
            ['support'] = 'HEALER',
            ['dps']     = 'DAMAGER' or 'NONE',
        }
        if  event == 'PLAYER_REGEN_ENABLED' then
            e:UnregisterEvent'PLAYER_REGEN_ENABLED'
        end

        if  IsInGroup() and not IsInRaid() then
            local f = _G['oUF_party']
            f.header:Show()
            f.header.t:Show()
        else
            local f = _G['oUF_party']
            f.header:Hide()
            f.header.t:Hide()
        end

        for  i, v in pairs(frames) do
            local f = _G['oUF_'..i]
            if f and f.header then
                if InCombatLockdown() then
                    e:RegisterEvent'PLAYER_REGEN_ENABLED'
                    return
                elseif  RaidInfoCounts and RaidInfoCounts['totalRole'..v] > 0 then
                    f.header:Show()
                    f.header.t:Show()
                else
                    f.header:Hide()
                    f.header.t:Hide()
                end
            end
        end
    end

    e:RegisterEvent'PLAYER_ENTERING_WORLD'
    e:RegisterEvent'GROUP_ROSTER_UPDATE'
    e:SetScript('OnEvent', OnEvent)


    --
