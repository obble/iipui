
	-- based on lightspark's actionbars now

	local _, ns = ...

	local ABARS 	= {}
	local e, re		= CreateFrame'Frame', CreateFrame'Frame'
	local created 	= false

	local controller
	local anim_controller

	local LibActionButton = LibStub'LibActionButton-1.0-ls'

	local hide = CreateFrame'Frame'
	hide:Hide()

	local bars = {
		['bar1'] = {
			buttons				= 'Action',
			flyout				= 'UP',
			grid				= true,
			name				= 'iipActionBar1',
			num 				= 12,
			padding 			= 9,
			positions			= {'BOTTOM', UIParent, 'BOTTOM', 0, 	80},
			wrappositions		= {'BOTTOM', UIParent, 'BOTTOM', -120, 	80},
			row					= 12,
			size 				= 30,
			type				= 'ACTIONBUTTON',
			visibility 			= '[vehicleui][petbattle][possessbar] hide; show',
			textureL			= {.02, .5, 0, 1},
			textureR			= {.5, .98, 0, 1},
			textureLpositionsT	= {'TOPLEFT', nil, 'TOPLEFT', -11, 14},	-- parent (textureLpositions[2]) defined in call
			textureLpositionsB	= {'BOTTOMRIGHT', nil, 'BOTTOM', 0, -16},
			textureRpositionsT	= {'TOPRIGHT', nil, 'TOPRIGHT', 11, 14},
			textureRpositionsB	= {'BOTTOMLEFT', nil, 'BOTTOM', 0, -16},
			textureShadowT		= {'TOPLEFT', nil, 'TOPLEFT', -32, 14},
			textureShadowB		= {'BOTTOMRIGHT', nil, 'BOTTOMRIGHT', 6, -14},
		},
		['bar2'] = {
			buttons				= 'MultiBarBottomLeft',
			flyout				= 'UP',
			grid				= true,
			name				= 'iipActionBar2',
			num 				= 12,
			padding 			= 9,
			page				= 6,
			positions			= {'BOTTOM', UIParent, 'BOTTOM', 0, 119},
			wrappositions		= {'BOTTOM', UIParent, 'BOTTOM', -120, 	119},
			row					= 12,
			size 				= 30,
			type				= 'MULTIACTIONBAR1BUTTON',
			visibility 			= '[vehicleui][petbattle][overridebar][possessbar] hide; show',
			textureL			= {.018, .5, 0, .8},
			textureR			= {.5, .982, 0, .8},
			textureLpositionsT	= {'TOPLEFT', nil, 'TOPLEFT', -12, 14},
			textureLpositionsB	= {'BOTTOMRIGHT', nil, 'BOTTOM', 0, -2},
			textureRpositionsT	= {'TOPRIGHT', nil, 'TOPRIGHT', 12, 14},
			textureRpositionsB	= {'BOTTOMLEFT', nil, 'BOTTOM', 0, -2},
			textureShadowT		= {'TOPLEFT', nil, 'TOPLEFT', -28, 14},
			textureShadowB		= {'BOTTOMRIGHT', nil, 'BOTTOMRIGHT', 6, -14},
		},
		['bar3'] = {
			buttons				= 'MultiBarBottomRight',
			flyout				= 'UP',
			grid				= true,
			name				= 'iipActionBar3',
			num 				= 12,
			padding 			= 9,
			page				= 5,
			positions			= {'BOTTOM', UIParent, 'BOTTOM', 231, 80},
			row					= 6,
			size 				= 30,
			type				= 'MULTIACTIONBAR2BUTTON',
			visibility 			= '[vehicleui][petbattle][overridebar][possessbar] hide; show',
			textureL			= {.2, 1, 0, 1},
			textureR			= {.2, 1, 0, 1},
			textureLpositionsT	= {'TOPLEFT', nil, 'TOPLEFT', -2, 14},
			textureLpositionsB	= {'BOTTOMRIGHT', nil, 'RIGHT', 15, -10},
			textureRpositionsT	= {'TOPRIGHT', nil, 'LEFT', -2, 12},
			textureRpositionsB	= {'BOTTOMLEFT', nil, 'BOTTOMRIGHT', 15, -15},
			textureShadowT		= {'TOPLEFT', nil, 'TOPLEFT', -28, 14},
			textureShadowB		= {'BOTTOMRIGHT', nil, 'BOTTOMRIGHT', 20, -14},
		},
		['bar4'] = {
			buttons				= 'MultiBarLeft',
			flyout				= 'LEFT',
			grid				= true,
			name				= 'iipActionBar4',
			num 				= 12,
			padding 			= 9,
			page				= 4,
			positions			= {'BOTTOMLEFT', UIParent, 'BOTTOMRIGHT', -130, 232},
			row					= 1,
			size 				= 30,
			type				= 'MULTIACTIONBAR4BUTTON',
			visibility 			= '[vehicleui][petbattle][overridebar][possessbar] hide; show',
		},
		['bar5'] = {
			buttons				= 'MultiBarRight',
			flyout				= 'LEFT',
			grid				= true,
			name				= 'iipActionBar5',
			num 				= 12,
			padding 			= 9,
			page				= 4,
			positions			= {'BOTTOMLEFT', UIParent, 'BOTTOMRIGHT', -91, 232},
			row					= 1,
			size 				= 30,
			type				= 'MULTIACTIONBAR3BUTTON',
			visibility 			= '[vehicleui][petbattle][overridebar][possessbar] hide; show',
		},
	}

	local PAGES = {
		['DEFAULT'] = '[vehicleui][possessbar] 12; [shapeshift] 13; [overridebar] 14; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;',
		['DRUID'] 	= '[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:3] 9; [bonusbar:4] 10;',
		['ROGUE'] 	= '[bonusbar:1] 7;',
	}

	local rebindable = {
		bar1 = true,
		bar2 = true,
		bar3 = true,
		bar4 = true,
		bar5 = true,
	}

	local keys = {
		KEY_NUMPADDECIMAL	= 'Nu.',
		KEY_NUMPADDIVIDE	= 'Nu/',
		KEY_NUMPADMINUS		= 'Nu-',
		KEY_NUMPADMULTIPLY 	= 'Nu*',
		KEY_NUMPADPLUS 		= 'Nu+',
		KEY_MOUSEWHEELUP	= '^U',
		KEY_MOUSEWHEELDOWN 	= '⌄D',
		KEY_NUMLOCK 		= 'NuLk',
		KEY_PAGEUP			= 'PU',
		KEY_PAGEDOWN 		= 'PD',
		KEY_SPACE			= 'Space',
		KEY_INSERT			= 'Ins',
		KEY_HOME			= 'Hm',
		KEY_DELETE			= 'Del',
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

	local AddBarPage = function()
		local _, class 	= UnitClass'player'
		local condition = PAGES['DEFAULT']
		local page 		= PAGES[class]

		if  page then
			condition = condition..' '..page
		end

		return condition..' [form] 1; 1'
	end

	local AddConfig = function(self)
		if  not self.buttonConfig then
			self.buttonConfig = {
				tooltip 		= 'enabled',
				colors 			= {},
				hideElements 	= {
					equipped = false,
				},
			}
		end

		self.buttonConfig.clickOnDown 			= false
		self.buttonConfig.desaturateOnCooldown 	= true
		self.buttonConfig.drawBling 			= true
		self.buttonConfig.flyout 				= 'UP'
		self.buttonConfig.outOfManaColoring 	= true
		self.buttonConfig.outOfRangeColoring 	= true
		self.buttonConfig.showGrid 				= tonumber(GetCVar'alwaysShowActionBars')

		self.buttonConfig.colors.mana 			= {r = 38/255, 	g = 97/255,	b = 172/255}
		self.buttonConfig.colors.normal 		= {r = 1,		g = 1,		b = 1}
		self.buttonConfig.colors.range 			= {r = 141/255, g = 28/255, b = 33/255}


		self.buttonConfig.hideElements.hotkey 	= false
		self.buttonConfig.hideElements.macro 	= false

		for i, bu in pairs(self._buttons) do
			self.buttonConfig.keyBoundTarget = bu._command
			bu.keyBoundTarget = self.buttonConfig.keyBoundTarget
			bu:UpdateConfig(self.buttonConfig)
			bu:SetAttribute('buttonlock', tonumber(GetCVar'lockActionBars') == 1 and true or false)
			bu:SetAttribute('checkselfcast',  true)
			bu:SetAttribute('checkfocuscast', true)
			bu:SetAttribute('*unit2', 'player') -- 'player' or nil
		end
	end

	local UpdateButtons = function(self, method, ...)
		for _,  button in next, self._buttons do
			if  button[method] then
				button[method](button, ...)
			end
		end
	end

	local UpdateBars = function(_, method, ...)
		for _,  bar in next, ABARS do
			if  bar[method] then
				bar[method](bar, ...)
			end
		end
	end

	local UpdateVisibility = function()
		local states = {
			['bar1'] = true,
			['bar2'] = SHOW_MULTI_ACTIONBAR_1,
			['bar3'] = SHOW_MULTI_ACTIONBAR_2,
			['bar4'] = SHOW_MULTI_ACTIONBAR_3,
			['bar5'] = SHOW_MULTI_ACTIONBAR_3 and SHOW_MULTI_ACTIONBAR_4,
		}
		for id,  bar in next, ABARS do
			RegisterStateDriver(bar, 'visibility', states[id] and bars[id].visibility or 'hide')
		end
	end

	local ShortenBindings = function(self)
		local t = self._command and GetBindingKey(self._command) or nil

		if  t then
			t = gsub(t, 'SHIFT%-', 'S·')
			t = gsub(t, "CTRL%-",  'C·')
			t = gsub(t, 'ALT%-',   'A·')
			t = gsub(t, 'BUTTON',  'M·')
			t = gsub(t, 'NUMPAD',  'Nu')
			for i, v in pairs(keys) do
				t = gsub(t, i, v)
			end
		end

		return t or ''
	end

	local UpdateHotkeyText = function(self)
		self:SetFormattedText('%s', ShortenBindings(self:GetParent()))
	end

	local UpdateMacroText = function(self, text)
		text = text or self:GetText()
		if  text then
			self:SetFormattedText('%s', text:sub(1, 3))
		end
	end

	local UpdateHotkey = function(self)
		self.HotKey:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE')
		self.HotKey:SetTextColor(1, 1, 1)
		self.HotKey:ClearAllPoints()
		self.HotKey:SetPoint'TOPLEFT'
		self.HotKey:SetWidth(100)
		self.HotKey:SetJustifyH'LEFT'

		UpdateHotkeyText(self.HotKey)
		hooksecurefunc(self.HotKey, 'SetText', UpdateHotkeyText)
	end

	local UpdateMacro = function(self)
		self.Name:SetFont(STANDARD_TEXT_FONT, 9)

		UpdateMacroText(self.Name)
		hooksecurefunc(self.Name, 'SetText', UpdateMacroText)
	end

	local UpdateBorderColour = function(self)
		local button = self:GetParent()
		for _, v in pairs(button.bo) do
			local equip = button:IsEquipped()
			v:SetVertexColor(equip and 0 or 1, 1, equip and 0 or 1)
		end
	end

	local ReassignBindings = function()
		if  not InCombatLockdown() then
			for id, bar in next, ABARS do
				if  rebindable[id] then
					ClearOverrideBindings(bar)
					for _, button in next, bar._buttons do
						for k = 1, select('#', GetBindingKey(button._command)) do
	                        local key = select(k, GetBindingKey(button._command))
	                        if  key and key ~= '' then
	                            SetOverrideBindingClick(bar, false, key, button:GetName())
	                        end
	                    end
					end
				end
			end
		end
	end

	local ClearBindings = function()
		if  not InCombatLockdown() then
			for id, bar in next, ABARS do
				if  rebindable[id] then
					ClearOverrideBindings(bar)
				end
			end
		end
	end

	local AddPositions = function(self)
		local t 		= bars[self._id]
		local width 	= t.size
		local height 	= t.size
		local num 		= min(t.num, #self._buttons)
		local wMult 	= min(num, t.row)
		local hMult 	= ceil(num/t.row)

		local initialAnchor = 'BOTTOMLEFT'
		local xDir, yDir 	= 1, 1

		self:SetSize(
			t.size*wMult + ((t.padding*wMult) - 5),
			t.size*hMult + ((t.padding*hMult) - 4)
		)

		for i, button in next, self._buttons do
			button:ClearAllPoints()

			if  i <= num then
				local col = (i - 1) % t.row
				local row = floor((i - 1) / t.row)

				button:SetParent(button._parent)
				button:SetFrameLevel(self:GetFrameLevel() + 1)
				button:SetSize(width, height)
				button:SetPoint(initialAnchor, self, initialAnchor, xDir * (2 + col * (t.padding + width)), yDir * (2 + row * (t.padding + height)))
			else
				button:SetParent(hide)
			end
		end
	end

	local Update = function(self)
		UpdateVisibility(self)
		UpdateButtons(self, 'UpdateHotKey')
		UpdateButtons(self, 'UpdateMacro')
		AddConfig(self)
	end

	local AddBars = function()
		for id, data in next, bars do
			local bar = CreateFrame('Frame', data.name, UIParent, 'SecureHandlerStateTemplate')
			bar._id 		= id
			bar._buttons 	= {}

			ns.BD(bar)
			add(bar)

			ABARS[id] = bar

			bar.UpdateConfig 		= AddConfig
			bar.UpdateVisibility	= UpdateVisibility
			bar.Update 				= Update
			bar.UpdateButtonConfig 	= AddConfig

			if 	bar._buttons then
				bar.UpdateButtons = UpdateButtons
			end

			if  data.textureL then
				bar.t = bar:CreateTexture(nil, 'ARTWORK')
				bar.t:SetAllPoints()
				bar.t:SetTexture[[Interface/PLAYERACTIONBARALT/STONE]]
				bar.t:SetTexCoord(0, 1, .18, .3)

				bar.boL = bar:CreateTexture(nil, 'BACKGROUND', nil, -6)
				bar.boL:SetPoint(data.textureLpositionsT[1], bar, data.textureLpositionsT[3], data.textureLpositionsT[4], data.textureLpositionsT[5])
				bar.boL:SetPoint(data.textureLpositionsB[1], bar, data.textureLpositionsB[3], data.textureLpositionsB[4], data.textureLpositionsB[5])
				bar.boL:SetTexture[[Interface/ACHIEVEMENTFRAME/UI-Achievement-Alert-Background-Mini]]
				bar.boL:SetVertexColor(.9, .9, .9)
				bar.boL:SetTexCoord(unpack(data.textureL))

				bar.boR = bar:CreateTexture(nil, 'BACKGROUND', nil, -6)
				bar.boR:SetPoint(data.textureRpositionsT[1], bar, data.textureRpositionsT[3], data.textureRpositionsT[4], data.textureRpositionsT[5])
				bar.boR:SetPoint(data.textureRpositionsB[1], bar, data.textureRpositionsB[3], data.textureRpositionsB[4], data.textureRpositionsB[5])
				bar.boR:SetTexture[[Interface/ACHIEVEMENTFRAME/UI-Achievement-Alert-Background-Mini]]
				bar.boR:SetVertexColor(.9, .9, .9)
				bar.boR:SetTexCoord(unpack(data.textureR))

				bar.shadow = bar:CreateTexture(nil, 'BACKGROUND', nil, -7)
				bar.shadow:SetPoint(data.textureShadowT[1], bar, data.textureShadowT[3], data.textureShadowT[4], data.textureShadowT[5])
				bar.shadow:SetPoint(data.textureShadowB[1], bar, data.textureShadowB[3], data.textureShadowB[4], data.textureShadowB[5])
				bar.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
				bar.shadow:SetVertexColor(0, 0, 0, 1)
				bar.shadow:SetTexCoord(0, .641, 0, .18)
			end

			for  i = 1, data.num do
				local button = LibActionButton:CreateButton(i, '$parentButton'..i, bar)
				button:SetState(0, 'action', i)
				for k = 1, 14 do
					button:SetState(k, 'action', (k - 1) * 12 + i)
				end

				add(button)

				button._parent 	= bar
				button._command = data.type..i

				button.UpdateFlyoutDirection 	= AddConfig
				button.UpdateGrid 				= AddConfig
				button.UpdateCountFont 			= UpdateFont
				button.UpdateHotKey 			= UpdateHotkey
				button.UpdateMacro 				= UpdateMacro

				if  not button.bo then
					ns.BU(button, .75, true, 30)
					ns.BUElements(button)
					ns.BUBorder(button)
					hooksecurefunc(button.Border, 'Show', UpdateBorderColour)
					hooksecurefunc(button.Border, 'Hide', UpdateBorderColour)
				end

				local bu = _G[data.buttons..'Button'..i]
				bu:SetAllPoints(button)
				bu:SetAttribute('statehidden', true)
				bu:SetParent(hide)
				bu:SetScript('OnEvent', nil)
				bu:SetScript('OnUpdate', nil)
				bu:UnregisterAllEvents()

				bar._buttons[i] = button
			end

			bar:SetAttribute('_onstate-page', [[
				if HasTempShapeshiftActionBar() then
					newstate = GetTempShapeshiftBarIndex() or newstate
				end
				self:SetAttribute('state', newstate)
				control:ChildUpdate('state', newstate)
			]])

			RegisterStateDriver(bar, 'page', id == 'bar1' and AddBarPage() or data.page)
		end

		for id, bar in next, ABARS do
			if  id == 'bar1' then
				for i = 1, 12 do
					bar:SetFrameRef('button'..i, _G['iipActionBar1Button'..i])
				end

				controller:Execute([[
					buttons = table.new()
					for i = 1, 12 do
						table.insert(buttons, self:GetFrameRef('button'..i))
					end
				]])

				controller:SetAttribute('_onstate-page', [[
					-- print('_onstate-page','index',newstate)
					for i, button in next, buttons do
					  button:SetAttribute('actionpage', newstate)
					end
				]])

				RegisterStateDriver(controller, 'mode', '[vehicleui][petbattle][overridebar][possessbar] 6; 12')
			end

			AddPositions(bar)
			Update(bar)
		end
	end

	local AddWrapper = function()
		controller = CreateFrame('Frame', 'iipActionBarWrapper', UIParent, 'SecureHandlerStateTemplate')
		controller:SetSize(32, 32)
		controller:SetPoint'BOTTOM'
		controller:SetAttribute('numbuttons', 12)
	end

	local SetPositions = function()
		for id,  bar in next, ABARS do
			local one, two, three, four	= GetActionBarToggles()
			local bar2 = _G['iipbar2']
			local t	= bars[id]
			local point

			if  three or four then
				bar2:Show()
			else
				bar2:Hide()
			end


			if  two and t.wrappositions then
				point = t.wrappositions
			else
				point = t.positions
			end

			bar:ClearAllPoints()
			bar:SetPoint(point[1], point[2], point[3], point[4], point[5])
			UpdateVisibility(bar)
		end
	end

	local PositionBarsAfterCombat = function()
		e:UnregisterEvent'PLAYER_REGEN_ENABLED'
		SetPositions()
	end

	re:SetScript('OnEvent', PositionBarsAfterCombat)

	local PLAYER_LOGIN = function()
		if  not created then
			AddWrapper()
			AddBars()

			-- MODULE:CreatePetActionBar()
			-- MODULE:CreatePetBattleBar()
			-- MODULE:CreateExtraButton()
			-- MODULE:CreateZoneButton()
			-- MODULE:CreateVehicleExitButton()
			-- CreateMicroMenu()
			-- CreateXPBar()

			ReassignBindings()

			--MODULE:UpdateBlizzVehicle()

			e:RegisterEvent('PET_BATTLE_CLOSE',	ReassignBindings)
			e:RegisterEvent('PET_BATTLE_OPENING_DONE', ClearBindings)
			e:RegisterEvent('UPDATE_BINDINGS', ReassignBindings)

			if  C_PetBattles.IsInBattle() then
				ClearBindings()
			else
				ReassignBindings()
			end

			SetPositions()
			hooksecurefunc('MultiActionBar_Update', function()
				if  InCombatLockdown() then
					re:RegisterEvent'PLAYER_REGEN_ENABLED'
				else
					SetPositions()
				end
			end)

			-- completely ridiculous, but this solves the problem with tainting frames
			-- by entering/leaving combat before vars are properly reflecting which of our bars are enabled
			-- ...we just delay its registration past the "not in combat" window after login
			C_Timer.After(2, function()
				hooksecurefunc('SetActionBarToggles', function()
					if  InCombatLockdown() then
						re:RegisterEvent'PLAYER_REGEN_ENABLED'
					else
						C_Timer.After(1.25, SetPositions)
					end
				end)
			end)

			created = true
		end
	end

	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', PLAYER_LOGIN)




	--
