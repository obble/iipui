

	local _, ns = ...

	--  whitelisted auras for group frames
	-- currently HoT ONLY
	-- you can add or remove spells with the following format:
	--			[spellID]	= 	{ r, g, b}
	--


	ns.SwipeAuraList  = {
						--  druid
		[33763] 	= 	{r = 50/255,  	g = 185/255, 	b = 0},			--  lifebloom	 			green
		[48438] 	= 	{r = 255/255, 	g = 190/255, 	b = 160/255},	--  wild growth  			sunset
		[8936]   	=	{r = 255/255, 	g = 255/255, 	b = 255/255},	--  regrowth	 			white
		[774]		= 	{r = 150/255, 	g = 145/255, 	b = 230/255},	--  rejuvenation 			purple
						--  monk
		[124682] 	=	{r = 255/255, 	g = 55/255, 	b = 235/255},	--  enveloping mist			blue
		[191840]	=	{r = 255/255, 	g = 255/255, 	b = 255/255},	--  essence font			white
		[144080]	=	{r = 235/255, 	g = 170/255, 	b = 0/255},		--  renewing mist			gold
						--  paladin
		[1044]		= 	{r = 250/255, 	g = 100/255, 	b = 140/255},	--  blessing of freedom		stained pink
		[1022]		= 	{r = 100/255, 	g = 150/255, 	b = 250/255},	--  blessing of protection	lilac
						--  priest
		[17]		= 	{r = 255/255, 	g = 210/255, 	b = 0/255}, 	--  power word: shield		yellow
		[41635]		=	{r = 220/255, 	g = 220/255,	b = 220/255},	--  prayer of mending		off-white
		[139]		= 	{r = 45/255, 	g = 250/255, 	b = 0/255},		--  renew					acid
		[194384]	= 	{r = 255/255, 	g = 65/255,		b = 45/255},	--  atonement				red
						--  shaman
		[73920]		= 	{r = 255/255, 	g = 135/255, 	b = 0/255}, 	--  healing rain			orange
						--  mage
		[11426]		=  {r = 255/255, 	g = 255/255, 	b = 255/255},	--  ice barrier				white
		[130]		= {r = 255/255, 	g = 210/255, 	b = 0/255},		--  slowfall
	}


	--
