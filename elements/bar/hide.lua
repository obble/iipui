

	local hide = CreateFrame'Frame'
	hide:Hide()

	local function DisableAllScripts(f)
  		for _, v in pairs({
  			'OnShow',
  			'OnHide',
  			'OnEvent',
  			'OnEnter',
  			'OnLeave',
  			'OnUpdate',
  			'OnValueChanged',
  			'OnClick',
  			'OnMouseDown',
  			'OnMouseUp',
		}) do
   			if  f:HasScript(v) then
      			f:SetScript(v, nil)
    		end
  		end
	end

	for _, v in pairs(
		{
			MainMenuBar,
			OverrideActionBar,
			StanceBarLeft,
			StanceBarMiddle,
			StanceBarRight,
			SlidingActionBarTexture0,
			SlidingActionBarTexture1,
			PossessBackground1,
			PossessBackground2,
			MainMenuBarTexture0,
			MainMenuBarTexture1,
			MainMenuBarTexture2,
			MainMenuBarTexture3,
	    	MainMenuBarLeftEndCap,
			MainMenuBarRightEndCap,
		}
	) do
		v:SetParent(hide)
	end

	for _, v in pairs(
		{
  		MainMenuBar,
  		MainMenuBarVehicleLeaveButton,
		ExhaustionTick,
  		ReputationWatchBar,
		ArtifactWatchBar,
		HonorWatchBar,
		MainMenuExpBar,
		MainMenuBarMaxLevelBar,
  		OverrideActionBar,
  		OverrideActionBarExpBar,
		OverrideActionBarHealthBar,
		OverrideActionBarPowerBar,
		OverrideActionBarPitchFrame,
		}
	) do
		v:UnregisterAllEvents()
   		DisableAllScripts(v)
  	end

  	for _, v in pairs({
		CharacterMicroButton,
		SpellbookMicroButton,
		TalentMicroButton,
		AchievementMicroButton,
		QuestLogMicroButton,
		GuildMicroButton,
		LFDMicroButton,
		CollectionsMicroButton,
		EJMicroButton,
		StoreMicroButton,
		MainMenuMicroButton,
		TalentMicroButtonAlert,
		CollectionsMicroButtonAlert,
		LFDMicroButtonAlert,
	}) do
		v:SetAlpha(0)
		v:ClearAllPoints()
		v:SetPoint('TOP', UIParent, 0, 9001)
	end

	for _, v in pairs(
		{
			'_BG',
			'_Border',
			'EndCapL',
			'EndCapR',
			'Divider1',
			'Divider2',
			'Divider3',
			'ExitBG',
			'MicroBGL',
			'MicroBGR',
			'_MicroBGMid',
			'ButtonBGL',
			'ButtonBGR',
			'_ButtonBGMid',
		}
	) do
		OverrideActionBar[v]:SetAlpha(0)
	end

	for _, v in pairs(
		{
			MainMenuBarArtFrame,
			PetActionBarFrame,
		}
	) do
		UIPARENT_MANAGED_FRAME_POSITIONS.v = nil
	end


	--
