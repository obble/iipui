
	local _, ns = ...

	local buttons = {
		'ActionButton',
		'MultiBarBottomLeftButton',
		'MultiBarBottomRightButton',
		'MultiBarLeftButton',
		'MultiBarRightButton',
		'StanceButton',
		'PetActionButton',
	}

  	local f   = _G['iipbar']
  	local bar = _G['iipbar_collapse']

  	local e = CreateFrame'Frame'

  	local x = ns.DELEGATE_BARS_SHOWN and 40 + (27*ns.DELEGATE_BARS_SHOWN) or 60 -- point at which animation offset finishes
	local z = ns.DELEGATE_BARS_SHOWN and 40 + (10*ns.DELEGATE_BARS_SHOWN) or 40	-- point at which elements show


	local barElement = false

  	local SetBarSize = function()
	  	bar:SetSize(f:GetWidth(), ns.DELEGATE_BARS_SHOWN and 40 + 32*ns.DELEGATE_BARS_SHOWN or 70)
	  	x = ns.DELEGATE_BARS_SHOWN and 40 + (21*ns.DELEGATE_BARS_SHOWN) or 60 -- recalculate
		z = ns.DELEGATE_BARS_SHOWN and 40 + (10*ns.DELEGATE_BARS_SHOWN) or 40 --
  	end

  	local ToggleButtons = function(show)
	  	if  HasExtraActionBar() then
			local bar = ExtraActionBarFrame
			local cd  = _G['ExtraActionButton1Cooldown']
			cd:SetDrawBling(show)
			bar:SetAlpha(show and 1 or 0)
		end

	  	for i = 1, 12 do
		  	for _, v in pairs(buttons) do
				local bu = _G[v..i]
			  	if  bu and bu:IsShown() then
				  	bu.cooldown:SetDrawBling(show)
				  	bu:SetAlpha(show and 1 or 0)
			  	end
		  	end
	  	end
  	end

  	local ToggleFrames = function(show)
	  	if show then MainMenuBarPageNumber:Show() else MainMenuBarPageNumber:Hide() end
	  	for _, v in pairs(ns.BAR_ELEMENTS) do
		  	local n = v:GetName()
		  	if n == nil or not n:match'ActionButton(.+)' then
			  	v:SetAlpha(show and 1 or 0)
		  	end
	  	end
  	end

  	local ToggleBars = function(show)
	  	for i = 1, 7 do
		  	local frame = _G['iipBar'..i]
		  	if  frame and frame:GetBackdrop() then
			  	frame:SetBackdropColor(0, 0, 0, show and 1 or 0)
		  	end
	  	end
  	end

  	local showElements = function()
	  	ToggleButtons(true)
	  	ToggleFrames(true)
	  	ToggleBars(true)
	  	ns.BAR_IS_GROWN 	= true
		bar.elementsShown 	= true
  	end

  	local hideElements = function()
	  	ToggleButtons(false)
	  	ToggleFrames(false)
	  	ToggleBars(false)
	  	ns.BAR_IS_GROWN		= false
		bar.elementsShown 	= false
  	end

	ns.BarShrink = function(self)
  		local point = {bar:GetPoint()}
  		if point[5] > 4 and not InCombatLockdown() then
  			bar:ClearAllPoints()
  			bar:SetPoint('TOP', UIParent, 'BOTTOM', 0, point[5] - ((ns.DELEGATE_BARS_SHOWN and ns.DELEGATE_BARS_SHOWN < 2) and 13 or 6)*(ns.DELEGATE_BARS_SHOWN and ns.DELEGATE_BARS_SHOWN or 1))
  			if point[5] < z then
  				hideElements()
  			else
  				showElements()
  			end
  		else
  			self:SetScript('OnUpdate', nil)
  		end
  	end

  	ns.BarGrow = function(self)
  		local point = {bar:GetPoint()}
  		if point[5] < x then
  			bar:ClearAllPoints()
  			bar:SetPoint('TOP', UIParent, 'BOTTOM', 0, point[5] + ((ns.DELEGATE_BARS_SHOWN and ns.DELEGATE_BARS_SHOWN < 2) and 13 or 6)*(ns.DELEGATE_BARS_SHOWN and ns.DELEGATE_BARS_SHOWN or 1))
  			if point[5] > z then
  				showElements()
  			else
  				hideElements()
  			end
  		else
  			self:SetScript('OnUpdate', nil)
  		end
  	end

	onUpdateShrink = function(self)
		if ns.ALWAYS_UP_BAR then return end
		self:SetScript('OnUpdate', ns.BarShrink)
	end

	onUpdateGrow = function(self)
		self:SetScript('OnUpdate', ns.BarGrow)
	end

  	local CombatBar = function()
	  	if  iipCombatActionBar == 1 then
		  	e:RegisterEvent'PLAYER_REGEN_DISABLED'
		  	e:RegisterEvent'PLAYER_REGEN_ENABLED'
		  	e:SetScript('OnEvent', function(self, event)
			  	if event == 'PLAYER_REGEN_DISABLED' then
				  	onUpdateGrow(bar)
			  	else
				  	onUpdateShrink(bar)
			  	end
		  	end)
	  	else
		  	e:UnregisterAllEvents()
		  	e:SetScript('OnEvent', nil)
	  	end
  	end

  	local AlwaysBar = function()
	  	if  iipAlwaysActionBar == 1 then
		  	e:UnregisterAllEvents()
		  	e:SetScript('OnEvent', nil)
		  	ns.ALWAYS_UP_BAR = true
		  	onUpdateGrow(bar)
	  	else
		  	ns.ALWAYS_UP_BAR = false
		  	onUpdateShrink(bar)
	  	end
  	end

  	ns.BAR_VAR_UPDATE = function()
	  	CombatBar()
	  	AlwaysBar()
  	end

  	ns.STICKY_BAR_MOUSEOVER = function()		-- assert "sticky" behaviour for bar pseudo-children
	  	ns.BAR_VAR_UPDATE()			-- preventing the bar collapsing when we mouseover elements within
	  	for i, v in pairs(ns.BAR_ELEMENTS) do	-- this is run on the initial login OnUpdate collapse
						  	-- in order to collect elements added after this file is run
		  	if not v.RegisteredForBar then		-- kill overhead
			  	v:HookScript('OnEnter', function() onUpdateGrow(bar) end)	-- TODO:  does this duplicate animation and cause crazy offsets
				v:HookScript('OnLeave', function() onUpdateShrink(bar) end)
				v.RegisteredForBar = true
		  	end
	  	end
						  -- defined in customise/customise.lua
	  	for _, v in pairs(ns.CUSTOM_BAR_ELEMENTS) do
		  	if v and not ns.BAR_ELEMENTS[v] then
			  	tinsert(ns.BAR_ELEMENTS, v)
		  	end
	  	end
  	end

	iipBarToggle = function()					-- global for keybind
		if  not bar.elementsShown then -- ?
			ns.ALWAYS_UP_BAR = true
			onUpdateGrow(bar)
		else
			ns.ALWAYS_UP_BAR = false
			onUpdateShrink(bar)
		end
	end

  	local InitialiseBar = function(self, event)--  fire on load, and then AGAIN when variables load in
	  	ns.STICKY_BAR_MOUSEOVER()		--  hijack to scoop up majority of BAR_ELEMENTS
	  	onUpdateShrink(bar)
	 	lip:UnregisterEvent('PLAYER_ENTERING_WORLD', InitialiseBar)
  	end

  	hooksecurefunc('MultiActionBar_Update', function()
	  	C_Timer.After(1.5, SetBarSize)		--  building in time for vars to update
  	end)

	f:SetScript('OnEnter',  function() onUpdateGrow(bar)   end)
	f:SetScript('OnLeave',  function() onUpdateShrink(bar) end)

	SpellBookFrame:HookScript('OnShow', function()
		ns.ALWAYS_UP_BAR = true
		onUpdateGrow(bar)
	end)
	SpellBookFrame:HookScript('OnHide', function()
		ns.ALWAYS_UP_BAR = false
		onUpdateShrink(bar)
	end)

	local init = CreateFrame'Frame'
	init:RegisterEvent'PLAYER_ENTERING_WORLD'
	init:RegisterEvent'VARIABLES_LOADED'
	init:SetScript('OnEvent', InitialiseBar)

 --
