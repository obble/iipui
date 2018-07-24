
	local _, ns = ...

	local init = false

	local layout = {
		num			= 6,
		padding		= 4,
		positions 	= {'BOTTOM', UIParent, 'BOTTOM', 0, 16},
		visibility = '[petbattle] show; hide',
		size		= 32,
	}

	local UpdateHotKey = function(self, state)
		self.HotKey:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE')
		self.HotKey:SetTextColor(1, 1, 1)
		self.HotKey:SetParent(self)
		self.HotKey:SetFormattedText('%s', self:GetHotkey())
		self.HotKey:Show()
	end

	local AddPetBattleBar = function()
		local bar = CreateFrame('Frame', 'iipPetBattleBar', UIParent, 'SecureHandlerStateTemplate')
		bar._id = 'petbattle'
		bar._buttons = {}

		bar.Update = function(self)
			RegisterStateDriver(bar, 'visibility', layout['visibility'])
		end

		bar._buttons[1] = PetBattleFrame.BottomFrame.abilityButtons[1]

		hooksecurefunc('PetBattleFrame_UpdateActionBarLayout', function()
			bar._buttons[1] = PetBattleFrame.BottomFrame.abilityButtons[1]
			bar._buttons[2] = PetBattleFrame.BottomFrame.abilityButtons[2]
			bar._buttons[3] = PetBattleFrame.BottomFrame.abilityButtons[3]
			bar._buttons[4] = PetBattleFrame.BottomFrame.SwitchPetButton
			bar._buttons[5] = PetBattleFrame.BottomFrame.CatchButton
			bar._buttons[6] = PetBattleFrame.BottomFrame.ForfeitButton

			for i, button in next, bar._buttons do
				button._parent = bar
				button._command = 'ACTIONBUTTON'..i

				-- print(button, GetBindingKey(button._command))

				button:SetParent(bar)

				button.UpdateHotKey = UpdateHotKey
			end
		end)

		local point = layout.positions
		bar:SetPoint(point[1], point[2], point[3], point[4], point[5])

		bar:Update()

		FlowContainer_PauseUpdates(PetBattleFrame.BottomFrame.FlowFrame)
	end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', AddPetBattleBar)

	--
