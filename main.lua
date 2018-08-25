local ADDON, namespace = ...
local db, dataobj
local ldb = LibStub:GetLibrary("LibDataBroker-1.1",true)

dataobj = ldb:NewDataObject("Broker_simpleAP", {
	type = "data source",
	icon = "Interface\\Addons\\"..ADDON.."\\icon.tga",
	label = "Simple AP",
	text = "-",
	OnClick = function(self, button, ...)
		if button == "RightButton" then
			dataobj:OpenOptions()
		end
	end
})

local function getAPData()
	local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
	local xp, totalAzeXP = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)		
	local azeriteItem = Item:CreateFromItemLocation(azeriteItemLocation)
	local azeriteName = azeriteItem:GetItemName() .. ":"
	local azeLvl = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
	return xp, totalAzeXP, azeriteName, azeLvl
end

function dataobj:updateAP()
	if C_AzeriteItem.HasActiveAzeriteItem() then
		local xp, totalAzeXP, azeriteName, azeLvl = getAPData()
		local textColor = "|cffffd200" --Yellow
		local whiteColor = "|cffffffff" --White
		local blueColor = "|c8eb9ff00" --Greenish
		local nextLvl = ""
		local apLvl = ""
		if db.showArtifactLevel then
			apLvl = string.format("%s%s|r %s%i |||r", blueColor, azeriteName, whiteColor, azeLvl)
		end
		if db.showNextLevelXP then
			nextLvl = string.format(" %sNext:|r %s%s", textColor, whiteColor, totalAzeXP - xp)
		end
		dataobj.text = string.format("%s%s", apLvl, nextLvl)
		--dataobj.text = string.format("%s%s|r %s%i |||r %s%s|r%s%s", blueColor, azeriteName, whiteColor, azeLvl, textColor, nextLvl, whiteColor, totalAzeXP - xp)
	else
		dataobj.text = "None"
	end
	
end

-- Not very familiar with LUA so made a local function to call dataobj:updateAP() from the C_Timer.After(...) as it was giving errors.
local function updateText()
	dataobj:updateAP();
end

function dataobj:SetDB(database)
	db = database
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED")

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		dataobj:RegisterOptions()
		frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
		-- Delay update. Otherwise API calls will return 'nil's.
		C_Timer.After(5, updateText);

	else
		updateText();
	end

end);

