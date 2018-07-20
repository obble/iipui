

	local _, ns = ...

	local events = {
		'PLAYER_REGEN_DISABLED',
		'PLAYER_REGEN_ENABLED'
	}

	local bar = _G['iipbar'].collapse
	local var = IIP_VAR['clock']
	local x   = 0
	local firstUpdate = true

	local OnClick = function(self)
		if  var.military then
			var.military = false
			self.t:SetText(date'%I.%M '..string.lower(date'%p'))
		else
			var.military = true
			self.t:SetText(date'%H:%M')
		end
	end

	local OnUpdate = function(self, elapsed)
		if firstUpdate then
			firstUpdate = false
			iipclock:UpdateSize()
		end
		x = x + elapsed
		if  x > 1 then
			x = 0
			self.t:SetText(var.military and date'%H.%M' or date'%I.%M '..string.lower(date'%p'))
		end
	end

	bar.clock = CreateFrame('Button', 'iipclock', bar)
	bar.clock:SetSize(70, 15)
	bar.clock:SetPoint('BOTTOM', _G['iipbar'].t, 0, -6)
	bar.clock:EnableMouse(true)
	bar.clock:SetFrameStrata'HIGH'
	tinsert(ns.bar_elements, bar.clock)

	bar.clock.t = bar.clock:CreateFontString(nil, 'OVERLAY', 'iipNameFontSmall')
	bar.clock.t:SetAllPoints()
	bar.clock.t:SetJustifyH'CENTER'
	bar.clock.t:SetTextColor(1, .8, 0)

	bar.clock:SetScript('OnClick',  OnClick)
	bar.clock:SetScript('OnUpdate', OnUpdate)
	bar.clock:SetScript('OnEnter', function(self) self.t:SetTextColor(1, .5, 0) end)
	bar.clock:SetScript('OnLeave', function(self) self.t:SetTextColor(1, .8, 0) end)

	bar.clock.UpdateSize = function ()
		local var = IIP_VAR['clock']
		local font, fontSize = bar.clock.t:GetFont()
		bar.clock.t:SetFont(font, var.fontsize == 'small' and 10 or var.fontsize == "medium" and 13 or var.fontsize == "large" and 15)
	end

	for _, e in pairs(events) do
		bar.clock:RegisterEvent(e)
	end

	--
