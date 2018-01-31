

    local _, ns = ...
    local f = CreateFrame'Frame'

    local TalkingHead = function()
        TalkingHeadFrame:SetSize(240, 68)
        TalkingHeadFrame:ClearAllPoints()
        TalkingHeadFrame:SetPoint('BOTTOM', UIParent, -20, 230)
        UIPARENT_MANAGED_FRAME_POSITIONS.TalkingHeadFrame = nil

        TalkingHeadFrame.NameFrame:SetSize(68, 24)
        TalkingHeadFrame.NameFrame:SetParent(TalkingHeadFrame.MainFrame.Model)
        TalkingHeadFrame.NameFrame:ClearAllPoints()
        TalkingHeadFrame.NameFrame:SetPoint('LEFT', TalkingHeadFrame, 'RIGHT', 32, 0)
        TalkingHeadFrame.NameFrame:SetFrameLevel(TalkingHeadFrame.MainFrame.Model:GetFrameLevel() + 3)

        TalkingHeadFrame.NameFrame.Name:SetWidth(200)
        TalkingHeadFrame.NameFrame.Name:SetFont([[Fonts\skurri.ttf]], 14)
        TalkingHeadFrame.NameFrame.Name:SetTextColor(1, 1, 1)
        TalkingHeadFrame.NameFrame.Name:SetShadowOffset(1, -1)
        TalkingHeadFrame.NameFrame.Name:SetShadowColor(0, 0, 0, 1)
        TalkingHeadFrame.NameFrame.Name:SetWordWrap(true)
        TalkingHeadFrame.NameFrame.Name:ClearAllPoints()
        TalkingHeadFrame.NameFrame.Name:SetPoint('LEFT', TalkingHeadFrame.MainFrame.Model,'RIGHT', 17, 0)

        for _, v in pairs({
            TalkingHeadFrame.BackgroundFrame,
            TalkingHeadFrame.PortraitFrame.Portrait,
            TalkingHeadFrame.MainFrame.Sheen,
            TalkingHeadFrame.MainFrame.TextSheen,
            TalkingHeadFrame.MainFrame.Overlay
        }) do v:Hide() end

        TalkingHeadFrame.TextFrame:SetWidth(200)
        TalkingHeadFrame.TextFrame:ClearAllPoints()
        TalkingHeadFrame.TextFrame:SetPoint('TOPLEFT', TalkingHeadFrame, 'BOTTOMLEFT', 20, -20)
        TalkingHeadFrame.TextFrame.Text:SetFont(STANDARD_TEXT_FONT, 10)
        TalkingHeadFrame.TextFrame.Text:SetWidth(200)

        TalkingHeadFrame.MainFrame:SetSize(68, 48)

        TalkingHeadFrame.MainFrame.Model:SetSize(68, 68)
        TalkingHeadFrame.MainFrame.Model:ClearAllPoints()
        TalkingHeadFrame.MainFrame.Model:SetPoint('TOPLEFT', TalkingHeadFrame, -15, 0)

        TalkingHeadFrame.MainFrame.Model.BORDERTOP = TalkingHeadFrame.MainFrame.Model:CreateTexture(nil, 'OVERLAY')
        TalkingHeadFrame.MainFrame.Model.BORDERTOP:SetSize(80, 45)
        TalkingHeadFrame.MainFrame.Model.BORDERTOP:SetPoint('TOP', TalkingHeadFrame.MainFrame.Model, 0, 10)
        TalkingHeadFrame.MainFrame.Model.BORDERTOP:SetTexture[[Interface\ACHIEVEMENTFRAME\UI-Achievement-WoodBorder]]
        TalkingHeadFrame.MainFrame.Model.BORDERTOP:SetTexCoord(.5, .75, 0, 1)

        TalkingHeadFrame.MainFrame.Model.BORDERBOT = TalkingHeadFrame.MainFrame.Model:CreateTexture(nil, 'OVERLAY')
        TalkingHeadFrame.MainFrame.Model.BORDERBOT:SetSize(80, 40)
        TalkingHeadFrame.MainFrame.Model.BORDERBOT:SetPoint('TOP', TalkingHeadFrame.MainFrame.Model.BORDERTOP, 'BOTTOM')
        TalkingHeadFrame.MainFrame.Model.BORDERBOT:SetTexture[[Interface\ACHIEVEMENTFRAME\UI-Achievement-WoodBorder]]
        TalkingHeadFrame.MainFrame.Model.BORDERBOT:SetTexCoord(.75, 1, 0, 1)

        TalkingHeadFrame.MainFrame.Model.PortraitBg:SetDrawLayer'ARTWORK'
        TalkingHeadFrame.MainFrame.Model.PortraitBg:SetTexture[[Interface\ChatFrame\ChatFrameBackground]]
        TalkingHeadFrame.MainFrame.Model.PortraitBg:SetVertexColor(1, 0, 0)
        TalkingHeadFrame.MainFrame.Model.PortraitBg:ClearAllPoints()
        TalkingHeadFrame.MainFrame.Model.PortraitBg:SetPoint('TOPLEFT', TalkingHeadFrame.MainFrame.Model, 1, 0)
        TalkingHeadFrame.MainFrame.Model.PortraitBg:SetPoint('BOTTOMRIGHT', TalkingHeadFrame.MainFrame.Model)

        TalkingHeadFrame.MainFrame.Model.shadow = TalkingHeadFrame.MainFrame.Model:CreateTexture(nil, 'BACKGROUND')
        TalkingHeadFrame.MainFrame.Model.shadow:SetPoint('TOPLEFT', TalkingHeadFrame.MainFrame.Model, -8, 18)
        TalkingHeadFrame.MainFrame.Model.shadow:SetPoint('BOTTOMRIGHT', TalkingHeadFrame.MainFrame.Model, 7, -11)
        TalkingHeadFrame.MainFrame.Model.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
        TalkingHeadFrame.MainFrame.Model.shadow:SetVertexColor(0, 0, 0, 1)
        TalkingHeadFrame.MainFrame.Model.shadow:SetTexCoord(0, .641, 0, .18)

        TalkingHeadFrame.MainFrame.CloseButton:SetFrameLevel(3)
        TalkingHeadFrame.MainFrame.CloseButton:ClearAllPoints()
        TalkingHeadFrame.MainFrame.CloseButton:SetPoint('BOTTOMRIGHT', TalkingHeadFrame.MainFrame.Model, 'TOPRIGHT', 7, -22)
    end

    local LoadTalkingHead = function(_, _, addon)
        if  addon == 'Blizzard_TalkingHeadUI' then
            TalkingHead()
            f:UnregisterEvent'ADDON_LOADED'
        end
    end

    f:RegisterEvent'ADDON_LOADED'
    f:SetScript('OnEvent', LoadTalkingHead)
    --
