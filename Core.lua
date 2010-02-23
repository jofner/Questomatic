local L = LibStub("AceLocale-3.0"):GetLocale("Questomatic", true)
Questomatic = LibStub("AceAddon-3.0"):NewAddon("Questomatic", "AceConsole-3.0", "AceEvent-3.0")

local options = {
    name = "Quest-o-matic",
    handler = Questomatic,
    type = "group",
    args = {
        toggle = {
            order = 1,
            type = "toggle",
            name = L["AddOn Enable"],
            desc = L["Enable/Disable Quest-o-matic"],
            get = function() return Questomatic.db.profile.toggle end,
            set = function( info, value ) Questomatic.db.profile.toggle = value end
        },
        accept = {
            order = 2,
            type = "toggle",
            name = L["Auto Accept Quests"],
            desc = L["Enable/Disable auto quest accepting"],
            get = function() return Questomatic.db.profile.accept end,
            set = function( info, value ) Questomatic.db.profile.accept = value end
        },
        greeting = {
            order = 3,
            type = "toggle",
            name = L["Skip Greetings"],
            desc = L["Enable/Disable NPC's greetings skip for one or more quests"],
            get = function() return Questomatic.db.profile.greeting end,
            set = function( info, value ) Questomatic.db.profile.greeting = value end
        },
        escort = {
            order = 4,
            type = "toggle",
            name = L["Auto Accept Escorts"],
            desc = L["Enable/Disable auto escort accepting"],
            get = function() return Questomatic.db.profile.escort end,
            set = function( info, value) Questomatic.db.profile.escort = value end
        },
        complete = {
            order = 5,
            type = "toggle",
            name = L["Auto Complete Quests"],
            desc = L["Enable/Disable auto quest complete"],
            get = function() return Questomatic.db.profile.complete end,
            set = function( info, value ) Questomatic.db.profile.complete = value end
        },
        inraid = {
            order = 6,
            type = "toggle",
            name = L["Auto Accept in Raid"],
            desc = L["Enable/Disable auto accepting quests in raid"],
            get = function() return Questomatic.db.profile.inraid end,
            set = function( info, value ) Questomatic.db.profile.inraid = value end
        },
        config = {
            order = 7,
            type = "execute",
            name = L["Config"],
            desc = L["Open configuration"],
            func = function() InterfaceOptionsFrame_OpenToCategory("Questomatic") end,
            guiHidden = true,
        },
    },
}

local defaults = {
    profile = {
        toggle = true,
        accept = true,
        greeting = true,
        escort = false,
        complete = true,
        inraid = true,
    },
}

function Questomatic:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("QOMDB", defaults, "Default");
    LibStub("AceConfig-3.0"):RegisterOptionsTable("Questomatic", options, {"Questomatic", "qm"});
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Questomatic", "Questomatic");
end

function Questomatic:OnEnable()
    self:RegisterEvent("QUEST_GREETING")
    self:RegisterEvent("GOSSIP_SHOW")
    self:RegisterEvent("QUEST_DETAIL")
    self:RegisterEvent("QUEST_ACCEPT_CONFIRM")
    self:RegisterEvent("QUEST_PROGRESS")
    self:RegisterEvent("QUEST_COMPLETE")
    
    self.db.profile.toggle = true
end

function Questomatic:OnDisable()
    self:UnregisterAllEvents()
    
    self.db.profile.toggle = false
end

function Questomatic:QUEST_GREETING(eventName, ...)
    if UnitInRaid("player") and ( not self.db.profile.inraid ) then
        return;
    end
    
    if (self.db.profile.toggle) and (self.db.profile.greeting) and ( not IsControlKeyDown() ) then
        local numact,numava = GetNumActiveQuests(), GetNumAvailableQuests()
        if numact+numava == 0 then return end

        if numava > 0 then
            SelectAvailableQuest(1);
        end
        if numact > 0 then
            SelectActiveQuest(1);
        end
    end
end

function Questomatic:GOSSIP_SHOW(eventName, ...)
    if UnitInRaid("player") and ( not self.db.profile.inraid ) then
        return;
    end
    
    if (self.db.profile.toggle) and (self.db.profile.greeting) and ( not IsControlKeyDown() ) then
        if GetGossipAvailableQuests() then
            SelectGossipAvailableQuest(1);
        elseif GetGossipActiveQuests() then
            SelectGossipActiveQuest(1);
        end
    end
end

function Questomatic:QUEST_DETAIL(eventName, ...)
    if UnitInRaid("player") and ( not self.db.profile.inraid ) then
        return;
    end
    
    if (self.db.profile.toggle) and (self.db.profile.accept) and ( not IsControlKeyDown() ) then
        AcceptQuest();
    end
end

function Questomatic:QUEST_ACCEPT_CONFIRM(eventName, ...)
    if UnitInRaid("player") and ( not self.db.profile.inraid ) then
        return;
    end
    
    if (self.db.profile.toggle) and (self.db.profile.escort) and ( not IsControlKeyDown() ) then
        ConfirmAcceptQuest();
    end
end

function Questomatic:QUEST_PROGRESS(eventName, ...)
    if (self.db.profile.toggle) and (self.db.profile.complete) and ( not IsControlKeyDown() ) then
        CompleteQuest();
    end
end

function Questomatic:QUEST_COMPLETE(eventName, ...)
    if (self.db.profile.toggle) and (self.db.profile.complete) and ( not IsControlKeyDown() ) then
        if GetNumQuestChoices() == 0 then
            GetQuestReward(QuestFrameRewardPanel.itemChoice);
        end
    end
end