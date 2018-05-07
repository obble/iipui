

    local _, ns = ...

    BNToastFrame:SetClampedToScreen(true)
    BNToastFrame:SetParent(ChatFrame1)  -- TODO:  check if neccessary 

    BNToastFrame.BG = BNToastFrame:CreateTexture(nil, 'BACKGROUND')
    BNToastFrame.BG:SetAllPoints()
    BNToastFrame.BG:SetTexture[[Interface/Glues/CHARACTERCREATE/UI-CharacterCreatePatchwerk]]
    BNToastFrame.BG:SetTexCoord(0, .415, .6, .69)
    BNToastFrame.BG:SetVertexColor(.7, .7, .7)

    BNToastFrame:HookScript('OnShow', function(self)
        local top = BNToastFrameTopLine:GetStringWidth()
        local bot = BNToastFrameBottomLine:GetStringWidth()

        BNToastFrameIconTexture:SetSize(20, 20)
    	BNToastFrameIconTexture:ClearAllPoints()
    	BNToastFrameIconTexture:SetPoint('TOPLEFT', 14, -26)

        BNToastFrameTopLine:ClearAllPoints()
    	BNToastFrameTopLine:SetPoint('TOPLEFT', 32, -16)

    	BNToastFrameMiddleLine:Hide()

    	BNToastFrameBottomLine:ClearAllPoints()
    	BNToastFrameBottomLine:SetPoint('TOPLEFT', 32, -32)

        BNToastFrameCloseButton:ClearAllPoints()
        BNToastFrameCloseButton:SetPoint('TOPRIGHT', -5, -8)

        self:SetBackdrop(nil)
        self:ClearAllPoints()
        self:SetPoint('TOPLEFT', ChatFrame1, 'TOPRIGHT', 20, -6)
        self:SetSize(bot > top and bot + 55 or top + 55, 60)
    end)

    SlashCmdList['TOAST'] = function()
    	BNToastFrame:Show()
        BNToastFrameTopLine:SetText'Modernist The Fine'
        BNToastFrameBottomLine:SetText'has gone offline'
        BNToastFrame:SetSize(BNToastFrameTopLine:GetStringWidth() + 45, 40)
    end
    SLASH_TOAST1 = '/to'


    --
