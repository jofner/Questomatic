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
            get = "GetToggle",
            set = "Toggle",
        },
        accept = {
            order = 2,
            type = "toggle",
            name = L["Auto Accept Quests"],
            desc = L["Enable/Disable auto quest accepting"],
            get = "GetAccept",
            set = "Accept"
        },
        greeting = {
            order = 3,
            type = "toggle",
            name = L["Skip Greetings"],
            desc = L["Enable/Disable NPC's greetings skip for one or more quests"],
            get = "GetGreeting",
            set = "Greeting"
        },
        escort = {
            order = 4,
            type = "toggle",
            name = L["Auto Accept Escorts"],
            desc = L["Enable/Disable auto escort accepting"],
            get = "GetEscort",
            set = "Escort",
        },
        complete = {
            order = 5,
            type = "toggle",
            name = L["Auto Complete Quests"],
            desc = L["Enable/Disable auto quest complete"],
            get = "GetComplete",
            set = "Complete",
        },
        inraid = {
            order = 6,
            type = "toggle",
            name = L["Auto Accept in Raid"],
            desc = L["Enable/Disable auto accepting quests in raid"],
            get = "GetInRaid",
            set = "InRaid",
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

function Questomatic:GetToggle(info)
    return self.db.profile.toggle;
end

function Questomatic:Toggle(info, value)
    self.db.profile.toggle = value;
    if self.db.profile.toggle then
        Questomatic:Print(L["Quest-o-matic Enabled"]);
    else
        Questomatic:Print(L["Quest-o-matic Disabled"]);
    end
end

function Questomatic:GetAccept(info)
    return self.db.profile.accept;
end

function Questomatic:Accept(info, value)
    self.db.profile.accept = value;
    if self.db.profile.accept then
        Questomatic:Print(L["Auto Accept Quests Enabled"]);
    else
        Questomatic:Print(L["Auto Accept Quests Disabled"]);
    end
end

function Questomatic:GetGreeting(info)
    return self.db.profile.greeting;
end

function Questomatic:Greeting(info, value)
    self.db.profile.greeting = value;
    if self.db.profile.greeting then
        Questomatic:Print(L["Skip Greetings Enabled"]);
    else
        Questomatic:Print(L["Skip Greetings Disabled"]);
    end
end

function Questomatic:GetEscort(info)
    return self.db.profile.escort;
end

function Questomatic:Escort(info, value)
    self.db.profile.escort = value;
    if self.db.profile.escort then
        Questomatic:Print(L["Auto Accept Escorts Enabled"]);
    else
        Questomatic:Print(L["Auto Accept Escorts Disabled"]);
    end
end

function Questomatic:GetComplete(info)
    return self.db.profile.complete;
end

function Questomatic:Complete(info, value)
    self.db.profile.complete = value;
    if self.db.profile.complete then
        Questomatic:Print(L["Auto Complete Quests Enabled"]);
    else
        Questomatic:Print(L["Auto Complete Quests Disabled"]);
    end
end

function Questomatic:GetInRaid(info)
    return self.db.profile.inraid;
end

function Questomatic:InRaid(info, value)
    self.db.profile.inraid = value;
    if self.db.profile.inraid then
        Questomatic:Print(L["Auto Accepting Quests in Raids Enabled"]);
    else
        Questomatic:Print(L["Auto Accepting Quests in Raids Disabled"]);
    end
end