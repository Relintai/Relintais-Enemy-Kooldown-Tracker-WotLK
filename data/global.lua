
Vect = LibStub("AceAddon-3.0"):NewAddon("Vect", "AceConsole-3.0", "AceEvent-3.0")
Vect.appName = "Vect"
Vect.dbName = "VectDB"
Vect.version = "0.9"

function Vect:HideFrames()
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