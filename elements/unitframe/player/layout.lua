

	local _, ns = ...

	ns.UnitSpecific.player = function(self, ...)
		ns.SharedLayout(self, ...)

		self:SetFrameLevel(1)	-- for layering
		self:SetSize(137, 20)

		local Health, Power, Castbar, RaidIcon = self.Health, self.Power, self.Castbar, self.RaidTargetIndicator

		Health:SetHeight(9)

		local Portrait = self.Health:CreateTexture(nil, 'ARTWORK')
		Portrait:SetSize(46, 46)
		Portrait:SetPoint('LEFT', self, -70, 0)

		Portrait.BG = self.Health:CreateTexture(nil, 'BACKGROUND')
		Portrait.BG:SetSize(128, 128)
		Portrait.BG:SetTexture[[Interface\COMMON\portrait-ring-withbg]]
		Portrait.BG:SetPoint('LEFT', self, -110, 0)

		Portrait.vehicle = self.Health:CreateTexture(nil, 'OVERLAY')
		Portrait.vehicle:SetSize(80, 80)
		Portrait.vehicle:SetTexture[[Interface\Artifacts\RelicForge]]
		Portrait.vehicle:SetPoint('LEFT', self, -92, 0)
		Portrait.vehicle:SetTexCoord(.59, .66, .49, .56)

		self.Border  = {}

		self.Border.left = self:CreateTexture(nil, 'OVERLAY')
		self.Border.left:SetSize(24, 42)
		self.Border.left:SetPoint('LEFT', -13, 0)
		self.Border.left:SetTexture[[Interface\AUCTIONFRAME/UI-AuctionPost-Endcaps]]
		self.Border.left:SetTexCoord(.5, 1, 0, 1)

		self.Border.middle = self:CreateTexture(nil, 'OVERLAY')
		self.Border.middle:SetSize(118, 42)
		self.Border.middle:SetPoint'CENTER'
		self.Border.middle:SetTexture([[Interface\AUCTIONFRAME/UI-AuctionPost-Middle]], true)
		self.Border.middle:SetHorizTile(true)

		self.Border.right = self:CreateTexture(nil, 'OVERLAY')
		self.Border.right:SetSize(24, 42)
		self.Border.right:SetPoint('RIGHT', 13, 0)
		self.Border.right:SetTexture[[Interface\AUCTIONFRAME/UI-AuctionPost-Endcaps]]
		self.Border.right:SetTexCoord(0, .5, 0, 1)

		self.Border.shadow = self:CreateTexture(nil, 'BACKGROUND')
		self.Border.shadow:SetPoint('TOPLEFT', self,  -15, 15)
		self.Border.shadow:SetPoint('BOTTOMRIGHT', self,  15, -15)
		self.Border.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
		self.Border.shadow:SetVertexColor(0, 0, 0, 1)
		self.Border.shadow:SetTexCoord(0, .641, 0, .18)

			-- TODO:	position and insert into oUF
		local AltPowerBar = CreateFrame('StatusBar', nil, self)
		AltPowerBar:SetHeight(9)
		AltPowerBar:SetStatusBarTexture(TEXTURE)
		AltPowerBar:SetStatusBarColor(1, 1, 1)

		ns.BD(Castbar)
		ns.CLASS_COLOUR(Castbar)
		Castbar:ClearAllPoints()
		Castbar:SetPoint('BOTTOM', UIParent, 0, 200)
		Castbar:SetSize(136, 8)
		Castbar.timeToHold = .4

		Castbar.SafeZone = Castbar:CreateTexture(nil, 'ARTWORK')

		Castbar.IconBD = CreateFrame('Frame', nil, Castbar)
		Castbar.IconBD:SetSize(18, 18)
		Castbar.IconBD:SetPoint('BOTTOMLEFT', Castbar, 'TOPLEFT', 0, 24)
		Castbar.IconBD:SetFrameLevel(2)
		ns.BD(Castbar.IconBD)

		Castbar.Icon = Castbar:CreateTexture(nil, 'OVERLAY', nil, 7)
		Castbar.Icon:SetAllPoints(Castbar.IconBD)
		Castbar.Icon:SetTexCoord(.1, .9, .1, .9)

		Castbar.Icon.Border = Castbar:CreateTexture(nil, 'BACKGROUND', nil, -7)
		Castbar.Icon.Border:SetSize(35, 34)
		Castbar.Icon.Border:SetPoint('TOP', Castbar.Icon, 3, 5)
		Castbar.Icon.Border:SetTexture[[Interface\ACHIEVEMENTFRAME\UI-Achievement-Progressive-IconBorder]]
		Castbar.Icon.Border:SetTexCoord(.1, .65, .1, .6)

		Castbar.text = Castbar:CreateFontString(nil, 'ARTWORK')
		Castbar.text:SetPoint('LEFT', Castbar.Icon, 'RIGHT', 12, 0)
		Castbar.text:SetFont([[Fonts\ARIALN.ttf]], 11)
		Castbar.text:SetWidth(80)
		Castbar.text:SetJustifyH'LEFT'
		Castbar.text:SetWordWrap(true)
		Castbar.text:SetShadowOffset(1, -1)
		Castbar.text:SetShadowColor(0, 0, 0, 1)

		Castbar.left = Castbar:CreateTexture(nil, 'BACKGROUND', nil, -1)
		Castbar.left:SetSize(94, 64)
		Castbar.left:SetPoint('TOPLEFT', -26, 27)
		Castbar.left:SetTexture[[Interface\CastingBar\UI-CastingBar-Border]]
		Castbar.left:SetTexCoord(0, .5, 0, 1)
		Castbar.left:SetVertexColor(.8, .8, .8)

		Castbar.right = Castbar:CreateTexture(nil, 'BACKGROUND', nil, -1)
		Castbar.right:SetSize(95, 64)
		Castbar.right:SetPoint('TOPRIGHT', 26, 27)
		Castbar.right:SetTexture[[Interface\CastingBar\UI-CastingBar-Border]]
		Castbar.right:SetTexCoord(.5, 1, 0, 1)
		Castbar.right:SetVertexColor(.8, .8, .8)

		Castbar.shadow = Castbar:CreateTexture(nil, 'BACKGROUND', nil, -3)
		Castbar.shadow:SetPoint('TOPLEFT', Castbar,  -14, 11)
		Castbar.shadow:SetPoint('BOTTOMRIGHT', Castbar,  14, -11)
		Castbar.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
		Castbar.shadow:SetVertexColor(0, 0, 0, 1)
		Castbar.shadow:SetTexCoord(0, .641, 0, .18)

		RaidIcon:ClearAllPoints()
		RaidIcon:SetPoint('CENTER', Portrait, 'TOP')

		-- TODO:  	insert BuilderSpender
		--			add castbar parent to nameplate

			-- register new elements
		self.Portrait = Portrait
	end


	--
