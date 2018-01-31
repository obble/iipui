
	local _, ns = ...

	local ADDON_LOADED = function(self, event, addon)
		if  iidCombatActionBar == nil then
			iidCombatActionBar = 1
		end
		if  iidRaidLayout == nil then
			iidRaidLayout = 1
		end
	end

	lip:RegisterEvent('ADDON_LOADED', ADDON_LOADED)


	--
