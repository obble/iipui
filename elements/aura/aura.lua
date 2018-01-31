

    local _, ns = ...

    local e = CreateFrame'Frame'

    local layout    = {
        ['player|HELPFUL']  = {
            point           = 'TOPRIGHT',
            sort            = 'TIME',
            minWidth        = 330,
            minHeight       = 100,
            x               = -32,
            y               = 0,
            wrapAfter       = 6,
            wrapY           = -42,
            direction       = '+',
            position        = {
                'TOPRIGHT',
                ObjectiveTrackerFrame,
                'TOPLEFT',
                -42,
                -14,
            },
        },
        ['player|HARMFUL']  = {
            point           = 'TOPRIGHT',
            sort            = 'TIME',
            minWidth        = 330,
            minHeight       = 100,
            x               = -50,
            wrapAfter       = 1,
            wrapY           = -50,
            direction       = '+',
            position        = {
                'TOPRIGHT',
                ObjectiveTrackerFrame,
                'TOPLEFT',
                -42,
                -150,
            },
        },
        ['weapons|NA']      =   {
            xOffset         = 40,
            position        = {
                'TOPRIGHT',
                -300,
                -200,
            },
        },
    }

    local UpdateSB = function(self, duration, expiration)
        self.sb:Hide()
        self.stone:SetPoint('BOTTOMRIGHT', self, 4, -4)
        if  expiration and duration > 0 then
            local p = duration/expiration
            self.sb:SetMinMaxValues(0, duration)
            self.sb:SetValue(expiration)
            self.sb:SetStatusBarColor(self.debuff and 1*p or 0, self.debuff and 0 or 1*p, 0)
            self.sb:Show()
            self.stone:SetPoint('BOTTOMRIGHT', self, 4, -12)
        end
    end

    local OnUpdate = function(self, elapsed)
    	if  self.expiration then
    		self.expiration = max(self.expiration - elapsed, 0)
    		self:SetText(SecondsToTimeAbbrev(self.expiration))
            UpdateSB(self, self.duration, self.expiration)
    	end
    end

    local FormatDebuffs = function(self, name, dtype)
        if  name then
            local colour = DebuffTypeColor[dtype or 'none']
            self.Name:SetText(strupper(name))
            self.Name:SetTextColor(colour.r*1.7, colour.g*1.7, colour.b*1.7)    -- brighten up
            self.Name:SetWidth(120)
            self.Name:SetWordWrap(true)
            self.bo:SetBackdropBorderColor(colour.r, colour.g, colour.b)
        else
            self.Name:SetText''
            self.bo:SetBackdropBorderColor(0, 0, 0, 0)
        end
    end

    local OnAttributeChanged = function(self, attribute, index)
    	if attribute ~= 'index' then return end
        local header = self:GetParent()
        local unit, filter = header:GetAttribute'unit', header:GetAttribute'filter'
    	local name, _, icon, count, dtype, duration, expiration = UnitAura(unit, index, filter)
    	if  name then
    		self:SetNormalTexture(icon)
    		self.Count:SetText(count > 1 and count or '')

            self.debuff     = false
            self.duration   = duration
    		self.expiration = expiration - GetTime()

            if  self.expiration and self.duration > 0 then
                self.sb:SetMinMaxValues(0, self.duration)
            end

            if  filter == 'HARMFUL' then
                self.debuff = true
                FormatDebuffs(self, name, dtype)
            end
    	end
    end

    local AddButton = function(self, name, bu)
    	if not name:match'^child' then return end       -- ty p3lim

    	ns.BD(bu)
        ns.BUBorder(bu)
        ns.BDStone(bu)

    	bu:SetScript('OnUpdate',            OnUpdate)
        bu:SetScript('OnAttributeChanged',  OnAttributeChanged)

    	local icon = bu:CreateTexture('$parentTexture', 'BORDER')
    	icon:SetAllPoints()
    	icon:SetTexCoord(.1, .9, .1, .9)

        local name = bu:CreateFontString('$parentName', nil, 'iipAuraFont')
        name:SetJustifyH'RIGHT'
        name:SetPoint('RIGHT', bu, 'LEFT', -15, 2)

    	local d = bu:CreateFontString('$parentDuration', nil, 'GameFontNormalSmall')
    	d:SetPoint('TOP', bu, 'BOTTOM', 0, -12)

    	local count = bu:CreateFontString('$parentCount', nil, 'iipAuraFont')
    	count:SetPoint('BOTTOMRIGHT', -1, 1)

        local sb = CreateFrame('StatusBar', nil, bu)
        ns.SB(sb)
        sb:SetHeight(5)
        sb:SetPoint'LEFT'
        sb:SetPoint'RIGHT'
        sb:SetPoint('TOP', bu, 'BOTTOM', 0, -3)
        sb:SetMinMaxValues(0, 1)
        sb:Hide()

        sb.bg = sb:CreateTexture(nil, 'BACKGROUND')
        sb.bg:SetTexture[[Interface\ChatFrame\ChatFrameBackground]]
        sb.bg:SetPoint('TOPLEFT', -3, 1)
        sb.bg:SetPoint('BOTTOMRIGHT', 3, -3)
        sb.bg:SetVertexColor(0, 0, 0)

        bu:SetFontString(d)
        bu:SetNormalTexture(icon)

    	bu.Count = count
        bu.Name  = name
        bu.sb    = sb
    end

    local AddHeader = function(unit, filter, attribute)
        local Header = CreateFrame('Frame', 'iipauras'..filter, UIParent, 'SecureAuraHeaderTemplate')
        Header:SetAttribute('template',         'iipauraTemplate')
        Header:SetAttribute('unit',             unit)
        Header:SetAttribute('filter',           filter)
        Header:SetAttribute('includeWeapons',   1)  --  ?
        Header:SetAttribute('xOffset',          attribute.x)
        Header:SetPoint(unpack(attribute.position))

        if  unit ~= 'weapons' then
            Header:SetAttribute('sortDirection',    attribute.direction)
            Header:SetAttribute('sortMethod',       attribute.sort)
            Header:SetAttribute('sortDirection',    attribute.direction)
            Header:SetAttribute('point',            attribute.point)
            Header:SetAttribute('minWidth',         attribute.minWidth)
            Header:SetAttribute('minHeight',        attribute.minHeight)
            Header:SetAttribute('xOffset',          attribute.x)
            Header:SetAttribute('wrapYOffset',      attribute.wrapY)
            Header:SetAttribute('wrapAfter',        attribute.wrapAfter)
        end

        Header:HookScript('OnAttributeChanged', AddButton)
        Header:Show()

        RegisterAttributeDriver(Header, 'unit', '[vehicleui] vehicle; player')
    end

    local RemoveBuffFrame = function()
        for _, v in pairs({TemporaryEnchantFrame, BuffFrame}) do
            v:UnregisterAllEvents()
            v:Hide()
        end
    end

    local AddHeader = function()
        e:UnregisterAllEvents()
        RemoveBuffFrame()
        for i ,v in pairs(layout) do
            local unit, filter = i:match'(.-)|(.+)'
            if unit then
                AddHeader(unit, filter, v)
            end
        end
    end

    e:RegisterEvent'PLAYER_ENTERING_WORLD'
    e:SetScript('OnEvent', AddHeader)

    --
