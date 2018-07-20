
	local _, ns = ...

	IIP_VAR = {
		['clock'] = {
			military		= false,
		},
		['minimap'] = {
			show_banner		= true,
		},
		['raid']  = {
			pets			= true, -- undecided
			name  			= true,
			maintankassist 	= true,
			power 			= true,
			role  			= true,
			value 			= true,
		},
	}

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
