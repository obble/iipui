
    local _, ns     = ...

    local size      = 5
    local elapsed   = 0

    local coord = CreateFrame('Frame', nil, WorldMapFrame)
    coord:SetFrameLevel(WorldMapFrame:GetFrameLevel() + 2)
    coord:SetPoint('TOPLEFT', WorldMapFrame, 30, -100)
    coord:SetSize(200, 16)

    coord.Player = coord:CreateFontString(nil, 'OVERLAY')
    coord.Player:SetFont(STANDARD_TEXT_FONT, 15, 'OUTLINE')
    coord.Player:SetShadowOffset(0, -0)
    coord.Player:SetJustifyH'LEFT'
    coord.Player:SetPoint'TOPLEFT'
    coord.Player:SetTextColor(1, 1, 1)

    coord.Cursor = coord:CreateFontString(nil, 'OVERLAY')
    coord.Cursor:SetFont(STANDARD_TEXT_FONT, 15, 'OUTLINE')
    coord.Cursor:SetShadowOffset(0, -0)
    coord.Cursor:SetJustifyH'LEFT'
    coord.Cursor:SetPoint('TOPLEFT', coord.Player, 'BOTTOMLEFT', 0, -2)
    coord.Cursor:SetTextColor(1, 1, 1)

    coord:SetScript('OnUpdate', function(self, elapsed)
        local x, y
        local id = C_Map.GetBestMapForUnit'player'
        if  id then
            local player = C_Map.GetPlayerMapPosition(id, 'player')
            if  player then
                x, y = player:GetXY()
            end
        end

        x = x or 0
        y = y or 0

        coord.Player:SetShown(x + y > 0)
        coord.Player:SetText(PLAYER..format(': %.0f / %.0f', x*100, y*100))

        x, y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()

        coord.Cursor:SetShown(x + y > 0)
        coord.Cursor:SetText('Mouse'..format(': %.0f / %.0f', x*100, y*100))
    end)


    WorldMapFrame:HookScript('OnUpdate', function(self, e)
	    elapsed = elapsed + e
	    if elapsed > .5 then -- update frequency
	        elapsed = 0
	        local groupSize = GetNumGroupMembers()
	        if groupSize > 0 then
		        local groupType = IsInRaid() and 'Raid' or 'Party'
		        for i = 1, groupSize do
			        local frame = _G['WorldMap'..groupType..i]
			        if frame then
				        if  not frame.overlay then
					        frame.overlay = frame:CreateTexture(nil, 'OVERLAY')
					        frame.overlay:SetDrawLayer('OVERLAY', 7)
					    end

					    frame.overlay:ClearAllPoints()

					    if  WorldMapFrame_InWindowedMode() then
					        frame.overlay:SetPoint('TOPLEFT', frame.icon, -size - 6, size + 6)
					        frame.overlay:SetPoint('BOTTOMRIGHT', frame.icon, size + 6, -size - 6)
					    else
					        frame.overlay:SetPoint('TOPLEFT', frame.icon, -size, size)
					        frame.overlay:SetPoint('BOTTOMRIGHT', frame.icon, size, -size)
					    end

					    local _, _, subgroup = GetRaidRosterInfo(i)

					    frame.overlay:SetTexture(groupType == 'Raid' and ('Interface\\AddOns\\iipui\\art\\worldmap\\raid'..subgroup) or 'Interface\\AddOns\\iipui\\art\\worldmap\\party')
				        if frame.unit and frame:IsShown() then
				            _, class = UnitClass(frame.unit)
				            color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
					        if color then
						        frame.overlay:SetVertexColor(color.r, color.g, color.b)
					        else
						        frame.overlay:SetVertexColor(103/255, 103/255, 103/255)
					        end
					        if GetTime()%1 < .5 then
						        if UnitAffectingCombat(frame.unit) then
							        frame.overlay:SetVertexColor(1, 0, 0)
						        elseif UnitIsDeadOrGhost(frame.unit) then
							        frame.overlay:SetVertexColor(.2, .2, .2)
						        elseif UnitIsAFK(frame.unit) then
							        frame.overlay:SetVertexColor(89/255, 0/255, 165/255)
						        end
						    end
					    end
				    end
			    end
		    end
	    end
    end)


    --
