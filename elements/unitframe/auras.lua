

	local _, ns = ...

	local list = ns.SwipeAuraList

	local playerUnits = {
		player  = true,
		pet     = true,
		vehicle = true
	}

	local dispelTypes = {
		Magic   = true,
		Curse   = true,
		Disease = true,
		Poison  = true,
		none    = true,
	}

	local Bloodlust = {
		[57723]  = true, --  exhausted
		[57724]  = true, --  sated
		[80354]  = true, --  temporal displacement
		[95809]  = true, --  insanity
		[160455] = true, --  fatigued
	}

	ns.auraElement             = {target = 'Debuffs'}

	ns.CustomAuraFilter = function(element, unit, icon, name, texture, count, dtype, duration, timeLeft, caster, isStealable, nameplateShowSelf, spellID, canApplyAura, isBossCast, casterIsPlayer, nameplateShowAll)
		local filter  = icon.filter
		local hostile = UnitCanAttack('player', unit) or not UnitCanAssist('player', unit)

		if isBossCast then					--  all boss auras go through
			return true
											--  as do all vehicle-cast auras
		elseif caster and UnitIsUnit(caster, 'vehicle') and not UnitIsPlayer'vehicle' then
			return true
		end

		if  hostile then
			if filter == 'HELPFUL' then		--  buff
				if  isStealable or icon.isPlayer or (caster and UnitIsUnit(caster, 'pet')) or nameplateShowAll then
					return true
				end
			elseif filter == 'HARMFUL' then	--  debuff
				if playerUnits[icon.owner] or nameplateShowAll then
					return true
				end
			end
		else								--  friend
			if filter == 'HELPFUL' then		--  buff
				if  icon.isPlayer or (caster and UnitIsUnit(caster, 'pet')) then
					return true
				end
			elseif filter == 'HARMFUL' then	--  debuff
				if (dispelTypes[dtype] and UnitIsFriend('player', unit)) or icon.isPlayer or (caster and UnitIsUnit(caster, 'pet')) then
					return true
				end
			end
		end
		return false
	end

	ns.CustomPartyAuraFilter = function(element, unit, icon, name, texture, count, dtype, duration, timeLeft, caster, isStealable, nameplateShowSelf, spellID, canApplyAura, isBossCast, casterIsPlayer, nameplateShowAll)
		if  list[spellID] and playerUnits[icon.owner] then
			return true
		else
			return false
		end
	end

	local dispels = {}
	ns.DispelPartyAuraFilter = function(element, unit, icon, name, texture, count, dtype, duration, timeLeft, caster, isStealable, nameplateShowSelf, spellID, canApplyAura, isBossCast, casterIsPlayer, nameplateShowAll)
		local filter = icon.filter
		wipe(dispels) 													--  wipe table
		for i = 1, #element do
			local aura = element[i]										-- roll through our built icons
			local name = UnitAura(unit, aura:GetID(), aura.filter)		-- check they exist
			if name then
				if aura.dtype then dispels[aura.dtype] = true end		-- and insert what we've already got into our table
			else
				if aura.dtype then aura.dtype = nil end
			end
		end
		if dispels[dtype] and icon.dtype and UnitAura(unit, name, nil, filter..'|RAID') then
			return true
		elseif dispelTypes[dtype] and not dispels[dtype] and UnitAura(unit, name, nil, filter..'|RAID') then
			dispels[dtype]  = true
			return true
		elseif Bloodlust[spellID] and dispelTypes['none'] then
			dispels['none'] = true
			return true
		else
			return false
		end
	end

	ns.PostCreateIcon = function(element, icon)
		icon.icon:SetTexCoord(.1, .9, .1, .9)

		icon.cd = CreateFrame('Cooldown', '$parentCooldown', icon, 'CooldownFrameTemplate')
		icon.cd:SetSwipeTexture[[Interface\AddOns\iidui\art\group\cd]]
		icon.cd:SetAlpha(.8)
		icon.cd:SetAllPoints(icon)
		icon.cd:SetHideCountdownNumbers(true)
		icon.cd:SetDrawEdge(false)

		icon.cd.bg = icon.cd:CreateTexture(nil, 'BACKGROUND')
		icon.cd.bg:SetPoint('TOPLEFT', -2, 2)
		icon.cd.bg:SetPoint('BOTTOMRIGHT', 2, -2)
		icon.cd.bg:SetAtlas'orderhalltalents-timer-bg'

		icon.cd.bd = icon:CreateTexture(nil, 'BACKGROUND')
		icon.cd.bd:SetAlpha(.9)
		icon.cd.bd:SetAllPoints()
		icon.cd.bd:SetVertexColor(0, 0, 0)

		icon.duration = icon:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
		icon.duration:SetFont(STANDARD_TEXT_FONT, 8)
		icon.duration:SetPoint('BOTTOM', icon, 'TOP', 0, 9)
		icon.duration:SetJustifyH'CENTER'

		icon.count:ClearAllPoints()
		icon.count:SetPoint('CENTER', icon.cd, 'BOTTOM', 0, 1)
		icon.count:SetFont('Fonts\\ARIALN.ttf', 12, 'OUTLINE')
		icon.count:SetTextColor(1, 1, 1)
		icon.count:SetShadowOffset(0, 0)

		icon.sb = CreateFrame('StatusBar', nil, icon)
		ns.BD(icon.sb, 1, -2)
        ns.SB(icon.sb)
        icon.sb:SetHeight(2)
        icon.sb:SetPoint('LEFT', 1, 0)
        icon.sb:SetPoint('RIGHT', -1, 0)
        icon.sb:SetPoint'BOTTOM'
        icon.sb:SetMinMaxValues(0, 1)
        icon.sb:Hide()

        icon.sb.bg = icon.sb:CreateTexture(nil, 'BORDER')
        ns.SB(icon.sb.bg)
        icon.sb.bg:SetAllPoints()
        icon.sb.bg:SetVertexColor(.2, .2, .2)
	end

	ns.PostCreateDispelIcon = function(element, icon)
		icon.icon:SetSize(20, 20)
		icon.count:ClearAllPoints()
	end

	local auratime_OnUpdate = function(icon, elapsed, name)
		local t = icon.timeLeft - elapsed
		if  icon.duration then
			local p = icon.timeDur/t
			icon.duration:SetFormattedText(SecondsToTimeAbbrev(t))
            icon.sb:SetMinMaxValues(0, icon.timeDur)
            icon.sb:SetValue(icon.timeLeft)
            icon.sb:SetStatusBarColor(icon.filter == 'HARMFUL' and 1*p or 0, icon.filter == 'HARMFUL' and 0 or 1*p, 0)
		end
		icon.timeLeft = t
	end

	ns.PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
		local name, _, count, dtype, duration, expiration, _, _, _, id = UnitAura(unit, index, icon.filter)

		if name and duration and not icon.startTime then	-- will this work for refresh/early removal??
			icon.startTime = GetTime()
		elseif GetTime() >= icon.startTime + duration then
			icon.startTime = nil
		end

		if  unit:sub(1, 6) == 'target' then
			ns.BD(icon)
			ns.BUBorder(icon)

			if  count and count > 0 then
				local number = icon.count:GetText()
				if number then icon.count:SetText(number) end
			end

			if  duration > 0 then
				icon.sb:SetMinMaxValues(0, duration)
				icon.sb:Show()
				icon.timeDur  = duration and duration or 0
				icon.timeLeft = experiration and (expiration - GetTime()) or 0
				icon:SetScript('OnUpdate', function(self, elapsed)
					auratime_OnUpdate(self, elapsed, name)
				end)
			else
				icon.sb:Hide()
				icon.duration:SetText''
				icon:SetScript('OnUpdate', nil)
			end
		end

		if icon.filter == 'HARMFUL' then
			local colour = DebuffTypeColor[dtype or 'none']
			if  icon.bo then
				for i = 1, 4 do
					icon.bo[i]:SetVertexColor(colour.r, colour.g, colour.b, .8)
				end
			end
			if  icon.duration then
				icon.duration:SetTextColor(colour.r*1.4, colour.g*1.4, colour.b*1.4)
			end
		else
			if  icon.bo then
				for i = 1, 4 do
					icon.bo[i]:SetVertexColor(1, 1, 1)
				end
			end
			if  icon.duration then
				icon.duration:SetTextColor(1, .7, 0)
			end
		end
	end

	ns.PostUpdateDispelIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
		local element = icons:GetParent()
		local name, _, _, _, dtype = UnitAura(unit, index, icon.filter)
		icon.dtype = dtype or 'none'
		icon.icon:SetTexture(icon.dtype == 'none' and 'Interface\\MINIMAP\\POIICONS' or 'Interface\\RaidFrame\\Raid-Icon-Debuff'..dtype)
		if  icon.dtype == 'none' then
			icon.icon:SetTexCoord(.92, .995, .455, .49)
		else
			icon.icon:SetTexCoord(0, 1, 0, 1)
		end
	end


	--
