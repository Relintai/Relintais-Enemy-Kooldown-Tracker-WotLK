
-- [42292] ={120, nil,   120,     120,     120,     0,    "", "anticc", false}, --PvP Trinket
-- spellid   cd  reset spec1cd, spec2cd, spec3cd, spec, class,  type,   ispetspell --comment

--spellid -> the spell's id
--cd -> base cooldown for the spell, this will be used until the spec is detected (if its on, else this will be used)
--		NOTE: cds are in seconds, and if the tooltip shows like 2.1M then you convert it like this: 2.1 * 60 = 126
--reset -> lua array, when the spell is cast these will be removed from the caster's spells (check Cold Snap or Preparation for an example)
--spec1cd, spec2cd, spec3cd ->cds on different specs, its in talent tree order e.g. Mage spec1 = Arcane, spec2 = Fire, spec3 = Arcane
--spec -> the addon detects the spec based on this, 0 to ignore, 3 switch to spec 1, 4 switch to spec2, 5 switch to spec 5
--class -> Used in "Pet CD Guessing", if everybody can cast it use "", else the calss name, with the first letter capitalized e.g. "Warrior"
--Type -> used for the colors, and type based sorting
--			values: silence,gapcloser,defensive,potion,nuke,anticc,cc,stun,disarm,cdreset,shield,uncategorized
--ispetspell -> if its a pet spell true, else false

--TODO recklessness value!
--TODO Rapid Fire value!
--TODO cheating death
--TODO Physic scream spec3 value is wrong
--TODO Sdahow Word Death, as it's a cc breaker
--TODO Shaman Nature's Swiftness base cd is probably wrong
--TODO Shaman Nature's guardian proc i think its a cd in wotlk
--TODO cold snap resets frost ward, and fire ward here?

Rect.spells = {
	--Trinkets
	[42292] = {120, nil, 120, 120, 120, 0, "", "anticc", false}, --PvP Trinket
	--Other Stuff
	[54861] = {180, nil, 180, 180, 180, 0, "", "gapcloser", false}, --Rocket Boots (Enchant)
	--Racials (War Stomp no combatlog entry)
	[59752] = {120, nil, 120, 120, 120, 0, "", "anticc", false}, --Every Man For Himself
	[7744] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Will of the Forsaken
	[25046] = {120, nil, 120, 120, 120, 0, "", "silence", false}, --Arcane Torrent (Energy Version)
	[28730] = {120, nil, 120, 120, 120, 0, "", "silence", false}, --Arcane Torrent (Mana version)
	[50613] = {120, nil, 120, 120, 120, 0, "", "silence", false}, --Arcane Torrent (Runic Power version)
	[28730] = {120, nil, 120, 120, 120, 0, "", "silence", false}, --Arcane Torrent (Heroes Warrior)
	[65116] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Stoneform
	[58984] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Shadowmeld
	[20589] = {105, nil, 105, 105, 105, 0, "", "defensive", false}, --Escape Artist
	[28880] = {180, nil, 180, 180, 180, 0, "", "defensive", false}, --Gift of the Naaru
	--Potions
	[6615] = {60, nil, 60, 60, 60, 0, "", "potion", false}, --Free Action Potion
	
	--Warrior
	--Total: 20
	--Arms
	[46924] = {90, nil, 90, 90, 90, 3, "Warrior", "nuke", false}, --BladeStrom
	[100] = {15, nil, 20, 15, 15, 0, "Warrior", "gapcloser", false}, --Charge rank 1
	[6178] = {15, nil, 20, 15, 15, 0, "Warrior", "gapcloser", false}, --Charge rank 2
	[11578] = {15, nil, 20, 15, 15, 0, "Warrior", "gapcloser", false}, --Charge rank 3
	[57755] = {60, nil, 60, 60, 60, 0, "Warrior", "uncategorized", false}, --Heroic Throw
	[20230] = {240, nil, 300, 300, 240, 0, "Warrior", "nuke", false}, --Retaliation
	[64382] = {300, nil, 300, 300, 300, 0, "Warrior", "uncategorized", false}, --Shattering Throw
	[12328] = {30, nil, 30, 30, 30, 3, "Warrior", "uncategorized", false}, --Sweeping Strikes
	--Detection
	[12294] = {0, nil, 0, 0, 0, 3, "Warrior", "", false}, --Mortal Strike r1
	[21551] = {0, nil, 0, 0, 0, 3, "Warrior", "", false}, --Mortal Strike r2
	[21552] = {0, nil, 0, 0, 0, 3, "Warrior", "", false}, --Mortal Strike r3
	[21553] = {0, nil, 0, 0, 0, 3, "Warrior", "", false}, --Mortal Strike r4
	[25248] = {0, nil, 0, 0, 0, 3, "Warrior", "", false}, --Mortal Strike r5
	[30330] = {0, nil, 0, 0, 0, 3, "Warrior", "", false}, --Mortal Strike r6
	[47485] = {0, nil, 0, 0, 0, 3, "Warrior", "", false}, --Mortal Strike r7
	[47486] = {0, nil, 0, 0, 0, 3, "Warrior", "", false}, --Mortal Strike r8
	--Fury
	[18499] = {20.1, nil, 30, 20.1, 30, 0, "Warrior", "anticc", false}, --Berserker Rage
	[12292] = {121, nil, 121, 121, 121, 4, "Warrior", "nuke", false}, --Death Wish
	[55694] = {180, nil, 180, 180, 180, 0, "Warrior", "defensive", false}, --Enraged Regeneration
	[60970] = {45, {20252}, 45, 45, 45, 4, "Warrior", "gapcloser", false}, --Heroic Fury
	[20252] = {20, nil, 30, 20, 30, 0, "Warrior", "gapcloser", false}, --Intercept
	[5246] = {120, nil, 120, 120, 120, 0, "Warrior", "cc", false}, --Intimidating Shout
	[6552] = {10, nil, 10, 10, 10, 0, "Warrior", "silence", false}, --Pummel
	[1719] = {161, nil, 300, 210, 240, 0, "Warrior", "nuke", false}, --Recklessness
	--Detection
	[23881] = {0, nil, 0, 0, 0, 4, "Warrior", "uncategorized", false}, --Bloodthirst
	--Protection
	[12809] = {30, nil, 30, 30, 30, 5, "Warrior", "stun", false}, --Concussion Blow
	[676] = {40, nil, 60, 60, 60, 0, "Warrior", "disarm", false}, --Disarm
	[3411] = {30, nil, 30, 30, 30, 0, "Warrior", "gapcloser", false}, --Intervene
	[12975] = {180, nil, 180, 180, 180, 0, "Warrior", "defensive", false}, --Last Stand
	[72] = {12, nil, 12, 12, 12, 0, "Warrior", "silence", false}, --Shield Bash
	[871] = {240, nil, 300, 300, 240, 0, "Warrior", "defensive", false}, --Shield Wall
	[46968] = {20, nil, 20, 20, 20, 5, "Warrior", "stun", false}, --Shockwave
	[23920] = {10, nil, 10, 10, 10, 0, "Warrior", "silence", false}, --Spell Reflection
	--Detection
	[20243] = {0, nil, 0, 0, 0, 5, "Warrior", "", false}, --Devastate r1
	[30016] = {0, nil, 0, 0, 0, 5, "Warrior", "", false}, --Devastate r2
	[30022] = {0, nil, 0, 0, 0, 5, "Warrior", "", false}, --Devastate r3
	[47497] = {0, nil, 0, 0, 0, 5, "Warrior", "", false}, --Devastate r4
	[47498] = {0, nil, 0, 0, 0, 5, "Warrior", "", false}, --Devastate r5
	[50720] = {0, nil, 0, 0, 0, 5, "Warrior", "", false}, --Vigilance
	
	--Paladin
	--Total: 16
	--Holy
	[31821] = {120, nil, 120, 120, 120, 0, "Paladin", "anticc", false}, --Aura Mastery
	[20216] = {120, nil, 120, 120, 120, 3, "Paladin", "uncategorized", false}, --Divine Favor
	[31842] = {180, nil, 180, 180, 180, 3, "Paladin", "uncategorized", false}, --Divine Illumination
	[54428] = {60, nil, 60, 60, 60, 0, "Paladin", "defensive", false}, --Divine Plea
	[2812] = {20, nil, 20, 20, 20, 0, "Paladin", "uncategorized", false}, --Holy Wrath r1
	[10318] = {20, nil, 20, 20, 20, 0, "Paladin", "uncategorized", false}, --Holy Wrath r2
	[27139] = {20, nil, 20, 20, 20, 0, "Paladin", "uncategorized", false}, --Holy Wrath r3
	[48816] = {20, nil, 20, 20, 20, 0, "Paladin", "uncategorized", false}, --Holy Wrath r4
	[48817] = {20, nil, 20, 20, 20, 0, "Paladin", "uncategorized", false}, --Holy Wrath r5
	[633] = {960, nil, 900, 900, 900, 0, "Paladin", "uncategorized", false}, --Lay on Hands r1
	[2800] = {960, nil, 900, 900, 900, 0, "Paladin", "uncategorized", false}, --Lay on Hands r2
	[10310] = {960, nil, 900, 900, 900, 0, "Paladin", "uncategorized", false}, --Lay on Hands r3
	[27154] = {960, nil, 900, 900, 900, 0, "Paladin", "uncategorized", false}, --Lay on Hands r4
	[48788] = {960, nil, 900, 900, 900, 0, "Paladin", "uncategorized", false}, --Lay on Hands r5
	--Detection
	[20473] = {0, nil, 0, 0, 0, 3, "Paladin", "", false}, --Holy Shock r1
	[20929] = {0, nil, 0, 0, 0, 3, "Paladin", "", false}, --Holy Shock r2
	[20930] = {0, nil, 0, 0, 0, 3, "Paladin", "", false}, --Holy Shock r3
	[27174] = {0, nil, 0, 0, 0, 3, "Paladin", "", false}, --Holy Shock r4
	[33072] = {0, nil, 0, 0, 0, 3, "Paladin", "", false}, --Holy Shock r5
	[48824] = {0, nil, 0, 0, 0, 3, "Paladin", "", false}, --Holy Shock r6
	[48825] = {0, nil, 0, 0, 0, 3, "Paladin", "", false}, --Holy Shock r7
	[53563] = {0, nil, 0, 0, 0, 3, "Paladin", "", false}, --Beacon of Light
	--Protection
	[31935] = {30, nil, 30, 30, 30, 4, "Paladin", "silence", false}, --Avenger's Shield r1
	[32699] = {30, nil, 30, 30, 30, 4, "Paladin", "silence", false}, --Avenger's Shield r2
	[32700] = {30, nil, 30, 30, 30, 4, "Paladin", "silence", false}, --Avenger's Shield r3
	[48826] = {30, nil, 30, 30, 30, 4, "Paladin", "silence", false}, --Avenger's Shield r4
	[48827] = {30, nil, 30, 30, 30, 4, "Paladin", "silence", false}, --Avenger's Shield r5
	[498] = {120, nil, 180, 120, 180, 0, "Paladin", "defensive", false}, --Divine Protection
	[64205] = {120, nil, 120, 120, 120, 0, "Paladin", "defensive", false}, --Divine Sacrifice
	[642] = {240, nil, 300, 240, 300, 0, "Paladin", "defensive", false}, --Divine Shield
	[853] = {30, nil, 40, 30, 40, 0, "Paladin", "stun", false}, --Hammer of justice r1
	[5588] = {30, nil, 40, 30, 40, 0, "Paladin", "stun", false}, --Hammer of justice r2
	[5589] = {30, nil, 40, 30, 40, 0, "Paladin", "stun", false}, --Hammer of justice r3
	[10308] = {30, nil, 40, 30, 40, 0, "Paladin", "stun", false}, --Hammer of justice r4
	[1044] = {25, nil, 25, 25, 25, 0, "Paladin", "anticc", false}, --Hand of Freedom
	[1022] = {180, nil, 180, 180, 180, 0, "Paladin", "defensive", false}, --Hand of Protection r1
	[5599] = {180, nil, 180, 180, 180, 0, "Paladin", "defensive", false}, --Hand of Protection r2
	[10278] = {180, nil, 180, 180, 180, 0, "Paladin", "defensive", false}, --Hand of Protection r3
	[6940] = {120, nil, 120, 120, 120, 0, "Paladin", "defensive", false}, --Hand of Sacrifice
	--Detection
	[53595] = {0, nil, 0, 0, 0, 4, "Paladin", "", false}, --Hammer of the Righteous
	[20925] = {0, nil, 0, 0, 0, 4, "Paladin", "", false}, --Holy Shield r1
	[20927] = {0, nil, 0, 0, 0, 4, "Paladin", "", false}, --Holy Shield r2
	[20928] = {0, nil, 0, 0, 0, 4, "Paladin", "", false}, --Holy Shield r3
	[27179] = {0, nil, 0, 0, 0, 4, "Paladin", "", false}, --Holy Shield r4
	[48951] = {0, nil, 0, 0, 0, 4, "Paladin", "", false}, --Holy Shield r5
	[48952] = {0, nil, 0, 0, 0, 4, "Paladin", "", false}, --Holy Shield r6
	--Retribution
	[31884] = {120, nil, 180, 180, 120, 0, "Paladin", "nuke", false}, --Avenging Wrath
	[20066] = {60, nil, 60, 60, 60, 5, "Paladin", "cc", false}, --Repentance
	--Detection
	[35395] = {0, nil, 0, 0, 0, 5, "Paladin", "", false}, --Crusader Strike
	[53385] = {0, nil, 0, 0, 0, 5, "Paladin", "", false}, --Crusader Strike
	
	--Hunter
	--Total: 15
	--Feign Death No Combat log entry
	--Pet
	[53480] = {42, nil, 42, 42, 42, 0, "Hunter", "defensive", true}, --Roar of Sacrifice
	[53476] = {21, nil, 21, 21, 21, 0, "Hunter", "defensive", true}, --Intervene
	[53562] = {28, nil, 28, 28, 28, 0, "Hunter", "stun", true}, --Ravage (ravager)
	[53548] = {28, nil, 28, 28, 28, 0, "Hunter", "cc", true}, --Pin (Crab)
	[53543] = {42, nil, 42, 42, 42, 0, "Hunter", "disarm", true}, --Snatch (Bird of Prey)
	[4167] = {28, nil, 28, 28, 28, 0, "Hunter", "cc", true}, --Web (Spider)
	[53434] = {210, nil, 210, 210, 210, 0, "Hunter", "nuke", true}, --Call of the Wild (Ferocity pet talent)
	--Beast Mastery
	[19574] = {84, nil, 84, 84, 84, 3, "Hunter", "nuke", false}, --Bestial Wrath
	[19577] = {42, nil, 42, 42, 42, 3, "Hunter", "stun", false}, --Intimidation
	[53271] = {60, nil, 60, 60, 60, 0, "Hunter", "anticc", false}, --Master's Call
	[14327] = {30, nil, 30, 30, 30, 0, "Hunter", "cc", false}, --Scare Beast
	--Marksman
	[1543] = {20, nil, 20, 20, 20, 0, "Hunter", "uncategorized", false}, --Flare
	[3045] = {180, nil, 300, 300, 300, 0, "Hunter", "nuke", false}, --Rapid Fire
	[23989] = {180, 
		{19577,53271,14327, 1543,3045,34490,3674,63668,63669,
		63670,63671,63672,19263,781,13813,14316,14317,
		27025,49066,49067,60192,1499,14310,14311,13809,
		13795,14302,14303,14304,14305,27023,49055,49056,
		19503,34600,19386,24132,24133,27068,49011,49012}, 180, 180, 180, 4, "Hunter", "cdreset", false}, --Readiness
	[34490] = {20, nil, 20, 20, 20, 4, "Hunter", "silence", false}, --Silencing Shot
	--Detection
	[53209] = {0, nil, 0, 0, 0, 4, "Hunter", "", false}, --Chimera Shot
	--Survival
	[3674] = {24, nil, 24, 24, 24, 5, "Hunter", "uncategorized", false}, --Black Arrow r1
	[63668] = {24, nil, 24, 24, 24, 5, "Hunter", "uncategorized", false}, --Black Arrow r2
	[63669] = {24, nil, 24, 24, 24, 5, "Hunter", "uncategorized", false}, --Black Arrow r3
	[63670] = {24, nil, 24, 24, 24, 5, "Hunter", "uncategorized", false}, --Black Arrow r4
	[63671] = {24, nil, 24, 24, 24, 5, "Hunter", "uncategorized", false}, --Black Arrow r5
	[63672] = {24, nil, 24, 24, 24, 5, "Hunter", "uncategorized", false}, --Black Arrow r6
	[19263] = {90, nil, 90, 90, 90, 0, "Hunter", "defensive", false}, --Deterrence
	[781] = {16, nil, 20, 16, 16, 0, "Hunter", "gapcloser", false}, --Disengage
	[13813] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Explosive Trap r1
	[14316] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Explosive Trap r2
	[14317] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Explosive Trap r3
	[27025] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Explosive Trap r4
	[49066] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Explosive Trap r5
	[49067] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Explosive Trap r6
	--Feign Death
	[60192] = {24, nil, 30, 30, 24, 0, "Hunter", "cc", false}, --Freezing Arrow
	[1499] = {24, nil, 30, 30, 24, 0, "Hunter", "cc", false}, --Freezing Trap r1
	[14310] = {24, nil, 30, 30, 24, 0, "Hunter", "cc", false}, --Freezing Trap r2
	[14311] = {24, nil, 30, 30, 24, 0, "Hunter", "cc", false}, --Freezing Trap r3
	[13809] = {24, nil, 30, 30, 24, 0, "Hunter", "cc", false}, --Frost Trap
	[13795] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Immolation Trap r1
	[14302] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Immolation Trap r2
	[14303] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Immolation Trap r3
	[14304] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Immolation Trap r4
	[14305] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Immolation Trap r5
	[27023] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Immolation Trap r6
	[49055] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Immolation Trap r7
	[49056] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Immolation Trap r8
	[19503] = {30, nil, 30, 30, 30, 0, "Hunter", "cc", false}, --Scatter Shot
	[34600] = {24, nil, 30, 30, 24, 0, "Hunter", "uncategorized", false}, --Snake Trap
	[19386] = {60, nil, 60, 60, 60, 5, "Hunter", "cc", false}, --Wyvern Sting r1
	[24132] = {60, nil, 60, 60, 60, 5, "Hunter", "cc", false}, --Wyvern Sting r2
	[24133] = {60, nil, 60, 60, 60, 5, "Hunter", "cc", false}, --Wyvern Sting r3
	[27068] = {60, nil, 60, 60, 60, 5, "Hunter", "cc", false}, --Wyvern Sting r4
	[49011] = {60, nil, 60, 60, 60, 5, "Hunter", "cc", false}, --Wyvern Sting r5
	[49012] = {60, nil, 60, 60, 60, 5, "Hunter", "cc", false}, --Wyvern Sting r6
	--Detection
	[53301] = {0, nil, 0, 0, 0, 5, "Hunter", "", false}, --Explosive Shot r1
	[60051] = {0, nil, 0, 0, 0, 5, "Hunter", "", false}, --Explosive Shot r2
	[60052] = {0, nil, 0, 0, 0, 5, "Hunter", "", false}, --Explosive Shot r3
	[60053] = {0, nil, 0, 0, 0, 5, "Hunter", "", false}, --Explosive Shot r4
	
	--Rogue
	--Total: 15
	--Assassination
	[14177] = {180, nil, 180, 180, 180, 3, "Rogue", "nuke", false}, --Cold Blood
	[51722] = {60, nil, 60, 60, 60, 0, "Rogue", "disarm", false}, --Dismantle
	[408] = {20, nil, 20, 20, 20, 0, "Rogue", "stun", false}, --Kidney Shot r1
	[8643] = {20, nil, 20, 20, 20, 0, "Rogue", "stun", false}, --Kidney Shot r2
	--detect
	[51662] = {0, nil, 0, 0, 0, 3, "Rogue", "", false}, --Hunger for Blood
	[1329] = {0, nil, 0, 0, 0, 3, "Rogue", "", false}, --Mutilate r1
	[34411] = {0, nil, 0, 0, 0, 3, "Rogue", "", false}, --Mutilate r2
	[34412] = {0, nil, 0, 0, 0, 3, "Rogue", "", false}, --Mutilate r3
	[34413] = {0, nil, 0, 0, 0, 3, "Rogue", "", false}, --Mutilate r4
	[48663] = {0, nil, 0, 0, 0, 3, "Rogue", "", false}, --Mutilate r5
	[48666] = {0, nil, 0, 0, 0, 3, "Rogue", "", false}, --Mutilate r6
	--Combat
	[13750] = {180, nil, 180, 180, 180, 4, "Rogue", "nuke", false}, --Adrenaline Rush
	[13877] = {120, nil, 120, 120, 120, 4, "Rogue", "nuke", false}, --Blade Flurry
	[5277] = {120, nil, 180, 120, 180, 0, "Rogue", "defensive", false}, --Evasion r1
	[26669] = {120, nil, 180, 120, 180, 0, "Rogue", "defensive", false}, --Evasion r2
	[1766] = {10, nil, 10, 10, 10, 0, "Rogue", "silence", false}, --Kick
	[51690] = {120, nil, 120, 120, 120, 4, "Rogue", "nuke", false}, --Killing Spree
	[2983] = {120, nil, 180, 120, 180, 0, "Rogue", "defensive", false}, --Sprint r1
	[8696] = {120, nil, 180, 120, 180, 0, "Rogue", "defensive", false}, --Sprint r2
	[11305] = {120, nil, 180, 120, 180, 0, "Rogue", "defensive", false}, --Sprint r3
	--Subtlety
	[2094] = {120, nil, 120, 120, 120, 0, "Rogue", "cc", false}, --Blind
	[31224] = {60, nil, 60, 60, 60, 0, "Rogue", "defensive", false}, --Cloak of Shadows
	[14185] = {300, {5277, 26669, 2983, 8696, 11305, 1856, 1857, 26889, 14177, 36554}, 480, 480, 300, 0, "Rogue", "cdreset", false}, --Preparation
	[51713] = {60, nil, 60, 60, 60, 5, "Rogue", "nuke", false}, --Shadow Dance
	[36554] = {20, nil, 30, 30, 20, 5, "Rogue", "gapcloser", false}, --Shadowstep
	[1856] = {120, nil, 120, 120, 120, 0, "Rogue", "defensive", false}, --Vanish r1
	[1857] = {120, nil, 120, 120, 120, 0, "Rogue", "defensive", false}, --Vanish r2
	[26889] = {120, nil, 120, 120, 120, 0, "Rogue", "defensive", false}, --Vanish r3

	--Priest
	--Total: 14
	--Discipline
	[6346] = {180, nil, 180, 180, 180, 0, "Priest", "anticc", false}, --Fear Ward
	[14751] = {144, nil, 144, 180, 180, 0, "Priest", "uncategorized", false}, --Inner Focus
	[33206] = {144, nil, 144, 144, 144, 3, "Priest", "defensive", false}, --Pain Supression
	[10060] = {96, nil, 96, 96, 96, 3, "Priest", "uncategorized", false}, --Power infusion
	[17] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r1
	[592] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r2
	[600] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r3
	[3747] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r4
	[6065] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r5
	[6066] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r6
	[10898] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r7
	[10899] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r8
	[10900] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r9
	[10901] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r10
	[25217] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r11
	[25218] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r12
	[48065] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r13
	[48066] = {15, nil, 15, 15, 15, 0, "Priest", "shield", false}, --Power Word: Shield r14
	--Detection
	--Penance no combatlog event
	--Holy
	[19203] = {120, nil, 120, 120, 120, 0, "Priest", "defensive", false}, --Desperate Prayer r1
	[19238] = {120, nil, 120, 120, 120, 0, "Priest", "defensive", false}, --Desperate Prayer r2
	[19240] = {120, nil, 120, 120, 120, 0, "Priest", "defensive", false}, --Desperate Prayer r3
	[19241] = {120, nil, 120, 120, 120, 0, "Priest", "defensive", false}, --Desperate Prayer r4
	[19242] = {120, nil, 120, 120, 120, 0, "Priest", "defensive", false}, --Desperate Prayer r5
	[19243] = {120, nil, 120, 120, 120, 0, "Priest", "defensive", false}, --Desperate Prayer r6
	[25437] = {120, nil, 120, 120, 120, 0, "Priest", "defensive", false}, --Desperate Prayer r7
	[48172] = {120, nil, 120, 120, 120, 0, "Priest", "defensive", false}, --Desperate Prayer r8
	[48173] = {120, nil, 120, 120, 120, 0, "Priest", "defensive", false}, --Desperate Prayer r9
	[64843] = {480, nil, 480, 480, 480, 0, "Priest", "defensive", false}, --Divine Hymn
	[47788] = {180, nil, 180, 180, 180, 4, "Priest", "defensive", false}, --Guardian Spirit
	[64901] = {360, nil, 360, 360, 360, 0, "Priest", "defensive", false}, --Hymn of Hope
	--Detection
	--Lightwell no combatlog entry
	[34861] = {0, nil, 0, 0, 0, 4, "Priest", "", false}, --Circle of Healing r1
	[34863] = {0, nil, 0, 0, 0, 4, "Priest", "", false}, --Circle of Healing r2
	[34864] = {0, nil, 0, 0, 0, 4, "Priest", "", false}, --Circle of Healing r3
	[34865] = {0, nil, 0, 0, 0, 4, "Priest", "", false}, --Circle of Healing r4
	[34866] = {0, nil, 0, 0, 0, 4, "Priest", "", false}, --Circle of Healing r5
	[48088] = {0, nil, 0, 0, 0, 4, "Priest", "", false}, --Circle of Healing r6
	[48089] = {0, nil, 0, 0, 0, 4, "Priest", "", false}, --Circle of Healing r7
	--Shadow
	[47585] = {75, nil, 75, 75, 75, 5, "Priest", "defensive", false}, --Dispersion
	[586] = {24, nil, 30, 30, 24, 0, "Priest", "uncategorized", false}, --Fade
	[64044] = {120, nil, 120, 120, 120, 5, "Priest", "cc", false}, --Psychic Horror
	[8122] = {26, nil, 30, 30, 24, 0, "Priest", "cc", false}, --Psychic Scream r1
	[8124] = {26, nil, 30, 30, 24, 0, "Priest", "cc", false}, --Psychic Scream r2
	[10888] = {26, nil, 30, 30, 24, 0, "Priest", "cc", false}, --Psychic Scream r3
	[10890] = {26, nil, 30, 30, 24, 0, "Priest", "cc", false}, --Psychic Scream r4
	[34433] = {180, nil, 180, 180, 180, 0, "Priest", "nuke", false}, --Shadowfiend
	[15487] = {45, nil, 45, 45, 45, 5, "Priest", "silence", false}, --Silence
	--Detection
	[15473] = {0, nil, 0, 0, 0, 5, "Priest", "", false}, --Shadowform
	[15286] = {0, nil, 0, 0, 0, 5, "Priest", "", false}, --Vampiric Embrace
	[34914] = {0, nil, 0, 0, 0, 5, "Priest", "", false}, --Vampiric Touch r1
	[34916] = {0, nil, 0, 0, 0, 5, "Priest", "", false}, --Vampiric Touch r2
	[34917] = {0, nil, 0, 0, 0, 5, "Priest", "", false}, --Vampiric Touch r3
	[48159] = {0, nil, 0, 0, 0, 5, "Priest", "", false}, --Vampiric Touch r4
	[48160] = {0, nil, 0, 0, 0, 5, "Priest", "", false}, --Vampiric Touch r5
	
	--Death Knight
	--Pet
	[47481] = {60, nil, 60, 60, 60, 0, "DeathKnight", "stun", true}, --Gnaw
	--Total: 18
	--Blood
	[49028] = {90, nil, 90, 90, 90, 3, "DeathKnight", "nuke", false}, --Dancing Rune Weapon
	[48743] = {120, nil, 120, 120, 120, 0, "DeathKnight", "defensive", false}, --Death Pact
	[49016] = {180, nil, 180, 180, 180, 3, "DeathKnight", "nuke", false}, --Hysteria
	[49005] = {180, nil, 180, 180, 180, 3, "DeathKnight", "defensive", false}, --Mark of Blood
	[48982] = {30, nil, 30, 60, 60, 0, "DeathKnight", "defensive", false}, --Rune Tap
	[47476] = {120, nil, 120, 120, 120, 0, "DeathKnight", "silence", false}, --Strangulate
	[55233] = {60, nil, 60, 60, 60, 3, "DeathKnight", "defensive", false}, --Vampiric Blood
	--Detection
	[55050] = {0, nil, 0, 0, 0, 3, "DeathKnight", "", false}, --Heart Strike r1
	[55258] = {0, nil, 0, 0, 0, 3, "DeathKnight", "", false}, --Heart Strike r2
	[55259] = {0, nil, 0, 0, 0, 3, "DeathKnight", "", false}, --Heart Strike r3
	[55260] = {0, nil, 0, 0, 0, 3, "DeathKnight", "", false}, --Heart Strike r4
	[55261] = {0, nil, 0, 0, 0, 3, "DeathKnight", "", false}, --Heart Strike r5
	[55262] = {0, nil, 0, 0, 0, 3, "DeathKnight", "", false}, --Heart Strike r6
	--Frost
	[49796] = {120, nil, 120, 120, 120, 4, "DeathKnight", "defensive", false}, --Unbreakable Armor
	[47568] = {300, nil, 300, 300, 300, 0, "DeathKnight", "nuke", false}, --Empower Rune Weapon
	[49203] = {60, nil, 60, 60, 60, 4, "DeathKnight", "cc", false}, --Hungering Cold
	[48792] = {120, nil, 120, 120, 120, 0, "DeathKnight", "anticc", false}, --Icebound Fortitude
	[49039] = {120, nil, 120, 120, 120, 0, "DeathKnight", "anticc", false}, --Lichborne
	[47528] = {10, nil, 10, 10, 10, 0, "DeathKnight", "silence", false}, --Mind Freeze
	[51271] = {60, nil, 60, 60, 60, 4, "DeathKnight", "defensive", false}, --Unbreakable Armor
	--Detection
	[49143] = {0, nil, 0, 0, 0, 4, "DeathKnight", "", false}, --Frost Strike r1
	[51416] = {0, nil, 0, 0, 0, 4, "DeathKnight", "", false}, --Frost Strike r2
	[51271] = {0, nil, 0, 0, 0, 4, "DeathKnight", "", false}, --Frost Strike r3
	[51418] = {0, nil, 0, 0, 0, 4, "DeathKnight", "", false}, --Frost Strike r4
	[51419] = {0, nil, 0, 0, 0, 4, "DeathKnight", "", false}, --Frost Strike r5
	[55268] = {0, nil, 0, 0, 0, 4, "DeathKnight", "", false}, --Frost Strike r6
	[49184] = {0, nil, 0, 0, 0, 4, "DeathKnight", "", false}, --Howling Blast r1
	[51409] = {0, nil, 0, 0, 0, 4, "DeathKnight", "", false}, --Howling Blast r2
	[51410] = {0, nil, 0, 0, 0, 4, "DeathKnight", "", false}, --Howling Blast r3
	[51411] = {0, nil, 0, 0, 0, 4, "DeathKnight", "", false}, --Howling Blast r4
	--Unholy
	[48707] = {45, nil, 45, 45, 45, 0, "DeathKnight", "defensive", false}, --Anti-Magic Shell
	[51052] = {120, nil, 120, 120, 120, 5, "DeathKnight", "defensive", false}, --Anti-Magic Zone
	[42650] = {360, nil, 600, 600, 360, 0, "DeathKnight", "nuke", false}, --Army of the Dead
	[49222] = {60, nil, 60, 60, 60, 5, "DeathKnight", "defensive", false}, --Bone Shield
	[49576] = {25, nil, 35, 35, 25, 0, "DeathKnight", "gapcloser", false}, --Death Grip
	[49206] = {180, nil, 180, 180, 180, 5, "DeathKnight", "nuke", false}, --Summon Gargoyle
	--Detection
	[55090] = {0, nil, 0, 0, 0, 5, "DeathKnight", "", false}, --Scourge Strike r1
	[55265] = {0, nil, 0, 0, 0, 5, "DeathKnight", "", false}, --Scourge Strike r2
	[55270] = {0, nil, 0, 0, 0, 5, "DeathKnight", "", false}, --Scourge Strike r3
	[55271] = {0, nil, 0, 0, 0, 5, "DeathKnight", "", false}, --Scourge Strike r4
	[63560] = {0, nil, 0, 0, 0, 5, "DeathKnight", "", false}, --Ghoul Frenzy
	
	--Shaman
	--Total: 17
	--Elemental
	[2484] = {10.5, nil, 10.5, 10.5, 10.5, 0, "Shaman", "uncategorized", false}, --Earthbind Totem
	[16166] = {180, nil, 180, 180, 180, 3, "Shaman", "nuke", false}, --Elemental Mastery
	[2894] = {600, nil, 600, 600, 600, 0, "Shaman", "nuke", false}, --Fire Elemental Totem
	[51514] = {45, nil, 45, 45, 45, 0, "Shaman", "cc", false}, --Hex
	[5730] = {21, nil, 21, 21, 21, 0, "Shaman", "shield", false}, --Stoneclaw Totem r1
	[6390] = {21, nil, 21, 21, 21, 0, "Shaman", "shield", false}, --Stoneclaw Totem r2
	[6391] = {21, nil, 21, 21, 21, 0, "Shaman", "shield", false}, --Stoneclaw Totem r3
	[6392] = {21, nil, 21, 21, 21, 0, "Shaman", "shield", false}, --Stoneclaw Totem r4
	[10427] = {21, nil, 21, 21, 21, 0, "Shaman", "shield", false}, --Stoneclaw Totem r5
	[10428] = {21, nil, 21, 21, 21, 0, "Shaman", "shield", false}, --Stoneclaw Totem r6
	[25525] = {21, nil, 21, 21, 21, 0, "Shaman", "shield", false}, --Stoneclaw Totem r7
	[58580] = {21, nil, 21, 21, 21, 0, "Shaman", "shield", false}, --Stoneclaw Totem r8
	[58581] = {21, nil, 21, 21, 21, 0, "Shaman", "shield", false}, --Stoneclaw Totem r9
	[58582] = {21, nil, 21, 21, 21, 0, "Shaman", "shield", false}, --Stoneclaw Totem r10
	[51490] = {45, nil, 45, 45, 45, 3, "Shaman", "gapcloser", false}, --Thunderstorm r1
	[59156] = {45, nil, 45, 45, 45, 3, "Shaman", "gapcloser", false}, --Thunderstorm r1
	[59158] = {45, nil, 45, 45, 45, 3, "Shaman", "gapcloser", false}, --Thunderstorm r1
	[59159] = {45, nil, 45, 45, 45, 3, "Shaman", "gapcloser", false}, --Thunderstorm r1
	[57994] = {5, nil, 5, 5, 6, 0, "Shaman", "silence", false}, --Wind Shear
	--Detection:
	[30706] = {0, nil, 0, 0, 0, 3, "Shaman", "", false}, --Totem of Wrath r1
	[57720] = {0, nil, 0, 0, 0, 3, "Shaman", "", false}, --Totem of Wrath r2
	[57721] = {0, nil, 0, 0, 0, 3, "Shaman", "", false}, --Totem of Wrath r3
	[57722] = {0, nil, 0, 0, 0, 3, "Shaman", "", false}, --Totem of Wrath r4
	--Enhancement
	[2825] = {300, nil, 300, 300, 300, 0, "Shaman", "nuke", false}, --Bloodlust
	[32182] = {300, nil, 300, 300, 300, 0, "Shaman", "nuke", false}, --Heroism
	[2062] = {600, nil, 600, 600, 600, 0, "Shaman", "nuke", false}, --Earth Elemental Totem
	[51533] = {180, nil, 180, 180, 180, 4, "Shaman", "nuke", false}, --Feral Spirit
	[58875] = {32, nil, 180, 180, 180, 4, "Shaman", "gapcloser", true}, --Spirit Walk
	[8177] = {13, nil, 15, 15, 15, 0, "Shaman", "silence", false}, --Grounding Totem
	[30823] = {60, nil, 60, 60, 60, 4, "Shaman", "defensive", false}, --Shamanistic Rage
	--Detection
	[17364] = {0, nil, 0, 0, 0, 4, "Shaman", "", false}, --Stormstrike
	[60103] = {0, nil, 0, 0, 0, 4, "Shaman", "", false}, --Lava Lash
	--Restoration
	[16190] = {300, nil, 300, 300, 300, 0, "Shaman", "uncategorized", false}, --Mana Tide Totem
	[16188] = {120, nil, 300, 300, 300, 0, "Shaman", "defensive", false}, --Nature's Swiftness
	[55198] = {180, nil, 180, 180, 180, 0, "Shaman", "defensive", false}, --Tidal Force
	--Detection
	[974] = {0, nil, 0, 0, 0, 5, "Shaman", "", false}, --Earth Shield r1
	[32593] = {0, nil, 0, 0, 0, 5, "Shaman", "", false}, --Earth Shield r2
	[32594] = {0, nil, 0, 0, 0, 5, "Shaman", "", false}, --Earth Shield r3
	[49283] = {0, nil, 0, 0, 0, 5, "Shaman", "", false}, --Earth Shield r4
	[49284] = {0, nil, 0, 0, 0, 5, "Shaman", "", false}, --Earth Shield r5
	[61295] = {0, nil, 0, 0, 0, 5, "Shaman", "", false}, --Riptide r1
	[61299] = {0, nil, 0, 0, 0, 5, "Shaman", "", false}, --Riptide r2
	[61300] = {0, nil, 0, 0, 0, 5, "Shaman", "", false}, --Riptide r3
	[61301] = {0, nil, 0, 0, 0, 5, "Shaman", "", false}, --Riptide r4
	[51886] = {0, nil, 0, 0, 0, 5, "Shaman", "", false}, --Cleanse Spirit
	--cleanse spirit
	
	---Mage
	--Total: 18
	--Freeze triggers no combatlog event
	--Arcane
	[12042] = {85, nil, 85, 85, 85, 3, "Mage", "nuke", false}, --Arcane Power
	[1953] = {15, nil, 15, 15, 15, 0, "Mage", "gapcloser", false}, --Blink
	[2139] = {24, nil, 24, 24, 24, 0, "Mage", "silence", false}, --Counterspell
	[12051] = {120, nil, 120, 240, 240, 0, "Mage", "defensive", false}, --Evocation
	[66] = {126, nil, 126, 180, 180, 0, "Mage", "defensive", false}, --Invisibility
	[55342] = {180, nil, 180, 180, 180, 0, "Mage", "nuke", false}, --Mirror Image
	[12043] = {85, nil, 85, 120, 120, 3, "Mage", "nuke", false}, --Presence of Mind
	[5405] = {120, nil, 120, 120, 120, 0, "Mage", "uncategorized", false}, --Mana Gem r1
	[10052] = {120, nil, 120, 120, 120, 0, "Mage", "uncategorized", false}, --Mana Gem r2
	[10057] = {120, nil, 120, 120, 120, 0, "Mage", "uncategorized", false}, --Mana Gem r3
	[10058] = {120, nil, 120, 120, 120, 0, "Mage", "uncategorized", false}, --Mana Gem r4
	[27103] = {120, nil, 120, 120, 120, 0, "Mage", "uncategorized", false}, --Mana Gem r5
	[42987] = {120, nil, 120, 120, 120, 0, "Mage", "uncategorized", false}, --Mana Gem r6
	--for detection:
	[44425] = {0, nil, 0, 0, 0, 3, "Mage", "", false}, --Arcane Barrage r1
	[44780] = {0, nil, 0, 0, 0, 3, "Mage", "", false}, --Arcane Barrage r2
	[44781] = {0, nil, 0, 0, 0, 3, "Mage", "", false}, --Arcane Barrage r3
	[31589] = {0, nil, 0, 0, 0, 3, "Mage", "", false}, --Slow
	--Fire
	[11113] = {30, nil, 30, 30, 30, 4, "Mage", "uncategorized", false}, --Blast Wave r1
	[13018] = {30, nil, 30, 30, 30, 4, "Mage", "uncategorized", false}, --Blast Wave r2
	[13019] = {30, nil, 30, 30, 30, 4, "Mage", "uncategorized", false}, --Blast Wave r3
	[13020] = {30, nil, 30, 30, 30, 4, "Mage", "uncategorized", false}, --Blast Wave r4
	[13021] = {30, nil, 30, 30, 30, 4, "Mage", "uncategorized", false}, --Blast Wave r5
	[27133] = {30, nil, 30, 30, 30, 4, "Mage", "uncategorized", false}, --Blast Wave r6
	[33933] = {30, nil, 30, 30, 30, 4, "Mage", "uncategorized", false}, --Blast Wave r7
	[42944] = {30, nil, 30, 30, 30, 4, "Mage", "uncategorized", false}, --Blast Wave r8
	[42945] = {30, nil, 30, 30, 30, 4, "Mage", "uncategorized", false}, --Blast Wave r9
	[28682] = {120, nil, 120, 120, 120, 4, "Mage", "nuke", false}, --Combustion
	[31661] = {20, nil, 30, 30, 30, 4, "Mage", "cc", false}, --Dragon's Breath r1
	[33041] = {20, nil, 30, 30, 30, 4, "Mage", "cc", false}, --Dragon's Breath r2
	[33042] = {20, nil, 30, 30, 30, 4, "Mage", "cc", false}, --Dragon's Breath r3
	[33043] = {20, nil, 30, 30, 30, 4, "Mage", "cc", false}, --Dragon's Breath r4
	[42949] = {20, nil, 30, 30, 30, 4, "Mage", "cc", false}, --Dragon's Breath r5
	[42950] = {20, nil, 30, 30, 30, 4, "Mage", "cc", false}, --Dragon's Breath r6
	[543] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Fire Ward r1
	[8457] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Fire Ward r2
	[8458] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Fire Ward r3
	[10223] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Fire Ward r4
	[10225] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Fire Ward r5
	[27128] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Fire Ward r6
	[43010] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Fire Ward r7
	--Frost
	[11958] = {384, 
		{44572, 122, 865, 6131, 10230, 27088, 42917, 6143, 8461, 8462,
		10177, 28609, 32796, 43012, 11426, 13031, 13032, 13033,
		27134, 33405, 43038, 43039, 45438, 12472, 31687}, 480, 480, 384, 5, "Mage", "cdreset", false}, --Cold Snap
	[44572] = {30, nil, 30, 30, 30, 5, "Mage", "stun", false}, --Deep Freeze
	[122] = {20, nil, 20, 20, 20, 0, "Mage", "cc", false}, --Frost Nova r1
	[865] = {20, nil, 20, 20, 20, 0, "Mage", "cc", false}, --Frost Nova r2
	[6131] = {20, nil, 20, 20, 20, 0, "Mage", "cc", false}, --Frost Nova r3
	[10230] = {20, nil, 20, 20, 20, 0, "Mage", "cc", false}, --Frost Nova r4
	[27088] = {20, nil, 20, 20, 20, 0, "Mage", "cc", false}, --Frost Nova r5
	[42917] = {20, nil, 20, 20, 20, 0, "Mage", "cc", false}, --Frost Nova r6
	[6143] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Frost Ward r1
	[8461] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Frost Ward r2
	[8462] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Frost Ward r3
	[10177] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Frost Ward r4
	[28609] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Frost Ward r5
	[32796] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Frost Ward r6
	[43012] = {30, nil, 30, 30, 30, 0, "Mage", "shield", false}, --Frost Ward r7
	[11426] = {24, nil, 24, 24, 24, 5, "Mage", "shield", false}, --Ice Barrier r1
	[13031] = {24, nil, 24, 24, 24, 5, "Mage", "shield", false}, --Ice Barrier r2
	[13032] = {24, nil, 24, 24, 24, 5, "Mage", "shield", false}, --Ice Barrier r3
	[13033] = {24, nil, 24, 24, 24, 5, "Mage", "shield", false}, --Ice Barrier r4
	[27134] = {24, nil, 24, 24, 24, 5, "Mage", "shield", false}, --Ice Barrier r5
	[33405] = {24, nil, 24, 24, 24, 5, "Mage", "shield", false}, --Ice Barrier r6
	[43038] = {24, nil, 24, 24, 24, 5, "Mage", "shield", false}, --Ice Barrier r7
	[43039] = {24, nil, 24, 24, 24, 5, "Mage", "shield", false}, --Ice Barrier r8
	[45438] = {240, nil, 240, 240, 240, 0, "Mage", "anticc", false}, --Ice Block
	[12472] = {144, nil, 144, 144, 144, 0, "Mage", "nuke", false}, --Icy Veins
	[31687] = {144, nil, 144, 144, 144, 5, "Mage", "nuke", false}, --Summon Water Elemental
	
	--Warlock
	--Total 10 (12 with pets)
	--Affliction
	[6789] = {120, nil, 120, 120, 120, 0, "Warlock", "cc", false}, --Death Coil r1
	[17925] = {120, nil, 120, 120, 120, 0, "Warlock", "cc", false}, --Death Coil r2
	[17962] = {120, nil, 120, 120, 120, 0, "Warlock", "cc", false}, --Death Coil r3
	[27223] = {120, nil, 120, 120, 120, 0, "Warlock", "cc", false}, --Death Coil r4
	[47859] = {120, nil, 120, 120, 120, 0, "Warlock", "cc", false}, --Death Coil r5
	[47860] = {120, nil, 120, 120, 120, 0, "Warlock", "cc", false}, --Death Coil r6
	[5484] = {40, nil, 40, 40, 40, 0, "Warlock", "cc", false}, --Howl of Terror r1
	[17928] = {40, nil, 40, 40, 40, 0, "Warlock", "cc", false}, --Howl of Terror r2
	--Detection
	[30108] = {0, nil, 0, 0, 0, 3, "Warlock", "", false}, --Unstable Affliction r1
	[30404] = {0, nil, 0, 0, 0, 3, "Warlock", "", false}, --Unstable Affliction r2
	[30405] = {0, nil, 0, 0, 0, 3, "Warlock", "", false}, --Unstable Affliction r3
	[47841] = {0, nil, 0, 0, 0, 3, "Warlock", "", false}, --Unstable Affliction r4
	[47843] = {0, nil, 0, 0, 0, 3, "Warlock", "", false}, --Unstable Affliction r5
	[48181] = {0, nil, 0, 0, 0, 3, "Warlock", "", false}, --Haunt r1
	[59161] = {0, nil, 0, 0, 0, 3, "Warlock", "", false}, --Haunt r2
	[59163] = {0, nil, 0, 0, 0, 3, "Warlock", "", false}, --Haunt r3
	[59164] = {0, nil, 0, 0, 0, 3, "Warlock", "", false}, --Haunt r4
	[18223] = {0, nil, 0, 0, 0, 3, "Warlock", "", false}, --Curse of Exhaustion
	--Demonology
	[23469] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Healthstone r1
	[23471] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Healthstone r2
	[23473] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Healthstone r3
	[23475] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Healthstone r4
	[23477] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Healthstone r5
	[27237] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Healthstone r6
	[47872] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Healthstone r7
	[47877] = {120, nil, 120, 120, 120, 0, "", "defensive", false}, --Healthstone r8
	[54785] = {45, nil, 45, 45, 45, 4, "Warlock", "stun", false}, --Demon Charge
	[48020] = {30, nil, 30, 30, 30, 0, "Warlock", "gapcloser", false}, --Demonic Circle: Teleport
	[47193] = {42, nil, 42, 42, 42, 4, "Warlock", "nuke", false}, --Demonic Empowerment
	[18708] = {126, nil, 180, 126, 180, 0, "Warlock", "nuke", false}, --Fel Domination
	[50589] = {30, nil, 30, 30, 30, 4, "Warlock", "nuke", false}, --Immolation Aura
	[47241] = {130, nil, 130, 130, 130, 4, "Warlock", "nuke", false}, --Metamorphosis
	[6229] = {30, nil, 30, 30, 30, 0, "Warlock", "shield", false}, --Shadow Ward r1
	[11739] = {30, nil, 30, 30, 30, 0, "Warlock", "shield", false}, --Shadow Ward r2
	[11740] = {30, nil, 30, 30, 30, 0, "Warlock", "shield", false}, --Shadow Ward r3
	[28610] = {30, nil, 30, 30, 30, 0, "Warlock", "shield", false}, --Shadow Ward r4
	[47890] = {30, nil, 30, 30, 30, 0, "Warlock", "shield", false}, --Shadow Ward r5
	[47891] = {30, nil, 30, 30, 30, 0, "Warlock", "shield", false}, --Shadow Ward r6
	--Detection
	[47193] = {0, nil, 0, 0, 0, 0, "Warlock", "uncategorized", false}, --Demonic Empowerment
	--Destruction
	[30283] = {20, nil, 20, 20, 20, 5, "Warlock", "stun", false}, --Shadowfury r1
	[30413] = {20, nil, 20, 20, 20, 5, "Warlock", "stun", false}, --Shadowfury r2
	[30414] = {20, nil, 20, 20, 20, 5, "Warlock", "stun", false}, --Shadowfury r3
	[47846] = {20, nil, 20, 20, 20, 5, "Warlock", "stun", false}, --Shadowfury r4
	[47847] = {20, nil, 20, 20, 20, 5, "Warlock", "stun", false}, --Shadowfury r5
	--Detection
	[17962] = {0, nil, 0, 0, 0, 5, "Warlock", "", false}, --Conflagrate
	--Pets
	[19647] = {24, nil, 0, 0, 0, 0, "Warlock", "silence", true}, --Spell Lock
	[47986] = {60, nil, 0, 0, 0, 0, "Warlock", "defensive", true}, --Sacrifice
	
	--Druid
	--Total: 18
	--Typhoon only triggers combat log event, when it hits something
	--Balance
	[22812] = {60, nil, 60, 60, 60, 0, "Druid", "defensive", false}, --Barkskin
	[33831] = {180, nil, 180, 180, 180, 3, "Druid", "nuke", false}, --Force of Nature
	[29166] = {180, nil, 180, 180, 180, 0, "Druid", "defensive", false}, --Innervate
	[16689] = {60, nil, 60, 60, 60, 0, "Druid", "cc", false}, --Nature's Grasp r1
	[16810] = {60, nil, 60, 60, 60, 0, "Druid", "cc", false}, --Nature's Grasp r2
	[16811] = {60, nil, 60, 60, 60, 0, "Druid", "cc", false}, --Nature's Grasp r3
	[16812] = {60, nil, 60, 60, 60, 0, "Druid", "cc", false}, --Nature's Grasp r4
	[16813] = {60, nil, 60, 60, 60, 0, "Druid", "cc", false}, --Nature's Grasp r5
	[17329] = {60, nil, 60, 60, 60, 0, "Druid", "cc", false}, --Nature's Grasp r6
	[27009] = {60, nil, 60, 60, 60, 0, "Druid", "cc", false}, --Nature's Grasp r7
	[53312] = {60, nil, 60, 60, 60, 0, "Druid", "cc", false}, --Nature's Grasp r8
	[48505] = {90, nil, 90, 90, 90, 3, "Druid", "nuke", false}, --Starfall r1
	[53199] = {90, nil, 90, 90, 90, 3, "Druid", "nuke", false}, --Starfall r2
	[53200] = {90, nil, 90, 90, 90, 3, "Druid", "nuke", false}, --Starfall r3
	[53201] = {90, nil, 90, 90, 90, 3, "Druid", "nuke", false}, --Starfall r4
	[61391] = {20, nil, 20, 20, 20, 3, "Druid", "gapcloser", false}, --Typhoon r1
	[61390] = {20, nil, 20, 20, 20, 3, "Druid", "gapcloser", false}, --Typhoon r2
	[61388] = {20, nil, 20, 20, 20, 3, "Druid", "gapcloser", false}, --Typhoon r3
	[61387] = {20, nil, 20, 20, 20, 3, "Druid", "gapcloser", false}, --Typhoon r4
	[53227] = {20, nil, 20, 20, 20, 3, "Druid", "gapcloser", false}, --Typhoon r5
	--Feral
	[5211] = {30, nil, 60, 30, 60, 0, "Druid", "stun", false}, --Bash r1
	[6798] = {30, nil, 60, 30, 60, 0, "Druid", "stun", false}, --Bash r2
	[8983] = {30, nil, 60, 30, 60, 0, "Druid", "stun", false}, --Bash r3
	[50334] = {180, nil, 180, 180, 180, 4, "Druid", "nuke", false}, --Berserk
	[1850] = {144, nil, 144, 144, 144, 0, "Druid", "defensive", false}, --Dash r1
	[9821] = {144, nil, 144, 144, 144, 0, "Druid", "defensive", false}, --Dash r2
	[33357] = {144, nil, 144, 144, 144, 0, "Druid", "defensive", false}, --Dash r3
	[5229] = {60, nil, 60, 60, 60, 0, "Druid", "uncategorized", false}, --Enrage
	[16979] = {15, nil, 15, 15, 15, 0, "Druid", "silence", false}, --Feral Charge - Bear
	[49376] = {30, nil, 30, 30, 30, 0, "Druid", "gapcloser", false}, --Feral Charge - Cat
	[22842] = {180, nil, 180, 180, 180, 0, "Druid", "defensive", false}, --Frenzied Regeneration
	[22570] = {10, nil, 10, 10, 10, 0, "Druid", "stun", false}, --Maim r1
	[49802] = {10, nil, 10, 10, 10, 0, "Druid", "stun", false}, --Maim r2
	[61336] = {180, nil, 180, 180, 180, 0, "Druid", "defensive", false}, --Survival Instinct
	[5217] = {30, nil, 30, 30, 30, 0, "Druid", "uncategorized", false}, --Tiger's Fury r1
	[6793] = {30, nil, 30, 30, 30, 0, "Druid", "uncategorized", false}, --Tiger's Fury r2
	[9845] = {30, nil, 30, 30, 30, 0, "Druid", "uncategorized", false}, --Tiger's Fury r3
	[9856] = {30, nil, 30, 30, 30, 0, "Druid", "uncategorized", false}, --Tiger's Fury r4
	[50212] = {30, nil, 30, 30, 30, 0, "Druid", "uncategorized", false}, --Tiger's Fury r5
	[50213] = {30, nil, 30, 30, 30, 0, "Druid", "uncategorized", false}, --Tiger's Fury r6
	--Detection
	[33876] = {0, nil, 0, 0, 0, 4, "Druid", "", false}, --Mangle (Cat) r1
	[33982] = {0, nil, 0, 0, 0, 4, "Druid", "", false}, --Mangle (Cat) r2
	[33983] = {0, nil, 0, 0, 0, 4, "Druid", "", false}, --Mangle (Cat) r3
	[48565] = {0, nil, 0, 0, 0, 4, "Druid", "", false}, --Mangle (Cat) r4
	[48566] = {0, nil, 0, 0, 0, 4, "Druid", "", false}, --Mangle (Cat) r5
	[33878] = {0, nil, 0, 0, 0, 4, "Druid", "", false}, --Mangle (Bear) r1
	[33986] = {0, nil, 0, 0, 0, 4, "Druid", "", false}, --Mangle (Bear) r2
	[33987] = {0, nil, 0, 0, 0, 4, "Druid", "", false}, --Mangle (Bear) r3
	[48563] = {0, nil, 0, 0, 0, 4, "Druid", "", false}, --Mangle (Bear) r4
	[48564] = {0, nil, 0, 0, 0, 4, "Druid", "", false}, --Mangle (Bear) r5
	--Restoration
	[17116] = {180, nil, 180, 180, 180, 5, "Druid", "defensive", false}, --Nature's Swiftness
	[18562] = {15, nil, 15, 15, 15, 5, "Druid", "defensive", false}, --Swiftmend
	[740] = {192, nil, 480, 480, 192, 0, "Druid", "defensive", false}, --Tranquility r1
	[8918] = {192, nil, 480, 480, 192, 0, "Druid", "defensive", false}, --Tranquility r2
	[9862] = {192, nil, 480, 480, 192, 0, "Druid", "defensive", false}, --Tranquility r3
	[9863] = {192, nil, 480, 480, 192, 0, "Druid", "defensive", false}, --Tranquility r4
	[26983] = {192, nil, 480, 480, 192, 0, "Druid", "defensive", false}, --Tranquility r5
	[48446] = {192, nil, 480, 480, 192, 0, "Druid", "defensive", false}, --Tranquility r6
	[48447] = {192, nil, 480, 480, 192, 0, "Druid", "defensive", false}, --Tranquility r7
	--Detection
	[48438] = {0, nil, 0, 0, 0, 5, "Druid", "", false}, --Wild Growth r1
	[53248] = {0, nil, 0, 0, 0, 5, "Druid", "", false}, --Wild Growth r2
	[53249] = {0, nil, 0, 0, 0, 5, "Druid", "", false}, --Wild Growth r3
	[53251] = {0, nil, 0, 0, 0, 5, "Druid", "", false}, --Wild Growth r4
	[33891] = {0, nil, 0, 0, 0, 5, "Druid", "", false}, --Tree of Life
}