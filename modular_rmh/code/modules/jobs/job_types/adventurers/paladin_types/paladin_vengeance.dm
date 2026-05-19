/datum/attribute_holder/sheet/job/advclass/combat/adventurer_paladin/vengeance
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = -2,
		STAT_FORTUNE = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/magic/holy = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 30
	)

/datum/job/advclass/combat/adventurer_paladin/vengeance
	title = "Oath Of Vengeance "
	tutorial = "You have set aside even your own purity to right wrongs and deliver justice to those who have committed the most grievous sins."

	outfit = /datum/outfit/adventurer_paladin/vengeance
	category_tags = list(CAT_ADVENTURER_PALADIN)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_paladin/vengeance


	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_NOBLE,
		TRAIT_STEELHEARTED,
		TRAIT_HOLY,
		TRAIT_BLINDFIGHTING,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/orison,
		/datum/action/cooldown/spell/essence/silence,
		/datum/action/cooldown/spell/status/guidance,
		/datum/action/cooldown/spell/healing,
		/datum/action/cooldown/spell/sacred_flame,
		/datum/action/cooldown/spell/undirected/divine_strike,
	)

/datum/job/advclass/combat/adventurer_paladin/vengeance/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.grant_language(/datum/language/celestial)

	if(spawned.dna?.species.id == SPEC_ID_HUMEN)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(spawned)

/datum/outfit/adventurer_paladin/vengeance
	name = "Oath Of Vengeance"
	head = /obj/item/clothing/head/helmet/heavy/ordinatorhelm
	mask = null
	neck = /obj/item/clothing/neck/gorget
	cloak = /obj/item/clothing/cloak/ordinatorcape
	armor = /obj/item/clothing/armor/plate/fluted/ornate/ordinator
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	wrists = null
	gloves = /obj/item/clothing/gloves/leather/otavan
	pants = /obj/item/clothing/pants/platelegs
	shoes = /obj/item/clothing/shoes/otavan/inqboots
	backr = /obj/item/storage/backpack/satchel/otavan
	backl = /obj/item/weapon/sword/long/judgement
	belt = /obj/item/storage/belt/leather/steel/adventurers_subclasses
	beltl = /obj/item/storage/belt/pouch/coins/mid
	beltr = null
	ring = /obj/item/clothing/ring/signet/silver
	l_hand = null
	r_hand = null

/datum/outfit/adventurer_paladin/vengeance/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	equipped_human.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
