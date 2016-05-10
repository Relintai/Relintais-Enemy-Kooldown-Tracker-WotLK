
--"Globals"
local aceDB = LibStub("AceDB-3.0");
local aceCDialog = LibStub("AceConfigDialog-3.0");
local aceConfig = LibStub("AceConfig-3.0");
local libSharedMedia = LibStub("LibSharedMedia-3.0");
local libDRData = LibStub('DRData-1.0');

--DR db functions
function Rekt:DRDebuffGained(spellID, dstGUID, isPlayer)
	local db =  Rekt.db.profile;
	if not db["enabled"] then return end;

	if not Rekt.drs[dstGUID] then
		 Rekt.drs[dstGUID] = {}
	end

	local drCat = libDRData:GetSpellCategory(spellID);
	local spellName, spellRank, spellIcon = GetSpellInfo(spellID);

	Rekt:UpdateDRs(dstGUID);
	
	if not Rekt.drs[dstGUID][drCat] then
		local cd = 18;
		local currentTime = GetTime();
		local endTime = currentTime + cd;
		local diminished = 1;
		local isDiminishingStarted = false;
		Rekt.drs[dstGUID][drCat] = {
			currentTime,
			endTime,
			cd,
			spellIcon,
			spellID,
			diminished,
			isDiminishingStarted,
			drCat
		}
	else
		local cd = 18;
		local currentTime = GetTime();
		local endTime = currentTime + cd;
		Rekt.drs[dstGUID][drCat][1] = currentTime;
		Rekt.drs[dstGUID][drCat][2] = currentTime + cd;
		Rekt.drs[dstGUID][drCat][4] = spellIcon;
		Rekt.drs[dstGUID][drCat][5] = spellID;
		Rekt.drs[dstGUID][drCat][6] = Rekt.drs[dstGUID][drCat][6] + 1;
		Rekt.drs[dstGUID][drCat][7] = false;
		
		--reset it back to 1, x > 3 means, the server updated the dr in less than 18 sec.
		if Rekt.drs[dstGUID][drCat][6] > 3 then
			Rekt.drs[dstGUID][drCat][6] = 1;
		end
	end
	
	--self:Print(Rekt.cds[srcGUID][spellID][1] .. " " .. Rekt.cds[srcGUID][spellID][2] .. " " .. Rekt.cds[srcGUID][spellID][3]);
	
	if self.targets["target"] == dstGUID then
		self:ReassignDRs("targetdr");
	end
	
	if self.targets["focus"] == dstGUID then
		self:ReassignDRs("focusdr");
	end
	
	if self.targets["self"] == dstGUID then
		self:ReassignDRs("selfdr");
	end
end

function Rekt:DRDebuffFaded(spellID, dstGUID, isPlayer)
	local db =  Rekt.db.profile;
	if not db["enabled"] then return end;

	if not Rekt.drs[dstGUID] then 
		 Rekt.drs[dstGUID] = {}
	end

	local drCat = libDRData:GetSpellCategory(spellID);
	local spellName, spellRank, spellIcon = GetSpellInfo(spellID);

	Rekt:UpdateDRs(dstGUID);
	
	if not Rekt.drs[dstGUID][drCat] then
		--means we didn't see it applied
		local cd = 18;
		local currentTime = GetTime();
		local endTime = currentTime + cd;
		local diminished = 1;
		local isDiminishingStarted = true;
		Rekt.drs[dstGUID][drCat] = {
			currentTime,
			endTime,
			cd,
			spellIcon,
			spellID,
			diminished,
			isDiminishingStarted,
			drCat
		}
	else
		local cd = 18;
		local currentTime = GetTime();
		local endTime = currentTime + cd;
		Rekt.drs[dstGUID][drCat][1] = currentTime;
		Rekt.drs[dstGUID][drCat][2] = endTime;
		Rekt.drs[dstGUID][drCat][7] = true;
	end

	--self:Print(Rekt.cds[srcGUID][spellID][1] .. " " .. Rekt.cds[srcGUID][spellID][2] .. " " .. Rekt.cds[srcGUID][spellID][3]);
	
	if self.targets["target"] == dstGUID then
		self:ReassignDRs("targetdr");
	end
	
	if self.targets["focus"] == dstGUID then
		self:ReassignDRs("focusdr");
	end
	
	if self.targets["self"] == dstGUID then
		self:ReassignDRs("selfdr");
	end
end

function Rekt:ReassignDRs(which)
	local db =  Rekt.db.profile;
	--bail out early, if frames are disabled
	if not db[which]["enabled"] or not db["enabled"] then return end;
	--first hide all
	for i = 1, 18 do
		local frame = Rekt.frames[which][i]["frame"];
		frame:Hide();
	end
	--check if frames are unlocked
	if not db["locked"] then return end;
	--check if we have cooldown for that unit
	local whichs = "";
	if which == "targetdr" then
		whichs = "target";
	elseif which == "focusdr" then
		whichs = "focus";
	else
		whichs = "self";
	end

	if not self.drs[self.targets[whichs]] then return end;
	--update then
	Rekt:UpdateDRs(self.targets[whichs]);
	--sort them
	local tmp = Rekt:SortDRs(whichs);
	--let's fill them up
	local i = 1;
	for k, v in ipairs(tmp) do
		--self:Print(v["spellID"]);
		local frame = Rekt.frames[which][i]["frame"];
		local text = Rekt.frames[which][i]["texture"];
		text:SetTexture(v["spellIcon"]);
		local CoolDown = Rekt.frames[which][i]["cooldown"];
		local t = Rekt.frames[which][i]["text"];
		if v["isDiminishingStarted"] then
			CoolDown:SetCooldown(v["currentTime"], v["cd"]);
		else
			CoolDown:SetCooldown(v["currentTime"], 0);
		end
		
		--print it out, if we need to
		if db[which]["drnumsize"] > 0 then
			t:SetText(v["diminished"]);
		end
		
		frame:Show();
		i = i + 1;
	end
end

function Rekt:SortDRs(which)
	local db = Rekt.db.profile;
	local tmp = {};

	--make the tmp table
	local i = 1;
	for k, v in pairs(self.drs[self.targets[which]]) do
		tmp[i] = {
			currentTime = v[1],
			endTime = v[2],
			cd = v[3],
			spellIcon = v[4],
			spellID = v[5],
			diminished = v[6],
			isDiminishingStarted = v[7]
			};
			
		--self:Print(v[1] .. v[2] .. v[3] .. v[4] .. v[5])
		--self:Print(tmp[i]["currentTime"] .. " " .. tmp[i]["endTime"] .. " " .. tmp[i]["cd"] .. " " .. tmp[i][4] .. " " .. tmp[i][5])
		i = i + 1;
	end

	if not tmp then return end;
	
	if which == "self" then which = "selfdr" end
	
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
	end
	--["7"] = "No order"
	return tmp;
end

function Rekt:CreateDRFrames(which)
	for i = 1, 18 do
		local frame = CreateFrame("Frame", nil, UIParent, nil);
		frame:SetFrameStrata("MEDIUM");
		frame:SetWidth(150);
		frame:SetHeight(150);
		
		local wh = "";
		if which == "targetdr" then
			wh = "target";
		elseif which == "focusdr" then
			wh = "focus";
		else
			wh = "self";
		end
		
		if i == 1 then
			frame:SetScript("OnUpdate", function() self:VOnDRTimerUpdate(wh) end)
		end
		local text = frame:CreateTexture();
		text:SetTexture("Interface\\Icons\\Spell_Arcane_Blink")
		text:SetAllPoints(frame);
		frame.texture = text;
		local CoolDown = CreateFrame("Cooldown", "RektCoolDown" .. i, frame);
		CoolDown:SetAllPoints()
		CoolDown:SetCooldown(GetTime(), 50);
		local t = frame:CreateFontString(nil, "OVERLAY");
		t:SetNonSpaceWrap(false);
		t:SetPoint("CENTER", frame, "CENTER", 0, 0);
		t:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
		--frame:Hide();
		Rekt.frames[which][i] = {}
		Rekt.frames[which][i]["frame"] = frame;
		Rekt.frames[which][i]["texture"] = text;
		Rekt.frames[which][i]["cooldown"] = CoolDown;
		Rekt.frames[which][i]["text"] = t;
	end
end

function Rekt:MoveDRTimersStop(which)
	local db = Rekt.db.profile;
	local x = db[which]["xPos"];
	local y = db[which]["yPos"];
	local size = db[which]["size"];
	local growOrder = db[which]["growOrder"];
	local drNumSize = db[which]["drnumsize"];
	local drNumPos = db[which]["drnumposition"];

	for i = 1, 18 do
		local frame = Rekt.frames[which][i]["frame"];
		frame:ClearAllPoints();
		frame:SetFrameStrata("MEDIUM");
		frame:SetWidth(size);
		frame:SetHeight(size);
		local text = Rekt.frames[which][i]["texture"];
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
		
		local t = Rekt.frames[which][i]["text"];
		t:ClearAllPoints();
		
		--check if we need numbers
		if (drNumSize > 0) then
			local xOSet = 0;
			local yOSet = 0;
			
			t:SetFont("Fonts\\FRIZQT__.TTF", drNumSize, "OUTLINE, MONOCHROME")
			
			--position it
			if (drNumPos == "1") then --["1"] = "Up",
				yOSet = ((drNumSize / 2) + (size / 2) + 2);
			elseif (drNumPos == "2") then --["2"] = "Right",
				xOSet = ((size / 2) + 5);
			elseif (drNumPos == "3") then --["3"] = "Down",
				yOSet = -((drNumSize / 2) + (size / 2) + 2);
			elseif (drNumPos == "4") then --["4"] = "Left",
				xOSet = -((size / 2) + 5);
			end --["5"] = "Middle"

			t:SetPoint("CENTER", frame, "CENTER", xOSet, yOSet);
		end
		
		local CoolDown = Rekt.frames[which][i]["cooldown"];
		CoolDown:SetAllPoints();
		--frame:Show();
	end
end

function Rekt:VOnDRTimerUpdate(which)
	if Rekt:UpdateDRs(self.targets[which]) then
		--we have to update every three, because if somebody is targeted and focused since sorting is 
		--implemented it triggers only one update, probably it had bugs before too, but got unnoticed
		self:ReassignDRs("targetdr");
		self:ReassignDRs("focusdr");
		self:ReassignDRs("selfdr");
	end
end

function Rekt:UpdateDRs(unitGUID)
	if not unitGUID then return end;
	--check if we have dr for that unit
	if not self.drs[unitGUID] then return end
	local t = GetTime();
	local found = false;
	--let's check if one of the cooldowns finished
	for k, v in pairs(self.drs[unitGUID]) do
		if (v[7] == true and v[2] <= t) or (v[2] + 25 <= t) then
			self.drs[unitGUID][v[8]] = nil;
			found = true;
		end
	end
	return found;
end

function Rekt:HideSelfDRFrames()
	if not Rekt.frames["selfdr"][1] then return end;

	for i = 1, 18 do
		local frame = Rekt.frames["selfdr"][i]["frame"];
		frame:Hide();
	end
end