

	local _, ns = ...

	local i      = {}
	local Gender = {'neuter or unknown', 'male', 'female'}

	local _, class = UnitClass'player'
	local _, race  = UnitRace'player'
	local colour = ns.INTERNAL_CLASS_COLORS[class]
	local var = IIP_VAR['bar']

	local f = CreateFrame('Frame', 'iipMenu', UIParent)
	f.displayMode = 'MENU'

	local bu = CreateFrame('Button', 'iipMenuButton', MainMenuBarBackpackButton)
	bu:SetSize(21, 21)
	bu:SetPoint('BOTTOMRIGHT', UIParent, -82, 20)
	-- ns.BU(bu, 1, true)

	local allied = {
		['highmountaintauren'] 	= 'Interface\\ICONS\\'..(Gender[UnitSex'player'] == 'male' and 'Inv_misc_head_tauren_01' or 'Inv_misc_head_tauren_02'),
		['lightforgeddraenei'] 	= 'Interface\\ICONS\\ACHIEVEMENT_CHARACTER_DRAENEI_'..Gender[UnitSex'player'],
		['magharorc']			= 'Interface\\ICONS\\ACHIEVEMENT_CHARACTER_ORC_'..Gender[UnitSex'player']..'_BRN',
		['nightborne'] 			= 'Interface\\ICONS\\Inv_nightborne'..Gender[UnitSex'player'],
		['voidelf']				= 'Interface\\AddOns\\iipui\\art\\alliedraces\\race_'..strlower(race)..'_'..Gender[UnitSex'player']..'.tga',
	}

	local mask = bu:CreateMaskTexture()
	mask:SetTexture[[Interface\Minimap\UI-Minimap-Background]]
	mask:SetPoint('TOPLEFT', -3, 3)
	mask:SetPoint('BOTTOMRIGHT', 3, -3)

	bu.hl = bu:CreateTexture('$parentNormalTexture', 'HIGHLIGHT')
	bu.hl:SetAllPoints()
	bu.hl:SetTexture[[Interface\Buttons\ButtonHilight-Square]]
	bu.hl:SetBlendMode'ADD'

	bu.icon = bu:CreateTexture(nil, 'ARTWORK')
	bu.icon:SetPoint('TOPLEFT', -4, 4)
	bu.icon:SetPoint('BOTTOMRIGHT', 4, -4)
	bu.icon:SetTexture(allied[strlower(race)] or 'Interface\\Icons\\Achievement_character_'..strlower(race == 'Scourge' and 'undead' or race)..'_'..Gender[UnitSex'player'])
	bu.icon:AddMaskTexture(mask)

	bu.latency = bu:CreateTexture(nil, 'BACKGROUND')
	ns.BD(bu.latency, 1, -2)
	ns.SB(bu.latency)
	bu.latency:SetSize(22, 3)
	bu.latency:SetPoint('TOP', bu, 'BOTTOM', 1, -1.5)
	bu.latency:SetVertexColor(1, 1, 1)

	bu.bo = bu:CreateTexture(nil, 'OVERLAY')
	bu.bo:SetSize(36, 36)
	bu.bo:SetTexture[[Interface\Artifacts\Artifacts]]
	bu.bo:SetPoint'CENTER'
	bu.bo:SetTexCoord(.25, .34, .86, .9475)
	bu.bo:SetVertexColor(.7, .7, .7)

	local add = function(...)
		level, i, i.icon, i.text, i.colorCode, i.notCheckable, i.func, i.checked, i.hasArrow, i.value, i.disabled = ...
		i.iip		 = true
		i.fontObject = iipMenuFont
		i.padding    = 15
		Lib_UIDropDownMenu_AddButton(i, level)
		wipe(i)
	end

	local AddLatency = function()
		local _, _, home, world = GetNetStats()
		local latency = home > world and home or world
		local r, g, b
		if  latency > PERFORMANCEBAR_MEDIUM_LATENCY then
			r, g, b = 1, 0, 0
		elseif latency > PERFORMANCEBAR_LOW_LATENCY then
			r, g, b = 1, 1, 0
		else
			r, g, b = 0, 1, 0
		end
		bu.latency:SetVertexColor(r, g, b)
	end

	f.initialize = function(self, level)
		if level == 1 then
			--PlaySound'igMainMenuQuit'
			add(
				level, i, nil,
				'iipui', '|c'..colour.colorStr, true,
				nil,
				nil, true, 'iipui'
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/character]],
			    CHARACTER_BUTTON, nil, true,
				function() securecall(ToggleCharacter, 'PaperDollFrame') end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/spell]],
				SPELLBOOK_ABILITIES_BUTTON, nil, true,
				function() securecall(ToggleSpellBook, BOOKTYPE_SPELL) end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/talent]],
				TALENTS_BUTTON, nil, true,
				function() securecall(ToggleTalentFrame) end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/social]],
				SOCIAL_BUTTON, nil, true,
				function() securecall(ToggleFriendsFrame) end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/guild]],
				GUILD, nil, true,
				function() securecall(ToggleGuildFrame) end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/achievement]],
				ACHIEVEMENT_BUTTON, nil, true,
				function() securecall(ToggleAchievementFrame) end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/quest]],
				QUESTLOG_BUTTON, nil, true,
				function() securecall(PVEFrame_ToggleFrame, 'GroupFinderFrame') end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/lfg]],
				GROUP_FINDER, nil, true,
				function() securecall(PVEFrame_ToggleFrame, 'GroupFinderFrame') end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/journal]],
				ADVENTURE_JOURNAL, nil, true,
				function() securecall(ToggleEncounterJournal) end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/pvp]],
				PVP_OPTIONS, nil, true,
				function() securecall(PVEFrame_ToggleFrame, 'PVPUIFrame', HonorFrame) end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/pet]],
				COLLECTIONS, nil, true,
				function(a1, a2, a3)
					if InCombatLockdown() then
						print'|cffffdd00You can\'t open this panel in combat.|r'
						return
					else
						securecall(ToggleCollectionsJournal)
					end
				end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/shop]],
				BLIZZARD_STORE, nil, true,
				function() securecall(ToggleStoreUI) end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/help]],
				HELP_BUTTON, nil, true,
				function() securecall(ToggleHelpFrame) end
			)
			add(
				level, i, 'Interface\\AddOns\\iipui\\art\\menu\\calendar\\calendar1',
				'Calendar', nil, true,
				function() ToggleCalendar() end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/map]],
				WORLD_MAP, nil, true,
				function() securecall(ToggleBattlefieldMinimap) end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/mapzone]],
				BATTLEFIELD_MINIMAP, nil, true,
				function() securecall(ToggleBattlefieldMinimap) end
			)
			add(
				level, i, [[Interface/AddOns/iipui/art/menu/loot]],
				LOOT_ROLLS, IsInInstance'player' and '|cff0ba100' or '|cff999999', true,
				function() securecall(ToggleLootHistoryFrame) end
			)
		elseif level == 2 and LIB_UIDROPDOWNMENU_MENU_VALUE == 'iipui' then
			add(
				level, i, nil,
				'UnitFrame Layout', nil, true,
				nil,
				nil, true, 'UFLayout'
			)
			add(
				level, i, nil,
				'Always Show Actionbar', nil, false,
				function()
					if  var and var.always then
						var.always = false
					else
						var.always = true
					end
					ns.AddBarLocks()
				end,
				var.always, nil
			)
			add(
				level, i, nil,
				'Expand Actionbar in Combat', nil, false,
				function()
					if  var and var.combat then
						var.combat = false
					else
						var.combat = true
					end
					ns.AddBarLocks()
				end,
				var.combat, nil,
				var.combat
			)
		elseif level == 3 and LIB_UIDROPDOWNMENU_MENU_VALUE == 'UFLayout' then
			add(
				level, i, nil,
				'This is Coming Soon', '|cff999999', nil,
				function()

				end,
				true, nil
			)
			-- old i.checked ----- iipRaidLayout == nil or iipRaidLayout == 1
			add(
				level, i, nil,
				'This one too', '|cff999999', nil,
				function() end,
				true, nil
			)
		end
	end

	bu:SetScript('OnEnter', function(self)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		GameTooltip:AddLine(MAINMENU_BUTTON)
		GameTooltip:Show()
	end)

	bu:SetScript('OnLeave', function()
		GameTooltip:Hide()
	end)

	bu:SetScript('OnMouseUp', function(self, button)
		if button == 'RightButton' then
			ToggleCharacter'PaperDollFrame'
		else
			Lib_ToggleDropDownMenu(1, nil, f, self, -160, 400)
		end
	end)

	local OnEvent = function()
		AddLatency()
		f.Ticker = C_Timer.NewTicker(30, function()
			 AddLatency()
		end)
	end

	f:RegisterEvent'PLAYER_LOGIN'
	f:SetScript('OnEvent', OnEvent)


	--
