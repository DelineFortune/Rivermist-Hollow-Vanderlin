/datum/attribute_holder/sheet/job/advclass/combat/adventurer_rogue/swashbuckler
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 3,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/labor/fishing = 30,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/stealing = 30,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/traps = 20
	)

/datum/job/advclass/combat/adventurer_rogue/swashbuckler
	title = "Swashbuckler"
	tutorial = "Woe the Bitch Queen! You awake, dazed from a true festivity of revelry and feasting. \
	The last thing you remember? Your mateys dumping you over the side of the boat as a joke. \
	Now on some Gods-forsaken rock, Umberlee will present you with booty and fun, no doubt."

	outfit = /datum/outfit/adventurer_rogue/swashbuckler
	category_tags = list(CAT_ADVENTURER_ROGUE)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_rogue/swashbuckler


	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_BLINDFIGHTING,
	)

/datum/outfit/adventurer_rogue/swashbuckler
	name = "Swashbuckler"
	head = /obj/item/clothing/head/helmet/leather/headscarf
	mask = null
	neck = null
	cloak = null
	armor = /obj/item/clothing/armor/leather/jacket/sea
	shirt = null
	wrists = null
	gloves = null
	pants = /obj/item/clothing/pants/tights/sailor
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/fishingrod/fisher
	belt = /obj/item/storage/belt/leather/adventurers_subclasses
	beltl = /obj/item/weapon/sword/sabre/cutlass
	beltr = /obj/item/weapon/knife/dagger
	ring = null
	l_hand = null
	r_hand = null

	backpack_contents = list(
		/obj/item/natural/worms/leech = 2,
		/obj/item/storage/belt/pouch/coins/mid = 1
	)

/datum/outfit/folkhero/swashbuckler/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	shirt = pick(/obj/item/clothing/shirt/undershirt/sailor, /obj/item/clothing/shirt/undershirt/sailor/red)
