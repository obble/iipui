

    local slash = function()
        SLASH_ADDONUSAGE3 = '/au'
    end

    local LoadAddonUsageSlashCMD = function(_, _, addon)
        if  addon == 'AddonUsage' then
            slash()
            lip:UnregisterEvent('ADDON_LOADED', LoadAddonUsageSlashCMD)
        end
    end


    if  IsAddOnLoaded'AddonUsage' then
        slash()
    else
        lip:RegisterEvent('ADDON_LOADED', LoadAddonUsageSlashCMD)
    end



    --
