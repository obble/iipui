



	local _, ns = ...

	ns.DELEGATE_FRAMES_TO_POSITION = {}

	local UpdateBarsShown = function()
		--  numberwang
		local one, two, three, four = GetActionBarToggles()
		ns.DELEGATE_BARS_SHOWN = (four and three) and 3 or three and 2 or (two and one) and 3 or two and 2 or one and 2 or 1
		ns.DELEGATE_ACTUAL_BARS_SHOWN = (four and three) and 5 or three and 4 or two and 3 or one and 2 or 1
		--
		for f, position in pairs(ns.DELEGATE_FRAMES_TO_POSITION) do
			local a, b, c, x, y = unpack(position)
			if tonumber(b) then		-- no RelTo
				c = c + (c/3)*ns.DELEGATE_BARS_SHOWN
			elseif tonumber(c) then -- no relPoint
				x = x + (x/3)*ns.DELEGATE_BARS_SHOWN
			else
				y = y + (y/3)*ns.DELEGATE_BARS_SHOWN
			end
			f:ClearAllPoints()
			f:SetPoint(a, b, c, x, y)
		end
 	end

	local DirtyUpdateBars = function()
		C_Timer.After(.5, UpdateBarsShown)
		lip:UnregisterEvent('PLAYER_REGEN_ENABLED', 	DirtyUpdateBars)
	end

	local AssignUpdate = function(self, event)
		if  InCombatLockdown() then
			lip:RegisterEvent('PLAYER_REGEN_ENABLED', 	DirtyUpdateBars)
		else
			if  event == 'PLAYER_ENTERING_WORLD' then
				UpdateBarsShown()
				lip:UnregisterEvent('PLAYER_ENTERING_WORLD', AssignUpdate)
			else
				C_Timer.After(1, function()		--  run c_timer because results from GetActionBarToggles() take a second to update
					if  InCombatLockdown() then	--  slipped into combat since last check
						lip:RegisterEvent('PLAYER_REGEN_ENABLED', DirtyUpdateBars)
					else
						UpdateBarsShown()
					end
				end)
			end
		end
	end

	hooksecurefunc('MultiActionBar_Update', 	AssignUpdate)

	lip:RegisterEvent('PLAYER_ENTERING_WORLD', 	AssignUpdate)

	--


	--
