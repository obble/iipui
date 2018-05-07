

    local _, ns = ...

    local FONT_REGULAR = ns.FONT_REGULAR

    -- *.*°.*°...*°.°*..*. SETTINGS *..*..**.*
    local collapse  = false                                            -- collapse chat with actionbar
    local XY        = {'BOTTOMLEFT', 50, 30}    -- base position for chat (influenced by actionbar size)
    -- ......***.*.*..°.*.*.***.*°.*.*°*.*

    DEFAULT_CHATFRAME_ALPHA  = .25
    CHAT_FRAME_FADE_OUT_TIME = .1
    CHAT_FRAME_FADE_TIME     = .1
    CHAT_FONT_HEIGHTS        = {
        [1]  = 8,  [2]  = 9,  [3]  = 10,
        [4]  = 11, [5]  = 12, [6]  = 13,
        [7]  = 14, [8]  = 15, [9]  = 16,
        [10] = 17, [11] = 18, [12] = 19,
        [13] = 20, [14] = 21, [15] = 22,
    }

    local BG = CreateFrame'Frame'
    BG:SetBackdrop({
        bgFile   = [[Interface\Tooltips\UI-Tooltip-Background]],
        tiled    = false,
        edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = 3,
        insets   = {left = -1, right = -1, top = -1, bottom = -1}
    })
    BG:SetBackdropColor(0, 0, 0, 0)
    BG:SetBackdropBorderColor(0, 0, 0, DEFAULT_CHATFRAME_ALPHA*2)
    BG:SetFrameStrata'LOW'

    local AddBG = function(chat, object, fadein)
        BG:Hide()
        if object:IsShown() then
            BG:SetAllPoints(object)
            if  fadein then
                UIFrameFadeIn(BG, CHAT_FRAME_FADE_TIME, object:GetAlpha(), max(chat.oldAlpha, DEFAULT_CHATFRAME_ALPHA))
            else
                UIFrameFadeOut(BG, CHAT_FRAME_FADE_OUT_TIME, max(object:GetAlpha(), chat.oldAlpha), chat.oldAlpha)
            end
        end
    end

    local UpdateBottom = function(self)
        local bottom = _G[self:GetName()..'ButtonFrameBottomButton']
        if self:AtBottom() and bottom:IsShown() then bottom:Hide() end
    end

    local HideChatElements = function(v)
        for _, j in pairs({
            _G[v..'ButtonFrameUpButton'], _G[v..'ButtonFrameDownButton'],
            _G[v..'ConversationButton'],  _G[v..'ButtonFrameMinimizeButton'],
            _G[v..'EditBoxFocusLeft'],    _G[v..'EditBoxFocusRight'], _G[v..'EditBoxFocusMid'],
            ChatFrameMenuButton,          FriendsMicroButton,         QuickJoinToastButton
        })  do
            if  j then
                j:SetAlpha(0)
                if not j:GetName():find'Edit' then
                    j:EnableMouse(false)
                    if j:HasScript'OnEvent' then j:UnregisterAllEvents() end
                end
            end
        end
        for _, j in pairs({
            'ButtonFrameBackground',
            'ButtonFrameTopLeftTexture',    'ButtonFrameTopRightTexture',
            'ButtonFrameBottomLeftTexture', 'ButtonFrameBottomRightTexture',
            'ButtonFrameLeftTexture',       'ButtonFrameRightTexture',
            'ButtonFrameBottomTexture',     'ButtonFrameTopTexture',
        })  do
            _G[v..j]:SetTexture(nil)
        end
    end

    local PlaceChat = function(chat)
        if  collapse then
            tinsert(ns.bar_elements, chat)
            chat:SetParent(_G['iipbar'])
            chat:SetFrameLevel(10)
        end
        ns.DELEGATE_FRAMES_TO_POSITION[chat] = XY
        chat:SetUserPlaced(true)
    end

    local AddChat = function()
        for i, v in pairs(CHAT_FRAMES) do
            local chat   = _G[v]
            local edit   = _G[v..'EditBox']
            local header = _G[v..'EditBoxHeader']
            local suffix = _G[v..'EditBoxHeaderSuffix']

            SetChatWindowAlpha(i, 0)
            HideChatElements(v)
            if not chat.loaded and i == 1 then PlaceChat(chat) end

            chat:SetFrameLevel(3)
            chat:SetShadowOffset(1, -1)
            chat:SetClampedToScreen(false)
            chat:SetClampRectInsets(0, 0, 0, 0)
            chat:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
            chat:SetMinResize(150, 25)


            edit:SetFrameLevel(0)
            edit:Hide()
            edit:SetSize(320, 20)
            edit:SetAltArrowKeyMode(false)
            edit:SetFont(FONT_REGULAR, 12)
            edit:SetTextInsets(11 + header:GetWidth() + (suffix:IsShown() and suffix:GetWidth() or 0), 11, 0, 0)
            edit:ClearAllPoints()
            edit:SetPoint('BOTTOM',  _G['iipbar'].collapse, 'TOP', 0, 69*ns.DELEGATE_ACTUAL_BARS_SHOWN)

            if not edit.f then
                edit.f = CreateFrame('Frame', nil, edit)
                ns.BD(edit.f)
                edit.f:SetPoint('TOPLEFT', 12, -6)
                edit.f:SetPoint('BOTTOMRIGHT', -12, 6)

                edit.shadow = edit:CreateTexture(nil, 'BACKGROUND', nil, -3)
                edit.shadow:SetPoint('TOPLEFT', edit,  -9, 7)
                edit.shadow:SetPoint('BOTTOMRIGHT', edit,  9, -7)
                edit.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
                edit.shadow:SetVertexColor(0, 0, 0, 1)
                edit.shadow:SetTexCoord(0, .641, 0, .18)
            end

            for _,  j in pairs({edit:GetRegions()}) do
                if  j:GetObjectType() == 'FontString' then
                    j:SetParent(edit.f)
                    j:SetFont(STANDARD_TEXT_FONT, 11)
                end
            end

            ChatFrameMenuButton:SetAlpha(0)
            ChatFrameMenuButton:EnableMouse(false)

            local bottom = _G[v..'ButtonFrameBottomButton']
            bottom:Hide()
            bottom:ClearAllPoints()
            bottom:SetPoint('RIGHT', chat, 'BOTTOMLEFT', -10, 12)
            bottom:HookScript('OnClick', function(self) self:Hide() end)
        end
    end

    hooksecurefunc('FCF_FadeInChatFrame',             function(self) AddBG(self, _G[self:GetName()..'Background'], true)  end)
    hooksecurefunc('FCF_FadeOutChatFrame',            function(self) AddBG(self, _G[self:GetName()..'Background'], false) end)
    hooksecurefunc('FloatingChatFrame_OnMouseScroll', UpdateBottom)
    hooksecurefunc('ChatFrame_OnUpdate',              UpdateBottom)
    hooksecurefunc('FCF_OpenTemporaryWindow',         AddChat)

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_ENTERING_WORLD'
    e:SetScript('OnEvent', AddChat)

    --
