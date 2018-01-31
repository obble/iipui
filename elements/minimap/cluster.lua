

	local _, ns = ...
	
	hooksecurefunc('UIParent_ManageFramePositions', function()
		if NUM_EXTENDED_UI_FRAMES then
			for i = 1, NUM_EXTENDED_UI_FRAMES do
				local bar = _G['WorldStateCaptureBar'..i]
				if bar and bar:IsVisible() then
					bar:ClearAllPoints()
					if  i == 1 then
						bar:SetPoint('TOP', MinimapCluster, 'BOTTOM', 5, -30)
					else
						bar:SetPoint('TOP', _G['WorldStateCaptureBar'..(i - 1)], 'BOTTOM', 0, -20)
					end
				end
			end
		end
	end)

	hooksecurefunc(DurabilityFrame, 'SetPoint', function(self, _, parent)
		if  parent == 'MinimapCluster' or parent == _G['MinimapCluster'] then
			self:ClearAllPoints()
			self:SetPoint('TOP', UIParent, 0, -200)
			self:SetScale(.7)
			self:SetParent(Minimap)
		end
	end)

	hooksecurefunc(VehicleSeatIndicator,'SetPoint', function(self, _, parent)
		if  parent == 'MinimapCluster' or parent == _G['MinimapCluster'] then
			self:ClearAllPoints()
			self:SetPoint('TOP', Minimap, 'BOTTOM', 0, -60)
			self:SetScale(.7)
		end
	end)


	--
