
--"Globals"
local aceDB = LibStub("AceDB-3.0");
local aceCDialog = LibStub("AceConfigDialog-3.0");
local aceConfig = LibStub("AceConfig-3.0");
local libSharedMedia = LibStub("LibSharedMedia-3.0");
local libDRData = LibStub('DRData-1.0');

--Utility Functions for the options

function Vect:VectDisable()
	self:Reset();
	self:ApplySettings();
	--hide the frames
	Vect:HideFrames();
	--self:Disable();
end

function Vect:VectEnable()
	--self:Enable();
	self:Reset();
	self:ApplySettings();
end


--enable
function Vect:isEnabled()
	local db = Vect.db.profile;
	return db["enabled"];
end

function Vect:setEnabledOrDisabled(enable)
	local db = Vect.db.profile;
	db["enabled"] = enable;
	if enable then
		Vect:VectEnable()
	else 
		Vect:VectDisable() 
	end
end

function Vect:isPartEnabled(which)
	local db = Vect.db.profile;
	return db[which]["enabled"];
end

function Vect:SetPartEnabledOrDisabled(which, enable)
	local db = Vect.db.profile;
	db[which]["enabled"] = enable;
	--hide all those frames
	if not enable then
		for i = 1, 23 do
			local frame = Vect.frames[which][i]["frame"];
			frame:Hide();
		end
	else
		self:ReassignCds(which);
	end
end

function Vect:SetDRPartEnabledOrDisabled(which, enable)
	local db = Vect.db.profile;
	db[which]["enabled"] = enable;
	--hide all those frames
	if not enable then
		for i = 1, 18 do
			local frame = Vect.frames[which][i]["frame"];
			frame:Hide();
		end
	else
		self:ReassignDRs(which);
	end
end

--lock
function Vect:isLocked()
	return Vect.db.profile["locked"];
end

function Vect:LockFrames()
	self:MoveTimersStop("target");
	self:MoveTimersStop("focus");
	self:HideMovableFrames()
	self:ReassignCds("target");
	self:ReassignCds("focus");
end

function Vect:UnlockFrames()
	--this will hide the frames
	self:ReassignCds("target");
	self:ReassignCds("focus");
	Vect:ShowMovableFrames();
end

function Vect:HideMovableFrames()
	if not Vect.MovableFrames then return end;
	--Hide them
	for k, v in pairs(Vect.MovableFrames) do
		v["frame"]:EnableMouse(false);
		v["frame"]:SetMovable(false);
		v["frame"]:Hide();
	end
end

function Vect:ShowMovableFrames()
	local db = Vect.db.profile;
	--Create them if they doesn't exists
	if not Vect.MovableFrames then
		Vect.MovableFrames = {}
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
			
			Vect.MovableFrames[i] = {}
			Vect.MovableFrames[i]["frame"] = frame;
			Vect.MovableFrames[i]["texture"] = text;
			Vect.MovableFrames[i]["text"] = t;
		end
	end

	--Show, resize them
	for k, v in pairs(Vect.MovableFrames) do
		v["frame"]:EnableMouse(true)
		v["frame"]:SetMovable(true)
		v["frame"]:RegisterForDrag("LeftButton")
		v["frame"]:SetPoint("BOTTOMLEFT", db[v["frame"].DragID]["xPos"], db[v["frame"].DragID]["yPos"]);
		v["frame"]:SetWidth(db[v["frame"].DragID]["size"]);
		v["frame"]:SetHeight(db[v["frame"].DragID]["size"]);
		v["frame"]:Show();
	end
end

function Vect:MovableFrameDragStart()
	this:StartMoving();
end

function Vect:MovableFrameDragStop()
	local db = Vect.db.profile;
	db[this.DragID]["xPos"] = this:GetLeft();
	db[this.DragID]["yPos"] = this:GetBottom();
	--Vect:Print(this:GetLeft() .. " " .. this:GetBottom());
	this:StopMovingOrSizing();
end

--size Functions

function Vect:getFrameSize(which)
	local db = Vect.db.profile;
	return db[which]["size"];
end

function Vect:setFrameSize(which, size)
	local db = Vect.db.profile;
	db[which]["size"] = size;
	
	Vect:MoveTimersStop(which)
	
	if not db["locked"] then
		Vect:ShowMovableFrames();
	end
end

function Vect:getDRNumSize(which)
	local db = Vect.db.profile;
	return db[which]["drnumsize"];
end

function Vect:setDRNumSize(which, size)
	local db = Vect.db.profile;
	db[which]["drnumsize"] = size;
	Vect:MoveDRTimersStop(which)
end

--Grow Order
function Vect:getGrowOrder(which)
	local db = Vect.db.profile;
	return db[which]["growOrder"];
end

function Vect:setGrowOrder(which, v)
	local db = Vect.db.profile;
	db[which]["growOrder"] = v;
	Vect:MoveTimersStop(which)
end

function Vect:setDRGrowOrder(which, v)
	local db = Vect.db.profile;
	db[which]["growOrder"] = v;
	Vect:MoveDRTimersStop(which)
end

--Sort Order
function Vect:getSortOrder(which)
	local db = Vect.db.profile;
	return db[which]["sortOrder"];
end

function Vect:setSortOrder(which, v)
	local db = Vect.db.profile;
	db[which]["sortOrder"] = v;
	Vect:ReassignCds(which);
end

--Num Position functions
function Vect:getDRNumPosition(which)
	local db = Vect.db.profile;
	return db[which]["drnumposition"];
end

function Vect:setDRNumPosition(which, v)
	local db = Vect.db.profile;
	db[which]["drnumposition"] = v;
	Vect:MoveDRTimersStop(which);
end

--Debug settings
function Vect:getDebugLevel()
	local db = Vect.db.profile;
	return db["debugLevel"];
end

function Vect:setDebugLevel(v)
	local db = Vect.db.profile;
	db["debugLevel"] = v;
end
		
function Vect:getSpellCastDebug()
	local db = Vect.db.profile;
	return db["spellCastDebug"];
end

function Vect:setSpellCastDebug(v)
	local db = Vect.db.profile;
	db["spellCastDebug"] = v;
end

function Vect:getSpellAuraDebug()
	local db = Vect.db.profile;
	return db["spellAuraDebug"];
end

function Vect:setSpellAuraDebug(v)
	local db = Vect.db.profile;
	db["spellAuraDebug"] = v;
end

function Vect:getAllCDebug()
	local db = Vect.db.profile;
	return db["allCDebug"];
end

function Vect:setAllCDebug(v)
	local db = Vect.db.profile;
	db["allCDebug"] = v;
end

function Vect:getSelfCDRegister()
	local db = Vect.db.profile;
	return db["selfCDRegister"];
end

function Vect:setSelfCDRegister(v)
	local db = Vect.db.profile;
	db["selfCDRegister"] = v;
	Vect:ReassignCds("target");
	Vect:ReassignCds("focus");
end