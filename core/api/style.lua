


    --  style api
    --

    local _, ns = ...

    local _, class = UnitClass'player'
    local colour   = RAID_CLASS_COLORS[class]

    ns.CLASS_COLOUR = function(f, a)
        if  f:GetObjectType() == 'StatusBar' then
            f:SetStatusBarColor(colour.r, colour.g, colour.b)
        elseif
            f:GetObjectType() == 'FontString' then
            f:SetTextColor(colour.r, colour.g, colour.b)
        else
            f:SetVertexColor(colour.r, colour.g, colour.b)
        end
    end

    ns.TEXT_WHITE = function(t, ...)
        t:SetTextColor(1, 1, 1)
    end

    ns.GRADIENT_COLOUR = function(f, v, min, max)
        if  not v then
            v = f:GetValue()
        end
        if  not min or not max then
             min, max = f:GetMinMaxValues()
        end
        if (not v) or v < min or v > max then return end
        if (max - min) > 0 then
            v = (v - min)/(max - min)
        else
            v = 0
        end
        if v > .5 then
            r = (1 - v)*2
            g = 1
        else
            r = 1
            g = v*2
        end
        b = 0
        if  f:GetObjectType() == 'StatusBar'  then
            f:SetStatusBarColor(r, g, b)
        elseif f:GetObjectType() == 'FontString' then
            f:SetTextColor(r*1.5, g*1.5, b*1.5)
        else
            f:SetVertexColor(r, g, b)
        end
    end


    --
