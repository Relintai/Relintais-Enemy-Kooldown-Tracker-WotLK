
local aceDBOptions = LibStub("AceDBOptions-3.0")

function Vect:GetVectOptions()
	local db = self.db.profile;
	local options = {
		type = "group", name = "Vect", childGroups = "tab",
		args = {
			enabled = {
				type = "toggle", name = "Enabled", desc = "Enable/Disable the addon", order = 0,
				get = function() return Vect:isEnabled() end,
				set = function(_, v)
						Vect:setEnabledOrDisabled(v);
					end
			},
			lock = {
				type = "toggle", name = "Lock", desc = "Uncheck to move the frames", order = 1,
				get = function() return Vect:isLocked() end,
				set = function(_, v)
						db.locked = v;
						if v then Vect:LockFrames() else Vect:UnlockFrames() end;
					end
			},
			targetandfocus = {
				type = "group", name = "CDs", desc = "Cooldown frame's settings.", childGroups = "tab", order = 2,
				args = Vect:getTargetandFocusOptions();
			},
			droptions = {
				type = "group", name = "DRs", desc = "DR frame's settings.", childGroups = "tab",order = 3,
				args = Vect:getDROptions();
			},
			coloroptions = {
				type = "group", name = "Global", desc = "Global settings.", childGroups = "tab",order = 4,
				args = Vect:getGlobalOptions()
			},
			debugoptions = {
				type = "group", name = "Debug", desc = "Debug settings.", childGroups = "tab", order = 5,
				args = Vect:getDebugOptions();
			},
			profileoptions = aceDBOptions:GetOptionsTable(self.db)
		}
	}
	return options;
end
--order 10-20
function Vect:getTargetandFocusOptions()
	local args = {
		targetHeader = {
			type = "header", name = "Target's settings", order = 10
		},
		targettoggle = {
			type = "toggle", name = "Target", desc = "Enable/Disable showing the target's cooldowns", order = 11,
			get = function() return Vect:isPartEnabled("target") end,
			set = function(_, v)
				Vect:SetPartEnabledOrDisabled("target", v);
			end
		},
		targetrange = {
			type = "range", name = "Target's size", order = 12, min = 10, max = 150, step = 1,
			get = function() return Vect:getFrameSize("target") end,
			set = function(_, v)
				Vect:setFrameSize("target", v);
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
			get = function() return Vect:getGrowOrder("target") end,
			set = function(_, v)
				Vect:setGrowOrder("target", v);
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
			get = function() return Vect:getSortOrder("target") end,
			set = function(_, v)
				Vect:setSortOrder("target", v);
			end
		},
		targetcolortoggle = {
			type = "toggle", name = "Colors", desc = "Enable/Disable showing the target's cooldown's colors.", order = 15,
			get = function() return Vect:getColorFrameEnabled("target") end,
			set = function(_, v)
				Vect:setColorFrameEnabled("target", v);
			end
		},
		targetcolorrange = {
			type = "range", name = "Target's Color size", order = 16, min = 1, max = 30, step = 1,
			get = function() return Vect:getColorFrameSize("target") end,
			set = function(_, v)
				Vect:setColorFrameSize("target", v);
			end
		},
		focusHeader = {
			type = "header", name = "Focus's settings", order = 17
		},
		focustoggle = {
				type = "toggle", name = "Focus", desc = "Enable/Disable showing the focus's cooldowns", order = 18,
				get = function() return Vect:isPartEnabled("focus") end,
				set = function(_, v)
					Vect:SetPartEnabledOrDisabled("focus", v);
				end
		},
		focusRange = {
				type = "range", name = "Focus's size", order = 19, min = 10, max = 150, step = 1,
				get = function() return Vect:getFrameSize("focus") end,
				set = function(_, v)
					Vect:setFrameSize("focus", v);
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
			get = function() return Vect:getGrowOrder("focus") end,
			set = function(_, v)
				Vect:setGrowOrder("focus", v);
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
			get = function() return Vect:getSortOrder("focus") end,
			set = function(_, v)
				Vect:setSortOrder("focus", v);
			end
		},
		focuscolortoggle = {
			type = "toggle", name = "Colors", desc = "Enable/Disable showing the target's cooldown's colors.", order = 22,
			get = function() return Vect:getColorFrameEnabled("focus") end,
			set = function(_, v)
				Vect:setColorFrameEnabled("focus", v);
			end
		},
		focuscolorrange = {
			type = "range", name = "Focus's Color size", order = 23, min = 1, max = 30, step = 1,
			get = function() return Vect:getColorFrameSize("focus") end,
			set = function(_, v)
				Vect:setColorFrameSize("focus", v);
			end
		},
	}
	return args;
end

--order 20-40
function Vect:getDROptions()
	local args = {
		targetdrHeader = {
			type = "header", name = "Target's settings", order = 10
		},
		targetdrtoggle = {
			type = "toggle", name = "Enabled", desc = "Enable/Disable showing the target's DRs.", order = 11,
			get = function() return Vect:isPartEnabled("targetdr") end,
			set = function(_, v)
				Vect:SetDRPartEnabledOrDisabled("targetdr", v);
			end
		},
		targetdrrange = {
			type = "range", name = "Target's DRs size", order = 12, min = 10, max = 150, step = 1,
			get = function() return Vect:getFrameSize("targetdr") end,
			set = function(_, v)
				Vect:setFrameSize("targetdr", v);
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
			get = function() return Vect:getGrowOrder("targetdr") end,
			set = function(_, v)
				Vect:setDRGrowOrder("targetdr", v);
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
			get = function() return Vect:getSortOrder("targetdr") end,
			set = function(_, v)
				Vect:setSortOrder("targetdr", v);
			end
		},
		targetdrnumsizerange = {
			type = "range", name = "Number's size", desc = "Target's DR's Number's size. Set it to 0 to disable it!",
			order = 15, min = 1, max = 30, step = 1,
			get = function() return Vect:getDRNumSize("targetdr") end,
			set = function(_, v)
				Vect:setDRNumSize("targetdr", v);
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
			get = function() return Vect:getDRNumPosition("targetdr") end,
			set = function(_, v)
				Vect:setDRNumPosition("targetdr", v);
			end
		},
		focusdrHeader = {
			type = "header", name = "Focus's settings", order = 17
		},
		focusdrtoggle = {
				type = "toggle", name = "Enabled", desc = "Enable/Disable showing the focus's DRs.", order = 18,
				get = function() return Vect:isPartEnabled("focusdr") end,
				set = function(_, v)
					Vect:SetDRPartEnabledOrDisabled("focusdr", v);
				end
		},
		focusdrRange = {
				type = "range", name = "Focus's size", order = 19, min = 10, max = 150, step = 1,
				get = function() return Vect:getFrameSize("focusdr") end,
				set = function(_, v)
					Vect:setFrameSize("focusdr", v);
				end
		},
		focusdrGrowSelect = {
			type = "select", style = "dropdown", name = "focusDRGrow", 
			desc = "Change which way the focus's DRs will grow", order = 20, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left"
			},
			get = function() return Vect:getGrowOrder("focusdr") end,
			set = function(_, v)
				Vect:setDRGrowOrder("focusdr", v);
			end
		},
		focusdrSortSelect = {
			type = "select", style = "dropdown", name = "focusDRSortOrder", 
			desc = "Change the focus's DR's sort order", order = 21, 
			values = {
				["1"] = "Ascending (CD left)",
				["2"] = "Descending (CD left)",
				["3"] = "Ascending (CD total)",
				["4"] = "Descending (CD total)",
				["5"] = "Recent first",
				["6"] = "Recent Last",
				["7"] = "No order"
			},
			get = function() return Vect:getSortOrder("focusdr") end,
			set = function(_, v)
				Vect:setSortOrder("focusdr", v);
			end
		},
		focusdrnumsizerange = {
			type = "range", name = "Number's size", desc = "Focus's DR's Number's size. Set it to 0 to disable it!",
			order = 22, min = 1, max = 30, step = 1,
			get = function() return Vect:getDRNumSize("focusdr") end,
			set = function(_, v)
				Vect:setDRNumSize("focusdr", v);
			end
			
		},
		focusdrnumposselect = {
			type = "select", style = "dropdown", name = "focusDRNumPos", 
			desc = "Change the focus's DR's number's position.", order = 23, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left",
				["5"] = "Middle"
			},
			get = function() return Vect:getDRNumPosition("focusdr") end,
			set = function(_, v)
				Vect:setDRNumPosition("focusdr", v);
			end
		},
		selfdrHeader = {
			type = "header", name = "Self's settings", order = 24
		},
		selfdrtoggle = {
			type = "toggle", name = "Enabled", desc = "Enable/Disable showing the your DRs.", order = 25,
			get = function() return Vect:isPartEnabled("selfdr") end,
			set = function(_, v)
				Vect:SetDRPartEnabledOrDisabled("selfdr", v);
			end
		},
		selfdrrange = {
			type = "range", name = "Self's DRs size", order = 26, min = 10, max = 150, step = 1,
			get = function() return Vect:getFrameSize("selfdr") end,
			set = function(_, v)
				Vect:setFrameSize("selfdr", v);
			end
		},
		selfdrGrowSelect = {
			type = "select", style = "dropdown", name = "selfDRGrow", 
			desc = "Change which way the your DRs will grow", order = 27, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left"
			},
			get = function() return Vect:getGrowOrder("selfdr") end,
			set = function(_, v)
				Vect:setDRGrowOrder("selfdr", v);
			end
		},
		selfdrSortSelect = {
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
			get = function() return Vect:getSortOrder("selfdr") end,
			set = function(_, v)
				Vect:setSortOrder("selfdr", v);
			end
		},
		selfdrnumsizerange = {
			type = "range", name = "Number's size", desc = "Your DR's Number's size. Set it to 0 to disable it!",
			order = 29, min = 1, max = 30, step = 1,
			get = function() return Vect:getDRNumSize("selfdr") end,
			set = function(_, v)
				Vect:setDRNumSize("selfdr", v);
			end
			
		},
		selfdrnumposselect = {
			type = "select", style = "dropdown", name = "selfDRNumPos", 
			desc = "Change your DR's number's position.", order = 30, 
			values = {
				["1"] = "Up",
				["2"] = "Right",
				["3"] = "Down",
				["4"] = "Left",
				["5"] = "Middle"
			},
			get = function() return Vect:getDRNumPosition("selfdr") end,
			set = function(_, v)
				Vect:setDRNumPosition("selfdr", v);
			end
		},
	}
	return args;
end

--order 40-50
function Vect:getGlobalOptions()
	local args = {
		globalHeader = {
			type = "header", name = "Global CD settings", order = 10
		},
		specdetectiontoggle = {
				type = "toggle", name = "Spec Detection", desc = "Enable/Disable Spec Detection", order = 11,
				get = function() return Vect:isSpecDetectionEnabled() end,
				set = function(_, v)
					Vect:setSpecDetectionEnabledorDisabled(v);
				end
		},
		petcdguessingtoggle = {
				type = "toggle", name = "Pet CD Guessing", 
				desc = "Enable/Disable Pet Cd Guessing, this will show pet cds on all possible masters, since there is no reasonable way of determining who's pet it is from combatlog events and GUIDs, this will be really inaccurate if there are 2-3 lock for example.", 
				order = 12,
				get = function() return Vect:getPetCDGuessing() end,
				set = function(_, v)
					Vect:setPetCDGuessing(v);
				end
		},
		globalcdtypesortHeader = {
			type = "header", name = "Global CD Type sorting", order = 13
		},
		cdtypesortordertoggle = {
				type = "toggle", name = "Enabled", desc = "Enable/Disable CD Type Sort Order, It works like this: you set silence to 1, then cc to 2 and anticc to 2, then silences will go first, then cc and anticc as secound, they are organized within groups based on how you set them in the CDs settings tab.", order = 15,
				get = function() return Vect:getCDTypeSortingEnable() end,
				set = function(_, v)
					Vect:setCDTypeSortingEnable(v);
				end
		},
		silencerange = {
			type = "range", name = "Silence's Type Order", order = 17, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("silence") end,
			set = function(_, v)
				Vect:setTypeSortOrder("silence", v);
			end
		},
		gapcloserrange = {
			type = "range", name = "Gapcloser's Type Order", order = 18, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("gapcloser") end,
			set = function(_, v)
				Vect:setTypeSortOrder("gapcloser", v);
			end
		},
		defensiverange = {
			type = "range", name = "Defensive's Type Order", order = 19, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("defensive") end,
			set = function(_, v)
				Vect:setTypeSortOrder("defensive", v);
			end
		},
		potionrange = {
			type = "range", name = "Potion's Type Order", order = 20, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("potion") end,
			set = function(_, v)
				Vect:setTypeSortOrder("potion", v);
			end
		},
		nukerange = {
			type = "range", name = "Nuke's Type Order", order = 21, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("nuke") end,
			set = function(_, v)
				Vect:setTypeSortOrder("nuke", v);
			end
		},
		anticcrange = {
			type = "range", name = "Anticc's Type Order", order = 22, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("anticc") end,
			set = function(_, v)
				Vect:setTypeSortOrder("anticc", v);
			end
		},
		ccrange = {
			type = "range", name = "Cc's Type Order", order = 23, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("cc") end,
			set = function(_, v)
				Vect:setTypeSortOrder("cc", v);
			end
		},
		stunrange = {
			type = "range", name = "Stun's Type Order", order = 24, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("stun") end,
			set = function(_, v)
				Vect:setTypeSortOrder("stun", v);
			end
		},
		disarmrange = {
			type = "range", name = "Disarm's Type Order", order = 25, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("disarm") end,
			set = function(_, v)
				Vect:setTypeSortOrder("disarm", v);
			end
		},
		cdresetrange = {
			type = "range", name = "Cdreset's Type Order", order = 26, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("cdreset") end,
			set = function(_, v)
				Vect:setTypeSortOrder("cdreset", v);
			end
		},
		shieldrange = {
			type = "range", name = "shield's Type Order", order = 27, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("shield") end,
			set = function(_, v)
				Vect:setTypeSortOrder("shield", v);
			end
		},
		uncategorizedrange = {
			type = "range", name = "Uncategorized's Type Order", order = 28, min = 1, max = 15, step = 1,
			get = function() return Vect:getTypeSortOrder("uncategorized") end,
			set = function(_, v)
				Vect:setTypeSortOrder("uncategorized", v);
			end
		},
		
		--50+
		globalcolorHeader = {
			type = "header", name = "CD Color settings", order = 51
		},
		silencecolorsel = {
			type = "color", name = "Silence's color", hasAlpha = true, order = 52, 
			get = function() return Vect:getColor("silence") end,
			set = function(_, r, g, b, a)
				Vect:setColor("silence", r, g, b, a);
			end
		},
		gapclosercolorsel = {
			type = "color", name = "Gapcloser's color", hasAlpha = true, order = 53, 
			get = function() return Vect:getColor("gapcloser") end,
			set = function(_, r, g, b, a)
				Vect:setColor("gapcloser", r, g, b, a);
			end
		},
		defensivecolorsel = {
			type = "color", name = "Defensive's color", hasAlpha = true, order = 54, 
			get = function() return Vect:getColor("defensive") end,
			set = function(_, r, g, b, a)
				Vect:setColor("defensive", r, g, b, a);
			end
		},
		potioncolorsel = {
			type = "color", name = "Potion's color", hasAlpha = true, order = 55, 
			get = function() return Vect:getColor("potion") end,
			set = function(_, r, g, b, a)
				Vect:setColor("potion", r, g, b, a);
			end
		},
		nukecolorsel = {
			type = "color", name = "Nuke's color", hasAlpha = true, order = 56, 
			get = function() return Vect:getColor("nuke") end,
			set = function(_, r, g, b, a)
				Vect:setColor("nuke", r, g, b, a);
			end
		},
		anticccolorsel = {
			type = "color", name = "Anticc's color", hasAlpha = true, order = 57, 
			get = function() return Vect:getColor("anticc") end,
			set = function(_, r, g, b, a)
				Vect:setColor("anticc", r, g, b, a);
			end
		},
		cccolorsel = {
			type = "color", name = "Cc's color", hasAlpha = true, order = 58, 
			get = function() return Vect:getColor("cc") end,
			set = function(_, r, g, b, a)
				Vect:setColor("cc", r, g, b, a);
			end
		},
		stuncolorsel = {
			type = "color", name = "Stun's color", hasAlpha = true, order = 59, 
			get = function() return Vect:getColor("stun") end,
			set = function(_, r, g, b, a)
				Vect:setColor("stun", r, g, b, a);
			end
		},
		disarmcolorsel = {
			type = "color", name = "Disarm's color", hasAlpha = true, order = 60, 
			get = function() return Vect:getColor("disarm") end,
			set = function(_, r, g, b, a)
				Vect:setColor("disarm", r, g, b, a);
			end
		},
		cdresetcolorsel = {
			type = "color", name = "Cdreset's color", hasAlpha = true, order = 61, 
			get = function() return Vect:getColor("cdreset") end,
			set = function(_, r, g, b, a)
				Vect:setColor("cdreset", r, g, b, a);
			end
		},
		shieldcolorsel = {
			type = "color", name = "Shield's color", hasAlpha = true, order = 62, 
			get = function() return Vect:getColor("shield") end,
			set = function(_, r, g, b, a)
				Vect:setColor("shield", r, g, b, a);
			end
		},
		uncategorizedcolorsel = {
			type = "color", name = "Uncategorized's color", hasAlpha = true, order = 63, 
			get = function() return Vect:getColor("uncategorized") end,
			set = function(_, r, g, b, a)
				Vect:setColor("uncategorized", r, g, b, a);
			end
		},
	}
	return args;
end

--order 50+
function Vect:getDebugOptions()
	local args = {
		spellcast = {
			type = "toggle", name = "SpellCast", desc = "Enable/Disable writing out SPELL_CAST_SUCCESS events.", order = 50,
			get = function() return Vect:getSpellCastDebug() end,
			set = function(_, v)
				Vect:setSpellCastDebug(v);
			end
		},
		spellAura = {
			type = "toggle", name = "SpellAura", desc = "Enable/Disablewriting out SPLL_AURA_* events", order = 51,
			get = function() return Vect:getSpellAuraDebug() end,
			set = function(_, v)
				Vect:setSpellAuraDebug(v);
			end
		},
		allLog = {
			type = "toggle", name = "Uber debug", desc = "Enable/Disable writing out all combatlog events", order = 52,
			get = function() return Vect:getAllCDebug() end,
			set = function(_, v)
				Vect:setAllCDebug(v);
			end
		},
		selfcd = {
			type = "toggle", name = "Self CDs", desc = "Enable/Disable registering self CDs", order = 53,
			get = function() return Vect:getSelfCDRegister() end,
			set = function(_, v)
				Vect:setSelfCDRegister(v);
			end
		},
		debugselect = {
			type = "select", style = "dropdown", name = "debuglevel", 
			desc = "Change the debuglevel", order = 54, 
			values = {
				["0"] = "No Messages",
			},
			get = function() return Vect:getDebugLevel() end,
			set = function(_, v)
				Vect:setDebugLevel(v);
			end
		},
	}
	return args;
end

function Vect:GetTypeSortDropdown(num)
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
			get = function() return Vect:getSortOrder("selfdr") end,
			set = function(_, v)
				Vect:setSortOrder("selfdr", v);
			end
		}
	return arr;
end
