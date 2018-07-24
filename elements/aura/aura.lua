

    local _, ns = ...

    local e = CreateFrame'Frame'

    local layout    = {
        ['player|HELPFUL']  = {
            point           = 'TOPRIGHT',
            sort            = 'TIME',
            minWidth        = 330,
            minHeight       = 100,
            x               = -38,
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
        if  expiration and duration > 0 then
            -- local p = duration/expiration
            self.sb:SetMinMaxValues(0, duration)
            self.sb:SetValue(expiration)
            self.sb:SetStatusBarColor(self.debuff and 1 or 0, self.debuff and 0 or 1, 0)
            self.sb:Show()
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
            for  i, v in pairs(self.F.bo) do
                 self.F.bo[i]:SetVertexColor(colour.r, colour.g, colour.b)
            end
        else
            self.Name:SetText''
            for  i, v in pairs(self.F.bo) do
                 self.F.bo[i]:SetVertexColor(1, 1, 1)
            end
        end
    end

    local OnAttributeChanged = function(self, attribute, index)
    	if attribute ~= 'index' then return end
        local header = self:GetParent()
        local unit, filter = header:GetAttribute'unit', header:GetAttribute'filter'
        local name, icon, count, dtype, duration, expiration = UnitAura(unit, index, filter)
        --local name, texture, count, dtype, duration, expiration
    	if  name then
    		self:SetNormalTexture(icon)
    		self.Count:SetText(count > 0 and count or '')

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

    	bu:SetScript('OnUpdate',            OnUpdate)
        bu:SetScript('OnAttributeChanged',  OnAttributeChanged)

        bu.F = CreateFrame('Frame', nil, bu)
        bu.F:SetAllPoints()
        ns.BD(bu)

        ns.BUBorder(bu.F, 20)

    	local icon = bu:CreateTexture('$parentTexture', 'ARTWORK')
    	icon:SetAllPoints()
    	icon:SetTexCoord(.1, .9, .1, .9)

        local name = bu:CreateFontString('$parentName', nil, 'iipAuraFont')
        name:SetFont([[Fonts\skurri.ttf]], 14)
        name:SetShadowOffset(1, -1)
    	name:SetShadowColor(0, 0, 0)
        name:SetJustifyH'RIGHT'
        name:SetPoint('RIGHT', bu, 'LEFT', -15, 2)

    	local d = bu:CreateFontString('$parentDuration', nil, 'GameFontNormalSmall')
    	d:SetPoint('TOP', bu, 'BOTTOM', 0, -8)

    	local count = bu:CreateFontString('$parentCount', nil, 'iipAuraFont')
        count:SetParent(bu.F)
        count:SetJustifyH'CENTER'
    	count:SetPoint('CENTER', bu, 'TOP', 0, 2)

        local sb = CreateFrame('StatusBar', nil, bu)
        ns.BD(sb, 1, -2)
        ns.SB(sb)
        sb:SetHeight(5)
        sb:SetPoint'LEFT'
        sb:SetPoint'RIGHT'
        sb:SetPoint'BOTTOM'
        sb:SetMinMaxValues(0, 1)
        sb:Hide()

        sb.bg = sb:CreateTexture(nil, 'BORDER')
        ns.SB(sb.bg)
        sb.bg:SetAllPoints()
        sb.bg:SetVertexColor(.2, .2, .2)

        bu:SetFontString(d)
        bu:SetNormalTexture(icon)

    	bu.Count = count
        bu.Name  = name
        bu.sb    = sb
    end

    local AddHeader = function(unit, filter, attribute)
        local Header = CreateFrame('Frame', 'iipauras'..filter, Minimap, 'SecureAuraHeaderTemplate')
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
