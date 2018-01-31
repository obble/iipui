

    local _, ns = ...

    if not iipRaidX then
		iipRaidX = 50
		iipRaidY = 35
	end

	ns.CreateSizingFrame = function()
		--[[local sizer = CreateFrame('Button', 'iipraidsizer', oUF_partyUnitButton1.Health)
		sizer:SetSize(16, 16)
		sizer:SetPoint('BOTTOMRIGHT', 5, -5)
		sizer:SetNormalTextureInterface\ChatFrame\UI-ChatIM-SizeGrabber-Up
		sizer:SetHighlightTextureInterface\ChatFrame\UI-ChatIM-SizeGrabber-Highlight
		sizer:SetPushedTextureInterface\ChatFrame\UI-ChatIM-SizeGrabber-Down

		local UpdateFrames = function()
			for i = 1, 40 do
				local bu = _G['oUF_partyUnitButton'..i]
				if 	bu then
					local x, y = oUF_partyUnitButton1:GetWidth(), oUF_partyUnitButton1:GetHeight()
					bu:SetSize(50, 35)
					iipRaidX, iipRaidY = 50, 35	-- save as cvar
				end
			end
			for i = 1, 8 do
				local bu = _G['iipRaidGroupNo'..i]
				if bu then
					if i == 1 then
						bu:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', 0, 50 + (oUF_partyUnitButton1:GetHeight() - 5))
					else
						bu:SetPoint('BOTTOMLEFT', _G['iipRaidGroupNo'..(i - 1)], 'TOPLEFT', 0, oUF_partyUnitButton1:GetHeight())
					end
				end
			end
		end

		sizer:SetScript('OnMouseDown', function(self)
			self:SetButtonState('PUSHED', true)
			self:GetHighlightTexture():Hide()
			if InCombatLockdown() then
				print'You can\'t resize raid frames in combat!'
			else
				_G['oUF_partyUnitButton1']:StartSizing'BOTTOMRIGHT'
				self:SetScript('OnUpdate', UpdateFrames)
			end
		end)

		sizer:SetScript('OnMouseUp', function(self)
			self:SetButtonState('NORMAL', false)
			self:GetHighlightTexture():Show()
			self:SetScript('OnUpdate', nil)
			oUF_partyUnitButton1:StopMovingOrSizing()
		end)]]
	end

    --
