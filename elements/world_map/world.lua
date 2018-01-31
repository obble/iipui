
    local _, ns     = ...
    
    local size      = 5
    local elapsed   = 0

    local coord = CreateFrame('Frame', nil, WorldMapButton)

    coord.Player = coord:CreateFontString(nil, 'OVERLAY')
    coord.Player:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
    coord.Player:SetShadowOffset(0, -0)
    coord.Player:SetJustifyH'LEFT'
    coord.Player:SetPoint('BOTTOMRIGHT', WorldMapButton, 'BOTTOM', -12, 12)
    coord.Player:SetTextColor(1, 1, 1)

    coord.Cursor = coord:CreateFontString(nil, 'OVERLAY')
    coord.Cursor:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
    coord.Cursor:SetShadowOffset(0, -0)
    coord.Cursor:SetJustifyH'LEFT'
    coord.Cursor:SetPoint('LEFT', coord.Player, 'RIGHT', 3, 0)
    coord.Cursor:SetTextColor(1, 1, 1)

    coord:SetScript('OnUpdate', function(self, elapsed)
        local width = WorldMapDetailFrame:GetWidth()
        local height = WorldMapDetailFrame:GetHeight()
        local mx, my = WorldMapDetailFrame:GetCenter()
        local px, py = GetPlayerMapPosition'player'
        local cx, cy = GetCursorPosition()

        mx = ((cx/WorldMapDetailFrame:GetEffectiveScale()) - (mx - width/2))/width
        my = ((my + height/2) - (cy/WorldMapDetailFrame:GetEffectiveScale()))/height

        if mx >= 0 and my >= 0 and mx <= 1 and my <= 1 then
            coord.Cursor:SetText('•  '..MOUSE_LABEL..format(': %.0f / %.0f', mx*100, my*100))
        else
            coord.Cursor:SetText''
        end

        if px ~= 0 and py ~= 0 then
            coord.Player:SetText(PLAYER..format(': %.0f / %.0f', px*100, py*100))
        else
            coord.Player:SetText'X / X'
        end

            -- update font size based on windowed mode
        if WorldMapFrame_InWindowedMode() then
            coord.Player:SetFont(STANDARD_TEXT_FONT, 22, 'OUTLINE')
            coord.Cursor:SetFont(STANDARD_TEXT_FONT, 22, 'OUTLINE')
        else
           coord.Player:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
           coord.Cursor:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
        end
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
