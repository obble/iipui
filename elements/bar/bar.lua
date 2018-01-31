

	local _, ns = ...

	ns.BAR_ELEMENTS = {} --  inserted in buttons.lua
	wipe(ns.BAR_ELEMENTS)

	local f = CreateFrame('Frame', 'iipbar', UIParent)
	f:SetHeight((ns.DELEGATE_BARS_SHOWN and 40 + 26*ns.DELEGATE_BARS_SHOWN or 65) + 30)
	f:SetPoint('LEFT', 250, 0) f:SetPoint'RIGHT' f:SetPoint'BOTTOM'
	f:SetFrameLevel(0)
	f:EnableMouse(false)

	local bar = CreateFrame('Frame', 'iipbar_collapse', UIParent)
	bar:SetHeight(ns.DELEGATE_BARS_SHOWN and 104 or 70)
	bar:SetPoint('LEFT', -250)
	bar:SetPoint('RIGHT', 250)
	bar:SetPoint('TOP', UIParent, 'BOTTOM', 0, ns.DELEGATE_BARS_SHOWN and 40 + 28*ns.DELEGATE_BARS_SHOWN or 65)

	bar.metal = bar:CreateTexture(nil, 'BACKGROUND')
	bar.metal:SetSize(310, 20)
	bar.metal:SetPoint('BOTTOM', bar, 0, ns.DELEGATE_BARS_SHOWN and 16*ns.DELEGATE_BARS_SHOWN or 32)
	bar.metal:SetTexture[[Interface\QUESTFRAME\AutoQuest-Parts]]
	bar.metal:SetTexCoord(.44, .9, 0, .5)
	bar.metal:SetAlpha(.65)

	--[[

	bar.px2 = bar:CreateTexture(nil, 'OVERLAY')
	bar.px2:SetHeight(7)
	bar.px2:SetPoint('TOPLEFT', bar.metal, 0, -6) bar.px2:SetPoint('TOPRIGHT', bar.metal, 0, -6)
	bar.px2:SetColorTexture(0, 0, 0)

	bar.organic = bar:CreateTexture(nil, 'OVERLAY', 0, 7)
	bar.organic:SetHeight(4)
	bar.organic:SetPoint('TOPLEFT', bar.metal, 0, -8) bar.organic:SetPoint('TOPRIGHT', bar.metal, 0, -8)
	bar.organic:SetTexture(Interface/PetBattles/_PetJournalHorizTile, true)
	bar.organic:SetTexCoord(0, 1, .23, .44)
	bar.organic:SetHorizTile(true)]]


	--
