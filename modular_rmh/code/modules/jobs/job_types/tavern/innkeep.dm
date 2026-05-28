/datum/attribute_holder/sheet/job/innkeep
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/cooking = 30,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/labor/mathematics = 20
	)

/datum/job/innkeep
	title = "Innkeep"
	tutorial = "You run the Drunken Dwarf — tavern, inn, and the public face of the Blue Sage Guild. \
	You serve drinks, rent rooms, keep guests comfortable, and act as the first point of contact \
	for adventurers, townsfolk, and travelers alike. A steady hand and a sharp ear keep both the ale and rumors flowing."
	department_flag = TAVERN
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_INNKEEP

	allowed_races = ALL_RACES_LIST
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)

	selection_color = JCOLOR_TAVERN

	outfit = /datum/outfit/innkeep

	give_bank_account = 100
	job_bitflag = BITFLAG_CONSTRUCTOR

	attribute_sheet = /datum/attribute_holder/sheet/job/innkeep


	traits = list(
		TRAIT_BOOZE_SLIDER,
		TRAIT_EXTEROCEPTION,
		TRAIT_RECOGNIZE_ADDICTS
	)

	exp_type = list(EXP_TYPE_LIVING)

	exp_requirements = list(
		EXP_TYPE_LIVING = 300
	)

/datum/outfit/innkeep
	name = "Innkeep"
	head = null
	mask = null
	neck = /obj/item/storage/belt/pouch/coins/mid
	cloak = /obj/item/clothing/cloak/apron/waist
	armor = null
	shirt = null
	wrists = null
	gloves = null
	pants = null
	shoes = /obj/item/clothing/shoes/shortboots
	backr = null
	backl = null
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/tavern_keeper
	beltr = /obj/item/reagent_containers/glass/bottle/beer/blackgoat
	ring = null
	l_hand = null
	r_hand = null

	backpack_contents = list(
		/obj/item/recipe_book/cooking,
		/obj/item/bottle_kit
	)

/datum/outfit/innkeep/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	..()
	if(equipped_human.gender == MALE)
		shirt = /obj/item/clothing/shirt/shortshirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
	else
		armor = /obj/item/clothing/shirt/dress
