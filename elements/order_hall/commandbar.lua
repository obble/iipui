

    local _, ns = ...

    local DeregisterArtifact = function()
        UIParent:UnregisterEvent'ARTIFACT_UPDATE'
        if  ArtifactFrame and not ArtifactFrame:IsShown() then
            ArtifactFrame:UnregisterEvent'ARTIFACT_UPDATE'
        end
    end

    local ReregisterArtifact = function()
        UIParent:RegisterEvent'ARTIFACT_UPDATE'
        if  ArtifactFrame and not ArtifactFrame:IsShown() then
            C_ArtifactUI.Clear()
            ArtifactFrame:RegisterEvent'ARTIFACT_UPDATE'
        end
    end

    local CollectPerkInfo = function()
        if  HasArtifactEquipped() then
            DeregisterArtifact()

            SocketInventoryItem(16)

            local ranks = C_ArtifactUI.GetTotalPurchasedRanks()
            local id    = GetInventoryItemID('player', INVSLOT_MAINHAND)
            local _, _, _, _, _, _, _,_, _, texture = GetItemInfo(id)

            ReregisterArtifact()

            return ranks, texture
        end
    end

    local AddFollower = function(self, i, v)
        if  _G['iipOrderHallFollower'..i] then
            local f = _G['iipOrderHallFollower'..i]
            f.t:SetFormattedText(ORDER_HALL_COMMANDBAR_CATEGORY_COUNT, v.count, v.limit)
            f.i:SetTexture(v.icon)
        else
            local f = CreateFrame('Button', 'iipOrderHallFollower'..i, self)
            ns.BD(f)
            f:SetSize(21, 13)
            f:SetFrameStrata'HIGH'
            f:SetPoint('TOPRIGHT',
                        i == 1 and self or _G['iipOrderHallFollower'..(i - 1)],
                        i == 1 and 'TOPRIGHT' or 'TOPLEFT',
                        i == 1 and -132 or -30,
                        0)

            f.i = f:CreateTexture(nil, 'ARTWORK')
            f.i:SetAllPoints()
            f.i:SetTexture(v.icon)
            f.i:SetTexCoord(.2, .8, .25, .75)

            f.t = f:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
            f.t:SetFont(STANDARD_TEXT_FONT, 9)
            f.t:SetPoint('LEFT', f, 'RIGHT', 6, 0)
            f.t:SetFormattedText(ORDER_HALL_COMMANDBAR_CATEGORY_COUNT, v.count, v.limit)

            f:SetScript('OnEnter', function()
                GameTooltip:SetOwner(f, 'ANCHOR_PRESERVE')
                GameTooltip:ClearAllPoints()
                GameTooltip:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -21, 0)
                GameTooltip:AddLine(v.name)
                if v.description then
                    GameTooltip:AddLine(v.description, 1, 1, 1, true)
                end
                GameTooltip:Show()
            end)
            f:SetScript('OnLeave', function() GameTooltip:Hide() end)

            v.iip = true
        end
    end

    local AddCategory = function(self)
        self.categoryPool:ReleaseAll()
        local info = C_Garrison.GetClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
        for i, v in ipairs(info) do
            AddFollower(self, i, v)
        end
    end

    local AddArtifact = function(self)
        local ranks, texture = CollectPerkInfo()
        if _G['iipOrderHallArtifact'] then
            local f = _G['iipOrderHallArtifact']
            f.t:SetText(ranks and ranks or '')
            f.i:SetTexture(texture and texture or '')
        elseif OrderHallCommandBar then
            local f = CreateFrame('Button', 'iipOrderHallArtifact', self)
            ns.BD(f)
            f:SetSize(21, 13)
            f:SetPoint('TOPRIGHT', -63, 0)
            f:SetScript('OnClick', function() if HasArtifactEquipped() then SocketInventoryItem(16) end end)

            f.i = f:CreateTexture(nil, 'ARTWORK')
            f.i:SetAllPoints()
            f.i:SetTexCoord(.1, .9, .25, .75)
            f.i:SetTexture(texture and texture or '')

            f.t = f:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
            f.t:SetFont(STANDARD_TEXT_FONT, 9)
            f.t:SetPoint('LEFT', f, 'RIGHT', 5, 0)
            f.t:SetText(ranks and ranks or '')
        end
    end

    local AddCommandBar = function(self, event, addon)
        local bar = OrderHallCommandBar
        if  addon == 'Blizzard_OrderHallUI' then
            bar:SetBackdrop(
        		{
        			bgFile   = [[Interface\BankFrame\Bank-Background]],
        			tile     = true,
        			tileSize = 256,
        		}
        	)
        	bar:SetBackdropColor(.8, .8, .8, .95)
            bar:SetHeight(20)

            bar.bezel = bar:CreateTexture(nil, 'OVERLAY')
        	bar.bezel:SetHeight(9)
        	bar.bezel:SetPoint('TOPLEFT', bar, 0, -11) bar.bezel:SetPoint('TOPRIGHT', bar, 0, -11)
        	bar.bezel:SetTexture([[Interface\PLAYERACTIONBARALT\NATURAL]], true)
        	bar.bezel:SetTexCoord(0, 1, 0, .05)
            bar.bezel:SetVertexColor(.45, .35, .4)
        	bar.bezel:SetHorizTile(true)

            local bottom = bar:CreateTexture(nil, 'BACKGROUND', nil, 7)
            ns.SB(bottom)
            bottom:SetHeight(10)
            bottom:SetPoint('BOTTOMLEFT',  bar, 0, -3)
            bottom:SetPoint('BOTTOMRIGHT', bar, 0, -3)
            bottom:SetVertexColor(0, 0, 0)

            bar.Background:Hide()

            bar.ClassIcon:Hide()

            ns.CLASS_COLOUR(bar.AreaName)
            bar.AreaName:SetFont([[Fonts\skurri.ttf]], 12)
            bar.AreaName:ClearAllPoints()
            bar.AreaName:SetPoint('TOP', bar, 0, -1)

            bar.Currency:SetFont(STANDARD_TEXT_FONT, 9)
            bar.Currency:ClearAllPoints()
            bar.Currency:SetPoint('TOPLEFT', bar, 75, -2)

            bar.CurrencyIcon:SetSize(15, 15)
            bar.CurrencyIcon:ClearAllPoints()
            bar.CurrencyIcon:SetPoint('TOPLEFT', 53, 0)

            bar.WorldMapButton:Hide()

            AddArtifact(bar)

            hooksecurefunc(bar, 'RequestCategoryInfo', AddCategory)
            hooksecurefunc(bar, 'RefreshCategories',   AddCategory)

            lip:UnregisterEvent('ADDON_LOADED', AddCommandBar)
        elseif event == 'ARTIFACT_UPDATE' then
            AddArtifact(bar)
        end
    end

    lip:RegisterEvent('ADDON_LOADED', AddCommandBar)
    -- e:RegisterEvent'ARTIFACT_UPDATE'
    -- e:RegisterUnitEvent('PLAYER_SPECIALIZATION_CHANGED', 'player') -- this causes conflicts with panels that are open


    --
