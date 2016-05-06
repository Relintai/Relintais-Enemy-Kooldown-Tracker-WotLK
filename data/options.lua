
--"Globals"
local aceDB = LibStub("AceDB-3.0");
local aceCDialog = LibStub("AceConfigDialog-3.0");
local aceConfig = LibStub("AceConfig-3.0");
local libSharedMedia = LibStub("LibSharedMedia-3.0");
local libDRData = LibStub('DRData-1.0');

--Utility Functions for the options

function Rect:RectDisable()
	self:Reset();
	self:ApplySettings();
	--hide the frames
	Rect:HideFrames();
	--self:Disable();
end

function Rect:RectEnable()
	--self:Enable();
	self:Reset();
	self:ApplySettings();
end


--enable
function Rect:isEnabled()
	local db = Rect.db.profile;
	return db["enabled"];
end

function Rect:setEnabledOrDisabled(enable)
	local db = Rect.db.profile;
	db["enabled"] = enable;
	if enable then
		Rect:RectEnable()
	else 
		Rect:RectDisable() 
	end
end

function Rect:isPartEnabled(which)
	local db = Rect.db.profile;
	return db[which]["enabled"];
end

function Rect:SetPartEnabledOrDisabled(which, enable)
	local db = Rect.db.profile;
	db[which]["enabled"] = enable;
	--hide all those frames
	if not enable then
		for i = 1, 23 do
			local frame = Rect.frames[which][i]["frame"];
			frame:Hide();
			local colorframe = Rect.fremes[which][i]["colorframe"];
			colorframe:Hide();
		end
	else
		self:ReassignCds(which);
	end
end

function Rect:SetDRPartEnabledOrDisabled(which, enable)
	local db = Rect.db.profile;
	db[which]["enabled"] = enable;
	--hide all those frames
	if not enable then
		for i = 1, 18 do
			local frame = Rect.frames[which][i]["frame"];
			frame:Hide();
		end
	else
		self:ReassignDRs(which);
	end
end

function Rect:isSpecDetectionEnabled()
	local db = Rect.db.profile;
	return db["specdetection"];
end

function Rect:setSpecDetectionEnabledorDisabled(enable)
	local db = Rect.db.profile;
	db["specdetection"] = enable;
	--call the remapcooldowns, and then update
	--self:ReassignCds(which);
end

function Rect:getColorFrameEnabled(which)
	local db = Rect.db.profile;
	return db[which]["colorframeenabled"];
end

function Rect:setColorFrameEnabled(which, enable)
	local db = Rect.db.profile;
	db[which]["colorframeenabled"] = enable;
	--hide all those frames
	if not enable then
		for i = 1, 23 do
			local colorframe = Rect.frames[which][i]["colorframe"];
			colorframe:Hide();
		end
	else
		self:ReassignCds(which);
	end
end

function Rect:getCDTypeSortingEnable()
	local db = Rect.db.profile;
	return db["cdtypesortorder"]["enabled"];
end

function Rect:setCDTypeSortingEnable(v)
	local db = Rect.db.profile;
	db["cdtypesortorder"]["enabled"] = v;
	
	self:ReassignCds("target");
	self:ReassignCds("focus");
end

function Rect:getPetCDGuessing()
	local db = Rect.db.profile;
	return db["petcdguessing"];
end

function Rect:setPetCDGuessing(v)
	local db = Rect.db.profile;
	db["petcdguessing"] = v;
end

--lock
function Rect:isLocked()
	return Rect.db.profile["locked"];
end

function Rect:LockFrames()
	self:MoveTimersStop("target");
	self:MoveTimersStop("focus");
	self:HideMovableFrames()
	self:ReassignCds("target");
	self:ReassignCds("focus");
end

function Rect:UnlockFrames()
	--this will hide the frames
	self:ReassignCds("target");
	self:ReassignCds("focus");
	Rect:ShowMovableFrames();
end

function Rect:HideMovableFrames()
	if not Rect.MovableFrames then return end;
	--Hide them
	for k, v in pairs(Rect.MovableFrames) do
		v["frame"]:EnableMouse(false);
		v["frame"]:SetMovable(false);
		v["frame"]:Hide();
	end
end

function Rect:ShowMovableFrames()
	local db = Rect.db.profile;
	--Create them if they doesn't exists
	if not Rect.MovableFrames then
		Rect.MovableFrames = {}
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
			
			Rect.MovableFrames[i] = {}
			Rect.MovableFrames[i]["frame"] = frame;
			Rect.MovableFrames[i]["texture"] = text;
			Rect.MovableFrames[i]["text"] = t;
		end
	end

	--Show, resize them
	for k, v in pairs(Rect.MovableFrames) do
		v["frame"]:EnableMouse(true)
		v["frame"]:SetMovable(true)
		v["frame"]:RegisterForDrag("LeftButton")
		v["frame"]:SetPoint("BOTTOMLEFT", db[v["frame"].DragID]["xPos"], db[v["frame"].DragID]["yPos"]);
		v["frame"]:SetWidth(db[v["frame"].DragID]["size"]);
		v["frame"]:SetHeight(db[v["frame"].DragID]["size"]);
		v["frame"]:Show();
	end
end

function Rect:MovableFrameDragStart()
	this:StartMoving();
end

function Rect:MovableFrameDragStop()
	local db = Rect.db.profile;
	db[this.DragID]["xPos"] = this:GetLeft();
	db[this.DragID]["yPos"] = this:GetBottom();
	--Rect:Print(this:GetLeft() .. " " .. this:GetBottom());
	this:StopMovingOrSizing();
end

--size Functions

function Rect:getFrameSize(which)
	local db = Rect.db.profile;
	return db[which]["size"];
end

function Rect:setFrameSize(which, size)
	local db = Rect.db.profile;
	db[which]["size"] = size;
	
	Rect:MoveTimersStop(which)
	
	if not db["locked"] then
		Rect:ShowMovableFrames();
	end
end

function Rect:getDRNumSize(which)
	local db = Rect.db.profile;
	return db[which]["drnumsize"];
end

function Rect:setDRNumSize(which, size)
	local db = Rect.db.profile;
	db[which]["size"] = size;
	Rect:MoveDRTimersStop(which)
end

function Rect:getColorFrameSize(which)
	local db = Rect.db.profile;
	return db[which]["colorframesize"];
end

function Rect:setColorFrameSize(which, size)
	local db = Rect.db.profile;
	db[which]["colorframesize"] = size;
	
	Rect:MoveTimersStop(which);
	Rect:ReassignCds(which);
	
	if not db["locked"] then
		Rect:ShowMovableFrames();
	end
end

--Grow Order
function Rect:getGrowOrder(which)
	local db = Rect.db.profile;
	return db[which]["growOrder"];
end

function Rect:setGrowOrder(which, v)
	local db = Rect.db.profile;
	db[which]["growOrder"] = v;
	Rect:MoveTimersStop(which)
end

function Rect:setDRGrowOrder(which, v)
	local db = Rect.db.profile;
	db[which]["growOrder"] = v;
	Rect:MoveDRTimersStop(which)
end

--Sort Order
function Rect:getSortOrder(which)
	local db = Rect.db.profile;
	return db[which]["sortOrder"];
end

function Rect:setSortOrder(which, v)
	local db = Rect.db.profile;
	db[which]["sortOrder"] = v;
	Rect:ReassignCds(which);
end

function Rect:getTypeSortOrder(which)
	local db = Rect.db.profile;
	return db["cdtypesortorder"][which];
end

function Rect:setTypeSortOrder(which, v)
	local db = Rect.db.profile;
	db["cdtypesortorder"][which] = v;
	Rect:ReassignCds("target");
	Rect:ReassignCds("focus");
end

--Num Position functions
function Rect:getDRNumPosition(which)
	local db = Rect.db.profile;
	return db[which]["drnumposition"];
end

function Rect:setDRNumPosition(which, v)
	local db = Rect.db.profile;
	db[which]["drnumposition"] = v;
	Rect:MoveDRTimersStop(which);
end

--Color options
function Rect:getColor(part)
	local db = Rect.db.profile;
	
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

function Rect:setColor(part, r, g, b, a)
	local db = Rect.db.profile;
	
	if not db["color"][part] then db["color"][part] = {} end
	
	db["color"][part]["r"] = r;
	db["color"][part]["g"] = g;
	db["color"][part]["b"] = b;
	db["color"][part]["a"] = a;
end

--Debug settings
function Rect:getDebugLevel()
	local db = Rect.db.profile;
	return db["debugLevel"];
end

function Rect:setDebugLevel(v)
	local db = Rect.db.profile;
	db["debugLevel"] = v;
end
		
function Rect:getSpellCastDebug()
	local db = Rect.db.profile;
	return db["spellCastDebug"];
end

function Rect:setSpellCastDebug(v)
	local db = Rect.db.profile;
	db["spellCastDebug"] = v;
end

function Rect:getSpellAuraDebug()
	local db = Rect.db.profile;
	return db["spellAuraDebug"];
end

function Rect:setSpellAuraDebug(v)
	local db = Rect.db.profile;
	db["spellAuraDebug"] = v;
end

function Rect:getAllCDebug()
	local db = Rect.db.profile;
	return db["allCDebug"];
end

function Rect:setAllCDebug(v)
	local db = Rect.db.profile;
	db["allCDebug"] = v;
end

function Rect:getSelfCDRegister()
	local db = Rect.db.profile;
	return db["selfCDRegister"];
end

function Rect:setSelfCDRegister(v)
	local db = Rect.db.profile;
	db["selfCDRegister"] = v;
	Rect:ReassignCds("target");
	Rect:ReassignCds("focus");
end