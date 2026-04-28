/datum/attribute_holder/sheet/job/advclass/combat/adventurer_fighter/black_swordsman
	raw_attribute_list = list(
		STAT_STRENGTH = 15,
		STAT_ENDURANCE = 3,
		STAT_CONSTITUTION = 3,
		STAT_INTELLIGENCE = -2,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/crossbows = 10,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/job/advclass/combat/adventurer_fighter/black_swordsman
	title = "Black Swordsman"
	tutorial = "A lone blade against the world, hardened by strife and blood. \
	You survive because you fight, because you endure, because giving up is never an option."

	allowed_sexes = list(MALE)
	outfit = /datum/outfit/adventurer_fighter/black_swordsman
	category_tags = list(CAT_ADVENTURER_FIGHTER)
	give_bank_account = TRUE
	total_positions = 0

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_fighter/black_swordsman


	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_STRONGBITE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
	)

/datum/outfit/adventurer_fighter/black_swordsman
	name = "Black Swordsman"
	head = null
	mask = null
	neck = null
	cloak = /obj/item/clothing/cloak/cape/colored/brown
	armor = /obj/item/clothing/armor/plate/iron
	shirt = /obj/item/clothing/armor/leather/vest/colored/black
	wrists = /obj/item/clothing/wrists/wrappings/common
	gloves = null
	pants = /obj/item/clothing/pants/trou/leather/advanced
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	backr = /obj/item/storage/backpack/satchel/black
	backl = null
	belt = /obj/item/storage/belt/leather/adventurers_subclasses
	beltl = null
	beltr = null
	ring = null
	l_hand = null
	r_hand = /obj/item/weapon/sword/long/greatsword/gutsclaymore

	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1
	)
