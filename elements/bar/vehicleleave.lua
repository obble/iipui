

	local _, ns = ...

	local AddVehicleLeaveButton = function()
		local bu = CreateFrame('CheckButton', 'iipVehicleExitButton', UIParent, 'ActionButtonTemplate, SecureHandlerClickTemplate')
		bu:SetSize(21, 21)
		bu:SetPoint('BOTTOMRIGHT', UIParent, -447, 104)
  		bu:RegisterForClicks'AnyUp'
  		bu:GetNormalTexture():SetTexture''

		tinsert(ns.bar_elements, bu)

		local mask = bu:CreateMaskTexture()
		mask:SetTexture[[Interface\Minimap\UI-Minimap-Background]]
		mask:SetPoint('TOPLEFT', -3, 3)
		mask:SetPoint('BOTTOMRIGHT', 3, -3)

		bu.icon:SetDrawLayer'ARTWORK'
		bu.icon:SetTexture[[Interface\Vehicles\UI-Vehicles-Button-Exit-Up]]
		bu.icon:ClearAllPoints()
		bu.icon:SetPoint('CENTER', bu)
		bu.icon:SetSize(21, 21)
		bu.icon:SetTexCoord(.15, .85, .15, .85)
		bu.icon:AddMaskTexture(mask)

		bu.bo = bu:CreateTexture(nil, 'OVERLAY')
		bu.bo:SetSize(36, 36)
		bu.bo:SetTexture[[Interface\Artifacts\Artifacts]]
		bu.bo:SetPoint'CENTER'
		bu.bo:SetTexCoord(.25, .34, .86, .9475)
		bu.bo:SetVertexColor(.7, .7, .7)

  		bu:SetScript('OnClick', function()
			VehicleExit()
			bu:SetChecked(false)
		end)

		RegisterStateDriver(bu, 'visibility', '[canexitvehicle] show; hide')
	end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', AddVehicleLeaveButton)

	--
