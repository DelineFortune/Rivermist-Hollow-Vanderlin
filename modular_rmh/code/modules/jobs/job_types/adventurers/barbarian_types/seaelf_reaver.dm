/datum/attribute_holder/sheet/job/advclass/combat/adventurer_barbarian/seaelf_reaver
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/bows = 20
	)

/datum/job/advclass/combat/adventurer_barbarian/seaelf_reaver
	title = "Sea Elf Reaver"
	tutorial = "You were raised to fear the sea — and to make offerings so it fears you back. \
	A reaver of the Sea Elves, you raid spilling blood so the waves spare your ship."

	allowed_races = RACES_PLAYER_ELF
	outfit = /datum/outfit/adventurer_barbarian/seaelf_reaver
	category_tags = list(CAT_ADVENTURER_BARBARIAN)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_barbarian/seaelf_reaver


	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_BLINDFIGHTING,
	)

/datum/outfit/adventurer_barbarian/seaelf_reaver
	name = "Sea Elf Reaver"
	head = /obj/item/clothing/head/helmet/nasal
	mask = null
	neck = /obj/item/clothing/neck/highcollier/iron
	cloak = null
	armor = /obj/item/clothing/armor/chainmail/iron
	shirt = null
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	backr = null
	backl = /obj/item/weapon/shield/wood
	belt = /obj/item/storage/belt/leather/adventurers_subclasses
	beltl = null
	beltr = null
	ring = null
	l_hand = null
	r_hand = null

/datum/outfit/adventurer_barbarian/seaelf_reaver/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	var/weapontype = pickweight(list("Bow" = 2, "Axe" = 2, "Claymore" = 1))

	switch(weapontype)
		if("Bow")
			head = /obj/item/clothing/head/roguehood/colored/black
			beltl = /obj/item/ammo_holder/quiver/arrows // womp womp, guess bow users cant have coins
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long
			beltr = /obj/item/weapon/sword/iron
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Axe")
			head = /obj/item/clothing/head/helmet/nasal
			backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
			beltr = /obj/item/storage/belt/pouch/coins/poor
			beltl = /obj/item/weapon/sword/iron
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		if("Claymore")
			head = /obj/item/clothing/head/helmet/nasal
			backr = /obj/item/weapon/sword/long/greatsword/claymore/iron
			beltl = /obj/item/weapon/axe/iron
			beltr = /obj/item/storage/belt/pouch/coins/poor
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
