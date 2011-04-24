local mod = QOM:NewModule("ldb")
local L = LibStub:GetLibrary("AceLocale-3.0"):GetLocale("Questomatic")

function mod:OnEnable()
    local LDB = LibStub("LibDataBroker-1.1")
    if not LDB then return end
    if self.ldb then return end

    DataObj = LDB:NewDataObject("Questomatic",{
        type = "data source",
        text = "Quest-o-matic",
        label = "Questomatic",
        icon	= "",
        OnClick = function(self, button)
            if button == "LeftButton" then
                if QOM.db.char.toggle then
                    QOM.db.char.toggle = false
                    DataObj.icon = "Interface\\GossipFrame\\ActiveQuestIcon"
                else
                    QOM.db.char.toggle = true
                    DataObj.icon = "Interface\\GossipFrame\\AvailableQuestIcon"
                end
            else
                InterfaceOptionsFrame_OpenToCategory("Questomatic")
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("Quest-o-matic")
            tooltip:AddLine(" ")
            tooltip:AddLine(L["Left-click to toggle Quest-o-matic"], 0, 1, 0)
            tooltip:AddLine(L["Right-click to open Quest-o-matic config"], 0, 1, 0)
            tooltip:AddLine(" ")
        end,
    })
    if QOM.db.char.toggle then
		DataObj.icon = "Interface\\GossipFrame\\AvailableQuestIcon"
	else
		DataObj.icon = "Interface\\GossipFrame\\ActiveQuestIcon"
	end
end