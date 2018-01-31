

    local pins  = {}
    local focus = nil

    StaticPopupDialogs['MAP_PIN_NOTE'] = {
        text = 'Add a Note',
        button2 = CLOSE,
        timeout = 0,
        hasEditBox = 1, maxLetters = 1024, editBoxWidth = 350,
        whileDead = true, hideOnEscape = true,
        OnShow = function(self)
            (self.icon or _G[self:GetName()..'AlertIcon']):Hide()
            local editBox = self.editBox or _G[self:GetName()..'EditBox']
            local pin = focus
            if pin.note then editBox:SetText(pin.note) else editBox:SetText'' end
            editBox:SetFocus()
            local button2 = self.button2 or _G[self:GetName()..'Button2']
            button2:ClearAllPoints()
            button2:SetPoint('TOP', editBox, 'BOTTOM', 0, -6)
            button2:SetWidth(150)
            self:SetFrameStrata'FULLSCREEN'
            WorldMapFrame:SetFrameStrata'DIALOG'
        end,
        OnHide = function(self)
            local editBox = self.editBox or _G[self:GetName()..'EditBox']
            local t = editBox:GetText()
            local pin = focus
            pin.note = t
            focus = nil
            self:SetFrameStrata'DIALOG'
            WorldMapFrame:SetFrameStrata'FULLSCREEN'
        end,
    }

    local create = function(button, z)
        local width  = WorldMapDetailFrame:GetWidth()
        local height = WorldMapDetailFrame:GetHeight()
        local x,  y  = WorldMapDetailFrame:GetCenter()
        local cx, cy = GetCursorPosition()

        x = ((cx/WorldMapDetailFrame:GetEffectiveScale()) - (x - width/2))/width
        y = ((y + height/2) - (cy/WorldMapDetailFrame:GetEffectiveScale()))/height

        if  x >= 0 and y >= 0 and x <= 1 and y <= 1 then
            local p = CreateFrame('Button', z..'iippin'..'_'..x, button)
            p:SetWidth(32) p:SetHeight(32)
            p:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
            p:SetPoint('CENTER', button, 'TOPLEFT', x*width + 8, -y*height + 8)
            p:SetScript('OnClick', function()
                if arg1 == 'RightButton' then
                    focus = p
                    StaticPopup_Show'MAP_PIN_NOTE'
                else
                    p:Hide() p.disable = true p.note = nil
                end
            end)
            p:SetScript('OnEnter', function()
                GameTooltip:SetOwner(p, 'ANCHOR_RIGHT')
                GameTooltip:AddLine(format('Pin: %.0f / %.0f', x*100, y*100))
                if p.note and p.note ~= '' then GameTooltip:AddLine('note: '..p.note) end
                GameTooltip:Show()
            end)
            p:SetScript('OnLeave', function() GameTooltip:Hide() end)
            tinsert(pins, p)

            local path = UnitFactionGroup'player' == 'Alliance' and [[Interface\WorldStateFrame\AllianceFlag]]
                         or [[Interface\WorldStateFrame\HordeFlag]]
            local t = p:CreateTexture(nil, 'BACKGROUND')
            t:SetTexture(path)
            t:SetAllPoints()
        end
    end

    local OnClick = function(button, mButton)
        if  IsShiftKeyDown() then
            local z = GetMapInfo()
            create(button, z)
        end
    end

    local Update = function()
        local  z = GetMapInfo()
        for _, v in pairs(pins) do
            if not v.disable then
                local name = v:GetName()
                if string.find(name, z) then v:Show()
                else v:Hide() end
            end
        end
    end

    WorldMapButton:HookScript('OnClick',    OnClick)

    hooksecurefunc('WorldMapFrame_Update',  Update)


    --
