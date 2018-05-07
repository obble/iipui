

    local _, ns = ...

    local LoC  = LossOfControlFrame

    local hide = CreateFrame'Frame'
    hide:Hide()

    local AddLoC = function()
        local bar = CreateFrame('StatusBar', nil, LoC)
        ns.SB(bar)
        ns.BD(bar, 1, -1)
        ns.BDStone(bar, 4)
        bar:SetHeight(20)
        LoC.bar = bar

        LoC:DisableDrawLayer'BACKGROUND'
        LoC:ClearAllPoints()
        LoC:SetAllPoints(bar)

        local bu = CreateFrame('Frame', nil, bar)
        ns.BD(bu)
        bu:SetPoint('TOPRIGHT', bar, 'TOPLEFT', -30, -20)
        bu:SetSize(70, 70)
        bu:SetFrameLevel(0)
        LoC.bu = bu

        bu.t = bu:CreateTexture(nil, 'BACKGROUND', nil, 7)
        bu.t:SetPoint('TOPLEFT', -8, 8)
        bu.t:SetPoint('BOTTOMRIGHT', 8, -8)
        bu.t:SetTexture[[Interface\PVPFrame\SilverIconBorder]]
        bu.t:SetVertexColor(.5, .5, .5)

        local icon = LoC.Icon
        icon:SetParent(bu)
        icon:SetTexCoord(.1, .9, .1, .9)
        icon:ClearAllPoints()
        icon:SetAllPoints(bu)

        local cd = LoC.Cooldown
        cd:SetParent(hide)

        local name = LoC.AbilityName
        name:SetParent(bar)
        name:ClearAllPoints()
        name:SetPoint('LEFT', 10, 0)
        name:SetFontObject(GameFontNormal)
        name:SetFont([[Fonts\skurri.ttf]], 12)
        name:SetDrawLayer'OVERLAY'

        local time = LoC.TimeLeft
        time:SetParent(hide)

        lip:UnregisterEvent('PLAYER_ENTERING_WORLD', AddLoC)
    end

    local PositionLoC = function()
        local bar = LoC.bar
        LoC:ClearAllPoints()
            --  ns.PLAYER_RESOURCE is the player "personal resource" nameplate
            --  cached in nameplates/nameplates.lua on show
        if  ns.PLAYER_RESOURCE and ns.PLAYER_RESOURCE:IsShown() then
            bar:SetPoint('BOTTOMLEFT',  ns.PLAYER_RESOURCE, 'TOPLEFT', 0, 50)
            bar:SetPoint('BOTTOMRIGHT', ns.PLAYER_RESOURCE, 'TOPRIGHT', 0, 50)
        else
            bar:SetPoint('BOTTOMLEFT',  UIParent, 'CENTER', -48, -60)
            bar:SetPoint('BOTTOMRIGHT', UIParent, 'CENTER', 48, -60)
        end
    end

    local UpdateBar = function(bar)
        local bar = LoC.bar
        local _, _, _, _, _, remaining = C_LossOfControl.GetEventInfo(1)
        if  remaining and remaining > 0 then
            bar:SetValue(remaining)
        else
            bar:SetScript('OnUpdate', nil)
        end
    end

    local SetUpBar = function()
        local bar = LoC.bar
        local _, _, _, _, start, _, duration = C_LossOfControl.GetEventInfo(1)
        if  start then
            bar:SetMinMaxValues(0, duration)
            bar:SetStatusBarColor(250/255, 200/255, 60/255) -- yellow
            bar:SetScript('OnUpdate', UpdateBar)
        else
            bar:SetMinMaxValues(0, 1)
            bar:SetStatusBarColor(250/255, 80/255, 60/255)  -- red
            bar:SetValue(1)
        end
    end

    LoC:HookScript('OnShow', PositionLoC)
    hooksecurefunc('LossOfControlFrame_SetUpDisplay', SetUpBar)

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_ENTERING_WORLD'
    e:SetScript('OnEvent', AddLoC)


    --
