

	local _, ns = ...

	local hide = CreateFrame'Frame'
	hide:Hide()

	--[[for _, event in pairs(
		{
			'DISPLAY_SIZE_CHANGED',
			'UI_SCALE_CHANGED'
		}
	) do
		MainMenuBar:UnregisterEvent(event)
	end]]

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
			MainMenuBarArtFrameBackground,
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
			MicroButtonAndBagsBar,
			ActionBarUpButton,
			ActionBarDownButton,
		}
	) do
		v:SetParent(hide)

	end

	for _, v in pairs(
		{
  		MainMenuBarVehicleLeaveButton,
		ExhaustionTick,
  		ReputationWatchBar,
		ArtifactWatchBar,
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
		StatusTrackingBarManager,
		MainMenuBarArtFrame,
		MicroButtonAndBagsBar
	}) do
		v:SetAlpha(0)
		v:ClearAllPoints()
		v:SetPoint('BOTTOMRIGHT', UIParent, 0, -9001)	-- LOL i guess this fixes the scale error from MultiActionBar_Update  ?
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
		--OverrideActionBar[v]:SetAlpha(0)
	end

	for _, v in pairs(
		{
			MainMenuBarArtFrame,
			PetActionBarFrame,
		}
	) do
		--UIPARENT_MANAGED_FRAME_POSITIONS.v = nil
	end

	for _, v in pairs(
		{
			TimerTracker,
			MainMenuBar,
		}
	) do
		tinsert(ns.bar_elements, v)
	end


	--
