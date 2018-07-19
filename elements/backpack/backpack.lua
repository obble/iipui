

	local _, ns = ...

	local UpdateBackpackFreeSlots = function()
		local total = 0
		for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			local free, family = GetContainerNumFreeSlots(i)
			if family == 0 then total = total + free end
		end
		MainMenuBarBackpackButtonCount:SetText(string.format('%s', total))
	end

	local bu = MainMenuBarBackpackButton
	bu:SetParent(UIParent)
	bu:ClearAllPoints()
	bu:SetPoint('BOTTOMRIGHT', UIParent, -30, 20)
	bu:SetSize(21, 21)
	bu:GetNormalTexture():SetTexture''
	ns.BUElements(bu)

	--SetPortraitToTexture(MainMenuBarBackpackButtonIconTexture, [[Interface\Buttons\Button-Backpack-Up]])

	local mask = bu:CreateMaskTexture()
	mask:SetTexture[[Interface\Minimap\UI-Minimap-Background]]
	mask:SetPoint('TOPLEFT', -3, 3)
	mask:SetPoint('BOTTOMRIGHT', 3, -3)

	bu:GetCheckedTexture():SetTexture''

	MainMenuBarBackpackButtonIconTexture:AddMaskTexture(mask)

	MainMenuBarBackpackButtonCount:SetAlpha(0)

	if  not bu.bo then
		bu.bo = bu:CreateTexture(nil, 'OVERLAY')
		bu.bo:SetSize(36, 36)
		bu.bo:SetTexture[[Interface\Artifacts\Artifacts]]
		bu.bo:SetPoint'CENTER'
		bu.bo:SetTexCoord(.25, .34, .86, .9475)
		bu.bo:SetVertexColor(.7, .7, .7)
	end

	UpdateBackpackFreeSlots()
	hooksecurefunc('MainMenuBarBackpackButton_UpdateFreeSlots', UpdateBackpackFreeSlots)

	--
