
	local _, ns = ...

	local e = CreateFrame'Frame'

	local bars = {
		positions 	= {'BOTTOM', UIParent, 'BOTTOM', 0, 142},
		size		= 46,
		scale		= .925,
	}

	local add = function(bu)
		if  not ns.bar_elements[bu] then
			tinsert(ns.bar_elements, bu)
		end
	end

	local AddPositions = function(self)
		self:SetPoint(bars.positions[1], bars.positions[2], bars.positions[3], bars.positions[4], bars.positions[5])
		self:SetSize(bars.size, bars.size)
	end

	local AddZoneBar = function(self)
		local bar 		= CreateFrame('Frame', 'iipExtraActionBar', UIParent, 'SecureHandlerStateTemplate')
		bar._id 		= 'extra'
		bar._buttons 	= {}

		add(bar)
		add(ExtraActionButton1)

		ExtraActionBarFrame.ignoreFramePositionManager 			= true
		UIPARENT_MANAGED_FRAME_POSITIONS['ExtraActionBarFrame'] = nil

		ExtraActionBarFrame:EnableMouse(false)
		ExtraActionBarFrame:SetParent(bar)
		ExtraActionBarFrame:SetAllPoints()
		ExtraActionBarFrame:SetFrameStrata'LOW'
		--ExtraActionBarFrame.button.style:SetParent(UIParent)
		ExtraActionBarFrame.button.style:SetScale(bars.scale)

		ns.BU(ExtraActionButton1)
		ns.BUElements(ExtraActionButton1)
		ns.BUBorder(ExtraActionButton1, 27, 28)

		ExtraActionButton1:SetFrameStrata'HIGH'
		ExtraActionButton1:ClearAllPoints()
		ExtraActionButton1:SetPoint('TOPLEFT', bar, 2, -2)
		ExtraActionButton1:SetPoint('BOTTOMRIGHT', bar, -2, 2)
		ExtraActionButton1:SetFrameStrata'HIGH'
		ExtraActionButton1._parent 	= bar
		ExtraActionButton1._command = 'EXTRAACTIONBUTTON1'

		ExtraActionButton1.icon:ClearAllPoints()
		ExtraActionButton1.icon:SetPoint('TOPLEFT', bar, 5, -5)
		ExtraActionButton1.icon:SetPoint('BOTTOMRIGHT', bar, -5, 5)

		bar._buttons[1] = ExtraActionButton1

		AddPositions(bar)
	end

	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', AddZoneBar)



	--
