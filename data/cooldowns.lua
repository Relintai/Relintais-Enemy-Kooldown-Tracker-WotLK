
--"Globals"
local aceDB = LibStub("AceDB-3.0");
local aceCDialog = LibStub("AceConfigDialog-3.0");
local aceConfig = LibStub("AceConfig-3.0");
local libSharedMedia = LibStub("LibSharedMedia-3.0");
local libDRData = LibStub('DRData-1.0');

--gets called when a cd is finished, reassigns the cds to frames.
function Vect:ReassignCds(which)
	local db =  Vect.db.profile;
	--bail out early, if frames are disabled
	if not db[which]["enabled"] or not db["enabled"] then return end;
	--first hide all
	for i = 1, 23 do
		local frame = Vect.frames[which][i]["frame"];
		frame:Hide();
	end
	--check if frames are unlocked
	if not db["locked"] then return end;
	--check if we need to display them for the player
	if not db["selfCDRegister"] and self.targets[which] == UnitGUID("player") then return end;
	--check if we have cooldown for that unit
	if not self.cds[self.targets[which]] then return end;
	--sort them
	local tmp = Vect:SortCDs(which);
	--let's fill them up
	local i = 1;
	for k, v in ipairs(tmp) do
		local frame = Vect.frames[which][i]["frame"];
		local text = Vect.frames[which][i]["texture"];
		text:SetTexture(v["spellIcon"]);
		local CoolDown = Vect.frames[which][i]["cooldown"];
		CoolDown:SetCooldown(v["currentTime"], v["cd"]);
		frame:Show();
		i = i + 1;
	end
end

function Vect:AddCd(srcGUID, spellID)
	local db =  Vect.db.profile;
	if not db["enabled"] then return end;
	
	if not Vect.cds[srcGUID] then 
		Vect.cds[srcGUID] = {}
		Vect.cds[srcGUID]["spec"] = 1;
	end
	
	local specchange = false;
	if db["specdetection"] then
		if Vect:DetectSpec(srcGUID, spellID) then
			specchange = true;
		end
	end
	
	local spec = Vect.cds[srcGUID]["spec"];
	local cd, reset = Vect.spells[spellID][spec], Vect.spells[spellID][2];
	
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
	Vect.cds[srcGUID][spellID] = {
		currentTime,
		endTime,
		cd,
		spellIcon,
		spellID
	}
	
	--self:Print(Vect.cds[srcGUID][spellID][1] .. " " .. Vect.cds[srcGUID][spellID][2] .. " " .. Vect.cds[srcGUID][spellID][3]);
	
	if reset then
		Vect:CdRemoval(srcGUID, reset);
	end
	
	--self:Print(self.targets["target"]);
	--self:Print(s
	
	if self.targets["target"] == srcGUID then
		self:ReassignCds("target");
	end
	
	if self.targets["focus"] == srcGUID then
		self:ReassignCds("focus");
	end
end

function Vect:DetectSpec(srcGUID, spellID)
	local spec = Vect.spells[spellID][6];
	
	if spec == 0 then return false end;
	if Vect.cds[srcGUID]["spec"] == spec then return false end;
	--self:Print("spec found: " .. spec);
	Vect:RemapSpecCDs(srcGUID, spec);
	return true;
end

function Vect:RemapSpecCDs(srcGUID, spec)
	if not self.cds[srcGUID] then return end
	for k, v in pairs(self.cds[srcGUID]) do
		if not (k == "spec") then
			local cd = Vect.spells[v[5]][spec];
			v[3] = cd;
			v[2] = v[1] + cd;
		end
	end
end

function Vect:CdRemoval(srcGUID, resetArray)
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

function Vect:SortCDs(which)
	local db = Vect.db.profile;
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
				spellID = v[5]
				};
				
			--self:Print(v[1] .. v[2] .. v[3] .. v[4] .. v[5])
			--self:Print(tmp[i]["currentTime"] .. " " .. tmp[i]["endTime"] .. " " .. tmp[i]["cd"]);-- .. " " .. tmp[i][4] .. " " .. tmp[i][5])
			i = i + 1;
		end
	end

	if not tmp then return end;
	
	if db[which]["sortOrder"] == "1" then --["1"] = "Ascending (CD left)",
		table.sort(tmp, function(a, b) return Vect:ComparerAscendingCDLeft(a, b) end);
	elseif db[which]["sortOrder"] == "2" then --["2"] = "Descending (CD left)",
		table.sort(tmp, function(a, b) return Vect:ComparerDescendingCDLeft(a, b) end);
	elseif db[which]["sortOrder"] == "3" then --["3"] = "Ascending (CD total)",
		table.sort(tmp, function(a, b) return Vect:ComparerAscendingCDTotal(a, b) end);
	elseif db[which]["sortOrder"] == "4" then --["4"] = "Descending (CD total)",
		table.sort(tmp, function(a, b) return Vect:ComparerDescendingCDTotal(a, b) end);
	elseif db[which]["sortOrder"] == "5" then --["5"] = "Recent first",
		table.sort(tmp, function(a, b) return Vect:ComparerRecentFirst(a, b) end);
	elseif db[which]["sortOrder"] == "6" then --["6"] = "Recent Last",
		table.sort(tmp, function(a, b) return Vect:ComparerRecentLast(a, b) end);
	end
	--["7"] = "No order"
	return tmp;
end

function Vect:CreateFrames(which)
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
		local CoolDown = CreateFrame("Cooldown", "VectCoolDown" .. i, frame);
		CoolDown:SetAllPoints()
		CoolDown:SetCooldown(GetTime(), 50);
		frame:Hide();
		Vect.frames[which][i] = {}
		Vect.frames[which][i]["frame"] = frame;
		Vect.frames[which][i]["texture"] = text;
		Vect.frames[which][i]["cooldown"] = CoolDown;
	end
end

function Vect:MoveTimersStop(which)
	local db = Vect.db.profile;
	local x = db[which]["xPos"];
	local y = db[which]["yPos"];
	local size = db[which]["size"];
	local growOrder = db[which]["growOrder"];
	
	for i = 1, 23 do
		local frame = Vect.frames[which][i]["frame"];
		frame:ClearAllPoints();
		frame:SetFrameStrata("MEDIUM");
		frame:SetWidth(size);
		frame:SetHeight(size);
		local text = Vect.frames[which][i]["texture"];
		text:SetAllPoints(frame);
		frame.texture = text;
		--set them based on the grow type
		if growOrder == "1" then --Up
			frame:SetPoint("BOTTOMLEFT", x, y + ((i - 1) * size));
		elseif growOrder == "2" then --Right
			frame:SetPoint("BOTTOMLEFT", x + ((i - 1) * size), y);
		elseif growOrder == "3" then --Down
			frame:SetPoint("BOTTOMLEFT", x, y - ((i - 1) * size));
		else --Left
			frame:SetPoint("BOTTOMLEFT", x - ((i - 1) * size), y);
		end
		local CoolDown = Vect.frames[which][i]["cooldown"];
		CoolDown:SetAllPoints();
		--frame:Show();
	end
end

function Vect:VOnTimerUpdate(which)
	--check if we have cooldown for that unit
	if not self.cds[self.targets[which]] then return end
	local t = GetTime();
	--let's check if one of the cooldowns finished
	for k, v in pairs(self.cds[self.targets[which]]) do
		if not (k == "spec") then
			if v[2] <= t then
				self.cds[self.targets[which]][v[5]] = nil;
				--we have to update both, because if somebody is targeted and focused since sorting is 
				--implemented it triggers only one update, probably it had bugs before too, but got unnoticed
				self:ReassignCds("target");
				self:ReassignCds("focus");
			end
		end
	end
end
