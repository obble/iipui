

    local _, ns = ...

    CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA   = 0
    CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA   = 1
    CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA   = 1
    CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA     = 0
    CHAT_TAB_HIDE_DELAY                     = 1

    -- GENERAL_CHAT_DOCK:ClearAllPoints()
    -- GENERAL_CHAT_DOCK:SetPoint('TOPLEFT', ChatFrame1, 0, 22)
    -- GENERAL_CHAT_DOCK:SetWidth(ChatFrame1:GetWidth())

    local ColourTab = function(self)
        local tab = _G[self:GetName()..'Tab']  or self
        local t   = _G[self:GetName()..'Text'] or _G[self:GetName()..'TabText']
        if  tab:IsMouseOver() then
            t:SetTextColor(0, 1, 1)
        elseif tab.alerting then
            -- UIFrameFlash(t, )
        elseif tab:GetID() == SELECTED_CHAT_FRAME:GetID() then
            t:SetTextColor(1, 1, 1)
        else
            t:SetTextColor(1, .8, 0)
        end
    end

    local NameTab = function(f, name, nosave)
        local tab  = _G[f:GetName()..'Tab']
        local n    = tonumber(f:GetName():match'%d+')
        if  name and n > 10 then
            local text = name:gsub('%-[^|]+', '')
            tab:SetText(text)
            tab.name  = text
            if not nosave then SetChatWindowName(f:GetID(), text) end
        end
    end

    local Tab = function(self, overflow)
        local chat = _G[self]
        local tab  = _G[self..'Tab']
        local t    = _G[self..'TabText']

        for i = 1,  select('#', tab:GetRegions()) do
            local v = select(i, tab:GetRegions())
            if v and v:GetObjectType() == 'Texture' and not v:GetName():find'Glow' then
                v:SetTexture(nil)
            end
        end

        local a = {t:GetPoint()}
        t:SetPoint(a[1], a[2], a[3], overflow and a[4] - 10 or a[4], overflow and -1 or 2)
        t:SetJustifyH'CENTER'
        t:SetFont(STANDARD_TEXT_FONT, overflow and 10 or 12)
        t:SetShadowOffset(1, -1)
        t:SetShadowColor(0, 0, 0, 1)
        t:SetDrawLayer('OVERLAY', 7)


        tab:HookScript('OnEnter', function() ColourTab(chat) end)
        tab:HookScript('OnLeave', function() ColourTab(chat) end)

        chat.tabbed = true
    end

    local UpdateTab = function(bu, chat)
        for i, v in ipairs(GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES) do
            if not v.tabbed then
                local n = tonumber(v:GetName():match'%d+')
                Tab(v:GetName(), n > 10 and true)
            end
        end
    end

    hooksecurefunc('FCF_SetWindowName',   NameTab)
    hooksecurefunc('FCFDock_UpdateTabs',  UpdateTab)
    hooksecurefunc('FCFTab_UpdateColors', ColourTab)
    hooksecurefunc('FCF_StartAlertFlash', ColourTab)
    hooksecurefunc('FCFTab_UpdateAlpha',  ColourTab)


    --
