

	local _, ns = ...

	--  this file is run AFTER all core iipui code is loaded, but BEFORE elements are loaded

	--  adding frame names to this array will insert them into action bar show/hide behaviour
	--		frame names can be found in the framestack tooltip by typing '/fs'
	--  	and mousing over the frame in question.
	--		nb: no accounting for secure frame taint
	ns.CUSTOM_BAR_ELEMENTS = {

	}


	--
