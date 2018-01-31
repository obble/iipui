

	local _, ns = ...

	local events = {
		'PLAYER_REGEN_DISABLED',
		'PLAYER_REGEN_ENABLED'
	}

	local bar = _G['iipbar_collapse']
	local x   = 0

	local OnUpdate = function(self, elapsed)
		x = x + elapsed
		if  x > 1 then
			x = 0
			self.t:SetText(date'%I.%M '..string.lower(date'%p'))
		end
	end

	local OnEvent = function(self, event)
		if  event == 'PLAYER_REGEN_DISABLED' then
			self:Hide()
		else
			self:Show()
		end
	end

	bar.clock = CreateFrame('Frame', 'iipclock', bar)
	bar.clock:SetSize(70, 15)
	bar.clock:SetPoint('BOTTOM', 0, ns.DELEGATE_BARS_SHOWN and 17*ns.DELEGATE_BARS_SHOWN or 34)
	bar.clock:EnableMouse(false)

	bar.clock.t = bar.clock:CreateFontString(nil, 'OVERLAY', 'iipNameFontSmall')
	bar.clock.t:SetAllPoints()
	bar.clock.t:SetJustifyH'CENTER'
	bar.clock.t:SetTextColor(1, .8, 0)

	bar.clock:SetScript('OnUpdate', OnUpdate)
	bar.clock:SetScript('OnEvent',  OnEvent)

	for _, e in pairs(events) do
		bar.clock:RegisterEvent(e)
	end

	--
