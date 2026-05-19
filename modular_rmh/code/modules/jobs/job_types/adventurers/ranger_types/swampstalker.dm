/datum/attribute_holder/sheet/job/advclass/combat/adventurer_ranger/swampstalker
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 3,
		STAT_SPEED = 1,
		STAT_ENDURANCE = 2,
		STAT_INTELLIGENCE = -2,
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
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/labor/taming = 10,
		/datum/attribute/skill/labor/lumberjacking = 30
	)

/datum/job/advclass/combat/adventurer_ranger/swampstalker
	title = "Swampstalker"
	tutorial = "Hardened in the fetid marshes of the Mere of Dead Men and the shadowed bogs of the Moonshae Isles, \
	these half-orc hunters live off the land, stalking both beast and foe. \
	Skilled in axes, ambush, and survival, they serve as mercenaries, guides, or enforcers for those daring enough to tread the swamps of Faerûn."

	allowed_races = list(SPEC_ID_HALF_ORC)
	outfit = /datum/outfit/adventurer_ranger/swampstalker
	category_tags = list(CAT_ADVENTURER_RANGER)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_ranger/swampstalker


	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_DEADNOSE,
		TRAIT_NASTY_EATER,
		TRAIT_BLINDFIGHTING,
		TRAIT_STEELHEARTED
	)

/datum/outfit/adventurer_ranger/swampstalker
	name = "Swampstalker"
	head = /obj/item/clothing/head/helmet/kettle
	mask = null
	neck = null
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	armor = /obj/item/clothing/armor/leather/hide
	shirt = /obj/item/clothing/shirt/tunic/colored/green
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/adventurers_subclasses
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/weapon/knife/villager
	ring = null
	l_hand = null
	r_hand = null

	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)
