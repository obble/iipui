

	local _, ns = ...
	local var = IIP_VAR['bar']

	-- todo: reorient flyover buttons

	ns.bar_elements = {} --  inserted in buttons.lua
	ns.bar_elements_nohide = {}

	local e = CreateFrame'Frame'
	local petbattle = false

	local bar = CreateFrame('Frame', 'iipbar', UIParent)
	bar:SetHeight(250)
	bar:SetPoint('LEFT', 350, 0)
	bar:SetPoint('RIGHT', -350, 0)
	bar:SetPoint'BOTTOM'
	bar:SetFrameLevel(0)
	bar:SetFrameStrata'LOW'

	bar.collapse = CreateFrame('Frame', nil, bar)
	bar.collapse:SetHeight(100)
	bar.collapse:SetPoint'LEFT'
	bar.collapse:SetPoint'RIGHT'
	bar.collapse:SetPoint('TOP', bar, 'BOTTOM', 0, 42)

	local bar2 = CreateFrame('Frame', 'iipbar2', UIParent)
	bar2:SetSize(150, 550)
	bar2:SetPoint('RIGHT', 0, -120)
	bar2:SetFrameLevel(0)
	bar2:SetFrameStrata'MEDIUM'

	bar.t = bar.collapse:CreateTexture(nil, 'BACKGROUND')
	bar.t:SetSize(310, 20)
	bar.t:SetPoint'TOP'
	bar.t:SetTexture[[Interface\QUESTFRAME\AutoQuest-Parts]]
	bar.t:SetTexCoord(.44, .9, 0, .5)
	bar.t:SetAlpha(.65)

	local ToggleButtons = function(show)
		if  HasExtraActionBar() then
			local bar = ExtraActionBarFrame
			local cd  = _G['ExtraActionButton1Cooldown']
			cd:SetDrawBling(show)
			bar:SetAlpha(show and 1 or 0)
		end
		for i = 1, 12 do
			for _, v in pairs(
				{
					'ActionButton',
					'MultiBarBottomLeftButton',
					'MultiBarBottomRightButton',
					'MultiBarLeftButton',
					'MultiBarRightButton',
					'StanceButton',
					'PetActionButton',
				}
			) do
				local bu = _G[v..i]
				if  bu and bu:IsShown() then
					bu.cooldown:SetDrawBling(show)
					bu:SetAlpha(show and 1 or 0)
				end
			end
		end
	end

	local ToggleFrames = function(show)
		--[[if 	show then
			MainMenuBarPageNumber:Show()
		else
			MainMenuBarPageNumber:Hide()
		end]]
		for _, v in pairs(ns.bar_elements) do
			local n = v:GetName()
			if 	n == nil or not n:match'ActionButton(.+)' then
				v:SetAlpha(show and 1 or 0)
			end
		end
	end

	local ToggleBars = function(show)
		for i = 1, 7 do
			local f = _G['iipaction'..i]
			if  f and f:GetBackdrop() then
				f:SetBackdropColor(0, 0, 0, show and 1 or 0)
			end
		end
	end

	local UpdateElements = function(show)
		ToggleButtons(show)
		ToggleFrames(show)
		ToggleBars(show)
		bar.shown = show
	end

	local grow = function(self)
		local x = {bar.collapse:GetPoint()}
		local z =  bar:GetHeight()/5
		if 	x[5] < z then
			bar.collapse:SetPoint('TOP', bar, 'BOTTOM', 0, x[5] + 12)
			UpdateElements(x[5] > (bar:GetHeight()/5 - 20) and true or false)
		else
			self:SetScript('OnUpdate', nil)
		end
	end

	local shrink = function(self)
		local x = {bar.collapse:GetPoint()}
		local z =  bar:GetHeight()/4
		if 	x[5] > 4 then
			bar.collapse:SetPoint('TOP', bar, 'BOTTOM', 0, x[5] - 12)
			UpdateElements(x[5] > (bar:GetHeight()/4 - 20) and true or false)
		else
			self:SetScript('OnUpdate', nil)
		end
	end

	local OnEnter = function()
		if petbattle then return end
		bar:SetScript('OnUpdate', grow)
	end

	local OnLeave = function()
		if (ns.bar_always and not petbattle) or ns.bar_spellbook or (var and var.combat and InCombatLockdown()) then return end
		bar:SetScript('OnUpdate', shrink)
	end

	local OnShow = function()
		ns.bar_spellbook = true
		OnEnter()
	end

	local OnHide = function()
		ns.bar_spellbook = false
		OnLeave()
	end

	local OnLock = function(ignore)
		if  var and var.always then
			e:UnregisterAllEvents()
			e:SetScript('OnEvent', nil)
			ns.bar_always = true
			OnEnter()
		elseif not ignore then
			ns.bar_always = false
			OnLeave()
		end
	end

	local OnCombat = function()
		if  var and var.combat then
			e:RegisterEvent'PLAYER_REGEN_DISABLED'
			e:RegisterEvent'PLAYER_REGEN_ENABLED'
			e:SetScript('OnEvent', function(self, event)
			  	if event == 'PLAYER_REGEN_DISABLED' then
				  	OnEnter()
			  	else
				  	OnLeave()
			  	end
		  	end)
		else
			e:UnregisterEvent'PLAYER_REGEN_DISABLED'
			e:UnregisterEvent'PLAYER_REGEN_ENABLED'
			e:SetScript('OnEvent', nil)
		end
	end

	ns.AddBarLocks = function(ignore)
		OnCombat()
		OnLock(ignore)
	end

	ns.AddBarMouseoverElements = function()		-- assert "sticky" behaviour for bar pseudo-children
		ns.AddBarLocks(true)					-- preventing the bar collapsing when we mouseover elements within
		for _, v in pairs(
			{
				ns.bar_elements,
				ns.bar_elements_nohide
			}
		) do
			for k, j in pairs(v) do
				if not j.RegisteredForBar then
					j:HookScript('OnEnter', OnEnter)
					j:HookScript('OnLeave', OnLeave)
					j.RegisteredForBar = true
				end
			end
		end			  						-- defined in customise/customise.lua
		for  _, v in pairs(ns.bar_elements_custom) do
			if 	v and not ns.bar_elements[v] then
				tinsert(ns.bar_elements, v)
			end
		end
	end

	iipBarToggle = function()					-- global for keybind
		if  not bar.elementsShown then
			ns.bar_always = true
			OnEnter()
		else
			ns.bar_always = false
			OnLeave()
		end
	end

	local OnEvent = function(self, event)		--  fire on load, and then AGAIN when variables load in
		C_Timer.After(2, function()				-- build in a delay
			ns.AddBarMouseoverElements() 					--  hijack to scoop up bar_elements
			if  ns.bar_always then
				OnEnter()
			else
				OnLeave()
			end
		end)
	end

	local PetBattleOnEvent = function(self, event)
		if  event == 'PET_BATTLE_CLOSE' then
			petbattle = false
			if ns.bar_always then OnEnter() end
		else
			if ns.bar_always then OnLeave() end
			petbattle = true
		end
	end

	local NewActionHighlightUpdate = function()
		OnEnter()
		C_Timer.After(5, function()
			local focus = GetMouseFocus()
			if  not var.always and not var.combat and not ns.bar_elements[focus] and not ns.bar_spellbook then
				OnLeave()
			end
		end)
	end

	ns.grow 	= OnEnter
	ns.shrink 	= OnLeave

	bar:SetScript('OnEnter',  OnEnter)
	bar:SetScript('OnLeave',  OnLeave)
	bar2:SetScript('OnEnter', OnEnter)
	bar2:SetScript('OnLeave', OnLeave)

	SpellBookFrame:HookScript('OnShow', OnShow)
	SpellBookFrame:HookScript('OnHide', OnHide)

	hooksecurefunc('MarkNewActionHighlight', NewActionHighlightUpdate)

	local init = CreateFrame'Frame'
	init:RegisterEvent'PLAYER_LOGIN'
	init:RegisterEvent'VARIABLES_LOADED'
	init:SetScript('OnEvent', OnEvent)

	local pet = CreateFrame'Frame'
	pet:RegisterEvent'PET_BATTLE_OPENING_START'
	pet:RegisterEvent'PET_BATTLE_CLOSE'
	pet:SetScript('OnEvent', PetBattleOnEvent)


	--
