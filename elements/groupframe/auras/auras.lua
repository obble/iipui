

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

	ns.CustomGroupAuraFilter = function(element, unit, icon, name, texture, count, dtype, duration, timeLeft, caster, isStealable, nameplateShowSelf, spellID, canApplyAura, isBossCast, casterIsPlayer, nameplateShowAll)
		if  list[spellID] and icon.isPlayer then
			return true
		else
			return false
		end
	end

	ns.DispelGroupAuraFilter = function(element, unit, icon, name, texture, count, dtype, duration, timeLeft, caster, isStealable, nameplateShowSelf, spellID, canApplyAura, isBossCast, casterIsPlayer, nameplateShowAll)
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
			local x   = 35 - (4*(i - 1))
			bu:ClearAllPoints()
			bu:SetPoint('CENTER', bu:GetParent(), 0, 1)
			bu:SetSize(x, x)
		end
	end

	ns.PostCreateGroupIcon = function(element, icon)
		icon.icon:ClearAllPoints()

		icon.cd = CreateFrame('Cooldown', '$parentCooldown', icon, 'CooldownFrameTemplate')
		icon.cd:SetSwipeTexture[[Interface\AddOns\iipui\art\group\cd\1.tga]]
		icon.cd:SetAlpha(.8)
		icon.cd:SetAllPoints(icon)
		icon.cd:SetHideCountdownNumbers(true)
		icon.cd:SetDrawEdge(false)

		icon.cd.bg = icon.cd:CreateTexture(nil, 'BACKGROUND')
		icon.cd.bg:SetPoint('TOPLEFT', -8, 8)
		icon.cd.bg:SetPoint('BOTTOMRIGHT', 8, -8)
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
		local name, texture, count, dtype, duration, timeLeft, caster, isStealable, nameplateShowSelf, id, canApplyAura, isBossCast, casterIsPlayer, nameplateShowAll = UnitAura(unit, index, icon.filter)
		local parent = icons:GetParent()
		local t = icon:GetName()
		local header

		for  _, v in next, {'dps', 'healer', 'tank'} do
			if strmatch(t, v) then header = v end
		end

		ns.SetGroupPosition(icons)

		icon:EnableMouse(false)
		icon.icon:SetAlpha(0)
		icon.count:Hide()

		if  duration > 0 then
			local i = icon:GetName():gsub('oUF_'..header..'UnitButton(%d+).AurasButton(%d+)', '%2')
			icon.cd:SetCooldown(timeLeft - duration, duration)
			icon.cd:SetSwipeTexture('Interface\\AddOns\\iipui\\art\\group\\cd\\'..i..'.tga')
			if tonumber(i) > 1 then
				icon.cd.bg:SetPoint('TOPLEFT', 4, -4)
				icon.cd.bg:SetPoint('BOTTOMRIGHT', -4, 4)
			elseif tonumber(i) > 2 then
				icon.cd.bg:SetPoint('TOPLEFT', 25, -25)
				icon.cd.bg:SetPoint('BOTTOMRIGHT', -25, 25)
			end
			icon.cd:SetSwipeColor(list[id].r or 1, list[id].g or .7, list[id].b or 0)
			icon.cd:Show()
		else
			icon.cd:Hide()
		end
	end

	ns.PostUpdateGroupAuras = function(self, unit)
		local parent = self:GetParent()
		local v, max = UnitHealth(unit), UnitHealthMax(unit)
		if  parent.Auras then
            if  parent.Auras.visibleBuffs > 0 then
                if  parent.Name then
					parent.Name:Hide()
					parent.Name.locked = true
				end
			else
				if  parent.Name and (v == max or v == 0) then
					parent.Name:Show()
					parent.Name.locked = false
				end
            end
        end
	end


	--
