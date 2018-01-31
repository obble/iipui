


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


    --
