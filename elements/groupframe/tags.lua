

	local _, ns = ...

	local tags      = oUF.Tags.Methods or oUF.Tags
	local tagevents = oUF.TagEvents or oUF.Tags.Events

	tags['iip:grouphp'] = function(unit)
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
			return ''
		end
	end

	tags['iip:groupname'] = function(unit, realm)
		local n = UnitName(realm or unit)
		return unit:sub(1, 5) == 'party' and n:gsub('(%u)%S*', '%1 ') or n:sub(1, 6)
	end

	tagevents['iip:grouphp'] 	= tagevents.missinghp
	tagevents['iip:groupname'] 	= tagevents.name

	--
