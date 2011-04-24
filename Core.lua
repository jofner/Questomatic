local L = LibStub("AceLocale-3.0"):GetLocale("Questomatic", true)
QOM = LibStub("AceAddon-3.0"):NewAddon("Questomatic", "AceConsole-3.0", "AceEvent-3.0")

local options = {
    name = "Quest-o-matic",
    handler = Questomatic,
    type = "group",
    args = {
        intro = {
            order = 1,
            type = "description",
            name = L["QOM_DESC"],
            cmdHidden = true,
        },
        general = {
            order = 2,
            type = "group",
            inline = true,
            name = L["General Settings"],
            args = {
                toggle = {
                    order = 3,
                    type = "toggle",
                    name = L["AddOn Enable"],
                    desc = L["Enable/Disable Quest-o-matic"],
                    get = function() return QOM.db.char.toggle end,
                    set = function( info, value ) QOM.db.char.toggle = value end
                },
                accept = {
                    order = 4,
                    type = "toggle",
                    name = L["Auto Accept Quests"],
                    desc = L["Enable/Disable auto quest accepting"],
                    get = function() return QOM.db.char.accept end,
                    set = function( info, value ) QOM.db.char.accept = value end
                },
                complete = {
                    order = 5,
                    type = "toggle",
                    name = L["Auto Complete Quests"],
                    desc = L["Enable/Disable auto quest complete"],
                    get = function() return QOM.db.char.complete end,
                    set = function( info, value ) QOM.db.char.complete = value end
                },
            },
        },
        types = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Types settings"],
            args = {
                dailiesonly = {
                    order = 7,
                    type = "toggle",
                    name = L["Dailies Only"],
                    desc = L["Enable/Disable auto accepting for daily quests only"],
                    get = function() return QOM.db.char.dailiesonly end,
                    set = function( info, value ) QOM.db.char.dailiesonly = value end
                },
                pvp = {
                    order = 8,
                    type = "toggle",
                    name = L["Accept PVP Quests"],
                    desc = L["Enable/Disable auto accepting for PvP flagging quests"],
                    get = function() return QOM.db.char.pvp end,
                    set = function( info, value ) QOM.db.char.pvp = value end
                },
                escort = {
                    order = 9,
                    type = "toggle",
                    name = L["Auto Accept Escorts"],
                    desc = L["Enable/Disable auto escort accepting"],
                    get = function() return QOM.db.char.escort end,
                    set = function( info, value) QOM.db.char.escort = value end
                },
            },
        },
        other = {
            order = 10,
            type = "group",
            inline = true,
            name = L["Other settings"],
            args = {
                inraid = {
                    order = 11,
                    type = "toggle",
                    name = L["Enable in Raid"],
                    desc = L["Enable/Disable auto accepting quests in raid"],
                    get = function() return QOM.db.char.inraid end,
                    set = function( info, value ) QOM.db.char.inraid = value end
                },
                greeting = {
                    order = 12,
                    type = "toggle",
                    name = L["Skip Greetings"],
                    desc = L["Enable/Disable NPC's greetings skip for one or more quests"],
                    get = function() return QOM.db.char.greeting end,
                    set = function( info, value ) QOM.db.char.greeting = value end
                },
                diskey = {
                    order = 13,
                    type = "select",
                    name = L["Disable Key"],
                    get = function() return QOM.db.char.diskey end,
                    set = function( info, value ) QOM.db.char.diskey = value end,
                    values = { "Alt", "Ctrl", "Shift" },
                },
            },
        },
        config = {
            order = 14,
            type = "execute",
            name = L["Config"],
            desc = L["Open configuration"],
            func = function() InterfaceOptionsFrame_OpenToCategory("Questomatic") end,
            guiHidden = true,
        },
    },
}

local defaults = {
    char = {
        toggle = true,
        accept = true,
        greeting = true,
        escort = false,
        complete = true,
        inraid = true,
        dailiesonly = false,
        pvp = false,
        diskey = 2,
    },
}

function QOM:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("QOMDB", defaults);
    LibStub("AceConfig-3.0"):RegisterOptionsTable("Questomatic", options, {"qm", "qom"});
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Questomatic", "Questomatic");
end

function QOM:OnEnable()
    self:RegisterEvent("QUEST_GREETING")
    self:RegisterEvent("GOSSIP_SHOW")
    self:RegisterEvent("QUEST_DETAIL")
    self:RegisterEvent("QUEST_ACCEPT_CONFIRM")
    self:RegisterEvent("QUEST_PROGRESS")
    self:RegisterEvent("QUEST_COMPLETE")
    self.db.char.toggle = true
end

function QOM:OnDisable()
    self:UnregisterAllEvents()
    self.db.char.toggle = false
end


-- basic config check for common settings
-- calls on each event fire (thats bad but...)
function QOM:CheckConfigs()
    --QOM:Print("QOM:CheckConfigs()")
    if ( not self.db.char.toggle ) then return end
    --QOM:Print("Addon enabled")
    if UnitInRaid("player") and ( not self.db.char.inraid ) then return end
    --QOM:Print("InRaid passed")
    
    if IsModifierKeyDown() then
        --QOM:Print("Diskey = " .. self.db.char.diskey);
        if     ( self.db.char.diskey == 1 ) and IsAltKeyDown() then return
        elseif ( self.db.char.diskey == 2 ) and IsControlKeyDown() then return
        elseif ( self.db.char.diskey == 3 ) and IsShiftKeyDown() then return end
    end
    
    return true
end

function QOM:CheckQuestData()
    --QOM:Print("CheckQuestData()")
    --QOM:Print("isDaily: " .. ( QuestIsDaily() or 0 ) )
    --QOM:Print("isPvP: " .. ( QuestFlagsPVP() or 0 ) )
    --QOM:Print("QuestID: " .. GetQuestID() )
    if ( not QuestIsDaily() ) and self.db.char.dailiesonly then return end
    if QuestFlagsPVP() and ( not self.db.char.pvp ) then return end
    
    return true
end

function QOM:QUEST_GREETING(eventName, ...)
    --QOM:Print("QUEST_GREETING")
    if QOM:CheckConfigs() and self.db.char.greeting then
        local numact,numava = GetNumActiveQuests(), GetNumAvailableQuests()
        if numact+numava == 0 then return end

        if numava > 0 then
            SelectAvailableQuest(1)
        end
        if numact > 0 then
            SelectActiveQuest(1)
        end
    end
end

function QOM:GOSSIP_SHOW(eventName, ...)
    --QOM:Print("GOSSIP_SHOW")
    if QOM:CheckConfigs() and self.db.char.greeting then
        if GetGossipAvailableQuests() then
            SelectGossipAvailableQuest(1)
        elseif GetGossipActiveQuests() then
            SelectGossipActiveQuest(1)
        end
    end
end

function QOM:QUEST_DETAIL(eventName, ...)
    --QOM:Print("QUEST_DETAIL")
    --QOM:Print("isDaily: " .. ( QuestIsDaily() or 0 ) )
    --QOM:Print("isPvP: " .. ( QuestFlagsPVP() or 0 ) )
    --QOM:Print("QuestID: " .. GetQuestID() )
    --if ( not QuestIsDaily() ) and self.db.char.dailiesonly then return end
    --if QuestFlagsPVP() and ( not self.db.char.pvp ) then return end
    if QOM:CheckConfigs() and QOM:CheckQuestData() and self.db.char.accept then 
        AcceptQuest()
    end
end

function QOM:QUEST_ACCEPT_CONFIRM(eventName, ...)
    --QOM:Print("QUEST_ACCEPT_CONFIRM")
    if QOM:CheckConfigs() and self.db.char.escort then
        ConfirmAcceptQuest()
    end
end

function QOM:QUEST_PROGRESS(eventName, ...)
    --QOM:Print("QUEST_PROGRESS")
    if QOM:CheckConfigs() and self.db.char.complete then
        CompleteQuest()
    end
end

function QOM:QUEST_COMPLETE(eventName, ...)
    --QOM:Print("QUEST_COMPLETE")
    if QOM:CheckConfigs() and self.db.char.complete then
        if GetNumQuestChoices() == 0 then
            GetQuestReward( QuestFrameRewardPanel.itemChoice )
        end
    end
end