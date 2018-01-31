

	local _, ns = ...

	RAID_NOTICE_DEFAULT_HOLD_TIME = 5

	for i = 1, 2 do
        local bu = CreateFrame('Frame', 'iipbossemoteicon'..i, RaidBossEmoteFrame)
		ns.BD(bu)
		bu:SetSize(20, 20)
        bu:SetPoint('RIGHT', 'RaidBossEmoteFrameSlot'..i, 'LEFT', -20, i > 1 and 2 or 0)

		bu.icon = bu:CreateTexture(nil, 'ARTWORK')
		bu.icon:SetTexCoord(.1, .9, .1, .9)
        bu.icon:SetAllPoints()

        FadingFrame_OnLoad(bu)
    	FadingFrame_SetFadeInTime(bu, RAID_NOTICE_FADE_IN_TIME)
    	FadingFrame_SetHoldTime(bu, RAID_NOTICE_FADE_IN_TIME)
    	FadingFrame_SetFadeOutTime(bu, RAID_NOTICE_FADE_OUT_TIME)

		for _, slot in pairs({_G['RaidBossEmoteFrameSlot'..i], _G['RaidWarningFrameSlot'..i]}) do
			slot:SetJustifyH'LEFT'
			if i == 2 then
				slot:ClearAllPoints()
				slot:SetPoint('BOTTOM', slot == _G['RaidBossEmoteFrameSlot2'] and _G['RaidBossEmoteFrameSlot1'] or _G['RaidWarningFrameSlot1'], 'TOP', 0, 10)
			end
		end
    end

	local strings = {ZoneTextFrame, PVPInfoTextString, PVPArenaTextString, PVPInfoTextString}

	local ic = function(bu, icon, hasIcon, time)
		if  icon ~= nil then	-- convert icon string to texture
			bu.icon:SetTexture([[Interface\Icons\]]..icon)
			bu.hasIcon = true
			FadingFrame_SetHoldTime(bu, time or RAID_NOTICE_DEFAULT_HOLD_TIME)
			FadingFrame_Show(bu)
		else
			bu.hasIcon = false
		end
	end

						-- reposition zone text
	hooksecurefunc('SetZoneText', function(show)
		for _, v in pairs(strings) do
			v:Hide()
		end

		SubZoneTextFrame:SetParent(UIParent)
		SubZoneTextString:SetJustifyH'CENTER'
		ns.DELEGATE_FRAMES_TO_POSITION[SubZoneTextFrame]  = {'BOTTOM', UIParent, 0, 160}

		if not show then PVPInfoTextString:SetText'' end
	end)

						-- hook raidnotice to sub boss emotes w/ icons in the strings
						-- to strings placed next to an actual texture icon (to skin)
	hooksecurefunc('RaidNotice_SetSlot', function(f, text, colour, height, time)
        local icon
        local hasIcon = false

        if  text:find'|TInterface\\Icons\\(.+)|t' then
            icon = gsub(text, '|TInterface\\Icons\\(.+)|t(.+)', '%1')
			icon = gsub(icon, ':%d+', '')	--  strip size/offset/texcoord
			text = gsub(text, '|T(.+)|t', '')
			hasIcon = true
			-- print('boss emote 1:  '..icon)
			-- print('boss emote 2:  '..text)
		elseif text:find'|T' then	-- hide other textures (raidicons, DBM icons etc), they're nearly always spam
			text = gsub(text, '|T(.+)|t', '')
        end

        ic(f:GetName() == 'RaidBossEmoteFrameSlot1' and _G['iipbossemoteicon1'] or _G['iipbossemoteicon2'], icon, hasIcon, time)

						-- strip brackets off've items/links
        text = gsub(text, '|H(.-)|h%[(.-)%]|h', '|H%1|h%2|h')

        f:SetText(text)
		f:SetWidth(200)
		f:SetTextHeight(14)

		RaidWarningFrame:ClearAllPoints()
		RaidWarningFrame:SetPoint('TOP', UIParent, 0, -160)
    end)

						-- fade our new icons appropriately
    hooksecurefunc('RaidNotice_UpdateSlot', function(f, timings, elapsed, hasfading)
		f:SetTextHeight(14)
        if  hasfading then
            if f:GetName() == 'RaidBossEmoteFrameSlot1' then
                local bu = _G['iipbossemoteicon1']
				if bu.hasIcon then FadingFrame_OnUpdate(bu) end
            else
                local bu = _G['iipbossemoteicon2']
                if bu.hasIcon then FadingFrame_OnUpdate(bu) end
            end
        end
    end)


	--
