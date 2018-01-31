

	local hide = CreateFrame'Frame'
	hide:Hide()

	for _, v in pairs({
			-- main
		MainMenuBar,	MainMenuExpBar,
			-- override
		OverrideActionBarExpBar,	OverrideActionBarHealthBar,
		OverrideActionBarPowerBar,	OverrideActionBarPitchFrame,
	}) do
		v:SetParent(hide)
	end

	for _, v in pairs({
		CharacterMicroButton,			SpellbookMicroButton,
		TalentMicroButton,				AchievementMicroButton,
		QuestLogMicroButton,			GuildMicroButton,
		LFDMicroButton,					CollectionsMicroButton,
		EJMicroButton,					StoreMicroButton,
		MainMenuMicroButton,			TalentMicroButtonAlert,
		CollectionsMicroButtonAlert,	LFDMicroButtonAlert,
	}) do
		v:SetAlpha(0)
		v:ClearAllPoints()
		v:SetPoint('TOP', UIParent, 0, 9001)
	end

	for _, v in pairs({
		StanceBarLeft,            StanceBarMiddle,     	StanceBarRight,
		SlidingActionBarTexture0, SlidingActionBarTexture1,
		PossessBackground1,       PossessBackground2,
		MainMenuBarTexture0,      MainMenuBarTexture1, 	MainMenuBarTexture2, 	MainMenuBarTexture3,
	    MainMenuBarLeftEndCap,    MainMenuBarRightEndCap,
	}) do
		v:SetTexture(nil)
	end

	for _, v in pairs({
		'_BG',       '_Border',
		'EndCapL',   'EndCapR',
		'Divider1',  'Divider2',  'Divider3',
		'ExitBG',
		'MicroBGL',  'MicroBGR',  '_MicroBGMid',
		'ButtonBGL', 'ButtonBGR', '_ButtonBGMid',
	}) do
		OverrideActionBar[v]:SetAlpha(0)
	end

	for _, v in pairs({
		MainMenuBarArtFrame,
		PetActionBarFrame,
	}) do
		UIPARENT_MANAGED_FRAME_POSITIONS.v = nil
	end

	
	--
