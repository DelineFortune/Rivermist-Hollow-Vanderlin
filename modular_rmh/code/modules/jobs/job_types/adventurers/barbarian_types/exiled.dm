/datum/attribute_holder/sheet/job/advclass/combat/adventurer_barbarian/exiled
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/traps = 30
	)

/datum/job/advclass/combat/adventurer_barbarian/exiled
	title = "Exiled Warrior"
	tutorial = "A barbarian - you're a brute, and you're a long way from home. \
	You took more of a liking to the blade than your elders wanted - in truth, they did not have to even deliberate to banish you. \
	You will drown in ale, and your enemies in blood."

	allowed_races = list(SPEC_ID_HALF_ORC)
	outfit = /datum/outfit/adventurer_barbarian/exiled
	category_tags = list(CAT_ADVENTURER_BARBARIAN)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_barbarian/exiled


	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
		TRAIT_BLINDFIGHTING,
		TRAIT_DUALWIELDER
	)

	voicepack_m = /datum/voicepack/male/warrior

/datum/job/advclass/combat/adventurer_barbarian/exiled/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.gender == MALE && spawned.dna?.species)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

/datum/outfit/adventurer_barbarian/exiled
	name = "Exiled Warrior"
	head = /obj/item/clothing/head/helmet/leather
	mask = null
	neck = /obj/item/clothing/neck/coif
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	armor = /obj/item/clothing/shirt/undershirt/easttats/exiled
	shirt = null
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather/advanced
	shoes = /obj/item/clothing/shoes/boots/leather
	backr = null
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/adventurers_subclasses
	beltl = /obj/item/weapon/axe/iron
	beltr = /obj/item/weapon/axe/iron
	ring = null
	l_hand = null
	r_hand = null

	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)
