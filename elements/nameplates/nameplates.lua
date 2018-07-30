

    local _, ns = ...

    local options = function(self)
        --[[for _, v in pairs({'Enemy', 'Friendly'}) do
            for _, j in pairs({'selectedBorderColor', 'tankBorderColor', 'defaultBorderColor'}) do
                _G['DefaultCompactNamePlate'..v..'FrameOptions'][j] = CreateColor(0, 0, 0, 0)
            end
            for _, j in pairs({'displayNameWhenSelected', 'displayNameByPlayerNameRules'}) do
                _G['DefaultCompactNamePlate'..v..'FrameOptions'][j] = false
            end
        end]]
    end

    local colours = function(frame)
        if  frame.optionTable.healthBarColorOverride then --?
            local _, class = UnitClass'player'
            local colour   = ns.INTERNAL_CLASS_COLORS[class]
            frame.healthBar:SetStatusBarColor(colour.r, colour.g, colour.b)
        else
            if  UnitIsPlayer(frame.displayedUnit) and UnitIsFriend('player', frame.displayedUnit) then
                frame.healthBar:SetStatusBarColor(60/255, 255/255, 80/255)
            end
        end
    end

    local AddTarget = function()
        for _, frame in pairs(C_NamePlate.GetNamePlates()) do
            frame.UnitFrame.target:Hide()
            if  frame.namePlateUnitToken and UnitIsUnit(frame.namePlateUnitToken, 'target') then
                frame.UnitFrame.target:Show()
            end
        end
    end

    local flag = function(unit)
        local base  = C_NamePlate.GetNamePlateForUnit(unit)
        local frame = base.UnitFrame

        local c = UnitClassification(unit)
        local q = UnitIsQuestBoss(unit)

        frame.classificationIndicator:Hide()

        if  UnitIsUnit('player', unit) then
            frame.bd.t:Hide()
            frame.bd.p:Show()
            frame.bd.p.s:Show()
            frame.bd:ClearAllPoints()
            frame.bd:SetPoint('TOPLEFT', frame.healthBar, -1, 1)
            frame.bd:SetPoint('BOTTOMRIGHT', frame.healthBar, 1, -12)
        else
            frame.bd.t:Show()
            frame.bd.p:Hide()
            frame.bd.p.s:Hide()
            frame.bd:ClearAllPoints()
            frame.bd:SetPoint('TOPLEFT', frame.healthBar, -5, 5)
            frame.bd:SetPoint('BOTTOMRIGHT', frame.healthBar, 5, -5)
        end

        if  frame.flag then
            if  c == 'worldboss' then
                frame.flag:SetAtlas'worldquest-icon-pvp-ffa'
                frame.flag:SetSize(15, 15)
                frame.flag:SetDesaturated(false)
                frame.flag:Show()
            elseif c == 'elite' or c == 'rareelite' or c == 'rare' then
                frame.flag:SetAtlas'worldquest-questmarker-dragon'
                frame.flag:SetSize(22, 22)
                frame.flag:Show()
                if  c == 'elite' then
                    frame.flag:SetDesaturated(false)
              else
                    frame.flag:SetDesaturated(true)
                end
            elseif q then
                frame.flag:SetAtlas'worldquest-questmarker-questbang'
                frame.flag:SetSize(6, 15)
                frame.flag:SetDesaturated(false)
                frame.flag:Show()
            else
                frame.flag:SetAtlas''
                frame.flag:SetDesaturated(false)
                frame.flag:Hide()
            end
        end
    end

    local buffs = function(self)
        local f = self:GetParent()
        for i = 1, 4 do
            local bu = _G[f:GetName()..'Buff'..i]
            if  bu and not bu.skinned then
                local x = {bu:GetPoint()}
                bu:SetSize(18, 12)
                ns.BD(bu)
                -- ns.BUBorder(bu, 16, 13)
                bu.skinned = true
            end
        end
    end

    local mana = function(self)
        self:SetHeight(10)                      --  1 more px to match, no idea why
        ns.SB(self)
        ns.BD(self, 1, -2)

        if  not self.background then
            self.background = self:CreateTexture(nil, 'OVERLAY', nil, 7)
        end
        ns.SB(self.background)
        self.background:SetAllPoints(self)
        self.background:SetVertexColor(.35, .35, .35)

        ns.PLAYER_RESOURCE = self:GetParent()   --  cache our player nameplate key
    end

    local name = function(frame)
        if frame.name:IsShown() then
            local unit    = frame.displayedUnit
            local r, g, b = frame.healthBar:GetStatusBarColor()
            frame.healthBar.background:SetVertexColor(r*.2, g*.2, b*.2)
            if UnitIsPlayer(unit) then
                local _, class = UnitClass(frame.displayedUnit)
                local colour   = RAID_CLASS_COLORS[class]
                frame.name:SetText(frame.name:GetText():gsub('%-[^|]+', ' —'))
                if colour then frame.name:SetTextColor(colour.r, colour.g, colour.b) end
            end
        end
    end

    local size = function(frame)
        frame.healthBar:SetHeight(9)
    end

    local style = function(frame)
        if frame.styled then return end

        ns.SB(frame.healthBar)
        ns.BD(frame.healthBar, 1, -2)

        ns.SB(frame.healthBar.background)
        frame.healthBar.background:SetDrawLayer'BORDER'
        frame.healthBar.background:SetVertexColor(.2, .2, .2)

        frame.name:SetFont([[Fonts\skurri.ttf]], 13)
        frame.name:ClearAllPoints()
        frame.name:SetPoint('BOTTOM', frame, 'TOP', 0, -12)
        
        frame.bd = CreateFrame('Frame', nil, frame)
        ns.BD(frame.bd, 1, -1)
        frame.bd:SetBackdropColor(.025, .025, .025)
		frame.bd:SetPoint('TOPLEFT', frame.healthBar, -4, 4)
        frame.bd:SetPoint('BOTTOMRIGHT', frame.healthBar, 4, -4)

		frame.bd.t = frame.bd:CreateTexture(nil, 'ARTWORK')
		frame.bd.t:SetPoint('TOPLEFT', 1, -1)
        frame.bd.t:SetPoint('BOTTOMRIGHT', -1, 1)
		frame.bd.t:SetTexture[[Interface/PLAYERACTIONBARALT/STONE]]
		frame.bd.t:SetTexCoord(0, 1, .18, .3)

        frame.bd.p = frame.bd:CreateTexture(nil, 'ARTWORK')
        frame.bd.p:SetPoint('TOPLEFT', -5, 6)
        frame.bd.p:SetPoint('BOTTOMRIGHT', 6, -5)
        frame.bd.p:SetTexture[[Interface\Store\Store-Main]]
        frame.bd.p:SetTexCoord(.5125, .7925, .546, .621)

        frame.bd.s = frame.bd:CreateTexture(nil, 'BACKGROUND')
        frame.bd.s:SetPoint('TOPLEFT',  -4, 4)
        frame.bd.s:SetPoint('BOTTOMRIGHT',  4, -4)
        frame.bd.s:SetTexture[[Interface\Scenarios\ScenarioParts]]
        frame.bd.s:SetVertexColor(0, 0, 0, 1)
        frame.bd.s:SetTexCoord(0, .641, 0, .18)

        frame.bd.p.s = frame.bd:CreateTexture(nil, 'BACKGROUND')
        frame.bd.p.s:SetPoint('TOPLEFT', frame.bd.p, -6, 6)
        frame.bd.p.s:SetPoint('BOTTOMRIGHT', frame.bd.p,  6, -6)
        frame.bd.p.s:SetTexture[[Interface\Scenarios\ScenarioParts]]
        frame.bd.p.s:SetVertexColor(0, 0, 0, 1)
        frame.bd.p.s:SetTexCoord(0, .641, 0, .18)

        frame.flag = frame.healthBar:CreateTexture(nil, 'OVERLAY')
        frame.flag:SetPoint('RIGHT', frame.healthBar, 7, 0)
        frame.flag:Hide()

        frame.selectionHighlight:SetParent(frame.bd)
        frame.selectionHighlight:ClearAllPoints()
        frame.selectionHighlight:SetPoint('TOPLEFT', frame.bd, -2, 1)
        frame.selectionHighlight:SetPoint('BOTTOMRIGHT', frame.bd,  2, 0)
        frame.selectionHighlight:SetTexture[[Interface\Scenarios\ScenarioParts]]
        frame.selectionHighlight:SetVertexColor(1, 1, 0, .2)
        frame.selectionHighlight:SetTexCoord(0, .641, 0, .18)
        frame.selectionHighlight:SetDrawLayer('BACKGROUND', -7)

        frame.aggroHighlight:ClearAllPoints()
        frame.aggroHighlight:SetPoint('TOPLEFT', frame.bd, -2, 1)
        frame.aggroHighlight:SetPoint('BOTTOMRIGHT', frame.bd,  2, 0)
        frame.aggroHighlight:SetTexture[[Interface\Scenarios\ScenarioParts]]
        frame.aggroHighlight:SetVertexColor(1, 0, 0, 1)
        frame.aggroHighlight:SetTexCoord(0, .641, 0, .18)
        frame.aggroHighlight:SetDrawLayer('BACKGROUND', -7)
        frame.aggroHighlight:SetAlpha(0)

        frame.target = frame.healthBar:CreateTexture(nil, 'OVERLAY')
        frame.target:SetSize(18, 18)
        frame.target:SetPoint('BOTTOM', frame.healthBar, 'TOP', 0, -5)
        frame.target:SetTexture[[Interface\CURSOR\Crosshairs]]
        frame.target:Hide()

        frame.RaidTargetFrame.RaidTargetIcon:SetSize(32, 32)
        frame.RaidTargetFrame.RaidTargetIcon:SetParent(frame.healthBar)
        frame.RaidTargetFrame.RaidTargetIcon:ClearAllPoints()
        frame.RaidTargetFrame.RaidTargetIcon:SetPoint('LEFT', frame.healthBar, 2, 4)
        frame.RaidTargetFrame.RaidTargetIcon:SetDrawLayer'OVERLAY'
        frame.RaidTargetFrame.RaidTargetIcon:SetTexture[[Interface\AddOns\iipui\art\raidicons\raidicons]]

        mana(ClassNameplateManaBarFrame)
        hooksecurefunc('CompactUnitFrame_UpdateName', name)
        hooksecurefunc(frame.BuffFrame, 'UpdateBuffs', buffs)
        hooksecurefunc(ClassNameplateManaBarFrame, 'OnOptionsUpdated', mana)

        frame.styled = true
    end

    local castbar = function(frame)
        ns.SB(frame.castBar)
        ns.BD(frame.castBar, 1, -2)
        frame.castBar:SetHeight(9)
        frame.castBar:ClearAllPoints()
        frame.castBar:SetPoint('BOTTOMLEFT', frame, 12, 0)
        frame.castBar:SetPoint('BOTTOMRIGHT', frame, -12, 0)
        frame.castBar:SetFrameLevel(frame.healthBar:GetFrameLevel() - 1)

        frame.castBar.bd = CreateFrame('Frame', nil, frame.castBar)
        ns.BD(frame.castBar.bd, 1, -1)
        frame.castBar.bd:SetBackdropColor(.05, .05, .05)
		frame.castBar.bd:SetPoint('TOPLEFT', frame.castBar, -4, 4)
		frame.castBar.bd:SetPoint('BOTTOMRIGHT', frame.castBar, 4, -4)
        frame.castBar.bd:SetFrameLevel(0)

		frame.castBar.bd.t = frame.castBar.bd:CreateTexture(nil, 'ARTWORK')
		frame.castBar.bd.t:SetPoint('TOPLEFT', 1, -1)
        frame.castBar.bd.t:SetPoint('BOTTOMRIGHT', -1, 1)
		frame.castBar.bd.t:SetTexture[[Interface/PLAYERACTIONBARALT/STONE]]
		frame.castBar.bd.t:SetTexCoord(0, 1, .18, .3)

        frame.castBar.Text:ClearAllPoints()
        frame.castBar.Text:SetPoint('TOP', frame.castBar, 'BOTTOM', 0, -3)
        frame.castBar.Text:SetFont(STANDARD_TEXT_FONT, 9)
        frame.castBar.Text:SetShadowOffset(1, -1)
	    frame.castBar.Text:SetShadowColor(0, 0, 0, 1)

        frame.castBar.Icon:SetSize(20, 20)
        frame.castBar.Icon:ClearAllPoints()
        frame.castBar.Icon:SetPoint('TOPRIGHT', frame.healthBar, 'TOPLEFT', -18, 0)
        frame.castBar.Icon:SetTexCoord(.1, .9, .1, .9)

        frame.castBar.BorderShield:SetSize(22, 22)
        frame.castBar.BorderShield:ClearAllPoints()
        frame.castBar.BorderShield:SetPoint('CENTER', frame.castBar.Icon)

        if  not frame.castBar.Icon.bg then
            frame.castBar.Icon.bg = CreateFrame('Frame', nil, frame.castBar)
            ns.BD(frame.castBar.Icon.bg)
            frame.castBar.Icon.bg:SetPoint('TOPLEFT', frame.castBar.Icon, -4, 4)
            frame.castBar.Icon.bg:SetPoint('BOTTOMRIGHT', frame.castBar.Icon, 4, -4)
            frame.castBar.Icon.bg:SetFrameLevel(0)

            frame.castBar.Icon.bg.t = frame.castBar.Icon.bg:CreateTexture(nil, 'BACKGROUND', nil, 7)
            frame.castBar.Icon.bg.t:SetPoint('TOPLEFT', -8, 8)
            frame.castBar.Icon.bg.t:SetPoint('BOTTOMRIGHT', 8, -8)
            frame.castBar.Icon.bg.t:SetTexture[[Interface\PVPFrame\SilverIconBorder]]
            frame.castBar.Icon.bg.t:SetVertexColor(.5, .5, .5)
        end

        frame.castBar:HookScript('OnShow', function()
    		frame.bd:SetPoint('BOTTOMRIGHT', frame.castBar, 4, -4)
        end)
        frame.castBar:HookScript('OnHide', function()
    		frame.bd:SetPoint('BOTTOMRIGHT', frame.healthBar, 4, -4)
        end)
    end

    hooksecurefunc('CompactUnitFrame_UpdateHealthColor',        colours)
    hooksecurefunc('DefaultCompactNamePlateFrameSetup',         castbar)
    hooksecurefunc('DefaultCompactNamePlateFrameSetupInternal', size)

    local NAME_PLATE_UNIT_ADDED = function(self, event, ...)
        local unit = ...
        flag(unit)
    end

    local NAME_PLATE_CREATED = function(self, event, ...)
        lip:RegisterEvent('NAME_PLATE_UNIT_ADDED', NAME_PLATE_UNIT_ADDED)
        local base = ...
        style(base.UnitFrame)
        options()
    end

    -- drop this just for now
    -- local e = CreateFrame'Frame'
    -- e:RegisterEvent'PLAYER_TARGET_CHANGED'
    -- e:SetScript('OnEvent', AddTarget)

    lip:RegisterEvent('NAME_PLATE_CREATED',     NAME_PLATE_CREATED)


    --
