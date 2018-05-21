

	local _, ns = ...

	local tags      = oUF.Tags.Methods or oUF.Tags
	local tagevents = oUF.TagEvents or oUF.Tags.Events

	tags['iip:hp'] = function(unit)
		local cv 	= GetCVar'statusTextDisplay'
		local v, m 	= UnitHealth(unit), UnitHealthMax(unit)
		if  (not UnitIsConnected(unit)) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
		if  cv and  cv == 'BOTH' and m == 100 then return end
		if  cv and (cv == 'NUMERIC' or cv == 'BOTH') then
			if  not UnitIsFriend('player', unit) then
				return ns.siValue(v)
			elseif v ~= 0 and v ~= m then
				return '-'..ns.siValue(m - v)
			else
				return ns.siValue(m)
			end
		elseif cv and cv == 'PERCENT' then
			if  m > 0 then
				return math.floor(v/m*100 + .5)
			else
				return
			end
		else
			return
		end
	end

	tags['iip:pp'] = function(unit)
		local cv = GetCVar'statusTextDisplay'
		local v, m = UnitPower(unit), UnitPowerMax(unit)
		if  v == 0 or m == 0 or (not UnitIsConnected(unit)) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
		if  cv and  cv == 'BOTH' and m == 100 then return end
		if  cv and (cv == 'NUMERIC' or cv == 'BOTH') then
			return ns.siValue(v)
		elseif cv and cv == 'PERCENT' then
			if  m == 0 then
				return 0
			else
				return math.floor(v/m*100 + .5)
			end
		else
			return
		end
	end

	tags['iip:_a_pp'] = function(unit)
		local cv 	= GetCVar'statusTextDisplay'
		local index = ADDITIONAL_POWER_BAR_INDEX or 0
		local v, m 	= UnitPower(unit, index), UnitPowerMax(unit, index)
		if (v == 0 or m == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end
		if  cv and  cv == 'BOTH' and m == 100 then return end
		if  cv and (cv == 'NUMERIC' or cv == 'BOTH') then
			return ns.siValue(v)
		elseif cv and cv == 'PERCENT' then
			if  m == 0 then
				return 0
			else
				return math.floor(v/m*100 + .5)
			end
		else
			return
		end
	end

	tags['iip:stagger'] = function(unit)
		local cv 		= GetCVar'statusTextDisplay'
		local v, m 		= UnitStagger(unit) or 0, UnitHealthMax(unit)
		local _, class 	= UnitClass(unit)
		if  class ~= 'MONK' then return end
		if  v == 0 or m == 0 or (not UnitIsConnected(unit)) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
		if  cv and (cv == 'NUMERIC' or cv == 'BOTH') then
			return ns.siValue(v)
		elseif cv and cv == 'PERCENT' then
			if  m == 0 then
				return 0
			else
				return math.floor(v/m*100 + .5)
			end
		else
			return
		end
	end

	tags['iip:perhp'] = function(unit)
		local cv = GetCVar'statusTextDisplay'
		if  cv and cv == 'BOTH' then
			local m = UnitHealthMax(unit)
			if  m == 0 then
				return 0
			else
				return math.floor(UnitHealth(unit)/m*100 + .5)
			end
		else
			return
		end
	end

	tags['iip:perpp'] = function(unit)
		local cv = GetCVar'statusTextDisplay'
		if  cv and cv == 'BOTH' then
			local m = UnitPowerMax(unit)
			if  m == 0 then
				return
			else
				return math.floor(UnitPower(unit)/m*100 + .5)
			end
		else
			return
		end
	end

	tags['iip:per_a_pp'] = function(unit)
		local cv 	= GetCVar'statusTextDisplay'
		local index = ADDITIONAL_POWER_BAR_INDEX or 0
		if  cv and cv == 'BOTH' then
			local m = UnitPowerMax(unit, index)
			if  m == 0 then
				return 0
			else
				return math.floor(UnitPower(unit, index)/m*100 + .5)
			end
		else
			return
		end
	end

	tags['iip:perstagger'] = function(unit)
		local cv 		= GetCVar'statusTextDisplay'
		local _, class 	= UnitClass(unit)
		if  class ~= 'MONK' then return end
		if  cv and cv == 'BOTH' then
			local m = UnitHealthMax(unit)
			if  m == 0 then
				return 0
			else
				return math.floor((UnitStagger(unit) or 0)/m*100 + .5)
			end
		else
			return
		end
	end

	tags['iip:level'] = function(unit)
		local c = UnitClassification(unit)
		local l = tags['level'](unit)
		if c == 'worldboss' or l == '??' then
			return ' |TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:16:16|t'
		else
			return l
		end
	end

	tags['iip:name'] = function(unit)
		local AFK = UnitIsAFK(unit) and ' |cff00ff00'..CHAT_FLAG_AFK..'|r' or ''
		local DND = UnitIsDND(unit) and ' |cff00ff00'..CHAT_FLAG_DND..'|r' or ''
		return AFK..DND..UnitName(unit)
	end

	tagevents['iip:hp']    		= 'CVAR_UPDATE UNIT_HEALTH UNIT_MAXHEALTH'
	tagevents['iip:pp']    		= 'CVAR_UPDATE UNIT_MAXPOWER UNIT_POWER'
	tagevents['iip:_a_pp']		= 'CVAR_UPDATE UNIT_MAXPOWER UNIT_POWER'
	tagevents['iip:stagger']	= 'CVAR_UPDATE UNIT_AURA'
	tagevents['iip:perhp'] 		= 'CVAR_UPDATE UNIT_HEALTH UNIT_MAXHEALTH'
	tagevents['iip:perpp'] 		= 'CVAR_UPDATE UNIT_MAXPOWER UNIT_POWER'
	tagevents['iip:per_a_pp']	= 'CVAR_UPDATE UNIT_MAXPOWER UNIT_POWER'
	tagevents['iip:perstagger']	= 'CVAR_UPDATE UNIT_AURA'

	tagevents['iip:level'] 		= tagevents.smartlevel
	tagevents['iip:name']  		= tagevents.name

	--
