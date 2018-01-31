

	local _, ns = ...

	local tags      = oUF.Tags.Methods or oUF.Tags
	local tagevents = oUF.TagEvents or oUF.Tags.Events

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
			return ''
		end
	end

	tagevents['iip:group'] = tagevents.missinghp

	--
