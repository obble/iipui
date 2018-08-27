

    local _, ns = ...

    --  TODO:  DESPERATELY NEEDS A REWRITE

    local reputation

    local header = Minimap:CreateFontString('iipXPHeader', 'ARTWORK', 'GameFontNormalMed2')
    header:SetTextColor(1, .8, 0)
    header:SetWidth(ObjectiveTrackerFrame:GetWidth())
    header:SetPoint('BOTTOMLEFT', Minimap, -104, 4)
    header:SetJustifyH'LEFT'
    header:SetText'Experience'

    header.Background = Minimap:CreateTexture(nil, 'BACKGROUND')
    header.Background:SetTexture[[Interface\QuestFrame\AutoQuest-Parts]]
    header.Background:SetTexCoord(.42, .96, 1, 0)
    header.Background:SetSize(ObjectiveTrackerFrame:GetWidth(), 43)
    header.Background:SetPoint('TOPLEFT', header, -30, 23)
    header.Background:SetAlpha(.65)

    local mouseover = CreateFrame('Frame', nil, UIParent)
    mouseover:SetPoint('TOPLEFT', header)
    mouseover:SetFrameLevel(1)
    mouseover:SetPoint('BOTTOMRIGHT', header, 0, -50)
    mouseover:SetFrameStrata'LOW'

    local xp = CreateFrame('StatusBar', 'iipXP', Minimap, 'AnimatedStatusBarTemplate')
    ns.SB(xp)
    xp:SetSize(100, 5)
    xp:SetPoint('TOPRIGHT',  Minimap, 'BOTTOMRIGHT', -118, -10)
    xp:SetFrameLevel(1)
    xp:SetStatusBarColor(120/255, 88/255, 237/255)
    xp:SetAnimatedTextureColors(120/255, 88/255, 237/255)
    xp:EnableMouse(false)

    xp.bg = xp:CreateTexture(nil, 'BORDER')
    ns.SB(xp.bg)
    xp.bg:SetAllPoints()
    xp.bg:SetVertexColor(.2, .2, .2)

    xp.spark = xp:CreateTexture(nil, 'OVERLAY', nil, 7)
    xp.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
    xp.spark:SetSize(28, 28)
    xp.spark:SetVertexColor(120/255, 88/255, 237/255)
    xp.spark:SetBlendMode'ADD'

    xp.data = xp:CreateFontString(nil, 'OVERLAY')
    xp.data:SetFont([[Fonts\ARIALN.ttf]], 9)
    xp.data:SetSpacing(4)
    xp.data:SetShadowOffset(1.5, -1)
    xp.data:SetShadowColor(0, 0, 0, 1)
    xp.data:SetPoint('RIGHT', xp, 'LEFT', -18, 0)
    xp.data:Hide()

    xp.anim = xp:CreateAnimationGroup'SlidingFrame'

    xp.slideIn = xp.anim:CreateAnimation'Translation'
    xp.slideIn:SetDuration(.22)
    xp.slideIn:SetOffset(0, -50)
    xp.slideIn:SetSmoothing'OUT'

    xp.slideIn:SetScript('OnPlay', function()
        _G['iipObjectives']:ClearAllPoints()
        _G['iipObjectives']:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', 15, -60)
    end)

    xp.slideIn:SetScript('OnFinished', function()
        active = false
        _G['iipObjectives']:ClearAllPoints()
        _G['iipObjectives']:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', 15, -60)
        xp.anim:Stop()
    end)

    xp.fadeIn = xp.anim:CreateAnimation'Alpha'
    xp.fadeIn:SetFromAlpha(0)
    xp.fadeIn:SetToAlpha(1)
    xp.fadeIn:SetDuration(.5)
    xp.fadeIn:SetSmoothing'OUT'

    local rest = CreateFrame('StatusBar', nil, xp)
    ns.SB(rest)
    ns.BD(rest)
    rest:SetSize(100, 5)
    rest:SetPoint('TOPRIGHT',  Minimap, 'BOTTOMRIGHT', -118, -10)
    rest:SetStatusBarColor(157/255, 187/255, 244/255)
    rest:SetFrameLevel(0)
    rest:SetFrameStrata'LOW'
    rest:EnableMouse(false)

    rest.bd = rest:CreateTexture(nil, 'BACKGROUND', nil, 7)
    rest.bd:SetTexture[[Interface\CastingBar\UI-CastingBar-Border-Small]]
    rest.bd:SetPoint('TOPLEFT', rest, -20, 20)
    rest.bd:SetPoint('BOTTOMRIGHT', rest, 20, -20)

    local artifact = CreateFrame('StatusBar', nil, Minimap, 'AnimatedStatusBarTemplate')
    ns.SB(artifact)
    ns.BD(artifact)
    artifact:SetSize(100, 5)
    artifact:SetStatusBarColor(230/255, 204/255, 128/255)
    artifact:SetAnimatedTextureColors(230/255, 204/255, 128/255)
    artifact:SetFrameLevel(1)
    artifact:EnableMouse(false)

    artifact.bg = artifact:CreateTexture(nil, 'BORDER')
    ns.SB(artifact.bg)
    artifact.bg:SetAllPoints()
    artifact.bg:SetVertexColor(.2, .2, .2)

    artifact.bd = artifact:CreateTexture(nil, 'BACKGROUND', nil, 7)
    artifact.bd:SetTexture[[Interface\CastingBar\UI-CastingBar-Border-Small]]
    artifact.bd:SetPoint('TOPLEFT', artifact, -20, 20)
    artifact.bd:SetPoint('BOTTOMRIGHT', artifact, 20, -20)

    artifact.spark = artifact:CreateTexture(nil, 'OVERLAY', nil, 7)
    artifact.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
    artifact.spark:SetSize(28, 28)
    artifact.spark:SetVertexColor(230/255, 204/255, 128/255)
    artifact.spark:SetBlendMode'ADD'

    artifact.data = artifact:CreateFontString(nil, 'OVERLAY')
    artifact.data:SetFont([[Fonts\ARIALN.ttf]], 9)
    artifact.data:SetSpacing(4)
    artifact.data:SetShadowOffset(1.5, -1)
    artifact.data:SetShadowColor(0, 0, 0, 1)
    artifact.data:SetPoint('RIGHT', artifact, 'LEFT', -18, 0)
    artifact.data:Hide()

    local rep = CreateFrame('StatusBar', 'iipRep', Minimap, 'AnimatedStatusBarTemplate')
    ns.SB(rep)
    ns.BD(rep)
    rep:SetSize(100, 5)
    rep:SetFrameLevel(10)
    rep:EnableMouse(false)
    rep:SetAlpha(0)

    rep.bg = rep:CreateTexture(nil, 'BORDER')
    ns.SB(rep.bg)
    rep.bg:SetAllPoints()
    rep.bg:SetVertexColor(.2, .2, .2)

    rep.spark = rep:CreateTexture(nil, 'OVERLAY', nil, 7)
    rep.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
    rep.spark:SetSize(28, 28)
    rep.spark:SetBlendMode'ADD'

    rep.data = rep:CreateFontString(nil, 'OVERLAY')
    rep.data:SetFont([[Fonts\ARIALN.ttf]], 9)
    rep.data:SetSpacing(4)
    rep.data:SetShadowOffset(1.5, -1)
    rep.data:SetShadowColor(0, 0, 0, 1)
    rep.data:SetPoint('RIGHT', rep, 'LEFT', -18, 0)
    rep.data:Hide()

    rep.bd = rep:CreateTexture(nil, 'BACKGROUND', nil, 7)
    rep.bd:SetTexture[[Interface\CastingBar\UI-CastingBar-Border-Small]]
    rep.bd:SetPoint('TOPLEFT', -20, 20)
    rep.bd:SetPoint('BOTTOMRIGHT', 20, -20)

    local honour = CreateFrame('StatusBar', 'iipHonour', Minimap, 'AnimatedStatusBarTemplate')
    ns.SB(honour)
    ns.BD(honour)
    honour:SetSize(100, 5)
    honour:SetPoint('TOPRIGHT',  Minimap, 'BOTTOMRIGHT', -118, -13)
    honour:SetStatusBarColor(1, .24, 0)
    honour:SetAnimatedTextureColors(1, .24, 0)
    honour:SetFrameLevel(10)
    honour:EnableMouse(false)
    honour:SetAlpha(0)

    honour.bg = honour:CreateTexture(nil, 'BORDER')
    ns.SB(honour.bg)
    honour.bg:SetAllPoints()
    honour.bg:SetVertexColor(.2, .2, .2)

    honour.bd = honour:CreateTexture(nil, 'BACKGROUND', nil, 7)
    honour.bd:SetTexture[[Interface\CastingBar\UI-CastingBar-Border-Small]]
    honour.bd:SetPoint('TOPLEFT', honour, -20, 20)
    honour.bd:SetPoint('BOTTOMRIGHT', honour, 20, -20)

    honour.data = honour:CreateFontString(nil, 'OVERLAY')
    honour.data:SetFont([[Fonts\ARIALN.ttf]], 9)
    honour.data:SetSpacing(4)
    honour.data:SetShadowOffset(1.5, -1)
    honour.data:SetShadowColor(0, 0, 0, 1)
    honour.data:SetPoint('RIGHT', honour, 'LEFT', -18, 0)
    honour.data:Hide()

    local ArtifactUpdate = function(self, event)
        local azerite = C_AzeriteItem.FindActiveAzeriteItem()
        if  azerite then
            local v, max    = C_AzeriteItem.GetAzeriteItemXPInfo(azerite)
            local level     = C_AzeriteItem.GetPowerLevel(azerite)
            local percent   = math.ceil(v/max*100)

            artifact:ClearAllPoints()
            artifact:SetPoint('TOPRIGHT',  Minimap, 'BOTTOMRIGHT', -118, xp:IsShown() and -25 or -10)

            artifact:SetAnimatedValues(v, 0, max, lvl)
            artifact.data:SetFormattedText(percent..'%% ap')
            artifact.spark:SetPoint('CENTER', artifact, 'LEFT', v/max*artifact:GetWidth(), -.5)

            -- show at max level, otherwise hover/event to reveal
            if  UnitLevel'player' == MAX_PLAYER_LEVEL then
                artifact:SetAlpha(1)
            end
        else
            artifact:SetAlpha(0)
        end
        if  event == 'ARTIFACT_XP_UPDATE' and UnitLevel'player' < MAX_PLAYER_LEVEL then
            if  artifact:GetAlpha() < 1 then
                artifact:SetAlpha(1)
                C_Timer.After(7, function() UIFrameFadeOut(artifact, .5, 1, 0) end)
            end
        end
    end

    local RepUpdate = function(self, event)
        local level
        local name, reaction, min, max, v, id = GetWatchedFactionInfo()
        local maxed = UnitLevel'player' < MAX_PLAYER_LEVEL
        if  name then
            if GetFriendshipReputation(id) then
                local fid, frep, fmax, fname, ftext, ftexture, ftextlevel, fthreshold, fnext = GetFriendshipReputation(id)
                level = GetFriendshipReputationRanks(id)
                if  fnext then
                    min, max, v = fthreshold, fnext, frep
                else
                    min, max, v = 0, 1, 1
                end
                reaction = 5
            else
                level = reaction
            end

            local colour = FACTION_BAR_COLORS[reaction]
            rep:SetAnimatedValues(v - min, 0, max - min, level)
            rep:SetStatusBarColor(colour.r, colour.g, colour.b)
            rep:SetAnimatedTextureColors(colour.r, colour.g, colour.b)
            rep:ClearAllPoints()
            rep:SetPoint(
                'TOPRIGHT',
                Minimap,
                'BOTTOMRIGHT',
                -118,
                (artifact:IsShown() and xp:IsShown()) and -40 or (artifact:IsShown() or xp:IsShown()) and -25 or -10
            )

            rep.spark:SetPoint('CENTER', rep, 'LEFT', ((v - min)/(max - min))*rep:GetWidth(), -.5)
            rep.spark:SetVertexColor(colour.r, colour.g, colour.b)

            rep.data:SetFormattedText(v - min..'/'..max-min..': '..name)

            if event == 'UPDATE_FACTION' and v ~= reputation then
                if  rep:GetAlpha() < 1 then
                    rep:SetAlpha(1)
                    if xp:IsShown() or artifact:IsShown() then C_Timer.After(5, function() UIFrameFadeOut(rep, .5, 1, 0) end) end
                end
                reputation = v
            end
        else
            rep:SetAlpha(0)
        end
    end

    local HonourUpdate = function()
        if  IsWatchingHonorAsXP() or InActiveBattlefield() or IsInActiveWorldPVP() then
            for _, v in pairs({artifact, rest, xp}) do
                v:Hide()
            end
            local v,   max    = UnitHonor'player',      UnitHonorMax'player'
            honour:SetAnimatedValues(v, 0, max, lvl)
            honour.data:SetText(v..'/'..max)
            honour:Show()
        else
            honour:Hide()
        end
    end

    local XPUpdate = function()
        local level   = UnitLevel'player'
        local XP, max = UnitXP'player', UnitXPMax'player'
        local percent = math.ceil(XP/max*100)
        local REST    = GetXPExhaustion()
        if  UnitLevel'player' == MAX_PLAYER_LEVEL then
            ArtifactUpdate()
            xp:Hide()
            rest:Hide()
            header:SetText'Artifact'

            artifact:SetAlpha(1)
            artifact:ClearAllPoints()
            artifact:SetPoint('TOPRIGHT',  Minimap, 'BOTTOMRIGHT', -118, -13)

            header:Show()
            header.Background:SetAlpha(1)

            if UnitInBattleground'player' then
                header:SetText'Honour'
                artifact:SetAlpha(0)
                honour:SetAlpha(1)
            else
                if  HasArtifactEquipped() and not C_ArtifactUI.IsEquippedArtifactMaxed() and not C_ArtifactUI.IsEquippedArtifactDisabled() then
                    header:SetText'Artifact'
                    artifact:SetAlpha(1)
                    honour:SetAlpha(0)
                else
                    if  GetWatchedFactionInfo() then
                        header:SetText'Faction'
                        RepUpdate()
                        rep:SetAlpha(1)
                        honour:SetAlpha(0)
                    else
                        header:Hide()
                        header.Background:SetAlpha(0)
                    end
                end
            end
        else
            xp:SetAnimatedValues(XP, 0, max, level)

            xp.spark:SetPoint('CENTER', xp, 'LEFT', XP/max*xp:GetWidth(), -.5)

            rest:SetMinMaxValues(min(0, XP), max)
            rest:SetValue(REST and (XP + REST) or 0)
            xp.data:SetFormattedText(percent..'%% xp')
        end
    end

    mouseover:SetScript('OnEnter', function()
        artifact.data:Show()
        ArtifactUpdate()
        RepUpdate()
        HonourUpdate()
        ns.grow()
        if UnitInBattleground'player' then honour.data:Show() end
        if GetWatchedFactionInfo() then rep.data:Show() rep:SetAlpha(1) end
        if  UnitLevel'player' < MAX_PLAYER_LEVEL then
            artifact:SetAlpha(1)
            xp.data:Show()
        end
    end)

    mouseover:SetScript('OnLeave', function()
        artifact.data:Hide()
        rep.data:Hide()
        honour.data:Hide()
        ns.shrink()
        if xp:IsShown() or artifact:IsShown() then rep:SetAlpha(0) end
        if  UnitLevel'player' < MAX_PLAYER_LEVEL then
            artifact:SetAlpha(0)
            xp.data:Hide()
        end
    end)

    local ZoneChangeXP = function()
        XPUpdate()
        RepUpdate()
        HonourUpdate()
        ArtifactUpdate()
    end

    local events = {
        'ARTIFACT_UPDATE',
        'PLAYER_XP_UPDATE',
        'PLAYER_LEVEL_UP',
        'UPDATE_EXHAUSTION',
        'PLAYER_ENTERING_WORLD',
        'UPDATE_FACTION',
        'ZONE_CHANGED_NEW_AREA',
        'HONOR_XP_UPDATE',
        'HONOR_LEVEL_UPDATE',
        --c'HONOR_PRESTIGE_UPDATE',
        'ARTIFACT_XP_UPDATE',
    }

    local OnEvent = function(self, event, ...)
        XPUpdate()
        if event == 'UPDATE_FACTION' then
            RepUpdate()
        elseif
            event == 'ZONE_CHANGED_NEW_AREA' then
            ZoneChangeXP()
        elseif
            event == 'HONOR_XP_UPDATE'
        or  event == 'HONOR_LEVEL_UPDATE'then
            HonourUpdate()
        elseif
            event == 'ARTIFACT_XP_UPDATE' then
            ArtifactUpdate()
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


    --
