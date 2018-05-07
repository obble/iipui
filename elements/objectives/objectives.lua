

    local _, ns = ...

    local otf           = ObjectiveTrackerFrame
    local t, throttle   = 0, .1
    local collapsed     = nil
    local moving

    otf:SetFrameLevel(0)

    otf.HeaderMenu.Title:SetText''

    otf.HeaderMenu.MinimizeButton:ClearAllPoints()
    otf.HeaderMenu.MinimizeButton:SetPoint('TOPRIGHT', otf, -15, -7)

    local OnClick = function()
        if  not otf.collapsed then
            collapsed = true
        else
            collapsed = false
        end
    end

    local UnitframeExists = function()
        for i = 1, 5 do
            if UnitExists('arena'..i) then return true end
        end
        for i = 1, MAX_BOSS_FRAMES do
            if UnitExists('boss'..i)  then return true end
        end
    end

    local CollapseTracker = function(self, event)
        local _, instanceType = IsInInstance()
        local bar = _G['WorldStateCaptureBar1']
            --  collapse if there's a boss or arena fight
        if  UnitframeExists() then
            if  not collapsed and not otf.boss then ObjectiveTracker_Collapse() otf.boss = true end
            --  or if a capture bar appears
        elseif event == 'UPDATE_WORLD_STATES' and bar and bar:IsVisible() then
            if  not collapsed and not otf.boss then ObjectiveTracker_Collapse() otf.boss = true end
        else
            if  otf.boss and not collapsed then
                ObjectiveTracker_Expand()
                otf.boss = nil
            end
        end
    end

    local AddHeader = function()
        if  otf.MODULES then
            for i = 1, #otf.MODULES do
                local module = otf.MODULES[i]
		        module.Header.Background:SetAtlas(nil)
                module.Header.Background:SetTexture[[Interface\QuestFrame\AutoQuest-Parts]]
                module.Header.Background:SetTexCoord(.42, .96, 1, 0)
                module.Header.Background:SetHeight(43)
                module.Header.Background:SetAlpha(.65)
	        end
	    end
    end

    local AddLines = function(line, key)
        line.Text:SetFont(STANDARD_TEXT_FONT, key == 0 and 12 or 11)
    end

    local AddItem = function(bu, elapsed)
        t = t + elapsed
        if  t > throttle then
            if  bu and not bu.skinned and not InCombatLockdown() then
                ns.BU(bu)
                ns.BUElements(bu)
                ns.BDStone(bu, 4, [[Interface\HELPFRAME\Tileable-Parchment]])
                bu:SetSize(21, 14)
                bu.icon:SetTexCoord(.1, .9, .25, .75)
                bu:SetFrameLevel(3)
                bu.skinned = true
            end
        end
    end

    local AddObjective = function(self, block, key)
        if  block.HeaderText then
            --print'is it this causing taint'
            local r, g, b = block.HeaderText:GetTextColor()
            block.HeaderText:SetFont(STANDARD_TEXT_FONT, 15)
        end
    end

    local AddHooks = function()
        if otf.MODULES then
            for i = 1, #otf.MODULES do
                local module = otf.MODULES[i]
                hooksecurefunc(module, 'AddObjective', AddObjective)
            end
        end
    end

    local SetPoint = function(self)
        -- http://www.wowinterface.com/forums/showthread.php?t=50666
        if moving then return end
        moving = true
        self:SetMovable(true)
        self:SetUserPlaced(true)
        self:ClearAllPoints()
        self:SetPoint('TOPRIGHT', UIParent, -15, -20)
        self:SetParent(Minimap)
        self:SetHeight(800)
        self:SetMovable(false)
        moving = nil
    end

    local OnEvent = function(self, event)
        CollapseTracker()
        if  event == 'PLAYER_ENTERING_WORLD' then
            -- AddHooks()
        end
    end

    hooksecurefunc(otf, 'SetPoint', SetPoint)

    hooksecurefunc('ObjectiveTracker_MinimizeButton_OnClick',   OnClick)
    hooksecurefunc('ObjectiveTracker_Update',                   AddHeader)
    -- hooksecurefunc('QuestObjectiveItem_OnUpdate',               AddItem)

    local e = CreateFrame'Frame'
    e:SetScript('OnEvent', OnEvent)
    e:RegisterEvent'PLAYER_ENTERING_WORLD'
    e:RegisterEvent'INSTANCE_ENCOUNTER_ENGAGE_UNIT'
    e:RegisterEvent'PLAYER_REGEN_ENABLED'
    e:RegisterEvent'UPDATE_WORLD_STATES'


    --
