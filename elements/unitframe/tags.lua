

	local _, ns = ...

	local tags      = oUF.Tags.Methods or oUF.Tags
	local tagevents = oUF.TagEvents or oUF.Tags.Events

	tags['iip:hp'] = function(unit)
		if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
		local v, m = UnitHealth(unit), UnitHealthMax(unit)
		if not UnitIsFriend('player', unit) then
			return ns.siValue(v)
		elseif v ~= 0 and v ~= m then
			return '-'..ns.siValue(m - v)
		else
			return ns.siValue(m)
		end
	end

	tags['iip:group'] = function(unit)
		if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
		local v, m = UnitHealth(unit), UnitHealthMax(unit)
		local p = floor((m - v)/m * 100)
		if v > 0 and p > 0 then
			if p > 40 then
				return '|cffff0000-'..p..'%|r'
			else
				return '|cffffffff-'..p..'%|r'
			end
		else
			return ''  --  ns.siValue(m)
		end
	end


	tags['iip:pp'] = function(unit)
		local min, max = UnitPower(unit), UnitPowerMax(unit)
		if(min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end
		return ns.siValue(min)
	end

	tags['iip:level'] = function(unit)
		local c = UnitClassification(unit)
		local l = tags['level'](unit)
		if c == 'worldboss' or l == '??' then
			return ' |TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:16:16|t'
		else
			return l < 10 and l..'  ' or l < 100 and l..' ' or l
		end
	end

	tagevents['iip:hp']    = tagevents.missinghp
	tagevents['iip:group'] = tagevents.missinghp
	tagevents['iip:pp']    = tagevents.missingpp
	tagevents['iip:level'] = tagevents.smartlevel

	--
