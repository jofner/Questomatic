# Quest-o-matic

Are you doing same daily quests every day? Are you leveling another alt and you know all quests in game?
You don't need read quests, you just want click and go? Bored to still Accept and Finish up quests?
Quest-o-matic can do some work for you.

Quest-o-matic is small addon which can auto accept and auto finish quests for you:

    - auto accepting quests
    - auto skipping "greetings" text by NPC
    - auto accpet escort quests (disabled by default)
    - auto accept daily quests only (optional)
    - not accept PvP flagging quests (optional)
    - auto turn in quests (only if there is no more then one reward)
    - temporary disable "auto" functions by holding modifier key (configurable)
    - show quest levels in quest log
    - minimap/broker support


Quest-o-matic supports LDB display addons like ChocolateBar, Bazooka etc. Question mark on your bar
means that the addon is enabled, exclamation point means it is disabled. Left click changes the state
of the addon, right click opens the settings. If you have no LDB display addon, you can still have
minimap icon with same functionality.

[Quest-o-matic was mentioned in Spotligth at Curse](https://mods.curse.com/spotlight/addons/wow/49154-world-of-warcraft-spotlight-quest-o-matic)

## Quest-o-matic Config and commands

There is two ways to config Quest-o-matic. Config dialog - press ESC > Interface > AddOns > Quest-o-matic, or chat commands:

    /qm - Show Settings
    /qm toggle - Enable/Disable Quest-o-matic
    /qm accept - Enable/Disable auto quest accepting
    /qm dailiesonly - Enable/Disable auto accepting for daily quests only
    /qm pvp - Enable/Disable auto accepting for pvp quests
    /qm greeting - Enable/Disable NPCs greetings skip for one or more quests
    /qm escort - Enable/Disable auto escort accepting
    /qm complete - Enable/Disable auto quest complete
    /qm inraid - Enable/Disable auto accepting quests in raid
    /qm config - Open configuration

You can use /qom command too

#### Sources

[Quest-o-matic on Curse](http://wow.curse.com/downloads/wow-addons/details/questomatic.aspx),
[Quest-o-matic on CurseForge](http://wow.curseforge.com/addons/questomatic/),
[Quest-o-matic on WoWInterface](http://www.wowinterface.com/downloads/info14119-Quest-o-matic.html),
[Quest-o-matic on GitHub](http://github.com/jofner/Questomatic)

### Quest-o-matic limitations / issues / to-do

-   not possible to check quest level before accepting, then QOM will never have
    "Don't accept low level quests" option (for now)
-   not possible to check PvP quest before accepting, only if quest flags PvP. There is
    option for PvP flag quests, but this doesn't work for normal PvP quests

### Quest-o-matic changelog

**2.6**
- Updated TOC to 7.1
- Added files locales.xml and embeds.xml to load dependencies

**2.5**
- Tooltip enchancements via LibQTip
- Reset time format changed into defauilt game format (redundant functions removed)
- Minimap button on/off hotfixed
- New date formats and handling
    - if you have stored record already and you will change dateformat, the change takes effect after new record
- Added option for hide tooltip hints
- Spacers in option before selects for better formatting
- Temporary disabled quest levels option
    - function will be adjusted in future
- Readme written in MarkDown

**2.4.1**
- Don't accept ignored quests

**2.4**
- TOC updated for 7.0
- Updated Ace3 libs
- Switched option function for minimap button

**2.3.1**
- TOC updated for 5.4.0

**2.3**
- Daily record counter added
- Auto accept MoP dailies fix (by vafada)
- Simplified Korea Localization by RootOne

**2.2**
- TOC updated for 5.0.4
- Updated Ace3 libs
- Added LibDataBroker include for compatibility
- Removed maxDailies info

**2.1**
- Updated Ace3 libs of AceGUI for 4.1
- Quest summary info added into LDB tooltip
- Quest levels added into quest log

**2.0**
- Addon rewritten
- Option to select key for temporary disabling auto functions added
- Options for daily quests only added
- Option to disable auto accepting PvP flaggin quests added
- /qom option command added
- LDB basic support added
- embeds.xml file removed
- TOC updated for 4.1

**1.5.3**
- TOC updated for WoW 4x
- AceLib updated to latest version

**1.5.2**
- Revision

**1.5.1**
- Traditional Chinese translation added (thanks to whocare)
- Info/Spam messages removed
- TO-DO added to readme
- Useless functions removed and code optimization

**1.5**
- Project renamed from FastQuest to Quest-o-matic
- Option for auto accepting quests in raid added

**1.4**
- TOC updated for 3.3.0
- Ace libs updated to latest version

**1.3**
- Added localisation support
- Updated TOC for 3.2.0

**1.2**
- Added settings into Interface > AddOns menu
- Small code changes

**1.1**
- Added option to enable/disable auto "greetings" skip
- Added "temporary disable addon functions" key - Ctrl

**1.0**
- Initial release
