

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

	local function IsButton(self, name)
        if self:GetName():match(name) then return true else return false end
    end

	local Zone = function(self)
		if  ZoneAbilityFrame then
			UIPARENT_MANAGED_FRAME_POSITIONS.ZoneAbilityFrame = nil
			ZoneAbilityFrame:SetParent(UIParent)
			ZoneAbilityFrame:SetScale(.7)
			ZoneAbilityFrame:ClearAllPoints()
			ZoneAbilityFrame:SetFrameStrata'HIGH'

			ns.BU(ZoneAbilityFrame.SpellButton)
			ns.BUElements(ZoneAbilityFrame.SpellButton)
			ZoneAbilityFrame.SpellButton:SetSize(36, 36)

			ZoneAbilityFrame.SpellButton.Style:SetDrawLayer'BACKGROUND'

			ZoneAbilityFrame.SpellButton.Icon:SetDrawLayer'ARTWORK'
			ZoneAbilityFrame.SpellButton.Icon:SetTexCoord(.1, .9, .1, .9)

			ZoneAbilityFrame.SpellButton:GetNormalTexture():SetTexture''
			ns.DELEGATE_FRAMES_TO_POSITION[ZoneAbilityFrame] = {'BOTTOM', 0, 20}
		end
	end

	local pet = function(self)
		for _, name in pairs({
            'PetActionButton',
            'PossessButton',
            'StanceButton',
        }) do
            for i = 1, 12 do
                local bu = _G[name..i]
				local ic = _G[name..i..'Icon']
				local fl = _G[name..i..'Flash']
				local bg = _G[name..i..'FloatingBG']
				local bo = _G[name..i..'Border']
				local no = _G[name..i..'NormalTexture'] or _G[name..i..'NormalTexture2']

				if bu then
					if not bu.style then
						ns.BUElements(bu)

						bu:SetFrameLevel(bu:GetParent():GetFrameLevel() + 1)

						--ns.BDStone(bu, 5)
						if name ~= 'StanceButton' then
							bu:SetSize(30, 30)
						else
							bu:SetSize(32, 32)
						end

						--ic:SetTexCoord(.1, .9, .3, .7)

						local mask = bu:CreateMaskTexture()
						mask:SetTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]
						mask:SetAllPoints()

						local mask2 = bu:CreateMaskTexture()
						mask2:SetTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]
						mask2:SetPoint('TOPLEFT', -5, 5)
						mask2:SetPoint('BOTTOMRIGHT', 5, -5)

						ic:AddMaskTexture(mask)

						bu:GetCheckedTexture():AddMaskTexture(mask)
						bu:GetPushedTexture():AddMaskTexture(mask)
						bu:GetHighlightTexture():AddMaskTexture(mask)

						fl:AddMaskTexture(mask)

						bu.cooldown:SetSwipeTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]

						if  not bu.bg then
							bu.bg = bu:CreateTexture(nil, 'BACKGROUND', nil, -4)
							bu.bg:SetPoint('TOPLEFT', -3, 3)
							bu.bg:SetPoint('BOTTOMRIGHT', 3, -3)
							bu.bg:SetTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]
							bu.bg:SetVertexColor(0, 0, 0)

							bu.bo = bu:CreateTexture(nil, 'BACKGROUND', nil, -5)
							bu.bo:SetPoint('TOPLEFT', -5, 5)
							bu.bo:SetPoint('BOTTOMRIGHT', 5, -5)
							bu.bo:SetTexture[[Interface\Stationery\StationeryTest1]]
							bu.bo:AddMaskTexture(mask2)
							bu.bo:SetVertexColor(.9, .9, .9)

							bu.stone = bu:CreateTexture(nil, 'BACKGROUND', nil, -6)
							bu.stone:SetPoint('TOPLEFT', -12, 12)
							bu.stone:SetPoint('BOTTOMRIGHT', 12, -12)
							bu.stone:SetTexture[[Interface\ARCHEOLOGY\ArchaeologyParts]]
							bu.stone:SetTexCoord(.115, .205, .5775, .765)
						end

						bu.style = true
					end

					for _, v in pairs({bg, bo, no}) do
						if v then v:SetAlpha(0) end
					end

					if  name == 'PetActionButton' then
	                    local shine = _G[name..i..'Shine']
	                    local auto  = _G[name..i..'AutoCastable']

	                    if  shine then
	                        shine:ClearAllPoints()
	                        shine:SetPoint('TOPLEFT', bu, -3, 4)
	                        shine:SetPoint('BOTTOMRIGHT', bu, 3, -4)
	                        shine:SetFrameStrata'BACKGROUND'
	                    end

	                    if  auto then
	                        auto:SetSize(46, 54)
	                        auto:SetDrawLayer('OVERLAY', 7)
	                    end
	                end
				end
			end
		end
	end

	local skin = function(self)
		local name	= self:GetName()
		local bu	= _G[name]
		local bg	= _G[name..'FloatingBG']
		local bo	= _G[name..'Border']
		local n		= _G[name..'Name']
		local fly	= _G[name..'FlyoutBorder']
		local flys	= _G[name..'FlyoutBorderShadow']

		if not bu.bo then
			ns.BU(bu, .75, true, 22)
			ns.BUElements(bu)
			ns.BUBorder(bu)
		end

		if IsEquippedAction(self.action) then
			bu.HotKey:SetParent(bu.bo)	-- draw over border
			bu.bo:SetBackdropBorderColor(0, .6, 0)
		end

		for _, v in pairs({fly, flys}) do
			if v then v:SetTexture'' end
		end
		for _, v in pairs({bg, bo}) do
			if v then v:SetAlpha(0) end
		end

		if  n then
			n:SetFont(STANDARD_TEXT_FONT, 8)
			n:SetText(n:GetText() and n:GetText():sub(1, 3))
		end

		if IsButton(self, 'ExtraActionButton') or IsButton(self, 'ZoneActionBarFrameButton') then
			Zone(bu)
			if not InCombatLockdown() then bu:SetSize(30, 30) end
		end
	end

	local AddFlyoutSkin = function(self)
		local i = 1
		while _G['SpellFlyoutButton'..i] do
			local bu = _G['SpellFlyoutButton'..i]
			local ic = _G['SpellFlyoutButton'..i..'Icon']
			ns.BU(bu)
			ns.BUElements(bu)
			for _, v in pairs({
				SpellFlyoutBackgroundEnd,
				SpellFlyoutHorizontalBackground, SpellFlyoutVerticalBackground
			}) do
				v:SetTexture''
			end
			i = i + 1
		end
	end

	local AddHotkey = function(self)
		local hotkey 	= self.HotKey
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

	for i = 1, 4 do
		local bu = _G['TotemFrameTotem'..i]
		local ic = _G['TotemFrameTotem'..i..'Icon']
		local tx = _G['TotemFrameTotem'..i..'IconTexture']
		local cd = _G['TotemFrameTotem'..i..'IconCooldown']
		local du = _G['TotemFrameTotem'..i..'Duration']

		local mask = ic:CreateMaskTexture()
		mask:SetTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]
		mask:SetAllPoints()

		local mask2 = ic:CreateMaskTexture()
		mask2:SetTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]
		mask2:SetPoint('TOPLEFT', ic, -5, 5)
		mask2:SetPoint('BOTTOMRIGHT', ic, 5, -5)

		bu:SetSize(45, 45)

		ic.bg = ic:CreateTexture(nil, 'BACKGROUND', nil, -4)
		ic.bg:SetPoint('TOPLEFT', ic, -3, 3)
		ic.bg:SetPoint('BOTTOMRIGHT', ic, 3, -3)
		ic.bg:SetTexture[[Interface\ARCHEOLOGY\Arch-Keystone-Mask]]
		ic.bg:SetVertexColor(0, 0, 0)

		ic.bo = ic:CreateTexture(nil, 'BACKGROUND', nil, -5)
		ic.bo:SetPoint('TOPLEFT', ic, -5, 5)
		ic.bo:SetPoint('BOTTOMRIGHT', ic, 5, -5)
		ic.bo:SetTexture[[Interface\Stationery\StationeryTest1]]
		ic.bo:AddMaskTexture(mask2)
		ic.bo:SetVertexColor(.9, .9, .9)

		ic.stone = ic:CreateTexture(nil, 'BACKGROUND', nil, -6)
		ic.stone:SetPoint('TOPLEFT', ic, -12, 12)
		ic.stone:SetPoint('BOTTOMRIGHT', ic, 12, -12)
		ic.stone:SetTexture[[Interface\ARCHEOLOGY\ArchaeologyParts]]
		ic.stone:SetTexCoord(.115, .205, .5775, .765)

		ic:SetSize(33, 33)

		tx:SetTexCoord(.1, .9, .1, .9)
		tx:AddMaskTexture(mask)

		cd:ClearAllPoints()

		du:SetPoint('TOP', bu, 'BOTTOM', 0, -5)

		bu:ClearAllPoints()
		bu:SetPoint('TOPLEFT', TotemFrame, -90 + (45*i), 0)

		-- 	sigh
		for  k, v in pairs({bu:GetChildren()}) do
			for _, j in pairs({v:GetRegions()}) do
				if  j:GetObjectType() == 'Texture' and j:GetTexture() == [[Interface\CharacterFrame\TotemBorder]] then
					j:SetTexture''
				end
			end
		end
	end

	SpellFlyout:HookScript('OnShow', AddFlyoutSkin)

	hooksecurefunc('PetActionBar_Update', pet)
    hooksecurefunc('StanceBar_UpdateState', pet)
    securecall'PetActionBar_Update'
	hooksecurefunc('ActionButton_Update', skin)
	hooksecurefunc('ActionButton_UpdateHotkeys', AddHotkey)


	--
