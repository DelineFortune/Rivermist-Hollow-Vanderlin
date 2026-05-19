/datum/attribute_holder/sheet/job/advclass/combat/adventurer_monk/shadow
	raw_attribute_list = list(
		STAT_ENDURANCE = 1,
		STAT_SPEED = 2,
		//they're basically ninjas.
		STAT_STRENGTH = 1,
		//because they're mainly supposed to use blunt weapons.
		STATKET_INT = -1,
		STAT_PERCEPTION = -1,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/labor/mathematics = 10,
		/datum/attribute/skill/misc/lockpicking = 20,
		//these guys free slaves, they probably know how to disarm traps and unlock things
		/datum/attribute/skill/misc/stealing = 20,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/combat/adventurer_monk/shadow
	title = "Shadow"
	tutorial = "You value the arts of stealth and subterfuge, bending the shadows to your will to strike without warning."

	category_tags = list(CAT_ADVENTURER_MONK)
	give_bank_account = TRUE
	outfit = /datum/outfit/adventurer_monk/shadow

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_monk/shadow


	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_MEDIUMARMOR, // so they can dodge wearing their mask, these guys dont actually spawn with medium armor, they have to EARN it.
		TRAIT_BLINDFIGHTING,
	)

/datum/outfit/adventurer_monk/shadow
	name = "Shadow"
	head = /obj/item/clothing/head/helmet/leather/headscarf/colored/red
	mask = /obj/item/clothing/face/shellmask
	neck = /obj/item/clothing/neck/coif/cloth/colored/berryblue
	cloak = /obj/item/clothing/shirt/undershirt/sash/colored/white
	armor = /obj/item/clothing/shirt/clothvest/colored/red
	shirt = /obj/item/clothing/armor/gambeson/heavy/colored/dark
	wrists = /obj/item/clothing/wrists/gem/shellbracelet
	gloves = /obj/item/clothing/gloves/angle
	pants = /obj/item/clothing/pants/trou/shadowpants
	shoes = /obj/item/clothing/shoes/boots
	backr = null
	backl = null
	belt = /obj/item/storage/belt/leather/plaquesilver/adventurers_subclasses
	beltr = /obj/item/weapon/mace/rungu
	beltl = /obj/item/storage/belt/pouch //broke as hell!
	ring = null
	l_hand = /obj/item/weapon/knuckles
	r_hand = null
