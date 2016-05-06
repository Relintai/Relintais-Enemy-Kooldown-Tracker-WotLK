
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
			selfdr = {
				type = "group", name = "Self DRs", desc = "Self DR frame's settings.", childGroups = "tab",order = 4,
				args = Vect:getSelfDROptions()
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
		focusHeader = {
			type = "header", name = "Focus's settings", order = 15
		},
		focustoggle = {
				type = "toggle", name = "Focus", desc = "Enable/Disable showing the focus's cooldowns", order = 16,
				get = function() return Vect:isPartEnabled("focus") end,
				set = function(_, v)
					Vect:SetPartEnabledOrDisabled("focus", v);
				end
		},
		focusRange = {
				type = "range", name = "Focus's size", order = 17, min = 10, max = 150, step = 1,
				get = function() return Vect:getFrameSize("focus") end,
				set = function(_, v)
					Vect:setFrameSize("focus", v);
				end
		},
		focusGrowSelect = {
			type = "select", style = "dropdown", name = "focusGrow", 
			desc = "Change which way the focus's cooldowns will grow", order = 18, 
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
			desc = "Change the focus's cooldowns's sort order", order = 19, 
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
		}
	}
	return args;
end

--order 20-40
function Vect:getDROptions()
	local args = {
		targetdrHeader = {
			type = "header", name = "Target's DR settings", order = 10
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
	}
	return args;
end

--order 40-50
function Vect:getSelfDROptions()
	local args = {
		selfdrtoggle = {
			type = "toggle", name = "Enabled", desc = "Enable/Disable showing the your DRs.", order = 11,
			get = function() return Vect:isPartEnabled("selfdr") end,
			set = function(_, v)
				Vect:SetDRPartEnabledOrDisabled("selfdr", v);
			end
		},
		selfdrrange = {
			type = "range", name = "Self's DRs size", order = 12, min = 10, max = 150, step = 1,
			get = function() return Vect:getFrameSize("selfdr") end,
			set = function(_, v)
				Vect:setFrameSize("selfdr", v);
			end
		},
		selfdrGrowSelect = {
			type = "select", style = "dropdown", name = "selfDRGrow", 
			desc = "Change which way the your DRs will grow", order = 13, 
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
			desc = "Change the your DR's sort order", order = 14, 
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
			order = 15, min = 1, max = 30, step = 1,
			get = function() return Vect:getDRNumSize("selfdr") end,
			set = function(_, v)
				Vect:setDRNumSize("selfdr", v);
			end
			
		},
		selfdrnumposselect = {
			type = "select", style = "dropdown", name = "selfDRNumPos", 
			desc = "Change your DR's number's position.", order = 16, 
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

--order 50+
function Vect:getDebugOptions()
	local args = {
		spellcast = {
			type = "toggle", name = "SpellCast", desc = "Enable/Disable writing out SPELL_CAST_SUCCESS events.", order = 50,
			get = function() return Vect:getSpellCastDebug() end,
			set = function(_, v)
				2Vect:setSpellCastDebug(v);
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
