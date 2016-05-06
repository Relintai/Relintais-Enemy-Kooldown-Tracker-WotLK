
--"Globals"
local aceDB = LibStub("AceDB-3.0");
local aceCDialog = LibStub("AceConfigDialog-3.0");
local aceConfig = LibStub("AceConfig-3.0");
local libSharedMedia = LibStub("LibSharedMedia-3.0");
local libDRData = LibStub('DRData-1.0');

--DR db functions
function Vect:DRDebuffGained(spellID, dstGUID, isPlayer)
	local db =  Vect.db.profile;
	if not db["enabled"] then return end;

	if not Vect.drs[dstGUID] then
		 Vect.drs[dstGUID] = {}
	end

	local drCat = libDRData:GetSpellCategory(spellID);
	local spellName, spellRank, spellIcon = GetSpellInfo(spellID);

	if not Vect.drs[dstGUID][drCat] then
		local cd = 18;
		local currentTime = GetTime();
		local endTime = currentTime + cd;
		local diminished = 1;
		local isDiminishingStarted = false;
		Vect.drs[dstGUID][drCat] = {
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
		Vect:UpdateDRs(dstGUID);
		local cd = 18;
		local currentTime = GetTime();
		local endTime = currentTime + cd;
		Vect.drs[dstGUID][drCat][1] = currentTime;
		Vect.drs[dstGUID][drCat][2] = currentTime + cd;
		Vect.drs[dstGUID][drCat][4] = spellIcon;
		Vect.drs[dstGUID][drCat][5] = spellID;
		Vect.drs[dstGUID][drCat][6] = Vect.drs[dstGUID][drCat][6] + 1;
		Vect.drs[dstGUID][drCat][7] = false;
	end
	
	--self:Print(Vect.cds[srcGUID][spellID][1] .. " " .. Vect.cds[srcGUID][spellID][2] .. " " .. Vect.cds[srcGUID][spellID][3]);
	
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

function Vect:DRDebuffFaded(spellID, dstGUID, isPlayer)
	local db =  Vect.db.profile;
	if not db["enabled"] then return end;

	if not Vect.drs[dstGUID] then 
		 Vect.drs[dstGUID] = {}
	end

	local drCat = libDRData:GetSpellCategory(spellID);
	local spellName, spellRank, spellIcon = GetSpellInfo(spellID);

	if not Vect.drs[dstGUID][drCat] then
		--means we didn't see it applied
		local cd = 18;
		local currentTime = GetTime();
		local endTime = currentTime + cd;
		local diminished = 1;
		local isDiminishingStarted = true;
		Vect.drs[dstGUID][drCat] = {
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
		Vect:UpdateDRs(dstGUID);
		local cd = 18;
		local currentTime = GetTime();
		local endTime = currentTime + cd;
		Vect.drs[dstGUID][drCat][1] = currentTime;
		Vect.drs[dstGUID][drCat][2] = endTime;
		Vect.drs[dstGUID][drCat][7] = true;
	end

	--self:Print(Vect.cds[srcGUID][spellID][1] .. " " .. Vect.cds[srcGUID][spellID][2] .. " " .. Vect.cds[srcGUID][spellID][3]);
	
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

function Vect:ReassignDRs(which)
	local db =  Vect.db.profile;
	--bail out early, if frames are disabled
	if not db[which]["enabled"] or not db["enabled"] then return end;
	--first hide all
	for i = 1, 18 do
		local frame = Vect.frames[which][i]["frame"];
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
	Vect:UpdateDRs(self.targets[whichs]);
	--sort them
	local tmp = Vect:SortDRs(whichs);
	--let's fill them up
	local i = 1;
	for k, v in ipairs(tmp) do
		--self:Print(v["spellID"]);
		local frame = Vect.frames[which][i]["frame"];
		local text = Vect.frames[which][i]["texture"];
		text:SetTexture(v["spellIcon"]);
		local CoolDown = Vect.frames[which][i]["cooldown"];
		local t = Vect.frames[which][i]["text"];
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

function Vect:SortDRs(which)
	local db = Vect.db.profile;
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

function Vect:CreateDRFrames(which)
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
		local CoolDown = CreateFrame("Cooldown", "VectCoolDown" .. i, frame);
		CoolDown:SetAllPoints()
		CoolDown:SetCooldown(GetTime(), 50);
		local t = frame:CreateFontString(nil, "OVERLAY");
		t:SetNonSpaceWrap(false);
		t:SetPoint("CENTER", frame, "CENTER", 0, 0);
		t:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
		--frame:Hide();
		Vect.frames[which][i] = {}
		Vect.frames[which][i]["frame"] = frame;
		Vect.frames[which][i]["texture"] = text;
		Vect.frames[which][i]["cooldown"] = CoolDown;
		Vect.frames[which][i]["text"] = t;
	end
end

function Vect:MoveDRTimersStop(which)
	local db = Vect.db.profile;
	local x = db[which]["xPos"];
	local y = db[which]["yPos"];
	local size = db[which]["size"];
	local growOrder = db[which]["growOrder"];
	local drNumSize = db[which]["drnumsize"];
	local drNumPos = db[which]["drnumposition"];

	for i = 1, 18 do
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
		
		local t = Vect.frames[which][i]["text"];
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
		
		local CoolDown = Vect.frames[which][i]["cooldown"];
		CoolDown:SetAllPoints();
		--frame:Show();
	end
end

function Vect:VOnDRTimerUpdate(which)
	if Vect:UpdateDRs(self.targets[which]) then
		--we have to update every three, because if somebody is targeted and focused since sorting is 
		--implemented it triggers only one update, probably it had bugs before too, but got unnoticed
		self:ReassignDRs("targetdr");
		self:ReassignDRs("focusdr");
		self:ReassignDRs("selfdr");
	end
end

function Vect:UpdateDRs(unitGUID)
	if not unitGUID then return end;
	--check if we have dr for that unit
	if not self.drs[unitGUID] then return end
	local t = GetTime();
	local found = false;
	--let's check if one of the cooldowns finished
	for k, v in pairs(self.drs[unitGUID]) do
		if v[7] == true and v[2] <= t then
			self.drs[unitGUID][v[8]] = nil;
			fount = true;
		end
	end
	return found;
end
