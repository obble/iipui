

	local _, ns = ...

	local tags      = oUF.Tags.Methods or oUF.Tags
	local tagevents = oUF.TagEvents or oUF.Tags.Events

	tags['iip:grouphp'] = function(unit)
		local cv = GetCVar'statusTextDisplay'
		if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
		local v, m = UnitHealth(unit), UnitHealthMax(unit)
		if  cv and (cv == 'NUMERIC' or cv == 'BOTH') then
			if  v ~= 0 and v ~= m then
				return '-'..ns.siValue(m - v)
			else
				return
			end
		elseif cv and cv == 'PERCENT' then
			local p = floor((m - v)/m * 100)
			if  v > 0 and p > 0 then
				return '-'..p..'%'
			else
				return
			end
		else
			return
		end
	end

	tags['iip:groupperhp'] = function(unit)
		local cv = GetCVar'statusTextDisplay'
		if  cv and cv == 'BOTH' then
			local v, m = UnitHealth(unit), UnitHealthMax(unit)
			local p = floor((m - v)/m * 100)
			if  v > 0 and p > 0 and v ~= m then
				return '-'..p..'%'
			else
				return
			end
		else
			return
		end
	end

	tags['iip:groupname'] = function(unit, realm)
		local n = UnitName(realm or unit)
		return unit:sub(1, 5) == 'party' and n:gsub('(%u)%S*', '%1 ') or n:sub(1, 5)
	end

	tagevents['iip:grouphp'] 	= 'CVAR_UPDATE UNIT_HEALTH UNIT_MAXHEALTH'
	tagevents['iip:groupperhp']	= 'CVAR_UPDATE UNIT_HEALTH UNIT_MAXHEALTH'
	tagevents['iip:groupname'] 	= tagevents.name

	--
