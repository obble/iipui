

    local _, ns = ...

    local tooltip = CreateFrame('GameTooltip', 'iipArtifactScanner', UIParent, 'GameTooltipTemplate')
    tooltip:SetOwner(UIParent, 'ANCHOR_NONE')

    local bu = CreateFrame('Button', 'iipArtifactConsumable', UIParent, 'SecureActionButtonTemplate')
    ns.BD(bu)
    bu:SetSize(18, 18)
    bu:SetAttribute('type', 'item')
    bu:SetPoint('BOTTOMRIGHT', Minimap, -228, 2)
    bu:Hide()

    bu.t = bu:CreateTexture()
    bu.t:SetTexCoord(.1, .9, .1, .9)
    bu.t:SetAllPoints()

    bu.bg = bu:CreateTexture(nil, 'BACKGROUND')
    bu.bg:SetPoint('TOPLEFT', -10, 10)
    bu.bg:SetPoint('BOTTOMRIGHT', 10, -10)
    bu.bg:SetTexture[[Interface\PVPFrame\SilverIconBorder]]
    bu.bg:SetVertexColor(.5, .5, .5)

    bu.cd = CreateFrame('Cooldown', nil, bu, 'CooldownFrameTemplate')
    bu.cd:SetAllPoints()

    bu.text = bu:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
    bu.text:SetFont(STANDARD_TEXT_FONT, 9)
    bu.text:SetPoint('RIGHT', bu, 'LEFT', -7, 1)

    local AddCooldown = function()
        if  bu.id then
            local start, cd = GetItemCooldown(bu.id)
            bu.cd:SetCooldown(start, cd)
        end
    end

    local Hide = function()
        bu.id = nil
        bu:SetAttribute('item', nil)
        bu:Hide()
        bu.t:SetTexture''
        bu.text:SetText''
    end

    local Show = function(id, ap)
        bu.id = id
        bu:SetAttribute('item', 'item:'..id)
        bu:Show()
        bu.t:SetTexture(GetItemIcon(id))
        bu.text:SetText(string.format('%s %s'..' +', ap, ARTIFACT_POWER))
    end

    local Scan = function()
        Hide()
        for i = 0, 4 do
            for j = 1, GetContainerNumSlots(i) do
                local item = GetContainerItemLink(i, j)
                local id   = GetContainerItemID(i, j)
                if  id and item then
                    tooltip:ClearLines()
                    tooltip:SetHyperlink(item)
                    local two = _G[tooltip:GetName()..'TextLeft2']
                    if  two and two:GetText() then
                        if  strmatch(two:GetText(), 'Artifact Power') then
                            local four = _G[tooltip:GetName()..'TextLeft4']:GetText()
                            local ap = string.match(four, '%d+')
                            if  strmatch(four, 'billion') then
                                ap = string.format('%d%s', ap, 'B')
                            elseif strmatch(four, 'million') then
                                ap = string.format('%d%s', ap, 'M')
                            end
                            if ap then Show(id, ap) return end
                        end
                    end
                end
            end
        end
    end

    bu:SetScript('OnEnter', function()
        GameTooltip:SetOwner(bu, 'ANCHOR_TOP')
        if bu.id then GameTooltip:SetItemByID(bu.id) end
    end)

    bu:SetScript('OnLeave', function() GameTooltip:Hide() end)

    local f = CreateFrame'Frame'
    f:RegisterEvent'BAG_UPDATE_COOLDOWN'
    f:RegisterEvent'SPELL_UPDATE_COOLDOWN'
    f:RegisterEvent'BAG_UPDATE_DELAYED'
    f:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)

    function f:BAG_UPDATE_COOLDOWN()   AddCooldown() end
    function f:SPELL_UPDATE_COOLDOWN() AddCooldown() end
    function f:BAG_UPDATE_DELAYED()
        if  InCombatLockdown() then
            f:RegisterEvent'PLAYER_REGEN_ENABLED'
        else
            Scan()
        end
    end
    function f:PLAYER_REGEN_ENABLED()
        Scan()
        f:UnregisterEvent'PLAYER_REGEN_ENABLED'
    end


    --
