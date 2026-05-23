/datum/attribute_holder/sheet/job/advclass/combat/adventurer_fighter/elven_blademaster
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 20
	)

/datum/job/advclass/combat/adventurer_fighter/elven_blademaster
	title = "Elven Blademaster"
	tutorial = "Honed in the courts of Evereska, you are a master of blade and agility. \
	With your people scattered or gone, you now roam the wider realms, \
	lending your skill to those in need—or seeking new challenges worthy of your craft."
	allowed_races = RACES_PLAYER_ELF_ALL

	outfit = /datum/outfit/adventurer_fighter/elven_blademaster
	category_tags = list(CAT_ADVENTURER_FIGHTER)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_fighter/elven_blademaster


	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_DUALWIELDER,
		TRAIT_STEELHEARTED,
	)

/datum/outfit/adventurer_fighter/elven_blademaster
	name = "Elven Blademaster"
	head = /obj/item/clothing/head/rare/elfplate/welfplate
	mask = null
	neck = /obj/item/clothing/neck/chaincoif
	cloak = null
	armor = /obj/item/clothing/armor/rare/elfplate/welfplate
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	wrists = null
	gloves = /obj/item/clothing/gloves/rare/elfplate/welfplate
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/boots/rare/elfplate/welfplate
	backr = /obj/item/weapon/sword/long/greatsword/elfgsword
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/adventurers_subclasses
	beltl = null
	beltl = /obj/item/storage/belt/pouch/coins/mid
	ring = null
	l_hand = null
	r_hand = null
