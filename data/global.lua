
Rekt = LibStub("AceAddon-3.0"):NewAddon("Rekt", "AceConsole-3.0", "AceEvent-3.0")
Rekt.appName = "Rekt"
Rekt.dbName = "RektDB"
Rekt.version = "1.05"

Rekt.modules = {}

function Rekt:NewTrinketTrackerModule(name, priority, defaults)
    local module = CreateFrame("Frame")
    module.name = name
    module.priority = priority or 0
    module.defaults = defaults or {}
    module.messages = {}

    module.RegisterMessage = function(self, message, func)
        self.messages[message] = func or message
    end

    module.GetOptions = function()
        return nil
    end

    if defaults then
	    for k, v in pairs(defaults) do
	    	self:Print(k);
	        Rekt.defaults.profile[k] = v;
	    end
	end

    self.modules[name] = module

    return module
end

function Rekt:HideFrames()
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