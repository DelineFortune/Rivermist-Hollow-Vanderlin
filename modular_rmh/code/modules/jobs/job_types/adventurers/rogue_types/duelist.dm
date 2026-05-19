/datum/attribute_holder/sheet/job/advclass/combat/adventurer_rogue/duelist
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_SPEED = 2,
		STAT_PERCEPTION = 2,
		STAT_STRENGTH = -1,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/cooking = 30
	)

/datum/job/advclass/combat/adventurer_rogue/duelist
	title = "Duelist"
	tutorial = "A nimble duelist from Waterdeep, wielding rapier and wit with deadly grace."

	outfit = /datum/outfit/adventurer_rogue/duelist
	category_tags = list(CAT_ADVENTURER_ROGUE)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_rogue/duelist


	traits = list(
		TRAIT_BLINDFIGHTING,
		TRAIT_DODGEEXPERT
	)

/datum/outfit/adventurer_rogue/duelist
	name = "Duelist"
	head = /obj/item/clothing/head/leather/duelhat
	mask = null
	neck = null
	cloak = /obj/item/clothing/cloak/half/duelcape
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	shirt = /obj/item/clothing/shirt/undershirt
	wrists = null
	gloves = /obj/item/clothing/gloves/leather/duelgloves
	pants = /obj/item/clothing/pants/trou/leather/advanced/colored/duelpants
	shoes = /obj/item/clothing/shoes/nobleboot/duelboots
	backr = null
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/adventurers_subclasses
	beltl = null
	beltr = null
	ring = null
	l_hand = null
	r_hand = null

	backpack_contents = list(/obj/item/storage/belt/pouch/coins/mid = 1)
	scabbards = list(/obj/item/weapon/scabbard/sword)

/datum/outfit/adventurer_rogue/duelist/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	var/rando = rand(1,6)
	switch(rando)
		if(1 to 2)
			beltl = /obj/item/weapon/sword/rapier
		if(3 to 4)
			beltl = /obj/item/weapon/sword/rapier/silver //Correct, They have a chance to receive a silver rapier, due to them being from Silvermoon.
		if(5 to 6)
			beltl = /obj/item/weapon/sword/rapier/dec
