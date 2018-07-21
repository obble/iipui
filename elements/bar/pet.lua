
	local _, ns = ...

	local e 	= CreateFrame'Frame'
	local hide 	= CreateFrame'Frame'
	hide:Hide()

	local flashTime 	= 0
	local rangeTimer 	= -1


	local bars = {
		['bar6'] = {
			buttons		= 'PetAction',
			num			= 10,
			padding		= 20,
			positions 	= {'BOTTOM', UIParent, 'BOTTOM', -4, 190},
			size		= 30,
		}
	}

	local events = {
		'PET_BAR_HIDEGRID',
		'PET_BAR_SHOWGRID',
		'PET_BAR_UPDATE_COOLDOWN',
		'PET_BAR_UPDATE',
		'PET_SPECIALIZATION_CHANGED',
		'PLAYER_CONTROL_GAINED',
		'PLAYER_CONTROL_LOST',
		'PLAYER_FARSIGHT_FOCUS_CHANGED',
		'UNIT_AURA',
		'UNIT_FLAGS',
		'UNIT_PET'
	}

	local add = function(bu)
		if  not ns.bar_elements[bu] then
			tinsert(ns.bar_elements, bu)
		end
	end

	local remove = function(bu)
		for i, v in pairs(ns.bar_elements) do
			if  bu:GetName() == v:GetName() then
				tremove(ns.bar_elements, i)
			end
		end
	end

	local HideGrid = function(self)
		if  self.showgrid > 0 then
			self.showgrid = self.showgrid - 1
		end

		if  self.showgrid == 0 and not GetPetActionInfo(self:GetID()) then
			self:SetAlpha(0)
		end
	end

	local ShowGrid = function(self)
		self.showgrid = self.showgrid + 1
		self:SetAlpha(1)
	end

	local UpdateGrid = function(self)
		ShowGrid(self)
		HideGrid(self)
	end

	local UpdateUsable = function(self)
		if  self.outOfRange then
			self.icon:SetDesaturated(true)
			self.icon:SetVertexColor(.85, .1, 0)
		elseif self.onCooldown then
			self.icon:SetDesaturated(true)
			self.icon:SetVertexColor(.7, .7, .7)
		else
			local isUsable = PetHasActionBar() and GetPetActionSlotUsable(self:GetID()) or false
			if isUsable then
				self.icon:SetDesaturated(false)
				self.icon:SetVertexColor(1, 1, 1)
			else
				self.icon:SetDesaturated(true)
				self.icon:SetVertexColor(.7, .7, .7)
			end
		end
	end

	local CooldownDone = function(self)
		self:SetScript('OnCooldownDone', nil)
		self:GetParent():UpdateCooldown()
	end

	local UpdateCooldown = function(self)
		local start, duration, enable, rate = GetPetActionCooldown(self:GetID())

		CooldownFrame_Set(self.cooldown, start, duration, enable, false, rate)

		local oldOnCooldown = self.onCooldown
		self.onCooldown = enable and enable ~= 0 and start > 0 and duration > 1.5
		if  self.onCooldown ~= oldOnCooldown then
			UpdateUsable(self)
			if  self.onCooldown then
				self.cooldown:SetScript('OnCooldownDone', onCooldownDone)
			end
		end
	end

	local Reset = function(self)
		self.icon:SetDesaturated(false)
		self.icon:SetVertexColor(1, 1, 1)

		self.checksRange 	= nil
		self.onCooldown 	= nil
		self.outOfRange 	= nil

		UpdateButton(self)
	end

	local UpdateButton = function(self)
		local id = self:GetID()
		local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(id)

		if  not isToken then
			self.icon:SetTexture(texture)
			self.tooltipName = name
		else
			self.icon:SetTexture(_G[texture])
			self.tooltipName = _G[name]
		end

		self.isToken = isToken

		self:SetChecked(PetHasActionBar() and isActive or false)

		if  PetHasActionBar() and isActive then
			if  IsPetAttackAction(id) then
				self:StartFlash()
				self:GetCheckedTexture():SetAlpha(.5)
			else
				self:StopFlash()
				self:GetCheckedTexture():SetAlpha(1)
			end
		else
			self:StopFlash()
			self:GetCheckedTexture():SetAlpha(1)
		end

		if  autoCastAllowed and not autoCastEnabled then
			self.auto:Hide()
			AutoCastShine_AutoCastStop(self.shine)
		elseif autoCastAllowed then
			self.auto:Show()
			AutoCastShine_AutoCastStart(self.shine)
		else
			self.auto:Hide()
			AutoCastShine_AutoCastStop(self.shine)
		end

		if  texture then
			UpdateUsable(self)
			self.icon:Show()
		else
			self.icon:Hide()
		end

		UpdateGrid(self)
		-- UpdateHotKey(self)
		UpdateCooldown(self)
	end

	local AddPositions = function(self)
		local bu
		for i, button in next, self._buttons do
			if  i == 1 then
				button:SetPoint('BOTTOMLEFT', self, 0, 0)
				bu = button
			else
				button:SetPoint('LEFT', bu, 'RIGHT', 20, 0)
				bu = button
			end
		end
	end

	local Update = function(self)
		for i, button in next, self._buttons do
			UpdateButton(button)
		end
	end

	local AddRange = function(_, elapsed)
		flashTime 	= flashTime - elapsed
		rangeTimer 	= rangeTimer - elapsed

		if  rangeTimer <= 0 or flashTime <= 0 then
			if  PetHasActionBar() then
				for _, button in next, _G['iipPetBar']._buttons do

					if  button.flashing and flashTime <= 0 then
						if  button.Flash:IsShown() then
							button.Flash:Hide()
						else
							button.Flash:Show()
						end
					end

					if  rangeTimer <= 0 then
						local _, _, _, _, _, _, _, _, checksRange, inRange = GetPetActionInfo(button:GetID())
						local oldRange 		= button.outOfRange
						button.outOfRange 	= checksRange and inRange == false or false

						local oldCheck = button.checksRange
						button.checksRange = checksRange

						if  oldCheck ~= button.checksRange or oldRange ~= button.outOfRange then
							UpdateUsable(button)
						end
					end
				end
			end

			if  flashTime <= 0 then
				flashTime = flashTime + ATTACK_BUTTON_FLASH_TIME
			end

			if  rangeTimer <= 0 then
				rangeTimer = TOOLTIP_UPDATE_TIME
			end
		end
	end

	local AddPetBar = function()
		local t 		= bars['bar6']
		local bar 		= CreateFrame('Frame', 'iipPetBar', UIParent, 'SecureHandlerStateTemplate')
		bar._id 		= 'bar6'
		bar._buttons 	= {}

		add(bar)

		bar:SetSize(((t.size + t.padding)*t.num) - t.padding, t.size)

		bar.Update 		= Update

		for i = 1, bars['bar6'].num do
			local bu 		= _G[t.buttons..'Button'..i]
			local button 	= CreateFrame('CheckButton', '$parentButton'..i, bar, 'PetActionButtonTemplate')
			local n			= button:GetName()

			--add(button)

			ns.BUElements(button)

			button:SetID(i)
			button:SetSize(t.size, t.size)
			button:SetScript('OnEvent',  nil)
			button:SetScript('OnUpdate', nil)
			button:UnregisterAllEvents()
			button.showgrid = 0
			button._parent  = bar
			button._command = 'BONUSACTIONBUTTON'..i

			button.HideGrid 		= HideGrid
			button.ShowGrid 		= ShowGrid
			button.UpdateGrid 		= UpdateGrid
			button.Reset 			= Reset
			button.StartFlash 		= PetActionButton_StartFlash
			button.StopFlash 		= PetActionButton_StopFlash
			button.Update 			= UpdateButton
			button.UpdateCooldown 	= UpdateCooldown
			button.UpdateUsable 	= UpdateUsable

			bu:SetAllPoints(button)
			bu:SetAttribute('statehidden', true)
			bu:SetParent(hide)
			bu:SetScript('OnEvent',  nil)
			bu:SetScript('OnUpdate', nil)
			bu:UnregisterAllEvents()

			local mask = button:CreateMaskTexture()
			mask:SetTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]
			mask:SetAllPoints()

			local mask2 = button:CreateMaskTexture()
			mask2:SetTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]
			mask2:SetPoint('TOPLEFT', -5, 5)
			mask2:SetPoint('BOTTOMRIGHT', 5, -5)

			_G[n..'Icon']:AddMaskTexture(mask)

			button:SetCheckedTexture[[Interface\LevelUp\BossBanner]]
			local check = button:GetCheckedTexture()
			check:SetDrawLayer'BACKGROUND'
			check:ClearAllPoints()
			check:SetPoint('TOPLEFT', button, -18, 18)
			check:SetPoint('BOTTOMRIGHT', button, 18, -18)
			check:SetTexCoord(0, .18, .805, 1)

			for _, v in pairs(
				{
					button:GetPushedTexture(),
					button:GetHighlightTexture()
				}
			) do
				v:AddMaskTexture(mask)
				v:ClearAllPoints()
				v:SetPoint('TOPLEFT', button, 2, -2)
				v:SetPoint('BOTTOMRIGHT', button, -2, 2)
			end

			button:GetNormalTexture():SetTexture''

			button.shine = _G[n..'Shine']
			button.shine:ClearAllPoints()
	        button.shine:SetPoint('TOPLEFT', button, -3, 4)
			button.shine:SetPoint('BOTTOMRIGHT', button, 3, -4)
			button.shine:SetFrameStrata'BACKGROUND'

			button.auto = _G[n..'AutoCastable']
			button.auto:SetSize(45, 50)
			button.auto:ClearAllPoints()
			button.auto:SetPoint('CENTER', 0, -1)
			button.auto:SetDrawLayer('OVERLAY', 7)

			_G[n..'Flash']:AddMaskTexture(mask)

			button.cooldown:SetSwipeTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]

			if  not button.bg then
				button.bg = button:CreateTexture(nil, 'BACKGROUND', nil, -4)
				button.bg:SetPoint('TOPLEFT', -3, 3)
				button.bg:SetPoint('BOTTOMRIGHT', 3, -3)
				button.bg:SetTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]
				button.bg:SetVertexColor(0, 0, 0)

				button.bo = button:CreateTexture(nil, 'BACKGROUND', nil, -5)
				button.bo:SetPoint('TOPLEFT', -5, 5)
				button.bo:SetPoint('BOTTOMRIGHT', 5, -5)
				button.bo:SetTexture[[Interface\Stationery\StationeryTest1]]
				button.bo:AddMaskTexture(mask2)
				button.bo:SetVertexColor(.9, .9, .9)

				button.stone = button:CreateTexture(nil, 'BACKGROUND', nil, -6)
				button.stone:SetPoint('TOPLEFT', -12, 12)
				button.stone:SetPoint('BOTTOMRIGHT', 12, -12)
				button.stone:SetTexture[[Interface\ARCHEOLOGY\ArchaeologyParts]]
				button.stone:SetTexCoord(.115, .205, .5775, .765)
			end

			bar._buttons[i] = button
		end

		bar:SetScript('OnEvent', function(self, event, arg1)
			if   event == 'PET_BAR_UPDATE' or event == 'PET_SPECIALIZATION_CHANGED'
			or	(event == 'UNIT_PET' and arg1 == 'player')
			or ((event == 'UNIT_FLAGS' or event == 'UNIT_AURA') and arg1 == 'pet')
			or	 event == 'PLAYER_CONTROL_LOST'
			or 	 event == 'PLAYER_CONTROL_GAINED'
			or 	 event == 'PLAYER_FARSIGHT_FOCUS_CHANGED' then
				Update(self)
			elseif event == 'PET_BAR_UPDATE_COOLDOWN' then
				Update(self)
			elseif event == 'PET_BAR_SHOWGRID' then
				for i, button in next, self._buttons do ShowGrid(button) end
			elseif event == 'PET_BAR_HIDEGRID' then
				for i, button in next, self._buttons do HideGrid(button) end
			end
		end)

		for  _, event in pairs(events) do
			bar:RegisterEvent(event)
		end

		local point = t.positions
		bar:SetPoint(point[1], point[2], point[3], point[4], point[5])

		e:SetScript('OnUpdate', AddRange)

		hooksecurefunc('ShowPetActionBar', function()
			for _, button in next, _G['iipPetBar']._buttons do add(button) end
			ns.AddBarMouseoverElements()
		end)

		hooksecurefunc('HidePetActionBar', function()
			for _, button in next, _G['iipPetBar']._buttons do remove(button) end
			ns.AddBarMouseoverElements()
		end)

		AddPositions(bar)
		Update(bar)
	end

	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', AddPetBar)

	--
