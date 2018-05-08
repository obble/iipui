

	local _, ns = ...

	local dispels 	= {}
	local list 		= ns.SwipeAuraList

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

	ns.auraGroupElement        = {party  = 'Buffs', raid = 'Buffs'}
	ns.auraGroupDecurseElement = {party  = 'Debuffs', raid = 'Debuffs'}

	ns.CustomGroupAuraFilter = function(element, unit, icon, name, rank, texture, count, dType, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossCast,_, nameplateShowAll)
		if  list[spellID] and playerUnits[icon.owner] then
			return true
		else
			return false
		end
	end

	ns.DispelGroupAuraFilter = function(element, unit, icon, name, rank, texture, count, dType, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossCast,_, nameplateShowAll)
		local filter = icon.filter
		wipe(dispels) 													--  wipe table
		for i = 1, #element do
			local aura = element[i]										-- roll through our built icons
			local name = UnitAura(unit, aura:GetID(), aura.filter)		-- check they exist
			if name then
				if aura.dType then dispels[aura.dType] = true end		-- and insert what we've already got into our table
			else
				if aura.dType then aura.dType = nil end
			end
		end
		if dispels[dType] and icon.dType and UnitAura(unit, name, nil, filter..'|RAID') then
			return true
		elseif dispelTypes[dType] and not dispels[dType] and UnitAura(unit, name, nil, filter..'|RAID') then
			dispels[dType]  = true
			return true
		elseif Bloodlust[spellID] and dispelTypes['none'] then
			dispels['none'] = true
			return true
		else
			return false
		end
	end

	ns.SetGroupPosition = function(icons)
		for i = 1, 3 do
			local  bu = icons[i]
			if not bu then break end
			local x   = 31 - (4*(i - 1))
			bu:ClearAllPoints()
			bu:SetPoint('CENTER', bu:GetParent(), 0, 1)
			bu:SetSize(x, x)
		end
	end

	ns.PostCreateGroupIcon = function(element, icon)
		icon.icon:ClearAllPoints()

		icon.cd = CreateFrame('Cooldown', '$parentCooldown', icon, 'CooldownFrameTemplate')
		icon.cd:SetSwipeTexture[[Interface\AddOns\iipui\art\group\cd]]
		icon.cd:SetAlpha(.8)
		icon.cd:SetAllPoints(icon)
		icon.cd:SetHideCountdownNumbers(true)
		icon.cd:SetDrawEdge(false)

		icon.cd.bg = icon.cd:CreateTexture(nil, 'BACKGROUND')
		icon.cd.bg:SetPoint('TOPLEFT', -2, 2)
		icon.cd.bg:SetPoint('BOTTOMRIGHT', 2, -2)
		icon.cd.bg:SetAtlas'orderhalltalents-timer-bg'

		icon.count:ClearAllPoints()
		icon.count:SetPoint('CENTER', icon.cd, 'BOTTOM', 0, 1)
		icon.count:SetFont('Fonts\\skurri.ttf', 14, 'OUTLINE')
		icon.count:SetTextColor(1, 1, 1)
		icon.count:SetShadowOffset(0, 0)
	end

	ns.PostCreateDispelIcon = function(element, icon)
		icon.icon:SetSize(20, 20)
		icon.count:ClearAllPoints()
	end

	ns.PostUpdateGroupIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
		local name, _, _, count, dtype, duration, expiration, _, _, _, id = UnitAura(unit, index, icon.filter)
		local i = icon:GetName():gsub('oUF_partyUnitButton(%d+).BuffsButton(%d+)', '%2')

		ns.SetGroupPosition(icons)
		icon.icon:SetAlpha(0)
		icon.count:Hide()
		icon.stone:Hide()
		icon:EnableMouse(false)
		if duration > 0 then
			icon.cd:SetCooldown(expiration - duration, duration)
			icon.cd:SetSwipeTexture('Interface\\AddOns\\iipui\\art\\group\\cd\\'..i)
			icon.cd.bd:SetTexture('Interface\\AddOns\\iipui\\art\\group\\cd\\'..i)
			icon.cd:SetSwipeColor(list[id].r or 1, list[id].g or .7, list[id].b or 0)
			icon.cd:Show()
		else
			icon.cd:Hide()
		end
	end


	--
