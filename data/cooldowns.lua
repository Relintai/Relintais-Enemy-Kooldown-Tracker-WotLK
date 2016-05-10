
--"Globals"
local aceDB = LibStub("AceDB-3.0");
local aceCDialog = LibStub("AceConfigDialog-3.0");
local aceConfig = LibStub("AceConfig-3.0");
local libSharedMedia = LibStub("LibSharedMedia-3.0");
local libDRData = LibStub('DRData-1.0');

--gets called when a cd is finished, reassigns the cds to frames.
function Rekt:ReassignCds(which)
	local db =  Rekt.db.profile;
	--bail out early, if frames are disabled
	if not db[which]["enabled"] or not db["enabled"] then return end;
	--first hide all
	for i = 1, 23 do
		local frame = Rekt.frames[which][i]["frame"];
		frame:Hide();
		local colorframe = Rekt.frames[which][i]["colorframe"];
		colorframe:Hide();
	end
	--check if frames are unlocked
	if not db["locked"] then return end;
	--check if we need to display them for the player
	if not db["selfCDRegister"] and self.targets[which] == UnitGUID("player") then return end;
	--check if we have cooldown for that unit
	if not self.cds[self.targets[which]] then return end;
	--update cds
	Rekt:UpdateCds(which);
	--sort them
	local tmp = Rekt:SortCDs(which);
	--let's fill them up
	local i = 1;
	for k, v in ipairs(tmp) do
		local frame = Rekt.frames[which][i]["frame"];
		local text = Rekt.frames[which][i]["texture"];
		text:SetTexture(v["spellIcon"]);
		local CoolDown = Rekt.frames[which][i]["cooldown"];
		CoolDown:SetCooldown(v["currentTime"], v["cd"]);
		frame:Show();
		if (db[which]["colorframeenabled"]) then
			local colorframe = Rekt.frames[which][i]["colorframe"];
			--self:Print(v["spellID"] .. " cat: " .. v["spellCategory"]);
			
			colorframe:SetBackdropColor(db["color"][v["spellCategory"]]["r"], 
					db["color"][v["spellCategory"]]["g"], 
					db["color"][v["spellCategory"]]["b"], 
					db["color"][v["spellCategory"]]["a"]);
			colorframe:Show();
		end
		i = i + 1;
	end
end

function Rekt:AddCd(srcGUID, spellID, srcFlags)
	local db = Rekt.db.profile;
	if not db["enabled"] then return end;
	
	if not Rekt.cds[srcGUID] then 
		Rekt.cds[srcGUID] = {}
		Rekt.cds[srcGUID]["spec"] = {};
		Rekt.cds[srcGUID]["spec"][1] = 1;
		Rekt.cds[srcGUID]["spec"][2] = "";
	end
	
	local specchange = false;
	if db["specdetection"] then
		if Rekt:DetectSpec(srcGUID, spellID) then
			specchange = true;
		end
	end
	
	local spec = Rekt.cds[srcGUID]["spec"][1];
	local class, isPet = Rekt.spells[spellID][7], Rekt.spells[spellID][9];
	local cd, reset, spellCategory = Rekt.spells[spellID][spec], Rekt.spells[spellID][2], Rekt.spells[spellID][8];
	local interrupt, warn = Rekt.spells[spellID][10], Rekt.spells[spellID][11];
	
	if db["petcdguessing"] then
		if (Rekt.cds[srcGUID]["spec"][2] == "") and class then
			Rekt.cds[srcGUID]["spec"][2] = class;
		end
	end
	
	if specchange and (not cd) then
		if self.targets["target"] == srcGUID then
			self:ReassignCds("target");
		end
		
		if self.targets["focus"] == srcGUID then
			self:ReassignCds("focus");
		end
	end
	
	--means spec detection spell
	if not cd then return end;
	
	local spellName, spellRank, spellIcon = GetSpellInfo(spellID);
	local currentTime = GetTime();
	local endTime = currentTime + cd;
	Rekt.cds[srcGUID][spellID] = {
		currentTime,
		endTime,
		cd,
		spellIcon,
		spellID,
		spellCategory
	}

	--Interruptbar
	if interrupt and db["interruptbar"]["enabled"] then
		Rekt:AddInterruptCD(Rekt.cds[srcGUID][spellID], srcFlags);
	end
	
	--add it to every class of the same type
	if db["petcdguessing"] and isPet then
		for k, v in pairs(Rekt.cds) do
			if (v["spec"][2] == class) then
				Rekt.cds[k][spellID] = {
					currentTime,
					endTime,
					cd,
					spellIcon,
					spellID,
					spellCategory
				}
			end
		end
	end
	
	--self:Print(Rekt.cds[srcGUID][spellID][1] .. " " .. Rekt.cds[srcGUID][spellID][2] .. " " .. Rekt.cds[srcGUID][spellID][3]);
	
	if reset then
		Rekt:CdRemoval(srcGUID, reset);
	end
	
	--self:Print(self.targets["target"]);
	--self:Print(s
	
	if self.targets["target"] == srcGUID or isPet then
		self:ReassignCds("target");
	end
	
	if self.targets["focus"] == srcGUID or isPet then
		self:ReassignCds("focus");
	end
end

function Rekt:DetectSpec(srcGUID, spellID)
	local spec = Rekt.spells[spellID][6];
	
	if spec == 0 then return false end;
	if Rekt.cds[srcGUID]["spec"][1] == spec then return false end;
	--self:Print("spec found: " .. spec);
	Rekt:RemapSpecCDs(srcGUID, spec);
	return true;
end

function Rekt:RemapSpecCDs(srcGUID, spec)
	if not self.cds[srcGUID] then return end
	for k, v in pairs(self.cds[srcGUID]) do
		if not (k == "spec") then
			local cd = Rekt.spells[v[5]][spec];
			v[3] = cd;
			v[2] = v[1] + cd;
		end
	end
end

function Rekt:CdRemoval(srcGUID, resetArray)
	if not self.cds[srcGUID] then return end
	for k, v in pairs(self.cds[srcGUID]) do
		if not (k == "spec") then
			for j, x in pairs(resetArray) do
				if v[5] == x then
					--self:Print("Removed cd: " .. v[5]);
					self.cds[srcGUID][v[5]] = nil;
				end
			end
		end
	end
end

function Rekt:SortCDs(which)
	local db = Rekt.db.profile;
	local tmp = {};

	--make the tmp table
	local i = 1;
	for k, v in pairs(self.cds[self.targets[which]]) do
		if not (k == "spec") then
			tmp[i] = {
				currentTime = v[1],
				endTime = v[2],
				cd = v[3],
				spellIcon = v[4],
				spellID = v[5],
				spellCategory = v[6]
				};
				
			--self:Print(v[1] .. v[2] .. v[3] .. v[4] .. v[5])
			--self:Print(tmp[i]["currentTime"] .. " " .. tmp[i]["endTime"] .. " " .. tmp[i]["cd"]);-- .. " " .. tmp[i][4] .. " " .. tmp[i][5])
			i = i + 1;
		end
	end

	if not tmp then return end;
	
	if not db["cdtypesortorder"]["enabled"] then
		if db[which]["sortOrder"] == "1" then --["1"] = "Ascending (CD left)",
			table.sort(tmp, function(a, b) return Rekt:ComparerAscendingCDLeft(a, b) end);
		elseif db[which]["sortOrder"] == "2" then --["2"] = "Descending (CD left)",
			table.sort(tmp, function(a, b) return Rekt:ComparerDescendingCDLeft(a, b) end);
		elseif db[which]["sortOrder"] == "3" then --["3"] = "Ascending (CD total)",
			table.sort(tmp, function(a, b) return Rekt:ComparerAscendingCDTotal(a, b) end);
		elseif db[which]["sortOrder"] == "4" then --["4"] = "Descending (CD total)",
			table.sort(tmp, function(a, b) return Rekt:ComparerDescendingCDTotal(a, b) end);
		elseif db[which]["sortOrder"] == "5" then --["5"] = "Recent first",
			table.sort(tmp, function(a, b) return Rekt:ComparerRecentFirst(a, b) end);
		elseif db[which]["sortOrder"] == "6" then --["6"] = "Recent Last",
			table.sort(tmp, function(a, b) return Rekt:ComparerRecentLast(a, b) end);
		end --["7"] = "No order"
	else
		if db[which]["sortOrder"] == "1" then --["1"] = "Ascending (CD left)",
			table.sort(tmp, function(a, b) return Rekt:ComparerAscendingCDLeftT(a, b) end);
		elseif db[which]["sortOrder"] == "2" then --["2"] = "Descending (CD left)",
			table.sort(tmp, function(a, b) return Rekt:ComparerDescendingCDLeftT(a, b) end);
		elseif db[which]["sortOrder"] == "3" then --["3"] = "Ascending (CD total)",
			table.sort(tmp, function(a, b) return Rekt:ComparerAscendingCDTotalT(a, b) end);
		elseif db[which]["sortOrder"] == "4" then --["4"] = "Descending (CD total)",
			table.sort(tmp, function(a, b) return Rekt:ComparerDescendingCDTotalT(a, b) end);
		elseif db[which]["sortOrder"] == "5" then --["5"] = "Recent first",
			table.sort(tmp, function(a, b) return Rekt:ComparerRecentFirstT(a, b) end);
		elseif db[which]["sortOrder"] == "6" then --["6"] = "Recent Last",
			table.sort(tmp, function(a, b) return Rekt:ComparerRecentLastT(a, b) end);
		end --["7"] = "No order"
	end
	
	return tmp;
end

function Rekt:CreateFrames(which)
	for i = 1, 23 do
		local frame = CreateFrame("Frame", nil, UIParent, nil);
		frame:SetFrameStrata("MEDIUM");
		frame:SetWidth(150);
		frame:SetHeight(150);
		if i == 1 then
			frame:SetScript("OnUpdate", function() self:VOnTimerUpdate(which) end)
		end
		local text = frame:CreateTexture();
		text:SetTexture("Interface\\Icons\\Spell_Arcane_Blink")
		text:SetAllPoints(frame);
		frame.texture = text;
		local CoolDown = CreateFrame("Cooldown", "RektCoolDown" .. i, frame);
		CoolDown:SetAllPoints()
		CoolDown:SetCooldown(GetTime(), 50);
		frame:Hide();
		
		local colorframe = CreateFrame("Frame", nil, UIParent, nil);
		colorframe:SetFrameStrata("BACKGROUND");
		colorframe:SetWidth(150);
		colorframe:SetHeight(150);
		colorframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
					--edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
					edgeFile = nil,
					tile = true, tileSize = 16, edgeSize = 0, 
					--insets = { left = 4, right = 4, top = 4, bottom = 4 }});
					insets = nil});
		colorframe:Hide();
		
		Rekt.frames[which][i] = {}
		Rekt.frames[which][i]["frame"] = frame;
		Rekt.frames[which][i]["texture"] = text;
		Rekt.frames[which][i]["cooldown"] = CoolDown;
		Rekt.frames[which][i]["colorframe"] = colorframe;
	end
end

function Rekt:MoveTimersStop(which)
	local db = Rekt.db.profile;
	local x = db[which]["xPos"];
	local y = db[which]["yPos"];
	local size = db[which]["size"];
	local growOrder = db[which]["growOrder"];
	local cdbacksize = db[which]["colorframesize"];
	
	for i = 1, 23 do
		local frame = Rekt.frames[which][i]["frame"];
		frame:ClearAllPoints();
		frame:SetFrameStrata("MEDIUM");
		frame:SetWidth(size);
		frame:SetHeight(size);
		local text = Rekt.frames[which][i]["texture"];
		text:SetAllPoints(frame);
		frame.texture = text;
		
		local colorframe = Rekt.frames[which][i]["colorframe"];
		colorframe:ClearAllPoints();
		colorframe:SetFrameStrata("BACKGROUND");
		colorframe:SetBackdropColor(1, 1, 1, 1);
		
		--set them based on the grow type
		if growOrder == "1" then --Up
			frame:SetPoint("BOTTOMLEFT", x, y + ((i - 1) * size));
			
			colorframe:SetWidth(size + (2 * cdbacksize));
			colorframe:SetHeight(size);
			colorframe:SetPoint("BOTTOMLEFT", x - cdbacksize, y + ((i - 1) * size));
		elseif growOrder == "2" then --Right
			frame:SetPoint("BOTTOMLEFT", x + ((i - 1) * size), y);
			
			colorframe:SetWidth(size);
			colorframe:SetHeight(size + (2 * cdbacksize));
			colorframe:SetPoint("BOTTOMLEFT", x + ((i - 1) * size), y - cdbacksize);
		elseif growOrder == "3" then --Down
			frame:SetPoint("BOTTOMLEFT", x, y - ((i - 1) * size));
			
			colorframe:SetWidth(size + (2 * cdbacksize));
			colorframe:SetHeight(size);
			colorframe:SetPoint("BOTTOMLEFT", x - cdbacksize, (y - ((i - 1) * size)));
		else --Left
			frame:SetPoint("BOTTOMLEFT", x - ((i - 1) * size), y);
			
			colorframe:SetWidth(size);
			colorframe:SetHeight(size + (2 * cdbacksize));
			colorframe:SetPoint("BOTTOMLEFT", x - ((i - 1) * size), y - cdbacksize);
		end
		local CoolDown = Rekt.frames[which][i]["cooldown"];
		CoolDown:SetAllPoints();
		--frame:Show();
	end
end

function Rekt:VOnTimerUpdate(which)
	if (Rekt:UpdateCds(which)) then
		--we have to update both, because if somebody is targeted and focused since sorting is 
		--implemented it triggers only one update, probably it had bugs before too, but got unnoticed
		self:ReassignCds("target");
		self:ReassignCds("focus");
	end
end

function Rekt:UpdateCds(which)
	--check if we have cooldown for that unit
	if not self.cds[self.targets[which]] then return end
	local t = GetTime();
	local found = false;
	--let's check if one of the cooldowns finished
	for k, v in pairs(self.cds[self.targets[which]]) do
		if not (k == "spec") then
			if v[2] <= t then
				self.cds[self.targets[which]][v[5]] = nil;
				found = true;
			end
		end
	end
	return found;
end
