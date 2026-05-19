/datum/attribute_holder/sheet/job/advclass/combat/adventurer_paladin/immortal
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 40
	)

/datum/job/advclass/combat/adventurer_paladin/immortal
	title = "Immortal"
	tutorial = "You are a veteran of the celestial-legion campaigns, sworn to defend the realms of Amn and the Sword Coast. \
	Trained in the ancient art of the shield wall, you stand as an unyielding bulwark"

	allowed_races = list(SPEC_ID_AASIMAR)
	outfit = /datum/outfit/adventurer_paladin/immortal
	category_tags = list(CAT_ADVENTURER_PALADIN)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_paladin/immortal


	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_HOLY,
		TRAIT_BLINDFIGHTING,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/orison,
		/datum/action/cooldown/spell/status/guidance,
		/datum/action/cooldown/spell/essence/silence,
		/datum/action/cooldown/spell/healing,
		/datum/action/cooldown/spell/diagnose/holy,
		/datum/action/cooldown/spell/essence/neutralize,
		/datum/action/cooldown/spell/sacred_flame,
	)

/datum/job/advclass/combat/adventurer_paladin/immortal/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(istype(spawned.backr, /obj/item/weapon/polearm/spear))
		spawned.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	else
		spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)

/datum/outfit/adventurer_paladin/immortal
	name = "Immortal"
	// Despite extensive combat experience, this class is exceptionally destitute. The only luxury besides combat gear that it possesses is a lantern for a source of light
	// Beneath the arms and armor is a simple loincloth, and it doesn't start with any money. This should encourage them to find someone to serve or work alongside with very quickly
	head = /obj/item/clothing/head/rare/hoplite
	mask = null
	neck = /obj/item/clothing/neck/gorget/hoplite
	cloak = /obj/item/clothing/cloak/half/colored/red
	armor = /obj/item/clothing/armor/rare/hoplite
	shirt = null
	wrists = /obj/item/clothing/wrists/bracers/rare/hoplite
	gloves = null
	pants = /obj/item/clothing/pants/loincloth/colored/brown
	shoes = /obj/item/clothing/shoes/rare/hoplite
	backr = null
	backl = /obj/item/weapon/shield/tower/hoplite
	belt = /obj/item/storage/belt/leather/rope/adventurers_subclasses
	beltl = null
	beltr = /obj/item/flashlight/flare/torch/lantern
	ring = null
	l_hand = null
	r_hand = null

	// Weapon will be set in pre_equip() based on random selection
/datum/outfit/adventurer_paladin/immortal/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	H.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)

	var/weapontype = pickweight(list("Khopesh" = 5, "Spear" = 3, "WingedSpear" = 2))

	switch(weapontype)
		if("Khopesh")
			beltl = /obj/item/weapon/sword/khopesh
		if("Spear")
			backr = /obj/item/weapon/polearm/spear/hoplite
		if("WingedSpear")
			backr = /obj/item/weapon/polearm/spear/hoplite/winged
