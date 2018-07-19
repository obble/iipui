

	local _, ns = ...

	local keys = {
		KEY_NUMPADDECIMAL	= 'Nu.',
		KEY_NUMPADDIVIDE	= 'Nu/',
		KEY_NUMPADMINUS		= 'Nu-',
		KEY_NUMPADMULTIPLY 	= 'Nu*',
		KEY_NUMPADPLUS 		= 'Nu+',
		KEY_MOUSEWHEELUP	= 'MU',
		KEY_MOUSEWHEELDOWN 	= 'MD',
		KEY_NUMLOCK 		= 'NuL',
		KEY_PAGEUP			= 'PU',
		KEY_PAGEDOWN 		= 'PD',
		KEY_SPACE			= '_',
		KEY_INSERT			= 'Ins',
		KEY_HOME			= 'Hm',
		KEY_DELETE			= 'Del',
	}

	local UpdateHotkeys = function(self)
		local n = 'iipActionBar'
		--[[for  i = 1, 5 do
			for j = 1, 12 do
				if  _G[n..i..'Button'..j] then
					local hotkey 	= _G[n..i..'Button'..j].hotkey
					local t 		= hotkey:GetText()

				    t = gsub(t, '(s%-)', 	'S·')
				    t = gsub(t, '(a%-)', 	'A·')
				    t = gsub(t, '(c%-)', 	'C·')
				    t = gsub(t, '(st%-)', 	'C·')

				    for i = 1, 30 do
				        t = gsub(t, _G['KEY_BUTTON'..i], 'M'..i)
				    end

				    for i = 1, 9 do
						t = gsub(t, _G['KEY_NUMPAD'..i], 'Nu'..i)
					end

					for i, v in pairs(keys) do
						t = gsub(t, i, v)
					end

					hotkey:SetText(t)
				end
			end
		end]]
	end


	hooksecurefunc('ActionButton_Update', UpdateHotkeys)


	--
