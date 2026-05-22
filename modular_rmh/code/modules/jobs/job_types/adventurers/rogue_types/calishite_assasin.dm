/datum/attribute_holder/sheet/job/advclass/combat/adventurer_rogue/calishite_assasin
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_SPEED = 2,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/stealing = 20,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/craft/traps = 10
	)

/datum/job/advclass/combat/adventurer_rogue/calishite_assasin
	title = "Calishite"
	tutorial = "A Calishite assassin trained in stealth and close-quarters murder, you sell death with a steady hand and no questions asked."

	outfit = /datum/outfit/adventurer_rogue/calishite_assasin
	category_tags = list(CAT_ADVENTURER_ROGUE)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_rogue/calishite_assasin


	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_BLINDFIGHTING,
		TRAIT_LIGHT_STEP,
	)

	languages = list(/datum/language/zalad)

	spells = list(
		/datum/action/cooldown/spell/undirected/rogue_vanish
	)

/datum/outfit/adventurer_rogue/calishite_assasin
	name = "Calishite Assasin"
	head = /obj/item/clothing/neck/keffiyeh/colored/red
	mask = null
	neck = null
	cloak = null
	armor = /obj/item/clothing/armor/leather/splint
	shirt = /obj/item/clothing/shirt/undershirt/colored/red
	wrists = null
	gloves = /obj/item/clothing/gloves/angle
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/shalal
	backr = null
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/shalal/adventurers_subclasses
	beltl = null
	beltr = /obj/item/weapon/knife/dagger/steel/special
	ring = null
	l_hand = null
	r_hand = null

	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/lockpick = 1
	)
