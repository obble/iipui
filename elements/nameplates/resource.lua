

    local _, ns = ...

    local x = 13

    local GetIcicles = function()
    --
    end

    local charge = function(self)   -- mage [arcane]
        local t   = [[Interface\AddOns\iipui\art\resource\charge.tga]]
        --[[local max = UnitPowerMax('player', SPELL_POWER_ARCANE_CHARGES)
        for i = 1, max do
            self.Charges[i].ChargeTexture:SetSize(18, 18)
            self.Charges[i].ChargeTexture:SetTexture(t)
            self.Charges[i].ChargeTexture:SetVertexColor(1, 1, 1)
            if not self.Charges[i].bg then
                self.Charges[i].bg = self.Charges[i]:CreateTexture(nil, 'BACKGROUND')
                self.Charges[i].bg:SetSize(18, 18)
                self.Charges[i].bg:SetPoint'CENTER'
                self.Charges[i].bg:SetTexture(t)
                self.Charges[i].bg:SetTexCoord(1, 0, 0, 1)
                self.Charges[i].bg:SetVertexColor(.7, .2, 1)
            end
        end]]
    end

    local cp = function(self)       -- rogue/druid
        local t   = [[Interface\AddOns\iipui\art\resource\cp.tga]]
        --[[local max = UnitPowerMax('player', SPELL_POWER_COMBO_POINTS)
        for i = 1, max do
            self.ComboPoints[i].Point:SetSize(x, x)
            self.ComboPoints[i].Point:SetTexture(t)
            self.ComboPoints[i].Point:SetVertexColor(0, 1, .1)
            self.ComboPoints[i].Background:SetSize(x, x)
            self.ComboPoints[i].Background:SetTexture(t)
            self.ComboPoints[i].Background:SetVertexColor(.2, .2, .2)
        end]]
    end

    local icicle = function(self)       -- mage (frost)
        local t   = [[Interface\AddOns\iipui\art\resource\cp.tga]]
        --[[for i = 1, GetIcicles() do
            self.Icicles[i].Point:SetSize(x, x)
            self.Icicles[i].Point:SetTexture(t)
            self.Icicles[i].Point:SetVertexColor(0, 1, .1)
            self.Icicles[i].Background:SetSize(x, x)
            self.Icicles[i].Background:SetTexture(t)
            self.Icicles[i].Background:SetVertexColor(.2, .2, .2)
        end]]
    end

    local AddHooks = function(frame)
        hooksecurefunc(ClassNameplateBarMageFrame,          'UpdatePower', charge)
        -- hooksecurefunc(ClassNameplateBarMageFrame,          'UpdatePower', icicles) -- this should be done by aura event!
        hooksecurefunc(ClassNameplateBarRogueDruidFrame,    'UpdatePower', cp)
    end

    local NAME_PLATE_CREATED = function(self, event, ...)
        local base = ...
        AddHooks(base.UnitFrame)
    end

    lip:RegisterEvent('NAME_PLATE_CREATED', NAME_PLATE_CREATED)


    --
