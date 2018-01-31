

	local _, ns = ...
	local path 	= 'Interface\\AddOns\\iipui\\art\\minimap\\'

	LoadAddOn'Blizzard_TimeManager'

	local lfg        = QueueStatusMinimapButton
	local mail       = MiniMapMailFrame
	local mailborder = MiniMapMailBorder
	local garrison   = GarrisonLandingPageMinimapButton

	local indicator = CreateFrame('Button', 'iipMinimapIcon', Minimap)
	indicator:SetSize(54, 54)
	indicator:RegisterForClicks'AnyUp'
	indicator:SetPoint('TOPRIGHT', Minimap, 15, 6)

	indicator.t = indicator:CreateTexture(nil, 'ARTWORK')
	indicator.t:SetAllPoints()
	indicator.t:SetTexture(path..'dalaran')

	indicator.mail = indicator:CreateTexture(nil, 'OVERLAY')
	indicator.mail:SetSize(12, 12)
	indicator.mail:SetPoint('TOPRIGHT', indicator.t, -10, -14)
	indicator.mail:SetTexture(path..'mail')
	indicator.mail:Hide()

	lfg:SetScale(.575)
	lfg:SetParent(Minimap)
	lfg:ClearAllPoints()
	lfg:SetPoint('TOPRIGHT', -26, 7)
	lfg:SetFrameLevel(5)

	TimeManagerClockButton:GetRegions():Hide()
	TimeManagerClockButton:Hide()

	HelpOpenWebTicketButton:SetSize(20, 20)
	HelpOpenWebTicketButton:SetParent(Minimap)
	HelpOpenWebTicketButton:ClearAllPoints()
	HelpOpenWebTicketButton:SetPoint('BOTTOMLEFT', -2, -5)

	local bugs = CreateFrame('Button', 'iipFuck', Minimap)
	ns.BD(bugs)
	bugs:SetPoint'BOTTOMLEFT'
	bugs:SetSize(6, 8)
	bugs:SetAlpha(0)

	bugs.t = bugs:CreateTexture(nil, 'OVERLAY')
	bugs.t:SetAllPoints()
	bugs.t:SetColorTexture(1, 0, 0)

	local AddAnim = function(frame, offset)
		local anim = frame:CreateAnimationGroup()
		anim:SetLooping'REPEAT'

		anim.translateUp = anim:CreateAnimation'Translation'
		anim.translateUp:SetOrder(1)
		anim.translateUp:SetOffset(0, offset)
		anim.translateUp:SetDuration(3)
		anim.translateUp:SetEndDelay(.1)
		anim.translateUp:SetSmoothing'IN_OUT'

		anim.translateDn = anim:CreateAnimation'Translation'
		anim.translateDn:SetOrder(2)
		anim.translateDn:SetOffset(0, -offset)
		anim.translateDn:SetDuration(3)
		anim.translateDn:SetEndDelay(.1)
		anim.translateDn:SetSmoothing'IN_OUT'

		anim:Play()
	end

	local OrganiseMinimap = function(self)
		local i = 1
		if not indicator:GetAnimationGroups() then AddAnim(indicator, 15) end
		for _, v in pairs({mail, garrison}) do
			v:Hide()
		end
	end

	local AddMail = function()
		if  HasNewMail() then
			indicator.mail:Show()
		else
			indicator.mail:Hide()
		end
	end

	local AddIndicatorTooltip = function(self)
		local sender1, sender2, sender3 = GetLatestThreeSenders()
		local t

		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')

		if  C_Garrison.GetLandingPageGarrisonType() == LE_GARRISON_TYPE_6_0 then
			GameTooltip:AddLine(GARRISON_LANDING_PAGE_TITLE, 1, 1, 1)
			GameTooltip:AddLine(MINIMAP_GARRISON_LANDING_PAGE_TOOLTIP, nil, nil, nil, true)
		elseif C_Garrison.GetLandingPageGarrisonType() ~= 0 then
			GameTooltip:AddLine(ORDER_HALL_LANDING_PAGE_TITLE, 1, 1, 1)
			GameTooltip:AddLine(MINIMAP_ORDER_HALL_LANDING_PAGE_TOOLTIP, nil, nil, nil, true)
		end

		if sender1 or sender2 or sender3 then
			t = HAVE_MAIL_FROM
		else
			t = HasNewMail() and HAVE_MAIL or nil
		end

		if  sender1 then
			t = t..'\n'..sender1
		end
		if  sender2 then
			t = t..'\n'..sender2
		end
		if  sender3 then
			t = t..'\n'..sender3
		end

		if  t then
			GameTooltip:AddLine' '
			GameTooltip:AddLine(t)
		end

		GameTooltip:Show()
	end

	local GetBrokerData = function()
		if not LibStub then return end
		local LDB     = LibStub('LibDataBroker-1.1', true)
		local LDBIcon = LibStub('LibDBIcon-1.0', true)
		if  LDB then
			return LDB:GetDataObjectByName'BugSack', LDB, LDBIcon
		end
	end

	local data, LDB, LDBIcon = GetBrokerData()
	if  data then
		if  not string.find(data.icon, 'red') then bugs:SetAlpha(0) end
		LDB.RegisterCallback(bugs, 'LibDataBroker_AttributeChanged_BugSack', function()
			if  string.find(data.icon, 'red') then
				bugs:SetAlpha(1)
			else
				bugs:SetAlpha(0)
			end
		end)
	end

	for _, v in pairs({garrison, lfg, mail}) do
		if  v:HasScript'OnShow' then
			v:HookScript('OnShow', 	OrganiseMinimap)
			v:HookScript('OnHide', 	OrganiseMinimap)
		else
			v:SetScript('OnShow', 	OrganiseMinimap)
			v:SetScript('OnHide', 	OrganiseMinimap)
		end
	end

	indicator:SetScript('OnEnter', 	AddIndicatorTooltip)
	indicator:SetScript('OnLeave', 	function()
		GameTooltip:Hide()
	end)
	indicator:SetScript('OnClick', 	function(self, button)
		if  button == 'LeftButton' then
			GarrisonLandingPageMinimapButton_OnClick()
		end
	end)

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_ENTERING_WORLD'
	e:RegisterEvent'UPDATE_PENDING_MAIL'
	e:SetScript('OnEvent', function(self, event)
		if event == 'PLAYER_ENTERING_WORLD' then
			OrganiseMinimap()
		else
			AddMail()
		end
	end)


	--
