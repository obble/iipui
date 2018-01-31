

	local _, ns = ...

	local UpdateBackpackFreeSlots = function()
		local total = 0
		for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			local free, family = GetContainerNumFreeSlots(i)
			if family == 0 then total = total + free end
		end
		MainMenuBarBackpackButtonCount:SetText(string.format('%s', total))
	end

	ns.AddBackpack = function()
		local bu = MainMenuBarBackpackButton
		bu:SetParent(ActionButton1)
		bu:ClearAllPoints()
		bu:SetPoint('BOTTOMRIGHT', UIParent, -42, 16)
		bu:SetSize(21, 21)
		bu:GetNormalTexture():SetTexture''
		ns.BUElements(bu)

		SetPortraitToTexture(MainMenuBarBackpackButtonIconTexture, [[Interface\Buttons\Button-Backpack-Up]])

		MainMenuBarBackpackButtonCount:SetFont([[Fonts/ARIALN.ttf]], 11, 'OUTLINE')
		MainMenuBarBackpackButtonCount:ClearAllPoints()
		MainMenuBarBackpackButtonCount:SetPoint('LEFT', bu, 'RIGHT', 6, 0)

		if  not bu.bo then
			bu.bo = bu:CreateTexture(nil, 'OVERLAY')
			bu.bo:SetSize(36, 36)
			bu.bo:SetTexture[[Interface\Artifacts\Artifacts]]
			bu.bo:SetPoint'CENTER'
			bu.bo:SetTexCoord(.49, .58, .875, .9625)
			bu.bo:SetVertexColor(.7, .7, .7)
		end

		UpdateBackpackFreeSlots()
		hooksecurefunc('MainMenuBarBackpackButton_UpdateFreeSlots', UpdateBackpackFreeSlots)
	end


	--
