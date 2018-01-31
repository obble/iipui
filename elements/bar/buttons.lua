

	-- thanks Zork

	local _, ns = ...

	local f = _G['iipbar']

	local BarPositions = {
		['iipBar1'] = {
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	70},
			GRIDDED	= {'BOTTOMRIGHT', 	UIParent, 'BOTTOM', -16, 	54},
			THREE	= {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	93},
			FIVE	= {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	142},
		},
		['iipBar2'] = {
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	120},
			GRIDDED	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  16, 	54},
			THREE	= {'BOTTOMRIGHT', 	UIParent, 'BOTTOM', -16, 	43},
			FIVE	= {'BOTTOMRIGHT', 	UIParent, 'BOTTOM', -16, 	43},
		},
		['iipBar3'] = {
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	157},
			GRIDDED	= {'BOTTOMRIGHT', 	UIParent, 'BOTTOM', -16, 	102},
			THREE 	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  16, 	43},
			FIVE 	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  16, 	43},
		},
		['iipBar4'] = {
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	200},
			GRIDDED	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  16, 	102},
			THREE 	= {'BOTTOMRIGHT', 	UIParent, 'BOTTOM', -16, 	139},
			FIVE 	= {'BOTTOMRIGHT', 	UIParent, 'BOTTOM', -16, 	93},
		},
		['iipBar5'] = {
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM',   0, 	240},
			GRIDDED	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  16, 	144},
			THREE 	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  16, 	139},
			FIVE 	= {'BOTTOMLEFT', 	UIParent, 'BOTTOM',  16, 	93},
		},
		['iipBar6'] = {	-- stance
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM', 0, 166},
			GRIDDED	= {'BOTTOM', 		UIParent, 'BOTTOM', 0, 157},
			THREE	= {'BOTTOM', 		UIParent, 'BOTTOM', 0, 142},
			FIVE	= {'BOTTOM', 		UIParent, 'BOTTOM', 0, 187},
			BASIC   = {'BOTTOM', 		UIParent, 'BOTTOM', 0, 120},
		},
		['iipBar7'] = {	-- pet
			STACKED = {'BOTTOM', 		UIParent, 'BOTTOM', -14, 166},
			GRIDDED	= {'BOTTOM', 		UIParent, 'BOTTOM', -14, 157},
			THREE 	= {'BOTTOM', 		UIParent, 'BOTTOM', -14, 142},
			FIVE 	= {'BOTTOM', 		UIParent, 'BOTTOM', -14, 187},
			BASIC 	= {'BOTTOM', 		UIParent, 'BOTTOM', -14, 120},
		},
	}

	local add = function(bu)
		if not ns.BAR_ELEMENTS[bu] then
			tinsert(ns.BAR_ELEMENTS, bu)
		end
	end

	local remove = function(bu)
		for i, v in pairs(ns.BAR_ELEMENTS) do
			if  bu:GetName() == v:GetName() then
				tremove(ns.BAR_ELEMENTS, i)
			end
		end
	end

	local SetEABPosition = function()
		ExtraActionBarFrame:SetParent(UIParent)
		ExtraActionBarFrame:ClearAllPoints()
		ExtraActionBarFrame.ignoreFramePositionManager = true
		ExtraActionBarFrame:SetPoint'BOTTOM'
		tinsert(ns.BAR_ELEMENTS, ExtraActionBarFrame)
		tinsert(ns.BAR_ELEMENTS, ExtraActionButton1)
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
		ActionBarUpButton:SetPoint('TOPLEFT', _G['iipBar1'], 'TOPRIGHT', 30, 5)
		ActionBarDownButton:SetPoint('TOP', ActionBarUpButton, 'BOTTOM', 0, 14)
		MainMenuBarPageNumber:SetPoint('TOPRIGHT', ActionBarUpButton, 'BOTTOMLEFT', -2, 9)

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

	local GetPositionsThree = function(name)
		local  point = BarPositions[name].THREE
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

	local SetPositions = function()
		local GridSplit = ns.DELEGATE_ACTUAL_BARS_SHOWN and math.ceil(ns.DELEGATE_ACTUAL_BARS_SHOWN/2) + 1 or 1

		--  this has to be reparented to our new bar
		--  in order for its child elements to show in their updated positions
		MainMenuBarArtFrame:SetParent(_G['iipBar1'])
		MainMenuBarArtFrame:EnableMouse(false)

		--  unpack bar positions
		for i = 1, 7 do
			local point, parent, relpoint, x, y
			local name = 'iipBar'..i
			local bar  = _G[name]
			if ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 5 then
				point, parent, relpoint, x, y = GetPositionsFive(name)
			elseif ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 3 then
				point, parent, relpoint, x, y = GetPositionsThree(name)
			elseif ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 4 then
				point, parent, relpoint, x, y = GetPositionsGridded(name)
			elseif ns.DELEGATE_ACTUAL_BARS_SHOWN and ns.DELEGATE_ACTUAL_BARS_SHOWN == 1 and (i == 6 or i == 7) then
				point, parent, relpoint, x, y = GetPetPositionsBasic(name)
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
		ns.BU(bu)
		ns.BD(bu)
		ns.BDStone(bu, 6)
		bu:SetPoint('RIGHT', MainMenuBarBackpackButton, -50, 0)
  		bu:RegisterForClicks'AnyUp'
  		bu:SetFrameLevel(4)
		add(bu)

		bu.icon:SetDrawLayer'OVERLAY'
		bu.icon:SetTexture[[Interface\Vehicles\UI-Vehicles-Button-Exit-Up]]
		bu.icon:ClearAllPoints()
		bu.icon:SetPoint('CENTER', bu)
		bu.icon:SetSize(21, 21)
		bu.icon:SetTexCoord(.2, .8, .2, .8)

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
	    for i, button in next, list do
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
		RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show')
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
		RegisterStateDriver(bar, 'page', '[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;1')
	end

	local AddBars = function()					-- 1:  action 	2:  multileft 	3:  multiright
		for i = 1, 7 do							-- 4:  right	5:  left	6:  stance	7: pet
			local x, y = _G['ActionButton1']:GetSize()
			local bar  = CreateFrame('Button', 'iipBar'..i, f, 'SecureHandlerStateTemplate')
			bar:SetFrameLevel(2)

			bar:SetSize((x*12) + 2.3*(i < 7 and 12 or 10), y)
			add(bar)
			if  i == 1 then
				AddFloatingGrid()
				AddPaging(bar)
			else
				-- RegisterStateDriver(bar, 'visibility', '[petbattle][overridebar][possessbar,@vehicle,exists] hide; show')
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
				parent.bd.bo:SetPoint('TOPLEFT', -14, 12)
				parent.bd.bo:SetPoint('BOTTOMRIGHT', 14, -12)
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

	local AddEAB = function(self)
		if  HasExtraActionBar() then
			local bar = ExtraActionBarFrame
			bar.button.style:SetSize(180, 90)
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
			ns.STICKY_BAR_MOUSEOVER()
			i = i + 1
		end
	end

	local AddButtonsToBar = function(num, name, parent)
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
					_G['iipBar6']:Show() bu:Show() bu:SetParent(parent)
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

	local PositionBarsAfterCombat = function()
		lip:UnregisterEvent('PLAYER_REGEN_ENABLED', PositionBarsAfterCombat)
		C_Timer.After(1.5, SetPositions)
	end

	local SetUpButtons = function()
			-- create single backpack button
		ns.AddBackpack()
			-- create bars to parent buttons to
		AddBars()
			--  begin button reparenting
		AddButtonsToBar(12, 'ActionButton',             	_G['iipBar1'])
		AddButtonsToBar(12, 'MultiBarBottomLeftButton', 	_G['iipBar2'])
		AddButtonsToBar(12, 'MultiBarBottomRightButton', 	_G['iipBar3'])
		AddButtonsToBar(12, 'MultiBarRightButton',	  	_G['iipBar4'])
		AddButtonsToBar(12, 'MultiBarLeftButton',		_G['iipBar5'])
		AddButtonsToBar(10, 'StanceButton',			_G['iipBar6'])
		AddButtonsToBar(10, 'PetActionButton',			_G['iipBar7'])
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
	hooksecurefunc('HidePetActionBar', function()
		HideBar(_G['iipBar7'])
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


	--
