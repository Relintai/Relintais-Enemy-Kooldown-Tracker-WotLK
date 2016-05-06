
Rect = LibStub("AceAddon-3.0"):NewAddon("Rect", "AceConsole-3.0", "AceEvent-3.0")
Rect.appName = "Rect"
Rect.dbName = "RectDB"
Rect.version = "1.0RC1"

function Rect:HideFrames()
	for i = 1, 23 do
		local frame = self.frames["target"][i]["frame"];
		frame:Hide();
	end
	for i = 1, 23 do
		local frame = self.frames["focus"][i]["frame"];
		frame:Hide();
	end
	for i = 1, 18 do
		local frame = self.frames["targetdr"][i]["frame"];
		frame:Hide();
	end
	for i = 1, 18 do
		local frame = self.frames["focusdr"][i]["frame"];
		frame:Hide();
	end
	for i = 1, 18 do
		local frame = self.frames["selfdr"][i]["frame"];
		frame:Hide();
	end
end