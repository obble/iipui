

	local _, ns = ...

	local i      = {}
	local Gender = {'neuter or unknown', 'male', 'female'}

	local _, class = UnitClass'player'
	local _, race  = UnitRace'player'
	local colour = ns.INTERNAL_CLASS_COLORS[class]

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

	--[[bu.bo.m = bu:CreateMaskTexture()
	bu.bo.m:SetTextureInterface\Minimap\UI-Minimap-Background
	bu.bo.m:SetAllPoints()]]

	bu.bo = bu:CreateTexture(nil, 'OVERLAY')
	bu.bo:SetSize(36, 36)
	bu.bo:SetTexture[[Interface\Artifacts\Artifacts]]
	bu.bo:SetPoint'CENTER'
	bu.bo:SetTexCoord(.25, .34, .86, .9475)

	local add = function(...)
		level, i, i.icon, i.text, i.colorCode, i.notCheckable, i.func, i.checked, i.hasArrow, i.value, i.disabled = ...
		i.iip		 = true
		i.fontObject = iipMenuFont
		i.padding    = 15
		Lib_UIDropDownMenu_AddButton(i, level)
		wipe(i)
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
				'Basic Options', nil, true,
				nil,
				nil, true, 'BasicOptions'
			)
			add(
				level, i, nil,
				'Clock Size', nil, true,
				nil,
				nil, true, 'ClockSize'
			)
			add(
				level, i, nil,
				'Always Show Actionbar', nil, false,
				function()
					if  iipAlwaysActionBar == 1 then
						iipAlwaysActionBar = 0
					else
						iipAlwaysActionBar = 1
					end
					ns.AddBarLocks()
				end,
				iipAlwaysActionBar == 1, nil
			)
			add(
				level, i, nil,
				'Expand Actionbar in Combat', nil, false,
				function()
					if  iipCombatActionBar == 1 then
						iipCombatActionBar = 0
					else
						iipCombatActionBar = 1
					end
					ns.AddBarLocks()
				end,
				iipCombatActionBar == 1, nil,
				iipAlwaysActionBar == 1
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
		elseif level == 3 and LIB_UIDROPDOWNMENU_MENU_VALUE == 'BasicOptions' then
			add(
				level, i, nil,
				'Show Minimap Banner', nil, false,
				function()
					if IIP_VAR['minimap'].show_banner then
						IIP_VAR['minimap'].show_banner = false
					else
						IIP_VAR['minimap'].show_banner = true
					end
					Minimap:UpdateBanner()
				end,
				IIP_VAR['minimap'].show_banner == true, nil
			)
		elseif level == 3 and LIB_UIDROPDOWNMENU_MENU_VALUE == 'ClockSize' then
			add(
				level, i, nil,
				'Small', nil, false,
				function()
					if IIP_VAR['clock'].fontsize ~= 'small' then
						IIP_VAR['clock'].fontsize = 'small'
						iipclock:UpdateSize()
					end
				end,
				IIP_VAR['clock'].fontsize == 'small', nil
			)
			add(
				level, i, nil,
				'Medium', nil, false,
				function()
					if IIP_VAR['clock'].fontsize ~= 'medium' then
						IIP_VAR['clock'].fontsize = 'medium'
						iipclock:UpdateSize()
					end
				end,
				IIP_VAR['clock'].fontsize == 'medium', nil
			)
			add(
				level, i, nil,
				'Large', nil, false,
				function()
					if IIP_VAR['clock'].fontsize ~= 'large' then
						IIP_VAR['clock'].fontsize = 'large'
						iipclock:UpdateSize()
					end
				end,
				IIP_VAR['clock'].fontsize == 'large', nil
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


	--
