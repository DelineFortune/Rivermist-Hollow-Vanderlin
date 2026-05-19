/datum/attribute_holder/sheet/job/advclass/combat/adventurer_rogue/thief
	raw_attribute_list = list(
		STAT_STRENGTH = -2,
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/sneaking = 50,
		/datum/attribute/skill/misc/stealing = 50,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/job/advclass/combat/adventurer_rogue/thief
	title = "Thief"
	tutorial = "Your quick hands and mastery of the larcenous arts make stealing second nature - \
	be it from a third floor window or a forgotten ruin."

	outfit = /datum/outfit/adventurer_rogue/thief
	category_tags = list(CAT_ADVENTURER_ROGUE)
	give_bank_account = TRUE


	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_rogue/thief


	traits = list(
		TRAIT_THIEVESGUILD,
		TRAIT_DODGEEXPERT,
		TRAIT_LIGHT_STEP,
		TRAIT_BLINDFIGHTING,
	)

	languages = list(/datum/language/thievescant)

/datum/outfit/adventurer_rogue/thief
	name = "Thief"
	head = null
	mask = null
	neck = null
	cloak = null
	armor = null
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	wrists = null
	gloves = /obj/item/clothing/gloves/fingerless
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	backr = null
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/adventurers_subclasses
	beltr = /obj/item/weapon/mace/cudgel // TEMP until I make a blackjack- for now though this will do.
	beltl = /obj/item/storage/belt/pouch/coins/poor
	ring = null
	l_hand = null
	r_hand = null

	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/clothing/face/shepherd/rag = 1,
	)

/datum/outfit/adventurer_rogue/thief/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()

	if(visuals_only)
		return

	var/list/thiefcloak_colors = list(\
		// Red Colors
		"Fyritius Dye"	="#b47011",\
		"Winestain Red"	="#6b3737",\
		"Maroon"		="#672c0d",\
		"Blood Red"		="#770d0d",\
		// Green Colors
		"Forest Green"	="#3f8b24",\
		"Bog Green"		="#58793f",\
		"Spring Green"	="#435436",\
		// Blue Colors
		"Royal Teal"	="#249589",\
		"Mana Blue"		="#1b3c7a",\
		"Berry"			="#38455b",\
		"Lavender"		="#865c9c",\
		"Majenta"		="#822b52",\
		// Brown Colors
		"Bark Brown"	="#685542",\
		"Russet"		="#685542",\
		"Chestnut"		="#5f3d21",\
		"Old Leather"	="#473a30",\
		"Ashen Black"	="#2f352f",\
	)

	var/thiefcloak_color_selection = input(H, "What color was I again?", "The Cloak", "Ashen Black") in thiefcloak_colors
	var/obj/item/clothing/cloak/raincloak/thiefcloak = new()
	thiefcloak.color = thiefcloak_colors[thiefcloak_color_selection]
	H.equip_to_slot(thiefcloak, ITEM_SLOT_CLOAK, TRUE)
