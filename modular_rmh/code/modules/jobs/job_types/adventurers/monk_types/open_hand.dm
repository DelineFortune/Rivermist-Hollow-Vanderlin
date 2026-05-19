/datum/attribute_holder/sheet/job/advclass/combat/adventurer_monk/open_hand
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_CONSTITUTION = 3,
		STAT_ENDURANCE = 3,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 2,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/unarmed = 60,
		/datum/attribute/skill/combat/wrestling = 50,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 40
	)

/datum/job/advclass/combat/adventurer_monk/open_hand
	title = "Open Hand"
	tutorial = "You specialise in unarmed combat, \
	using your hands and your control of ki to heal or inflict grievous hurt."

	outfit = /datum/outfit/adventurer_monk/open_hand
	category_tags = list(CAT_ADVENTURER_MONK)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_monk/open_hand


	traits = list(
		TRAIT_BREADY,
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NUTCRACKER,
		TRAIT_BLINDFIGHTING,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/longstrider,
		/datum/action/cooldown/spell/undirected/feather_falling,
		/datum/action/cooldown/spell/healing
	)

/datum/outfit/adventurer_monk/open_hand
	name = "Open Hand"

	head = /obj/item/clothing/head/roguehood/colored/brown
	mask = null
	neck = /obj/item/clothing/cloak/templar/undivided
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	armor = /obj/item/clothing/shirt/robe/colored/plain
	shirt = null
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/bandages/pugilist
	pants = null
	shoes = /obj/item/clothing/shoes/shortboots
	backr = /obj/item/weapon/polearm/woodstaff
	backl = /obj/item/storage/backpack/backpack
	belt = /obj/item/storage/belt/leather/rope/adventurers_subclasses
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltr = null
	ring = null
	l_hand = /obj/item/weapon/knuckles
	r_hand = null

	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1
	)

/datum/outfit/adventurer_monk/open_hand/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	equipped_human.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
