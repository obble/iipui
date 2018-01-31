


    --  style api
    --

    local _, ns = ...

    ns.DecimalRound = function(v)
        local  shift = 10^1
        local  result = floor(v*shift+.5)/shift
        return result
    end

    ns.siValue = function(v)
        if not v then return '' end
        local absvalue = abs(v)
        local str, val
        if absvalue >= 1e10 then
            str, val = '%.0fb', v/1e9
        elseif absvalue >= 1e9 then
            str, val = '%.1fb', v/1e9
        elseif absvalue >= 1e7 then
            str, val = '%.1fm', v/1e6
        elseif absvalue >= 1e6 then
            str, val = '%.2fm', v/1e6
        elseif absvalue >= 1e5 then
            str, val = '%.0fk', v/1e3
        elseif absvalue >= 1e3 then
            str, val = '%.1fk', v/1e3
        else
            str, val = '%d', v
        end
        return format(str, val)
    end

    function SecondsToTimeAbbrev(time)
        local hr, m, s, text
        if time <= 0 then
            text = ''
        elseif time < 3600 and time > 60 then
            hr = floor(time/3600)
            m = floor(mod(time, 3600)/60 + 1)
            text = format('%dm', m)
        elseif time < 60 then
            m = floor(time/60)
            s = mod(time, 60)
            text = m == 0 and format('%ds', s)
        else
            hr = floor(time/3600 + 1)
            text = format('%dh', hr)
        end
        return text
     end


    --
