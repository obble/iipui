
	local _, ns = ...

	local e 	= CreateFrame'Frame'
	local hide 	= CreateFrame'Frame'
	hide:Hide()

	local bars = {
		['bar7'] = {
			buttons		= 'Stance',
			num			= 10,
			padding		= 40,
			positions 	= {'BOTTOM', UIParent, 'BOTTOM', 0, 205},
			visibility = '[vehicleui][petbattle][overridebar][possessbar] hide; show',
			size		= 42,
		}
	}

	local events = {
		'ACTIONBAR_PAGE_CHANGED',
		'PLAYER_ENTERING_WORLD',
		'PLAYER_REGEN_ENABLED',
		'UPDATE_BONUS_ACTIONBAR',
		'UPDATE_OVERRIDE_ACTIONBAR',
		'UPDATE_POSSESS_BAR',
		'UPDATE_SHAPESHIFT_COOLDOWN',
		'UPDATE_SHAPESHIFT_FORM',
		'UPDATE_SHAPESHIFT_FORMS',
		'UPDATE_SHAPESHIFT_USABLE',
		'UPDATE_VEHICLE_ACTIONBAR',
	}

	local add = function(bu)
		if  not ns.bar_elements[bu] then
			tinsert(ns.bar_elements, bu)
		end
	end

	local UpdateCooldown = function(self)
		self.cooldown:SetDrawBling(self.cooldown:GetEffectiveAlpha() > .5) --?
		CooldownFrame_Set(self.cooldown, GetShapeshiftFormCooldown(self:GetID()))
	end

	local UpdateButton = function(self)
		if  self:IsShown() then
			local texture, isActive, isCastable = GetShapeshiftFormInfo(self:GetID())

			self:SetChecked(isActive)

			self.icon:SetTexture(texture)

			if  texture then
				self.cooldown:Show()
			else
				self.cooldown:Hide()
			end

			UpdateCooldown(self)

			if  isCastable then
				self.icon:SetDesaturated(false)
			else
				self.icon:SetDesaturated(true)
			end
		end
	end

	local AddPositions = function(self)
		local t		= bars['bar7']
		local num 	= GetNumShapeshiftForms()

		self:SetSize(((t.size + t.padding)*num) - (t.padding*2) + 12, t.size)

		for i, button in next, self._buttons do
			if  i <= num then
				button:Show()
				button:ClearAllPoints()
				button:SetPoint('CENTER', self, (-((num*70)/2 + 36)) + (70*i), 0)
				UpdateButton(button)
			else
				button:Hide()
			end
		end
	end

	local Update = function(self)
		for i, button in next, self._buttons do
			UpdateButton(button)
		end
	end

	local AddStanceBar = function()
		local t 		= bars['bar7']
		local bar = CreateFrame('Frame', 'iipStanceBar', UIParent, 'SecureHandlerStateTemplate')
		bar._id 		= 'bar7'
		bar._buttons 	= {}

		add(bar)

		bar.Update 		= Update
		bar.UpdateForms = Update

		RegisterStateDriver(bar, 'visibility', bars['bar7'].visibility)

		for i = 1, bars['bar7'].num do
			local bu 		= _G[t.buttons..'Button'..i]
			local button 	= CreateFrame('CheckButton', '$parentButton'..i, bar, 'StanceButtonTemplate')
			local n			= button:GetName()

			ns.BUElements(button)

			add(button)

			button:SetID(i)
			button:SetSize(42, 42)
			button:SetScript('OnEvent',  nil)
			button:SetScript('OnUpdate', nil)
			button:UnregisterAllEvents()
			button._parent  = bar
			button._command = 'SHAPESHIFTBUTTON'..i

			button.Update 			= UpdateButton
			button.UpdateCooldown 	= UpdateCooldown
			-- button.UpdateHotKey 	= UpdateHotKey
			-- button.UpdateHotKeyFont = UpdateHotKeyFont

			button:SetFrameLevel(bu:GetParent():GetFrameLevel() + 1)

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

			button:SetCheckedTexture[[Interface\LevelUp\BossBanner]]
			local check = button:GetCheckedTexture()
			check:SetDrawLayer'BACKGROUND'
			check:ClearAllPoints()
			check:SetPoint('TOPLEFT', button, -18, 18)
			check:SetPoint('BOTTOMRIGHT', button, 18, -18)
			check:SetTexCoord(0, .18, .805, 1)

			button:GetPushedTexture():AddMaskTexture(mask)
			button:GetHighlightTexture():AddMaskTexture(mask)
			button:GetNormalTexture():SetTexture''

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

			for _, v in pairs(
				{
					_G[n..'Icon'],
					_G[n..'Flash']
				}
			) do
				v:AddMaskTexture(mask)
			end

			bar._buttons[i] = button
		end

		bar:SetScript('OnEvent', function(self, event)
			if  event == 'UPDATE_SHAPESHIFT_COOLDOWN' then
				Update(self)
			elseif  event == 'PLAYER_REGEN_ENABLED' then
				if  self.needsUpdate and not InCombatLockdown() then
					self.needsUpdate = nil
					Update(self)
				end
			else
				if  InCombatLockdown() then
					self.needsUpdate = true
				else
					Update(self)
				end
			end
		end)

		for  _, event in pairs(events) do
			bar:RegisterEvent(event)
		end

		local point = bars['bar7'].positions
		bar:SetPoint(point[1], point[2], point[3], point[4], point[5])

		AddPositions(bar)
		Update(bar)
	end

	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', AddStanceBar)

	--
