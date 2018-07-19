
	local _, ns = ...

	local e = CreateFrame'Frame'

	local bars = {
		['zone'] = {
			positions 	= {'BOTTOM', UIParent, 'BOTTOM', 0, 34},
			size		= 36,
			scale		= .8,
		}
	}

	local add = function(bu)
		if  not ns.bar_elements[bu] then
			tinsert(ns.bar_elements, bu)
		end
	end

	local AddZoneBar = function(self)
		local t			= bars['zone']
		local bar 		= CreateFrame('Frame', 'iipZoneAbilityBar', UIParent, 'SecureHandlerStateTemplate')
		bar._id 		= 'zone'
		bar._buttons 	= {}

		bar.Update 		= Update

		add(bar)
		add(ZoneAbilityFrame)

		UIPARENT_MANAGED_FRAME_POSITIONS.ZoneAbilityFrame = nil
		ZoneAbilityFrame:SetParent(bar)
		ZoneAbilityFrame:SetScale(t.scale)
		ZoneAbilityFrame:ClearAllPoints()
		ZoneAbilityFrame:SetPoint(t.positions[1], t.positions[2], t.positions[3], t.positions[4], t.positions[5])
		ZoneAbilityFrame:SetFrameStrata'HIGH'

		ns.BU(ZoneAbilityFrame.SpellButton)
		ns.BUElements(ZoneAbilityFrame.SpellButton)
		ZoneAbilityFrame.SpellButton:SetSize(t.size, t.size)

		ZoneAbilityFrame.SpellButton:GetNormalTexture():SetTexture''

		ZoneAbilityFrame.SpellButton.Style:SetDrawLayer'BACKGROUND'

		ZoneAbilityFrame.SpellButton.Icon:SetDrawLayer'ARTWORK'
		ZoneAbilityFrame.SpellButton.Icon:SetTexCoord(.1, .9, .1, .9)
	end

	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', AddZoneBar)



	--
