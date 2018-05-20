

	-- thanks Zork

	local _, ns = ...

	local f = _G['iipbar']

	local BarPositions = {
		['iipBar1'] = {
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	70},
			GRIDDED	= {'BOTTOMRIGHT', 	UIParent, 'BOTTOM', -18, 	70},
			FIVE	= {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	173},
			visibility = '[petbattle] hide; show'
		},
		['iipBar2'] = {
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	125},
			GRIDDED	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  18, 	70},
			FIVE	= {'BOTTOMRIGHT', 	UIParent, 'BOTTOM', -16, 	71},
			visibility = '[petbattle][overridebar][vehicleui][possessbar][shapeshift][canexitvehicle] hide; show'
		},
		['iipBar3'] = {
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	180},
			GRIDDED	= {'BOTTOMRIGHT', 	UIParent, 'BOTTOM', -18, 	123},
			FIVE 	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  16, 	71},
			visibility = '[petbattle][overridebar][vehicleui][possessbar][shapeshift][canexitvehicle] hide; show'
		},
		['iipBar4'] = {
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	200},
			GRIDDED	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  18, 	123},
			FIVE 	= {'BOTTOMRIGHT', 	UIParent, 'BOTTOM', -16, 	121},
			visibility = '[petbattle][overridebar][vehicleui][possessbar][shapeshift][canexitvehicle] hide; show'
		},
		['iipBar5'] = {
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	240},
			GRIDDED	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  18, 	159},
			FIVE 	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  16, 	121},
			visibility = '[petbattle][overridebar][vehicleui][possessbar][shapeshift][canexitvehicle] hide; show'
		},
		['iipBar6'] = {	-- stance
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM', 0, 240},
			GRIDDED	= {'BOTTOM', 		UIParent, 'BOTTOM', 0, 200},
			FIVE	= {'BOTTOM', 		UIParent, 'BOTTOM', 0, 240},
			BASIC   = {'BOTTOM', 		UIParent, 'BOTTOM', 0, 140},
			TWO		= {'BOTTOM', 		UIParent, 'BOTTOM', 0, 200},
			visibility = '[petbattle][overridebar][vehicleui][possessbar][shapeshift][canexitvehicle] hide; show'
		},
		['iipBar7'] = {	-- pet
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM', -32, 240},
			GRIDDED	= {'BOTTOM', 		UIParent, 'BOTTOM', -32, 180},
			FIVE 	= {'BOTTOM', 		UIParent, 'BOTTOM', -32, 230},
			BASIC 	= {'BOTTOM', 		UIParent, 'BOTTOM', -32, 140},
			TWO		= {'BOTTOM', 		UIParent, 'BOTTOM', -32, 190},
			visibility = '[petbattle][overridebar][vehicleui][possessbar][shapeshift][canexitvehicle] hide; [pet] show; hide'
		},
	}

	local add = function(bu)
		if not ns.bar_elements[bu] then
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

	local SetEABPosition = function()
		ExtraActionBarFrame:SetParent(UIParent)
		ExtraActionBarFrame:ClearAllPoints()
		ExtraActionBarFrame.ignoreFramePositionManager = true
		ExtraActionBarFrame:SetPoint('BOTTOM', UIParent, 0, 12)
		ExtraActionBarFrame:SetFrameLevel(4)
		tinsert(ns.bar_elements, ExtraActionBarFrame)
		tinsert(ns.bar_elements, ExtraActionButton1)
	end

	local SetPagingPosition = function()
		for _, v in pairs({
			MainMenuBarPageNumber,
			ActionBarUpButton,
			ActionBarDownButton
		}) do
			v:ClearAllPoints()
			if v ~= MainMenuBarPageNumber then
				v:SetSize(24, 24)
				ns.BD(v, 1, 6)
				ns.BDStone(v, -4)
			end
		end

		if ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 4 then
			ActionBarUpButton:SetPoint('TOPRIGHT', _G['iipBar1'], 'TOPLEFT', -20, 5)
			ActionBarDownButton:SetPoint('TOP', ActionBarUpButton, 'BOTTOM', 0, 14)
			MainMenuBarPageNumber:SetPoint('TOPRIGHT', ActionBarUpButton, 'BOTTOMLEFT', -2, 9)
		else
			ActionBarUpButton:SetPoint('TOPLEFT', _G['iipBar1'], 'TOPRIGHT', 30, 5)
			ActionBarDownButton:SetPoint('TOP', ActionBarUpButton, 'BOTTOM', 0, 14)
			MainMenuBarPageNumber:SetPoint('TOPRIGHT', ActionBarUpButton, 'BOTTOMLEFT', -2, 9)
		end

		if  not ActionBarUpButton.bg then
			ActionBarUpButton.bg = ActionBarUpButton:CreateTexture(nil, 'BACKGROUND', nil, -7)
			ActionBarUpButton.bg:SetPoint('TOP', ActionBarUpButton, -2, 5)
			ActionBarUpButton.bg:SetSize(30, 26)
			ActionBarUpButton.bg:SetTexture[[Interface\ACHIEVEMENTFRAME\UI-Achievement-Category-Background]]
			ActionBarUpButton.bg:SetTexCoord(0, 1, .1, 1, 0, 0, .1, 0)

			ActionBarUpButton.bgbottom = ActionBarUpButton:CreateTexture(nil, 'BACKGROUND', nil, -7)
			ActionBarUpButton.bgbottom:SetPoint('BOTTOM', ActionBarDownButton, 2, -3)
			ActionBarUpButton.bgbottom:SetSize(30, 26)
			ActionBarUpButton.bgbottom:SetTexture[[Interface\ACHIEVEMENTFRAME\UI-Achievement-Category-Background]]
			ActionBarUpButton.bgbottom:SetTexCoord(.1, 0, 0, 0, .1, 1, 0, 1)
			-- 0, .1, 0, .9
		end
	end

	local GetPositionsFive = function(name)
		local  point = BarPositions[name].FIVE
		return point[1], point[2], point[3], point[4], point[5]
	end

	local GetPositionsGridded = function(name)
		local  point = BarPositions[name].GRIDDED
		return point[1], point[2], point[3], point[4], point[5]
	end

	local GetPositionsStacked = function(name)
		local  point = BarPositions[name].STACKED
		return point[1], point[2], point[3], point[4], point[5]
	end

	local GetPetPositionsBasic = function(name)
		local  point = BarPositions[name].BASIC
		return point[1], point[2], point[3], point[4], point[5]
	end

	local GetPetPositionsTwo = function(name)
		local  point = BarPositions[name].TWO
		return point[1], point[2], point[3], point[4], point[5]
	end

	local SetPositions = function()
		local GridSplit = ns.DELEGATE_ACTUAL_BARS_SHOWN and math.ceil(ns.DELEGATE_ACTUAL_BARS_SHOWN/2) + 1 or 1

		--  unpack bar positions
		for i = 1, 7 do
			local point, parent, relpoint, x, y
			local name = 'iipBar'..i
			local bar  = _G[name]
			if ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 5 then
				point, parent, relpoint, x, y = GetPositionsFive(name)
			elseif ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 4 then
				point, parent, relpoint, x, y = GetPositionsGridded(name)
			elseif ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 1 and (i == 6 or i == 7) then
				point, parent, relpoint, x, y = GetPetPositionsBasic(name)
			elseif ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 2 and (i == 6 or i == 7) then
				point, parent, relpoint, x, y = GetPetPositionsTwo(name)
			else
				point, parent, relpoint, x, y = GetPositionsStacked(name)
			end
			bar:ClearAllPoints()
			bar:SetPoint(point, parent, relpoint, x, y)
		end

		--	reposition other elements
		SetEABPosition()
		SetPagingPosition()
	end

	local AddVehicleLeaveButton = function(self, event, ...)
		local bu = CreateFrame('CheckButton', 'iipVehicleExitButton', UIParent, 'ActionButtonTemplate, SecureHandlerClickTemplate')
		bu:SetSize(21, 21)
		bu:SetPoint('BOTTOM', UIParent, -200, 70)
  		bu:RegisterForClicks'AnyUp'
  		bu:SetFrameLevel(4)
  		bu:GetNormalTexture():SetTexture''
		add(bu)

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
		bu.bo:SetTexCoord(.49, .58, .875, .9625)
		bu.bo:SetVertexColor(.7, .7, .7)


  		bu:SetScript('OnClick', function() VehicleExit() bu:SetChecked(false) end)
		RegisterStateDriver(bu, 'visibility', '[canexitvehicle] show; hide')
	end

	local GetButtonList = function(buttonName, numButtons)
	  	local buttonList = {}
	  	for i = 1, numButtons do
	    	local  button = _G[buttonName..i]
	    	if not button then break end
	    	table.insert(buttonList, button)
	  	end
	  	return buttonList
	end

	local AddFloatingGrid = function()
			local list = GetButtonList('ActionButton', 12)
		    if  InCombatLockdown() then
		      	lip:RegisterEvent('PLAYER_REGEN_ENABLED', 	 AddFloatingGrid)
		      	return
		    end
		    local var = tonumber(GetCVar'alwaysShowActionBars')
			lip:UnregisterEvent('PLAYER_REGEN_ENABLED',		 AddFloatingGrid)
		    for _, button in next, list do
				button:SetAttribute('showgrid', var)
				ActionButton_ShowGrid(button)
			end
	end

	local AddPaging = function(bar)
		local list = GetButtonList('ActionButton', 12)
		for _, v in pairs({
			ActionBarUpButton, ActionBarDownButton
		}) do
			add(v)
		end
		for i, button in next, list do
			bar:SetFrameRef('ActionButton'..i, button)
		end
		bar:Execute(([[
			buttons = table.new()
			for i = 1, %d do
			  table.insert(buttons, self:GetFrameRef("%s"..i))
			end
		]]):format(NUM_ACTIONBAR_BUTTONS, 'ActionButton'))
		bar:SetAttribute('_onstate-page', [[
			-- print('_onstate-page','index',newstate)
			for i, button in next, buttons do
			  button:SetAttribute('actionpage', newstate)
			end
		]])
		RegisterStateDriver(bar, 'page', '[vehicleui][possessbar] 12; [shapeshift] 13; [overridebar] 14; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;')
	end

	local AddBars = function()					-- 1:  action 	2:  multileft 	3:  multiright
		for i = 1, 7 do							-- 4:  right	5:  left	6:  stance	7: pet
			local x, y = _G['ActionButton1']:GetSize()
			local bar  = CreateFrame('Button', 'iipBar'..i, f, 'SecureHandlerStateTemplate')
			bar:SetFrameLevel(2)

			bar:SetSize((x*12) + 2.3*(i < 7 and 12 or 10), y)
			add(bar)

			local v = BarPositions['iipBar'..i].visibility
			RegisterStateDriver(bar, 'visibility', v) -- see if this fixes vehicle bug eh?
																			--  N O P E


			if  i == 1 then
				AddFloatingGrid()
				AddPaging(bar)
			end
		end
		AddVehicleLeaveButton()
		SetPositions()
	end

	local AddBarBD = function(bu, parent)
		if  bu:IsShown() then
			if not parent.bd then
				parent.bd = CreateFrame('Frame', nil, bu)
				parent.bd:SetBackdrop({
					bgFile = [[Interface\Buttons\WHITE8x8]],
					insets = {left = -2, right = -2, top = -2, bottom = -2}
				})
				parent.bd:SetBackdropColor(.05, .05, .05)
				parent.bd:SetPoint('TOPLEFT',  -5, 6)
				parent.bd:SetPoint('BOTTOMRIGHT', parent, 10, -6)
				parent.bd:SetFrameLevel(2)

				parent.bd.t = parent.bd:CreateTexture(nil, 'ARTWORK')
				parent.bd.t:SetAllPoints()
				parent.bd.t:SetTexture[[Interface/PLAYERACTIONBARALT/STONE]]
				parent.bd.t:SetTexCoord(0, 1, .18, .3)

				parent.bd.bo = parent.bd:CreateTexture(nil, 'BACKGROUND', nil, -7)
				parent.bd.bo:SetPoint('TOPLEFT', -15, 13)
				parent.bd.bo:SetPoint('BOTTOMRIGHT', 15, -13)
				parent.bd.bo:SetTexture[[Interface/ACHIEVEMENTFRAME/UI-Achievement-Alert-Background-Mini]]
				parent.bd.bo:SetVertexColor(225/255, 225/255, 225/255)
			end
		end
	end

	local HideBar = function(parent)
		if  parent then
			if  InCombatLockdown() then
				parent:RegisterEvent'PLAYER_REGEN_ENABLED'
				parent:SetScript('OnEvent', function(self)
					self:Hide()
					self:UnregisterAllEvents()
				end)
			else
				parent:Hide()
			end
		end
	end

	local ShowBar = function(parent)
		if  parent then
			if  InCombatLockdown() then
				parent:RegisterEvent'PLAYER_REGEN_ENABLED'
				parent:SetScript('OnEvent', function(self)
					self:Show()
					self:UnregisterAllEvents()
				end)
			else
				parent:Show()
			end
		end
	end

	local AddEAB = function(self)
		if  HasExtraActionBar() then
			local bar = ExtraActionBarFrame
			bar.button.style:SetSize(140, 70)
			bar.button.style:SetDrawLayer('BACKGROUND', -7)
			ns.BD(bar.button)
		end
	end

	local AddFlyout = function(self)
		local i  = 1
	  	while   _G['SpellFlyoutButton'..i] and i <= 13 do
			if self:GetParent():GetName():sub(1, 5) == 'Spell' then
				remove(_G['SpellFlyoutButton'..i])
				remove(SpellFlyout)
			else
				add(_G['SpellFlyoutButton'..i])
				add(SpellFlyout)
			end
			ns.AddBarMouseoverElements()
			i = i + 1
		end
	end

	local AddButtonsToBar = function(num, name, parent, old, page)
		if  old then
			old:SetParent(parent)
			old:EnableMouse(false)
		end
		for i = 1, num do
			local bu = _G[name..i]
			add(bu)
			bu:ClearAllPoints()
			if  i == 1 then
				bu:SetPoint('BOTTOMLEFT', parent)
				if  name ~= 'PetActionButton' and name ~= 'StanceButton' then
					AddBarBD(bu, parent)
				end
			else
				bu:SetPoint('LEFT', _G[name..i - 1], 'RIGHT', name == 'StanceButton' and 12 or name == 'PetActionButton' and 6 or 3, 0)
			end
			--  stance bar will show or hide whether the player uses it or not
			--  so w have to override it in our factory
			if  name == 'StanceButton' then
				bu:SetFrameLevel(0)
				if  bu:IsShown() then
					bu.stanceUsed = true
				else
					bu.stanceUsed = nil
				end
				if  StanceBarFrame:IsShown() then
					_G['iipBar6']:Show() bu:Show()
				else
					_G['iipBar6']:Hide() bu:Hide()
				end
			end
			--  pet bar is parented to blizzard frames that we hide, so parent it to bar
			if  name == 'PetActionButton' then
				bu:SetParent(parent)
			end
		end
	end

	local AddStancePositions = function()
		local i = 0
		for j = 1, 10 do
			local bu = _G['StanceButton'..j]
			if bu and bu.stanceUsed then i = i + 1 end
		end
		local bu = _G['StanceButton1']
		bu:ClearAllPoints()
		bu:SetPoint('BOTTOM', _G['iipBar6'], i > 1 and -(20*i) + 16 or 0, 0)
	end

	local AddTotems = function()
		-- pinch the stance position set and reposition totems
		local name = 'iipBar6'
		local point, parent, relpoint, x, y
		-- TODO: turn this into an external function
		if  ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 5 then
			point, parent, relpoint, x, y = GetPositionsFive(name)
		elseif ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 4 then
			point, parent, relpoint, x, y = GetPositionsGridded(name)
		elseif ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 1 then
			point, parent, relpoint, x, y = GetPetPositionsBasic(name)
		elseif ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 2 then
			point, parent, relpoint, x, y = GetPetPositionsTwo(name)
		else
			point, parent, relpoint, x, y = GetPositionsStacked(name)
		end
		TotemFrame:SetParent(f)
		TotemFrame:ClearAllPoints()
		TotemFrame:SetPoint(point, parent, relpoint, x, y)
	end

	local PositionBarsAfterCombat = function()
		lip:UnregisterEvent('PLAYER_REGEN_ENABLED', PositionBarsAfterCombat)
		C_Timer.After(1.5, SetPositions)
	end

	local SetUpButtons = function()
			-- create bars to parent buttons to
		AddBars()
			--  begin button reparenting
		AddButtonsToBar(12,	'ActionButton',					_G['iipBar1'], MainMenuBarArtFrame)
		AddButtonsToBar(12, 'MultiBarBottomLeftButton',		_G['iipBar2'], MultiBarBottomLeft, 6)
		AddButtonsToBar(12, 'MultiBarBottomRightButton',	_G['iipBar3'], MultiBarBottomRight, 5)
		AddButtonsToBar(12, 'MultiBarRightButton',			_G['iipBar4'], MultiBarRight, 4)
		AddButtonsToBar(12, 'MultiBarLeftButton',			_G['iipBar5'], MultiBarLeft, 3)
		AddButtonsToBar(10, 'StanceButton',					_G['iipBar6'], StanceBarFrame)
		AddButtonsToBar(10, 'PetActionButton',				_G['iipBar7'], PetActionBarFrame)
		AddStancePositions()
			--  set new ExtraActionButton format
		hooksecurefunc('ExtraActionBar_Update', AddEAB)
			-- 	position bars
			--	TODO:	this event runs fairly infrequently but we should double check
			--			that we're not overdoing it
		hooksecurefunc('MultiActionBar_Update', function()
			if InCombatLockdown() then
				lip:RegisterEvent('PLAYER_REGEN_ENABLED', PositionBarsAfterCombat)
			else
				C_Timer.After(1.5, SetPositions)
			end
		end)
	end

	SpellFlyout:HookScript('OnShow', AddFlyout)

	hooksecurefunc('MultiActionBar_UpdateGridVisibility', AddFloatingGrid)
	hooksecurefunc('TotemFrame_Update', AddTotems)
	hooksecurefunc('HidePetActionBar', function()
		HideBar(_G['iipBar7'])
	end)
	hooksecurefunc('ShowPetActionBar', function()
		ShowBar(_G['iipBar7'])
	end)

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_ENTERING_WORLD'
	e:SetScript('OnEvent', SetUpButtons)

	local updated = false
	local uuupdate = function(self)
		if not updated then
			for i, v in pairs(FADEFRAMES) do
				print(v:GetName())
			end
			updated = true
		end
	end

	ValidateActionBarTransition = function() return end


	--
