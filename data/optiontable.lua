
local aceDBOptions = LibStub("AceDBOptions-3.0")

function Rekt:GetRektOptions()
	local db = self.db.profile;
	local options = {
		type = "group", name = "Rekt", childGroups = "tab",
		args = {
			enabled = {
				type = "toggle", name = "Enabled", desc = "Enable/Disable the addon", order = 0,
				get = function() return Rekt:isEnabled() end,
				set = function(_, v)
						Rekt:setEnabledOrDisabled(v);
					end
			},
			lock = {
				type = "toggle", name = "Lock", desc = "Uncheck to move the frames", order = 1,
				get = function() return Rekt:isLocked() end,
				set = function(_, v)
						db.locked = v;
						if v then Rekt:LockFrames() else Rekt:UnlockFrames() end;
					end
			},
			targetandfocus = {
				type = "group", name = "CDs", desc = "Cooldown frame's settings.", childGroups = "tab", order = 2,
				args = Rekt:getTargetandFocusOptions();
			},
			droptions = {
				type = "group", name = "DRs", desc = "DR frame's settings.", childGroups = "tab",order = 3,
				args = Rekt:getDROptions();
			},
			coloroptions = {
				type = "group", name = "Global", desc = "Global settings.", childGroups = "tab",order = 4,
				args = Rekt:getGlobalOptions()
			},
			debugoptions = {
				type = "group", name = "Debug", desc = "Debug settings.", childGroups = "tab", order = 5,
				args = Rekt:getDebugOptions();
			},
			profileoptions = aceDBOptions:GetOptionsTable(self.db)
		}
	}
	return options;
end

--order 10-20
function Rekt:getTargetandFocusOptions()
	local args = {
		targetHeader = {
			type = "header", name = "Target's settings", order = 10
		},
		targettoggle = {
			type = "toggle", name = "Target", desc = "Enable/Disable showing the target's cooldowns", order = 11,
			get = function() return Rekt:isPartEnabled("target") end,
			set = function(_, v)
				Rekt:SetPartEnabledOrDisabled("target", v);
			end
		},
		targetrange = {
			type = "range", name = "Target's size", order = 12, min = 10, max = 150, step = 1,
			get = function() return Rekt:getFrameSize("target") end,
			set = function(_, v)
				Rekt:setFrameSize("target", v);
			end
		},
		targetGrowSelect = {
			type = "select", style = "dropdown", name = "targetGrow", 
			desc = "Change which way the target's cooldowns will grow", order = 13, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left"
			},
			get = function() return Rekt:getGrowOrder("target") end,
			set = function(_, v)
				Rekt:setGrowOrder("target", v);
			end
		},
		targetSortSelect = {
			type = "select", style = "dropdown", name = "targetSortOrder", 
			desc = "Change the target's cooldowns's sort order", order = 14, 
			values = {
				["1"] = "Ascending (CD left)",
				["2"] = "Descending (CD left)",
				["3"] = "Ascending (CD total)",
				["4"] = "Descending (CD total)",
				["5"] = "Recent first",
				["6"] = "Recent Last",
				["7"] = "No order"
			},
			get = function() return Rekt:getSortOrder("target") end,
			set = function(_, v)
				Rekt:setSortOrder("target", v);
			end
		},
		targetcolortoggle = {
			type = "toggle", name = "Colors", desc = "Enable/Disable showing the target's cooldown's colors.", order = 15,
			get = function() return Rekt:getColorFrameEnabled("target") end,
			set = function(_, v)
				Rekt:setColorFrameEnabled("target", v);
			end
		},
		targetcolorrange = {
			type = "range", name = "Target's Color size", order = 16, min = 1, max = 30, step = 1,
			get = function() return Rekt:getColorFrameSize("target") end,
			set = function(_, v)
				Rekt:setColorFrameSize("target", v);
			end
		},
		focusHeader = {
			type = "header", name = "Focus's settings", order = 17
		},
		focustoggle = {
				type = "toggle", name = "Focus", desc = "Enable/Disable showing the focus's cooldowns", order = 18,
				get = function() return Rekt:isPartEnabled("focus") end,
				set = function(_, v)
					Rekt:SetPartEnabledOrDisabled("focus", v);
				end
		},
		focusRange = {
				type = "range", name = "Focus's size", order = 19, min = 10, max = 150, step = 1,
				get = function() return Rekt:getFrameSize("focus") end,
				set = function(_, v)
					Rekt:setFrameSize("focus", v);
				end
		},
		focusGrowSelect = {
			type = "select", style = "dropdown", name = "focusGrow", 
			desc = "Change which way the focus's cooldowns will grow", order = 20, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left"
			},
			get = function() return Rekt:getGrowOrder("focus") end,
			set = function(_, v)
				Rekt:setGrowOrder("focus", v);
			end
		},
		focusSortSelect = {
			type = "select", style = "dropdown", name = "focusSortOrder", 
			desc = "Change the focus's cooldowns's sort order", order = 21, 
			values = {
				["1"] = "Ascending (CD left)",
				["2"] = "Descending (CD left)",
				["3"] = "Ascending (CD total)",
				["4"] = "Descending (CD total)",
				["5"] = "Recent first",
				["6"] = "Recent Last",
				["7"] = "No order"
			},
			get = function() return Rekt:getSortOrder("focus") end,
			set = function(_, v)
				Rekt:setSortOrder("focus", v);
			end
		},
		focuscolortoggle = {
			type = "toggle", name = "Colors", desc = "Enable/Disable showing the target's cooldown's colors.", order = 22,
			get = function() return Rekt:getColorFrameEnabled("focus") end,
			set = function(_, v)
				Rekt:setColorFrameEnabled("focus", v);
			end
		},
		focuscolorrange = {
			type = "range", name = "Focus's Color size", order = 23, min = 1, max = 30, step = 1,
			get = function() return Rekt:getColorFrameSize("focus") end,
			set = function(_, v)
				Rekt:setColorFrameSize("focus", v);
			end
		},
		ibHeader = {
			type = "header", name = "InterruptBar's settings", order = 30
		},
		ibtoggle = {
			type = "toggle", name = "InterruptBar", desc = "Enable/Disable showing the InterruptBar", order = 31,
			get = function() return Rekt:isPartEnabled("interruptbar") end,
			set = function(_, v)
				Rekt:SetPartEnabledOrDisabled("interruptbar", v);
			end
		},
		ibrange = {
			type = "range", name = "InterruptBar's size", order = 32, min = 10, max = 150, step = 1,
			get = function() return Rekt:getFrameSize("interruptbar") end,
			set = function(_, v)
				Rekt:setFrameSize("interruptbar", v);
			end
		},
		ibGrowSelect = {
			type = "select", style = "dropdown", name = "InterruptBarGrow", 
			desc = "Change which way the InterruptBar's cooldowns will grow", order = 33, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left"
			},
			get = function() return Rekt:getGrowOrder("interruptbar") end,
			set = function(_, v)
				Rekt:setGrowOrder("interruptbar", v);
			end
		},
		ibSortSelect = {
			type = "select", style = "dropdown", name = "InterruptBarSortOrder", 
			desc = "Change the InterruptBar's cooldowns's sort order", order = 34, 
			values = {
				["1"] = "Ascending (CD left)",
				["2"] = "Descending (CD left)",
				["3"] = "Ascending (CD total)",
				["4"] = "Descending (CD total)",
				["5"] = "Recent first",
				["6"] = "Recent Last",
				["7"] = "No order"
			},
			get = function() return Rekt:getSortOrder("interruptbar") end,
			set = function(_, v)
				Rekt:setSortOrder("interruptbar", v);
			end
		},
		ibcolortoggle = {
			type = "toggle", name = "Colors", desc = "Enable/Disable showing the InterruptBar's cooldown's colors.", order = 35,
			get = function() return Rekt:getColorFrameEnabled("interruptbar") end,
			set = function(_, v)
				Rekt:setColorFrameEnabled("interruptbar", v);
			end
		},
		ibcolorrange = {
			type = "range", name = "InterruptBar's Color size", order = 36, min = 1, max = 30, step = 1,
			get = function() return Rekt:getColorFrameSize("interruptbar") end,
			set = function(_, v)
				Rekt:setColorFrameSize("interruptbar", v);
			end
		},
		--[[
		warnHeader = {
			type = "header", name = "Warn Frame's settings", order = 40
		},
		warntoggle = {
			type = "toggle", name = "Warn Frame", desc = "Enable/Disable showing the Warn Frame", order = 41,
			get = function() return Rekt:isPartEnabled("interruptbar") end,
			set = function(_, v)
				Rekt:SetPartEnabledOrDisabled("interruptbar", v);
			end
		},
		warnrange = {
			type = "range", name = "Warn Frame's size", order = 42, min = 10, max = 150, step = 1,
			get = function() return Rekt:getFrameSize("interruptbar") end,
			set = function(_, v)
				Rekt:setFrameSize("interruptbar", v);
			end
		},
		warntextsizerange = {
			type = "range", name = "Text size", desc = "Warn Frame's Text size. Set it to 0 to disable it!",
			order = 43, min = 1, max = 30, step = 1,
			get = function() return Rekt:getDRNumSize("targetdr") end,
			set = function(_, v)
				Rekt:setDRNumSize("targetdr", v);
			end
		},
		warntextposselect = {
			type = "select", style = "dropdown", name = "Warn Frame Text Position", 
			desc = "Change the target's DR's number's position.", order = 44, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left",
				["5"] = "Middle"
			},
			get = function() return Rekt:getDRNumPosition("targetdr") end,
			set = function(_, v)
				Rekt:setDRNumPosition("targetdr", v);
			end
		},
	]]--
	}
	return args;
end

--order 20-40
function Rekt:getDROptions()
	local args = {
		targetdrHeader = {
			type = "header", name = "Target's settings", order = 10
		},
		targetdrtoggle = {
			type = "toggle", name = "Enabled", desc = "Enable/Disable showing the target's DRs.", order = 11,
			get = function() return Rekt:isPartEnabled("targetdr") end,
			set = function(_, v)
				Rekt:SetDRPartEnabledOrDisabled("targetdr", v);
			end
		},
		targetdrrange = {
			type = "range", name = "Target's DRs size", order = 12, min = 10, max = 150, step = 1,
			get = function() return Rekt:getFrameSize("targetdr") end,
			set = function(_, v)
				Rekt:setFrameSize("targetdr", v);
			end
			
		},
		targetdrGrowSelect = {
			type = "select", style = "dropdown", name = "targetDRGrow", 
			desc = "Change which way the target's cooldowns will grow", order = 13, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left"
			},
			get = function() return Rekt:getGrowOrder("targetdr") end,
			set = function(_, v)
				Rekt:setDRGrowOrder("targetdr", v);
			end
		},
		targetdrSortSelect = {
			type = "select", style = "dropdown", name = "targetDRSortOrder", 
			desc = "Change the target's DR's sort order", order = 14, 
			values = {
				["1"] = "Ascending (CD left)",
				["2"] = "Descending (CD left)",
				["3"] = "Ascending (CD total)",
				["4"] = "Descending (CD total)",
				["5"] = "Recent first",
				["6"] = "Recent Last",
				["7"] = "No order"
			},
			get = function() return Rekt:getSortOrder("targetdr") end,
			set = function(_, v)
				Rekt:setSortOrder("targetdr", v);
			end
		},
		targetdrnumsizerange = {
			type = "range", name = "Number's size", desc = "Target's DR's Number's size. Set it to 0 to disable it!",
			order = 15, min = 1, max = 30, step = 1,
			get = function() return Rekt:getDRNumSize("targetdr") end,
			set = function(_, v)
				Rekt:setDRNumSize("targetdr", v);
			end
			
		},
		targetdrnumposselect = {
			type = "select", style = "dropdown", name = "targetDRNumPos", 
			desc = "Change the target's DR's number's position.", order = 16, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left",
				["5"] = "Middle"
			},
			get = function() return Rekt:getDRNumPosition("targetdr") end,
			set = function(_, v)
				Rekt:setDRNumPosition("targetdr", v);
			end
		},
		targetdrOnlyShowDRCountDownToggle = {
			type = "toggle", name = "Only Show DR CountDown", desc = "If enabled the DR icon will only show up when the DR countdown actually starts.", order = 17,
			get = function() return Rekt:isOnlyShowDRCountDown("targetdr") end,
			set = function(_, v)
				Rekt:setOnlyShowDRCountDown("targetdr", v);
			end
		},
		focusdrHeader = {
			type = "header", name = "Focus's settings", order = 18
		},
		focusdrtoggle = {
				type = "toggle", name = "Enabled", desc = "Enable/Disable showing the focus's DRs.", order = 19,
				get = function() return Rekt:isPartEnabled("focusdr") end,
				set = function(_, v)
					Rekt:SetDRPartEnabledOrDisabled("focusdr", v);
				end
		},
		focusdrRange = {
				type = "range", name = "Focus's size", order = 20, min = 10, max = 150, step = 1,
				get = function() return Rekt:getFrameSize("focusdr") end,
				set = function(_, v)
					Rekt:setFrameSize("focusdr", v);
				end
		},
		focusdrGrowSelect = {
			type = "select", style = "dropdown", name = "focusDRGrow", 
			desc = "Change which way the focus's DRs will grow", order = 21, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left"
			},
			get = function() return Rekt:getGrowOrder("focusdr") end,
			set = function(_, v)
				Rekt:setDRGrowOrder("focusdr", v);
			end
		},
		focusdrSortSelect = {
			type = "select", style = "dropdown", name = "focusDRSortOrder", 
			desc = "Change the focus's DR's sort order", order = 22, 
			values = {
				["1"] = "Ascending (CD left)",
				["2"] = "Descending (CD left)",
				["3"] = "Ascending (CD total)",
				["4"] = "Descending (CD total)",
				["5"] = "Recent first",
				["6"] = "Recent Last",
				["7"] = "No order"
			},
			get = function() return Rekt:getSortOrder("focusdr") end,
			set = function(_, v)
				Rekt:setSortOrder("focusdr", v);
			end
		},
		focusdrnumsizerange = {
			type = "range", name = "Number's size", desc = "Focus's DR's Number's size. Set it to 0 to disable it!",
			order = 23, min = 1, max = 30, step = 1,
			get = function() return Rekt:getDRNumSize("focusdr") end,
			set = function(_, v)
				Rekt:setDRNumSize("focusdr", v);
			end
			
		},
		focusdrnumposselect = {
			type = "select", style = "dropdown", name = "focusDRNumPos", 
			desc = "Change the focus's DR's number's position.", order = 24, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left",
				["5"] = "Middle"
			},
			get = function() return Rekt:getDRNumPosition("focusdr") end,
			set = function(_, v)
				Rekt:setDRNumPosition("focusdr", v);
			end
		},
		focusdrOnlyShowDRCountDownToggle = {
			type = "toggle", name = "Only Show DR CountDown", desc = "If enabled the DR icon will only show up when the DR countdown actually starts.", order = 25,
			get = function() return Rekt:isOnlyShowDRCountDown("focusdr") end,
			set = function(_, v)
				Rekt:setOnlyShowDRCountDown("focusdr", v);
			end
		},
		selfdrHeader = {
			type = "header", name = "Self's settings", order = 26
		},
		selfdrtoggle = {
			type = "toggle", name = "Enabled", desc = "Enable/Disable showing the your DRs.", order = 27,
			get = function() return Rekt:isPartEnabled("selfdr") end,
			set = function(_, v)
				Rekt:SetDRPartEnabledOrDisabled("selfdr", v);
			end
		},
		selfdrrange = {
			type = "range", name = "Self's DRs size", order = 28, min = 10, max = 150, step = 1,
			get = function() return Rekt:getFrameSize("selfdr") end,
			set = function(_, v)
				Rekt:setFrameSize("selfdr", v);
			end
		},
		selfdrGrowSelect = {
			type = "select", style = "dropdown", name = "selfDRGrow", 
			desc = "Change which way the your DRs will grow", order = 29, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left"
			},
			get = function() return Rekt:getGrowOrder("selfdr") end,
			set = function(_, v)
				Rekt:setDRGrowOrder("selfdr", v);
			end
		},
		selfdrSortSelect = {
			type = "select", style = "dropdown", name = "selfDRSortOrder", 
			desc = "Change the your DR's sort order", order = 30, 
			values = {
				["1"] = "Ascending (CD left)",
				["2"] = "Descending (CD left)",
				["3"] = "Ascending (CD total)",
				["4"] = "Descending (CD total)",
				["5"] = "Recent first",
				["6"] = "Recent Last",
				["7"] = "No order"
			},
			get = function() return Rekt:getSortOrder("selfdr") end,
			set = function(_, v)
				Rekt:setSortOrder("selfdr", v);
			end
		},
		selfdrnumsizerange = {
			type = "range", name = "Number's size", desc = "Your DR's Number's size. Set it to 0 to disable it!",
			order = 31, min = 1, max = 30, step = 1,
			get = function() return Rekt:getDRNumSize("selfdr") end,
			set = function(_, v)
				Rekt:setDRNumSize("selfdr", v);
			end
			
		},
		selfdrnumposselect = {
			type = "select", style = "dropdown", name = "selfDRNumPos", 
			desc = "Change your DR's number's position.", order = 32, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left",
				["5"] = "Middle"
			},
			get = function() return Rekt:getDRNumPosition("selfdr") end,
			set = function(_, v)
				Rekt:setDRNumPosition("selfdr", v);
			end
		},
		selfdrOnlyShowDRCountDownToggle = {
			type = "toggle", name = "Only Show DR CountDown", desc = "If enabled the DR icon will only show up when the DR countdown actually starts.", order = 33,
			get = function() return Rekt:isOnlyShowDRCountDown("selfdr") end,
			set = function(_, v)
				Rekt:setOnlyShowDRCountDown("selfdr", v);
			end
		},
	}
	return args;
end

--order 40-50
function Rekt:getGlobalOptions()
	local args = {
		globalHeader = {
			type = "header", name = "Global CD settings", order = 10
		},
		specdetectiontoggle = {
				type = "toggle", name = "Spec Detection", desc = "Enable/Disable Spec Detection", order = 11,
				get = function() return Rekt:isSpecDetectionEnabled() end,
				set = function(_, v)
					Rekt:setSpecDetectionEnabledorDisabled(v);
				end
		},
		petcdguessingtoggle = {
				type = "toggle", name = "Pet CD Guessing", 
				desc = "Enable/Disable Pet Cd Guessing, this will show pet cds on all possible masters, since there is no reasonable way of determining who's pet it is from combatlog events and GUIDs, this will be really inaccurate if there are 2-3 lock for example.", 
				order = 12,
				get = function() return Rekt:getPetCDGuessing() end,
				set = function(_, v)
					Rekt:setPetCDGuessing(v);
				end
		},
		globalcdtypesortHeader = {
			type = "header", name = "Global CD Type sorting", order = 13
		},
		cdtypesortordertoggle = {
				type = "toggle", name = "Enabled", desc = "Enable/Disable CD Type Sort Order, It works like this: you set silence to 1, then cc to 2 and anticc to 2, then silences will go first, then cc and anticc as secound, they are organized within groups based on how you set them in the CDs settings tab.", order = 15,
				get = function() return Rekt:getCDTypeSortingEnable() end,
				set = function(_, v)
					Rekt:setCDTypeSortingEnable(v);
				end
		},
		silencerange = {
			type = "range", name = "Silence's Type Order", order = 17, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("silence") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("silence", v);
			end
		},
		gapcloserrange = {
			type = "range", name = "Gapcloser's Type Order", order = 18, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("gapcloser") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("gapcloser", v);
			end
		},
		defensiverange = {
			type = "range", name = "Defensive's Type Order", order = 19, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("defensive") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("defensive", v);
			end
		},
		potionrange = {
			type = "range", name = "Potion's Type Order", order = 20, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("potion") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("potion", v);
			end
		},
		nukerange = {
			type = "range", name = "Nuke's Type Order", order = 21, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("nuke") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("nuke", v);
			end
		},
		anticcrange = {
			type = "range", name = "Anticc's Type Order", order = 22, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("anticc") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("anticc", v);
			end
		},
		ccrange = {
			type = "range", name = "Cc's Type Order", order = 23, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("cc") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("cc", v);
			end
		},
		stunrange = {
			type = "range", name = "Stun's Type Order", order = 24, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("stun") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("stun", v);
			end
		},
		disarmrange = {
			type = "range", name = "Disarm's Type Order", order = 25, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("disarm") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("disarm", v);
			end
		},
		cdresetrange = {
			type = "range", name = "Cdreset's Type Order", order = 26, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("cdreset") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("cdreset", v);
			end
		},
		shieldrange = {
			type = "range", name = "shield's Type Order", order = 27, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("shield") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("shield", v);
			end
		},
		uncategorizedrange = {
			type = "range", name = "Uncategorized's Type Order", order = 28, min = 1, max = 15, step = 1,
			get = function() return Rekt:getTypeSortOrder("uncategorized") end,
			set = function(_, v)
				Rekt:setTypeSortOrder("uncategorized", v);
			end
		},
		
		--50+
		globalcolorHeader = {
			type = "header", name = "CD Color settings", order = 51
		},
		silencecolorsel = {
			type = "color", name = "Silence's color", hasAlpha = true, order = 52, 
			get = function() return Rekt:getColor("silence") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("silence", r, g, b, a);
			end
		},
		gapclosercolorsel = {
			type = "color", name = "Gapcloser's color", hasAlpha = true, order = 53, 
			get = function() return Rekt:getColor("gapcloser") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("gapcloser", r, g, b, a);
			end
		},
		defensivecolorsel = {
			type = "color", name = "Defensive's color", hasAlpha = true, order = 54, 
			get = function() return Rekt:getColor("defensive") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("defensive", r, g, b, a);
			end
		},
		potioncolorsel = {
			type = "color", name = "Potion's color", hasAlpha = true, order = 55, 
			get = function() return Rekt:getColor("potion") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("potion", r, g, b, a);
			end
		},
		nukecolorsel = {
			type = "color", name = "Nuke's color", hasAlpha = true, order = 56, 
			get = function() return Rekt:getColor("nuke") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("nuke", r, g, b, a);
			end
		},
		anticccolorsel = {
			type = "color", name = "Anticc's color", hasAlpha = true, order = 57, 
			get = function() return Rekt:getColor("anticc") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("anticc", r, g, b, a);
			end
		},
		cccolorsel = {
			type = "color", name = "Cc's color", hasAlpha = true, order = 58, 
			get = function() return Rekt:getColor("cc") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("cc", r, g, b, a);
			end
		},
		stuncolorsel = {
			type = "color", name = "Stun's color", hasAlpha = true, order = 59, 
			get = function() return Rekt:getColor("stun") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("stun", r, g, b, a);
			end
		},
		disarmcolorsel = {
			type = "color", name = "Disarm's color", hasAlpha = true, order = 60, 
			get = function() return Rekt:getColor("disarm") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("disarm", r, g, b, a);
			end
		},
		cdresetcolorsel = {
			type = "color", name = "Cdreset's color", hasAlpha = true, order = 61, 
			get = function() return Rekt:getColor("cdreset") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("cdreset", r, g, b, a);
			end
		},
		shieldcolorsel = {
			type = "color", name = "Shield's color", hasAlpha = true, order = 62, 
			get = function() return Rekt:getColor("shield") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("shield", r, g, b, a);
			end
		},
		uncategorizedcolorsel = {
			type = "color", name = "Uncategorized's color", hasAlpha = true, order = 63, 
			get = function() return Rekt:getColor("uncategorized") end,
			set = function(_, r, g, b, a)
				Rekt:setColor("uncategorized", r, g, b, a);
			end
		},

		--70+
		globalotherHeader = {
			type = "header", name = "Other settings", order = 70
		},
		drtimerange = {
			type = "range", name = "Diminishing Return time", order = 71, min = 1, max = 25, step = 1,
			get = function() return Rekt:getDRTime() end,
			set = function(_, v)
				Rekt:setDRTime(v);
			end
		},
	}

	--[[
	--100+ (Modules)
	local ordern = 1;
	for k, v in pairs(self.modules) do
        local options = v:GetOptions()

		args["moduleheader" .. ordern] = {
			type = "header", name = "Other settings", order = 100 * ordern
		};

		local orderic = 1;
		for k1, v1 in pairs(options) do
			args[k1] = {
				type = v1["type"], name = v1["name"], order = (100 * ordern) + orderic
			};
		end

        ordern = ordern + 1
    end
    ]]--

	return args;
end

--order 50+
function Rekt:getDebugOptions()
	local args = {
		spellcast = {
			type = "toggle", name = "SpellCast", desc = "Enable/Disable writing out SPELL_CAST_SUCCESS events.", order = 50,
			get = function() return Rekt:getSpellCastDebug() end,
			set = function(_, v)
				Rekt:setSpellCastDebug(v);
			end
		},
		spellAura = {
			type = "toggle", name = "SpellAura", desc = "Enable/Disablewriting out SPLL_AURA_* events", order = 51,
			get = function() return Rekt:getSpellAuraDebug() end,
			set = function(_, v)
				Rekt:setSpellAuraDebug(v);
			end
		},
		allLog = {
			type = "toggle", name = "Uber debug", desc = "Enable/Disable writing out all combatlog events", order = 52,
			get = function() return Rekt:getAllCDebug() end,
			set = function(_, v)
				Rekt:setAllCDebug(v);
			end
		},
		selfcd = {
			type = "toggle", name = "Self CDs", desc = "Enable/Disable registering self CDs", order = 53,
			get = function() return Rekt:getSelfCDRegister() end,
			set = function(_, v)
				Rekt:setSelfCDRegister(v);
			end
		},
		selfIBcd = {
			type = "toggle", name = "Friendly + Self Interrupts", desc = "Enable/Disable registering, and showing friendly and self interrupts at the interruptbar.", order = 54,
			get = function() return Rekt:getIBSelfCDRegister() end,
			set = function(_, v)
				Rekt:setIBSelfCDRegister(v);
			end
		},
		debugselect = {
			type = "select", style = "dropdown", name = "debuglevel", 
			desc = "Change the debuglevel", order = 55, 
			values = {
				["0"] = "No Messages",
			},
			get = function() return Rekt:getDebugLevel() end,
			set = function(_, v)
				Rekt:setDebugLevel(v);
			end
		},
		debuglistselfdrs = {
			type = "execute", name = "List SelfDRs", 
			desc = "List SelfDRs", order = 56,
			func = function() return Rekt:printAllDRsForGUID(Rekt.targets["self"]); end,
		},
	}
	return args;
end

function Rekt:GetTypeSortDropdown(num)
	local arr = {
			type = "select", style = "dropdown", name = "selfDRSortOrder", 
			desc = "Change the your DR's sort order", order = 28, 
			values = {
				["1"] = "Ascending (CD left)",
				["2"] = "Descending (CD left)",
				["3"] = "Ascending (CD total)",
				["4"] = "Descending (CD total)",
				["5"] = "Recent first",
				["6"] = "Recent Last",
				["7"] = "No order"
			},
			get = function() return Rekt:getSortOrder("selfdr") end,
			set = function(_, v)
				Rekt:setSortOrder("selfdr", v);
			end
		}
	return arr;
end
