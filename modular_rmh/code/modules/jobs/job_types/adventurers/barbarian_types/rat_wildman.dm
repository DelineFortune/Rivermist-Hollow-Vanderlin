/datum/attribute_holder/sheet/job/advclass/combat/adventurer_barbarian/rat_wildman
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -3,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/combat/unarmed = 50,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/labor/farming = 20,
		/datum/attribute/skill/labor/fishing = 20,
		/datum/attribute/skill/labor/mathematics = 10,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/labor/taming = 40
	)

/datum/job/advclass/combat/adventurer_barbarian/rat_wildman
	title = "Rat Wildman"
	tutorial = "Abandoned at birth and raised in the sewers by rats, \
	you learned to fight, scavenge, and survive by any means necessary. \
	Your instincts are sharp, your body is tough, and your bite is deadly. The rats are you friends."

	outfit = /datum/outfit/adventurer_barbarian/rat_wildman
	category_tags = list(CAT_ADVENTURER_BARBARIAN)
	give_bank_account = TRUE
	total_positions = 2
	faction = FACTION_RATS

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_barbarian/rat_wildman


	traits = list(
		TRAIT_DARKVISION,
		TRAIT_DEADNOSE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
		TRAIT_STEELHEARTED,
		TRAIT_STRONGBITE,
		TRAIT_NASTY_EATER,
		TRAIT_BLINDFIGHTING,
	)

	spells = list(
		/datum/action/cooldown/spell/conjure/rous
	)

/datum/outfit/adventurer_barbarian/rat_wildman
	name = "Rat Wildman"
	head = null
	mask = /obj/item/clothing/face/shepherd
	neck = null
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	armor = /obj/item/clothing/armor/leather/advanced
	shirt = null
	wrists = /obj/item/rope/chain
	gloves = null
	pants = null
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	backr = null
	backl = null
	belt = /obj/item/storage/belt/leather/rope/adventurers_subclasses
	beltl = null
	beltr = /obj/item/weapon/knife/hunting
	ring = null
	l_hand = /obj/item/weapon/knuckles
	r_hand = null
