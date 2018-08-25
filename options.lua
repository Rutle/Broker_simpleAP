local LibStub = LibStub
local Broker_simpleAP = LibStub:GetLibrary("LibDataBroker-1.1",true):GetDataObjectByName("Broker_simpleAP")
local db

local aceoptions = { 
    name = "Broker_simpleAP",
    handler = Broker_simpleAP,
    type = "group",
    args = {
        apLvl = {
            type = "toggle",
            name = "Show artifact level",
            desc = "Show or hide the artifact level.",
            get = function(info, value)
				return db.showArtifactLevel
			end,
            set = function(info, value)
				db.showArtifactLevel = value
				Broker_simpleAP:updateAP()
			end,
        },
		nextLvl = {
            type = "toggle",
            name = "Show xp",
            desc = "Show or hide the xp required till next level.",
            get = function(info, value)
				return db.showNextLevelXP
			end,
            set = function(info, value)
				db.showNextLevelXP = value
				Broker_simpleAP:updateAP()
			end,
        },
    },
}


function Broker_simpleAP:RegisterOptions()
	local defaults = {
		profile = {
			showArtifactLevel = true,
			showNextLevelXP = true
		}
	}

	db = LibStub("AceDB-3.0"):New("Broker_simpleAPDB", defaults, "Default")
	db = db.profile
	Broker_simpleAP:SetDB(db)	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Broker_simpleAP", aceoptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Broker_simpleAP", "Broker simpleAP")
	--aceoptions.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)
end

function Broker_simpleAP:OpenOptions()
	LibStub("AceConfigDialog-3.0"):Open("Broker_simpleAP")
end