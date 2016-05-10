
local band = bit.band

Rekt.interrupts = {
	["count"] = 0,
	["spells"] = {}
}

function Rekt:AddInterruptCD(cooldown, srcFlags)
	local db =  Rekt.db.profile;

	if not db["selfIBCDRegister"] then
		if not (band(srcFlags, 0x00000040) == 0x00000040) then
			return;
		end
	end


	local ir = Rekt.interrupts;

	ir["count"] = ir["count"] + 1;

	if not ir["spells"] then
		ir["spells"] = {};
	end

	ir["spells"][ir["count"]] = cooldown;

	Rekt:ReassignIBCds();
end

function Rekt:CreateInterruptBarFrames()
	for i = 1, 23 do
		local frame = CreateFrame("Frame", nil, UIParent, nil);
		frame:SetFrameStrata("MEDIUM");
		frame:SetWidth(150);
		frame:SetHeight(150);
		if i == 1 then
			frame:SetScript("OnUpdate", function() self:OnInterruptBarUpdate() end)
		end
		local text = frame:CreateTexture();
		text:SetTexture("Interface\\Icons\\Spell_Arcane_Blink")
		text:SetAllPoints(frame);
		frame.texture = text;
		local CoolDown = CreateFrame("Cooldown", "RektIBCoolDown" .. i, frame);
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
		
		Rekt.frames["interruptbar"][i] = {}
		Rekt.frames["interruptbar"][i]["frame"] = frame;
		Rekt.frames["interruptbar"][i]["texture"] = text;
		Rekt.frames["interruptbar"][i]["cooldown"] = CoolDown;
		Rekt.frames["interruptbar"][i]["colorframe"] = colorframe;
	end
end

function Rekt:OnInterruptBarUpdate()
	if Rekt:UpdateIBCDs() then
		Rekt:ReassignIBCds();
	end
end

function Rekt:UpdateIBCDs()
	if self.interrupts["count"] == 0 then
		return;
	end

	if not self.interrupts["spells"] then
		return;
	end

	local t = GetTime();
	local found = false;
	local count = 0;

	--let's check if one of the cooldowns finished
	for k, v in pairs(self.interrupts["spells"]) do
		if v[2] <= t then
			self.interrupts["spells"][k] = nil;
			count = count + 1;
			found = true;
		end
	end

	if found then
		self.interrupts["count"] = self.interrupts["count"] - count;
		self.interrupts["spells"] = Rekt.NormalizeTable(self.interrupts["spells"]);
	end

	return found;
end

--This function will remap the given table to be sequential
--meaning: [0] = 5, [1] = nil, [2] = 4, will become [0] = 5, [1] = 4, [2] = nil
 function Rekt:NormalizeTable(table)
	
	if not table then return; end

	local tmp = {};

	--make the tmp table
	local i = 1;
	for k, v in pairs(table) do
		if v then
			tmp[i] = v;
		end
	end

	return tmp;
end

--Refreshes the frames
function Rekt:ReassignIBCds()
	local db =  Rekt.db.profile;

	--first hide all
	for i = 1, 23 do
		local frame = Rekt.frames["interruptbar"][i]["frame"];
		frame:Hide();
		local colorframe = Rekt.frames["interruptbar"][i]["colorframe"];
		colorframe:Hide();
	end

	--check if frames are unlocked
	if not db["locked"] then return end;

	if self.interrupts["count"] == 0 then
		return;
	end

	if not self.interrupts["spells"] then
		return;
	end

	--update cds
	Rekt:UpdateIBCDs();

	--sort them
	local tmp = Rekt:SortIBCDs();

	--let's fill them up
	local i = 1;
	for k, v in ipairs(tmp) do
		local frame = Rekt.frames["interruptbar"][i]["frame"];
		local text = Rekt.frames["interruptbar"][i]["texture"];
		text:SetTexture(v["spellIcon"]);
		local CoolDown = Rekt.frames["interruptbar"][i]["cooldown"];
		CoolDown:SetCooldown(v["currentTime"], v["cd"]);
		frame:Show();
		if (db["interruptbar"]["colorframeenabled"]) then
			local colorframe = Rekt.frames["interruptbar"][i]["colorframe"];
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

function Rekt:SortIBCDs()
	if self.interrupts["count"] == 0 then
		return;
	end

	if not self.interrupts["spells"] then
		return;
	end
	
	local db = Rekt.db.profile;
	local ir = Rekt.interrupts;
	local tmp = {};

	--make the tmp table
	local i = 1;
	for k, v in pairs(ir["spells"]) do
		if v then
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
		if db["interruptbar"]["sortOrder"] == "1" then --["1"] = "Ascending (CD left)",
			table.sort(tmp, function(a, b) return Rekt:ComparerAscendingCDLeft(a, b) end);
		elseif db["interruptbar"]["sortOrder"] == "2" then --["2"] = "Descending (CD left)",
			table.sort(tmp, function(a, b) return Rekt:ComparerDescendingCDLeft(a, b) end);
		elseif db["interruptbar"]["sortOrder"] == "3" then --["3"] = "Ascending (CD total)",
			table.sort(tmp, function(a, b) return Rekt:ComparerAscendingCDTotal(a, b) end);
		elseif db["interruptbar"]["sortOrder"] == "4" then --["4"] = "Descending (CD total)",
			table.sort(tmp, function(a, b) return Rekt:ComparerDescendingCDTotal(a, b) end);
		elseif db["interruptbar"]["sortOrder"] == "5" then --["5"] = "Recent first",
			table.sort(tmp, function(a, b) return Rekt:ComparerRecentFirst(a, b) end);
		elseif db["interruptbar"]["sortOrder"] == "6" then --["6"] = "Recent Last",
			table.sort(tmp, function(a, b) return Rekt:ComparerRecentLast(a, b) end);
		end --["7"] = "No order"
	else
		if db["interruptbar"]["sortOrder"] == "1" then --["1"] = "Ascending (CD left)",
			table.sort(tmp, function(a, b) return Rekt:ComparerAscendingCDLeftT(a, b) end);
		elseif db["interruptbar"]["sortOrder"] == "2" then --["2"] = "Descending (CD left)",
			table.sort(tmp, function(a, b) return Rekt:ComparerDescendingCDLeftT(a, b) end);
		elseif db["interruptbar"]["sortOrder"] == "3" then --["3"] = "Ascending (CD total)",
			table.sort(tmp, function(a, b) return Rekt:ComparerAscendingCDTotalT(a, b) end);
		elseif db["interruptbar"]["sortOrder"] == "4" then --["4"] = "Descending (CD total)",
			table.sort(tmp, function(a, b) return Rekt:ComparerDescendingCDTotalT(a, b) end);
		elseif db["interruptbar"]["sortOrder"] == "5" then --["5"] = "Recent first",
			table.sort(tmp, function(a, b) return Rekt:ComparerRecentFirstT(a, b) end);
		elseif db["interruptbar"]["sortOrder"] == "6" then --["6"] = "Recent Last",
			table.sort(tmp, function(a, b) return Rekt:ComparerRecentLastT(a, b) end);
		end --["7"] = "No order"
	end
	
	return tmp;
end
