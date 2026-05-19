/datum/attribute_holder/sheet/job/advclass/combat/adventurer_barbarian/spearmaiden
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = -1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/craft/tanning = 10
	)

/datum/job/advclass/combat/adventurer_barbarian/spearmaiden
	title = "Spearmaiden"
	tutorial = "A proud and formidable Spearmaiden from the remote isles, \
	you were raised among fierce women who hunted, trained, and fought in the wilds."

	allowed_sexes = list(FEMALE)
	outfit = /datum/outfit/adventurer_barbarian/spearmaiden
	category_tags = list(CAT_ADVENTURER_BARBARIAN)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_barbarian/spearmaiden


	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_BLINDFIGHTING,
		TRAIT_NOPAINSTUN
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/battle_song
	)

/datum/outfit/adventurer_barbarian/spearmaiden
	name = "Spearmaiden"
	head = null
	mask = null
	neck = /obj/item/ammo_holder/dartpouch/poisondarts
	cloak = null
	armor = /obj/item/clothing/armor/amazon_chainkini
	shirt = null
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = null
	pants = null
	shoes = /obj/item/clothing/shoes/gladiator
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
	backl = /obj/item/weapon/polearm/spear
	belt = /obj/item/storage/belt/leather/rope/adventurers_subclasses
	beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/blowgun
	beltr = /obj/item/ammo_holder/quiver/arrows
	beltr = null
	ring = null
	l_hand = /obj/item/weapon/shield/wood
	r_hand = null
