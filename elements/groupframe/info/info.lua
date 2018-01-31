

	-- based on evl_raidstatus

	local _, ns = ...

	local roles = {}

	local f = CreateFrame('Button', 'iipRaidStats', CompactRaidFrameManager)
	f:SetHeight(50)

	local header = f:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	header:SetFont([[Fonts\skurri.ttf]], 13)
	header:SetTextColor(1, 1, 1)
	header:SetPoint('TOPLEFT', f, -3, 0)

	local t = f:CreateFontString('iipRaidStats_Alive', 'ARTWORK', 'GameFontHighlight')
	t:SetPoint('TOPLEFT', header, 'BOTTOMLEFT', 0, -6)

	local t2 = f:CreateFontString('iipRaidStats_Roles', 'ARTWORK', 'GameFontHighlight')
	t2:SetPoint('TOPLEFT', t, 'BOTTOMLEFT', 0, -3)

	local name = f:CreateFontString('iipRaidStats_GRIDName', 'ARTWORK', 'GameFontHighlight')
	name:SetFont([[Fonts\skurri.ttf]], 13)
	name:SetTextColor(1, 1, 1)
	name:SetPoint('TOPLEFT', t2, 'BOTTOMLEFT', 20, -8)

	local sort = function(a, b)
		local method
		if a.colour and b.colour then
			method = ((a.colour.r + a.colour.g + a.colour.b)..a.name) < ((b.colour.r + b.colour.g + b.colour.b)..b.name)
		else
			method = a.name < b.name
		end
		return method
	end

	local MatchGroup = function()
		for name, callback in pairs(roles) do
			local matches = {}
			for i = 1, GetNumGroupMembers() do
				local unit = UnitInRaid'player' and 'raid'..i or 'party'..i
				if UnitExists(unit) and callback(unit) then
					local _, id = UnitClass(unit)
					table.insert(matches, {index = i, unit = unit, name = UnitName(unit), colour = RAID_CLASS_COLORS[id], alive = UnitIsDeadOrGhost(unit) and '(Dead)' or ''})
				end
			end
			if  next(matches) then
				if GameTooltip:NumLines() > 0 then GameTooltip:AddLine' ' end
				GameTooltip:AddLine(name..':', 1, 1, 1)
				table.sort(matches, sort)
				for _, v in pairs(matches) do
					GameTooltip:AddDoubleLine(v.name, v.alive, v.colour.r, v.colour.g, v.colour.b, v.colour.r, v.colour.g, v.colour.b)
				end
			end
		end
	end

	local DeadOrGhostGroup = function()
		local _, type = IsInInstance'player'
		local flagged = {}
		for i = 1, GetNumGroupMembers() do
			local unit    = UnitInRaid'player' and 'raid'..i or 'party'..i
			if  UnitIsDeadOrGhost(unit) or ((type == 'party' or type == 'raid') and not UnitAffectingCombat(unit)) then
				local _, id = UnitClass(unit)
				tinsert(flagged, {name = UnitName(unit), colour = RAID_CLASS_COLORS[id], flag = UnitIsDead(unit) and 'Dead' or ((type == 'party' or type == 'raid') and not UnitAffectingCombat(unit)) and 'Away' or 'Ghost'})
			end
		end
		if  #flagged > 0 then
			GameTooltip:AddLine' '
			GameTooltip:AddLine('Out of Action:', 1, 1, 1)
			for _, v in pairs(flagged) do
				if v.colour then
					GameTooltip:AddDoubleLine(v.name, v.flag, v.colour.r, v.colour.g, v.colour.b, v.colour.r, v.colour.g, v.colour.b)
				end
			end
		end
	end

	local OverflowGroup = function()
		--  raid frames only show units 1-25
		--  so put the rest in the tooltip for now
		local num = GetNumGroupMembers()
		if num > 25 then
			GameTooltip:AddLine' '
			GameTooltip:AddLine('25+ Raid Members:', 1, 1, 1)
			for i = 25, num do
				local unit    = 'raid'..i
				local _, id   = UnitClass(unit)
				local colour  = RAID_CLASS_COLORS[id]
				local n, v, m = UnitName(unit), UnitHealth(unit), UnitHealthMax(unit)
				local p = floor(v/m*100)
				GameTooltip:AddDoubleLine(n, p..'%', colour.r, colour.g, colour.b, 0, 1, 0)
			end
		end
	end

	local Update = function()
		local alive, max = 0, 0
		local last   = 0
		local result = nil
		local num = GetNumGroupMembers()
		if num > 0 then
				--  total raid alive
				--  account for player
				--  then raid
			for i = 1, num do
				local unit = UnitInRaid'player' and 'raid'..i or 'party'..i
				if UnitExists(unit) then
					max = max + 1
					if not UnitIsDeadOrGhost(unit) then alive = alive + 1 end
				end
			end
				-- role callback handler
			for name, callback in pairs(roles) do
				local count = 0
				cAlive = 0
				for i = 1, num do
					local unit = UnitInRaid'player' and 'raid'..i or 'party'..i
					if UnitExists(unit) and callback(unit) then
						count = count + 1
						if not UnitIsDeadOrGhost(unit) then
							cAlive = cAlive + 1
						end
					end
				end
				if count > 0 then
					result = (result and result..'   ' or '')..name ..': '..cAlive..'/'..count
				end
			end
		end
		if max > 0 then
			header:Show()
			header:SetText(UnitInRaid'player' and 'RAID' or 'PARTY')
			t:SetFormattedText(alive..'/'..max..' alive')
			t:Show()
			f:SetWidth(t:GetWidth())
		else
			header:Hide()
			t:Hide()
		end
		if result then
			t2:SetText(result)
			t2:Show()
			f:SetWidth(t:GetWidth())
		else
			t2:Hide()
		end
	end

	local Enter = function()
		GameTooltip:SetOwner(f, 'ANCHOR_TOPLEFT', 0, 20)
		MatchGroup() DeadOrGhostGroup() OverflowGroup()
		GameTooltip:Show()
	end

	function ns:AddRole(name, callback)
		roles[name] = callback
	end

		-- tank
	ns:AddRole('Tanks: ', function(unit)
		return UnitGroupRolesAssigned(unit) == 'TANK'
	end)

		-- healer
	ns:AddRole('Healers: ', function(unit)
		return UnitGroupRolesAssigned(unit) == 'HEALER'
	end)

	C_Timer.NewTicker(1, Update)
	f:SetScript('OnEnter', Enter)
	f:SetScript('OnLeave', function() GameTooltip:Hide() end)


	--
