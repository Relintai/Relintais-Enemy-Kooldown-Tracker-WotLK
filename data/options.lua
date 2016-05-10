
--"Globals"
local aceDB = LibStub("AceDB-3.0");
local aceCDialog = LibStub("AceConfigDialog-3.0");
local aceConfig = LibStub("AceConfig-3.0");
local libSharedMedia = LibStub("LibSharedMedia-3.0");
local libDRData = LibStub('DRData-1.0');

--Utility Functions for the options

function Rekt:RektDisable()
	self:Reset();
	self:ApplySettings();
	--hide the frames
	Rekt:HideFrames();
	--self:Disable();
end

function Rekt:RektEnable()
	--self:Enable();
	self:Reset();
	self:ApplySettings();
end


--enable
function Rekt:isEnabled()
	local db = Rekt.db.profile;
	return db["enabled"];
end

function Rekt:setEnabledOrDisabled(enable)
	local db = Rekt.db.profile;
	db["enabled"] = enable;
	if enable then
		Rekt:RektEnable()
	else 
		Rekt:RektDisable() 
	end
end

function Rekt:isPartEnabled(which)
	local db = Rekt.db.profile;
	return db[which]["enabled"];
end

function Rekt:SetPartEnabledOrDisabled(which, enable)
	local db = Rekt.db.profile;
	db[which]["enabled"] = enable;
	--hide all those frames
	if not enable then
		for i = 1, 23 do
			local frame = Rekt.frames[which][i]["frame"];
			frame:Hide();
			local colorframe = Rekt.fremes[which][i]["colorframe"];
			colorframe:Hide();
		end
	else
		self:ReassignCds(which);
	end
end

function Rekt:SetDRPartEnabledOrDisabled(which, enable)
	local db = Rekt.db.profile;
	db[which]["enabled"] = enable;
	--hide all those frames
	if not enable then
		for i = 1, 18 do
			local frame = Rekt.frames[which][i]["frame"];
			frame:Hide();
		end
	else
		self:ReassignDRs(which);
	end
end

function Rekt:isSpecDetectionEnabled()
	local db = Rekt.db.profile;
	return db["specdetection"];
end

function Rekt:setSpecDetectionEnabledorDisabled(enable)
	local db = Rekt.db.profile;
	db["specdetection"] = enable;
	--call the remapcooldowns, and then update
	--self:ReassignCds(which);
end

function Rekt:getColorFrameEnabled(which)
	local db = Rekt.db.profile;
	return db[which]["colorframeenabled"];
end

function Rekt:setColorFrameEnabled(which, enable)
	local db = Rekt.db.profile;
	db[which]["colorframeenabled"] = enable;
	--hide all those frames
	if not enable then
		for i = 1, 23 do
			local colorframe = Rekt.frames[which][i]["colorframe"];
			colorframe:Hide();
		end
	else
		self:ReassignCds(which);
	end
end

function Rekt:getCDTypeSortingEnable()
	local db = Rekt.db.profile;
	return db["cdtypesortorder"]["enabled"];
end

function Rekt:setCDTypeSortingEnable(v)
	local db = Rekt.db.profile;
	db["cdtypesortorder"]["enabled"] = v;
	
	self:ReassignCds("target");
	self:ReassignCds("focus");
end

function Rekt:getPetCDGuessing()
	local db = Rekt.db.profile;
	return db["petcdguessing"];
end

function Rekt:setPetCDGuessing(v)
	local db = Rekt.db.profile;
	db["petcdguessing"] = v;
end

--lock
function Rekt:isLocked()
	return Rekt.db.profile["locked"];
end

function Rekt:LockFrames()
	self:MoveTimersStop("target");
	self:MoveTimersStop("focus");
	self:HideMovableFrames()
	self:ReassignCds("target");
	self:ReassignCds("focus");
end

function Rekt:UnlockFrames()
	--this will hide the frames
	self:ReassignCds("target");
	self:ReassignCds("focus");
	Rekt:ShowMovableFrames();
end

function Rekt:HideMovableFrames()
	if not Rekt.MovableFrames then return end;
	--Hide them
	for k, v in pairs(Rekt.MovableFrames) do
		v["frame"]:EnableMouse(false);
		v["frame"]:SetMovable(false);
		v["frame"]:Hide();
	end
end

function Rekt:ShowMovableFrames()
	local db = Rekt.db.profile;
	--Create them if they doesn't exists
	if not Rekt.MovableFrames then
		Rekt.MovableFrames = {}
		for i = 1, 5 do
			local frame = CreateFrame("Frame", nil, UIParent, nil);
			frame:SetFrameStrata("BACKGROUND");
			frame:SetScript("OnDragStart", function() self:MovableFrameDragStart() end)
			frame:SetScript("OnDragStop", function() self:MovableFrameDragStop() end)
			local text = frame:CreateTexture();
			text:SetTexture("Interface\\Icons\\Spell_Arcane_Blink")
			text:SetAllPoints(frame);
			frame.texture = text;
			local t = frame:CreateFontString(nil, "OVERLAY");
			t:SetNonSpaceWrap(false);
			t:SetPoint("CENTER", frame, "CENTER", 2, 0);
			t:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
			
			local ttext = "";
			if i == 1 then
				ttext = "T";
			elseif i == 2 then
				ttext = "F";
			elseif i == 3 then
				ttext = "TDR";
			elseif i == 4 then
				ttext = "FDR";
			elseif i == 5 then
				ttext = "SDR";
			end
			
			t:SetText(ttext);
			
			local which = "";
			if i == 1 then
				which = "target";
			elseif i == 2 then
				which = "focus";
			elseif i == 3 then
				which = "targetdr";
			elseif i == 4 then
				which = "focusdr";
			elseif i == 5 then
				which = "selfdr";
			end
			
			frame.DragID = which;
			
			Rekt.MovableFrames[i] = {}
			Rekt.MovableFrames[i]["frame"] = frame;
			Rekt.MovableFrames[i]["texture"] = text;
			Rekt.MovableFrames[i]["text"] = t;
		end
	end

	--Show, resize them
	for k, v in pairs(Rekt.MovableFrames) do
		v["frame"]:EnableMouse(true)
		v["frame"]:SetMovable(true)
		v["frame"]:RegisterForDrag("LeftButton")
		v["frame"]:SetPoint("BOTTOMLEFT", db[v["frame"].DragID]["xPos"], db[v["frame"].DragID]["yPos"]);
		v["frame"]:SetWidth(db[v["frame"].DragID]["size"]);
		v["frame"]:SetHeight(db[v["frame"].DragID]["size"]);
		v["frame"]:Show();
	end
end

function Rekt:MovableFrameDragStart()
	this:StartMoving();
end

function Rekt:MovableFrameDragStop()
	local db = Rekt.db.profile;
	db[this.DragID]["xPos"] = this:GetLeft();
	db[this.DragID]["yPos"] = this:GetBottom();
	--Rekt:Print(this:GetLeft() .. " " .. this:GetBottom());
	this:StopMovingOrSizing();
end

--size Functions

function Rekt:getFrameSize(which)
	local db = Rekt.db.profile;
	return db[which]["size"];
end

function Rekt:setFrameSize(which, size)
	local db = Rekt.db.profile;
	db[which]["size"] = size;
	
	Rekt:MoveTimersStop(which)
	
	if not db["locked"] then
		Rekt:ShowMovableFrames();
	end
end

function Rekt:getDRNumSize(which)
	local db = Rekt.db.profile;
	return db[which]["drnumsize"];
end

function Rekt:setDRNumSize(which, size)
	local db = Rekt.db.profile;
	db[which]["size"] = size;
	Rekt:MoveDRTimersStop(which)
end

function Rekt:getColorFrameSize(which)
	local db = Rekt.db.profile;
	return db[which]["colorframesize"];
end

function Rekt:setColorFrameSize(which, size)
	local db = Rekt.db.profile;
	db[which]["colorframesize"] = size;
	
	Rekt:MoveTimersStop(which);
	Rekt:ReassignCds(which);
	
	if not db["locked"] then
		Rekt:ShowMovableFrames();
	end
end

--Grow Order
function Rekt:getGrowOrder(which)
	local db = Rekt.db.profile;
	return db[which]["growOrder"];
end

function Rekt:setGrowOrder(which, v)
	local db = Rekt.db.profile;
	db[which]["growOrder"] = v;
	Rekt:MoveTimersStop(which)
end

function Rekt:setDRGrowOrder(which, v)
	local db = Rekt.db.profile;
	db[which]["growOrder"] = v;
	Rekt:MoveDRTimersStop(which)
end

--Sort Order
function Rekt:getSortOrder(which)
	local db = Rekt.db.profile;
	return db[which]["sortOrder"];
end

function Rekt:setSortOrder(which, v)
	local db = Rekt.db.profile;
	db[which]["sortOrder"] = v;
	Rekt:ReassignCds(which);
end

function Rekt:getTypeSortOrder(which)
	local db = Rekt.db.profile;
	return db["cdtypesortorder"][which];
end

function Rekt:setTypeSortOrder(which, v)
	local db = Rekt.db.profile;
	db["cdtypesortorder"][which] = v;
	Rekt:ReassignCds("target");
	Rekt:ReassignCds("focus");
end

--Num Position functions
function Rekt:getDRNumPosition(which)
	local db = Rekt.db.profile;
	return db[which]["drnumposition"];
end

function Rekt:setDRNumPosition(which, v)
	local db = Rekt.db.profile;
	db[which]["drnumposition"] = v;
	Rekt:MoveDRTimersStop(which);
end

--Color options
function Rekt:getColor(part)
	local db = Rekt.db.profile;
	
	if not db["color"] then db["color"] = {} end
	
	if not db["color"][part] then 
		db["color"][part] = {};
		db["color"][part]["r"] = 1;
		db["color"][part]["g"] = 0;
		db["color"][part]["b"] = 0;
		db["color"][part]["a"] = 1;
	end
	
	return db["color"][part]["r"], db["color"][part]["g"], db["color"][part]["b"], db["color"][part]["a"];
end

function Rekt:setColor(part, r, g, b, a)
	local db = Rekt.db.profile;
	
	if not db["color"][part] then db["color"][part] = {} end
	
	db["color"][part]["r"] = r;
	db["color"][part]["g"] = g;
	db["color"][part]["b"] = b;
	db["color"][part]["a"] = a;
end

--Debug settings
function Rekt:getDebugLevel()
	local db = Rekt.db.profile;
	return db["debugLevel"];
end

function Rekt:setDebugLevel(v)
	local db = Rekt.db.profile;
	db["debugLevel"] = v;
end
		
function Rekt:getSpellCastDebug()
	local db = Rekt.db.profile;
	return db["spellCastDebug"];
end

function Rekt:setSpellCastDebug(v)
	local db = Rekt.db.profile;
	db["spellCastDebug"] = v;
end

function Rekt:getSpellAuraDebug()
	local db = Rekt.db.profile;
	return db["spellAuraDebug"];
end

function Rekt:setSpellAuraDebug(v)
	local db = Rekt.db.profile;
	db["spellAuraDebug"] = v;
end

function Rekt:getAllCDebug()
	local db = Rekt.db.profile;
	return db["allCDebug"];
end

function Rekt:setAllCDebug(v)
	local db = Rekt.db.profile;
	db["allCDebug"] = v;
end

function Rekt:getSelfCDRegister()
	local db = Rekt.db.profile;
	return db["selfCDRegister"];
end

function Rekt:setSelfCDRegister(v)
	local db = Rekt.db.profile;
	db["selfCDRegister"] = v;
	Rekt:ReassignCds("target");
	Rekt:ReassignCds("focus");
end