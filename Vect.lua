
--"Globals"
local ALLOCATE_FRAME_NUM = 5;

local aceDB = LibStub("AceDB-3.0")
local aceCDialog = LibStub("AceConfigDialog-3.0")
local aceConfig = LibStub("AceConfig-3.0")
local libSharedMedia = LibStub("LibSharedMedia-3.0")

Vect.targets = {
	["target"] = nil,
	["focus"] = nil
}

Vect.cds = {}

Vect.frames = {
	["target"] = {},
	["focus"] = {}
}

Vect.defaults = {
   profile = {
		enabled = true,
		locked = true,
		spellDebug = false;
		target = {
			enabled = true,
			size = 23,
			xPos = -150,
			yPos = -125
		},
		focus = {
			enabled = true,
			size = 23,
			xPos = 200,
			yPos = -28
		}
   }
}

function Vect:Reset()
   self.cds = {}
   self.target = {unitGUID = -1, timers = {}}
   self.focus = {unitGUID = -1, timers = {}}
end
   
function Vect:OnInitialize()
	self.db = aceDB:New("VectDB", self.defaults);
	self.db.RegisterCallback(self, "OnProfileChanged", function() self:ApplySettings() end)
	self.db.RegisterCallback(self, "OnProfileCopied", function() self:ApplySettings() end)
	self.db.RegisterCallback(self, "OnProfileReset", function() self:ApplySettings() end)
	self:Print(self.appName .. " v. " .. Vect.version .. ". Chat command is /vect");
	--AceConfig:RegisterOptionsTable(self.appName, self:getOptions())
	self:RegisterChatCommand("vect", "ChatCommand")
end

function Vect:OnEnable()
	--local db = self.db.profile
	self:Reset()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:CreateFrames("target");
	self:CreateFrames("focus");
	self:ApplySettings();
end


function Vect:OnDisable()
   --TODO: cleanup
end


function Vect:ChatCommand(input)
   --TODO
end

function Vect:COMBAT_LOG_EVENT_UNFILTERED(_, timestamp, eventType, srcGUID, srcName, srcFlags, 
					  dstGUID, dstName, dstFlags, spellID, spellName, spellSchool,
					  detail1, detail2, detail3)
	local db =  Vect.db.profile;
	if db["spellDebug"] then
		self:Print("eventType: " .. eventType .. " id: " .. spellID .. " spellName: " .. spellName);
	end
	
   if eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" then
        --self:Print("id: " .. spellID .. " spellName: " .. spellName);
	  
		if Vect.spells[spellID] then
			Vect:AddCd(srcGUID, spellID);
		end
   end
end

function Vect:PLAYER_TARGET_CHANGED()
	local unitGUID = UnitGUID("target");
	self.targets["target"] = unitGUID;
	self:ReassignCds("target");
end

function Vect:PLAYER_FOCUS_CHANGED()
	local unitGUID = UnitGUID("focus");
	self.targets["focus"] = unitGUID;
	self:ReassignCds("focus");
end

function Vect:PLAYER_ENTERING_WORLD()

end

--gets called when a cd is finished, reassigns the cds to frames.
function Vect:ReassignCds(which)
	--first hide all
	for i = 1, 23 do
		local frame = Vect.frames[which][i]["frame"];
		frame:Hide();
	end
	--check if we have cooldown for that unit
	if not self.cds[self.targets[which]] then return end
	--let's fill them up
	local i = 1;
	for k, v in pairs(self.cds[self.targets[which]]) do
		local frame = Vect.frames[which][i]["frame"];
		local text = Vect.frames[which][i]["texture"];
		text:SetTexture(v[4]);
		local CoolDown = Vect.frames[which][i]["cooldown"];
		CoolDown:SetCooldown(v[1], v[3]);
		frame:Show();
		i = i + 1;
	end
end

function Vect:AddCd(srcGUID, spellID)
	local db =  Vect.db.profile;
	if not db["enabled"] then return end;
	
	if not Vect.cds[srcGUID] then Vect.cds[srcGUID] = {} end
	local cd, reset = Vect.spells[spellID][1], Vect.spells[spellID][2];
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

function Vect:CdRemoval(srcGUID, resetArray)
	if not self.cds[srcGUID] then return end
	for k, v in pairs(self.cds[srcGUID]) do
		for j, x in pairs(resetArray) do
			if v[5] == x then
				--self:Print("Removed cd: " .. v[5]);
				self.cds[srcGUID][v[5]] = nil;
			end
		end
	end
end

function Vect:CreateFrames(which)
	for i = 1, 23 do
		local frame = CreateFrame("Frame", nil, UIParent, nil);
		frame:SetFrameStrata("BACKGROUND");
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
		--frame:Show();
		Vect.frames[which][i] = {}
		Vect.frames[which][i]["frame"] = frame;
		Vect.frames[which][i]["texture"] = text;
		Vect.frames[which][i]["cooldown"] = CoolDown;
	end
end

function Vect:MoveTimersStop(which, x, y, size)
	for i = 1, 23 do
		local frame = Vect.frames[which][i]["frame"];
		frame:ClearAllPoints();
		frame:SetFrameStrata("BACKGROUND");
		frame:SetWidth(size);
		frame:SetHeight(size);
		local text = Vect.frames[which][i]["texture"];
		text:SetAllPoints(frame);
		frame.texture = text;
		frame:SetPoint("CENTER", x + ((i - 1) * size), y);
		local CoolDown = Vect.frames[which][i]["cooldown"];
		CoolDown:SetAllPoints();
		--frame:Show();
	end
end

function Vect:ApplySettings()
	local db = Vect.db.profile;
	--self:Print(db["target"]["yPos"]);
	Vect:MoveTimersStop("target", db["target"]["xPos"], db["target"]["yPos"], db["target"]["size"]);
	Vect:MoveTimersStop("focus", db["focus"]["xPos"], db["focus"]["yPos"], db["focus"]["size"]);
	Vect:ReassignCds("target");
	Vect:ReassignCds("focus");
end

function Vect:VOnTimerUpdate(which)
	--check if we have cooldown for that unit
	if not self.cds[self.targets[which]] then return end
	--let's check if one of the cooldowns finished
	for k, v in pairs(self.cds[self.targets[which]]) do
		if v[2] <= GetTime() then
			self.cds[self.targets[which]][v[5]] = nil;
			self:ReassignCds(which);
		end
	end
end