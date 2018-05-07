

	local _, ns = ...

	local events = {
		'PLAYER_REGEN_DISABLED',
		'PLAYER_REGEN_ENABLED'
	}

	local bar = _G['iipbar'].collapse
	local x   = 0

	local OnUpdate = function(self, elapsed)
		x = x + elapsed
		if  x > 1 then
			x = 0
			self.t:SetText(date'%I.%M '..string.lower(date'%p'))
		end
	end

	bar.clock = CreateFrame('Frame', 'iipclock', bar)
	bar.clock:SetSize(70, 15)
	bar.clock:SetPoint('BOTTOM', _G['iipbar'].t, 0, -6)
	bar.clock:EnableMouse(false)

	bar.clock.t = bar.clock:CreateFontString(nil, 'OVERLAY', 'iipNameFontSmall')
	bar.clock.t:SetAllPoints()
	bar.clock.t:SetJustifyH'CENTER'
	bar.clock.t:SetTextColor(1, .8, 0)

	bar.clock:SetScript('OnUpdate', OnUpdate)

	for _, e in pairs(events) do
		bar.clock:RegisterEvent(e)
	end

	--
