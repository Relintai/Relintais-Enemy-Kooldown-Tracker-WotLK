
local adbo = LibStub("AceDBOptions-3.0")

function Vect:GetVectOptions()
	local db = self.db.profile;
	local options = {
		type = "group", name = "Vect", childGroups = "tab",
		args = {
			enabled = {
				type = "toggle", name = "Enabled", desc = "Enable/Disable the addon", order = 0,
				get = function() return Vect:IsEnabled() end,
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
				type = "group", name = "T. and F. CDs", desc = "Cooldown frame's settings.", childGroups = "tab", order = 3,
				args = Vect:getTargetandFocusOptions();
			},
			droptions = {
				type = "group", name = "T. and F. DRs", desc = "DR frame's settings.", childGroups = "tab",order = 4,
				args = Vect:getDROptions();
			},
			selfdr = {
				type = "group", name = "Self DRs", desc = "Self DR frame's settings.", childGroups = "tab",order = 5,
				args = Vect:getSelfDROptions()
			},
			debugoptions = {
				type = "group", name = "Debug", desc = "Debug settings.", childGroups = "tab",order = 6,
				args = Vect:getDebugOptions();
			}
		}
	}
	return options;
end

function Vect:getTargetandFocusOptions()
	local args = {
		targetHeader = {
			type = "header", name = "Target's settings", order = 10
		},
		targettoggle = {
			type = "toggle", name = "Target", desc = "Enable/Disable showing the target's cooldowns", order = 3,
			get = function() return Vect:isPartEnabled("target") end,
			set = function(_, v)
				Vect:SetPartEnabledOrDisabled("target", v);
			end
		},
		targetrange = {
			type = "range", name = "Target's size", order = 11, min = 10, max = 150, step = 1,
			get = function() return Vect:getFrameSize("target") end,
			set = function(_, v)
				Vect:setFrameSize("target", v);
			end
			
		},
		targetGrowSelect = {
			type = "select", style = "dropdown", name = "targetGrow", 
			desc = "Change which way the target's cooldowns will grow", order = 12, 
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
			desc = "Change the target's cooldowns's sort order", order = 13, 
			values = {
				["1"] = "Ascending",
				["2"] = "Descending",
				["3"] = "Recent first",
				["4"] = "Recent Last",
				["5"] = "Random"
			},
			get = function() return Vect:getSortOrder("target") end,
			set = function(_, v)
				Vect:setSortOrder("target", v);
			end
		},
				focusHeader = {
			type = "header", name = "Focus's settings", order = 14
		},
		focustoggle = {
				type = "toggle", name = "Focus", desc = "Enable/Disable showing the focus's cooldowns", order = 8,
				get = function() return Vect:isPartEnabled("focus") end,
				set = function(_, v)
					Vect:SetPartEnabledOrDisabled("focus", v);
				end
		},
		focusRange = {
				type = "range", name = "Focus's size", order = 15, min = 10, max = 150, step = 1,
				get = function() return Vect:getFrameSize("focus") end,
				set = function(_, v)
					Vect:setFrameSize("focus", v);
				end
		},
		focusGrowSelect = {
			type = "select", style = "dropdown", name = "focusGrow", 
			desc = "Change which way the focus's cooldowns will grow", order = 16, 
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
			desc = "Change the focus's cooldowns's sort order", order = 17, 
			values = {
				["1"] = "Ascending",
				["2"] = "Descending",
				["3"] = "Recent first",
				["4"] = "Recent Last",
				["5"] = "Random"
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

	}
	return args;
end

--order 40-50
function Vect:getSelfDROptions()
	local args = {

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
