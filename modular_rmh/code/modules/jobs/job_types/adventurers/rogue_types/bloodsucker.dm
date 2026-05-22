/datum/attribute_holder/sheet/job/advclass/combat/adventurer_rogue/bloodsucker
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_SPEED = 3,
		STAT_ENDURANCE = 3,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = 2,
		STAT_PERCEPTION = 2,
		/datum/attribute/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY * 10,
		/datum/attribute/skill/misc/stealing = SKILL_LEVEL_LEGENDARY * 10,
		/datum/attribute/skill/misc/lockpicking = SKILL_LEVEL_MASTER * 10,
		/datum/attribute/skill/misc/athletics = SKILL_LEVEL_EXPERT * 10,
		/datum/attribute/skill/misc/climbing = SKILL_LEVEL_MASTER * 10,
		/datum/attribute/skill/combat/unarmed = SKILL_LEVEL_EXPERT * 10,
		/datum/attribute/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN * 10,
		/datum/attribute/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN * 10,
		/datum/attribute/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN * 10,
		/datum/attribute/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN * 10,
		/datum/attribute/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN * 10
	)

/datum/job/advclass/combat/adventurer_rogue/bloodsucker
	title = "Bloodsucker"
	tutorial = "You have recently been embraced as a vampire. Strange urges, unnatural strength, and a thirst for blood drive your every action. \
	Now you must survive among mortals while hiding your true nature."
	outfit = /datum/outfit/adventurer_rogue/bloodsucker
	category_tags = list(CAT_ADVENTURER_ROGUE)
	give_bank_account = TRUE
	total_positions = 2
	antag_job = TRUE
	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_MEDIUMARMOR,
		TRAIT_BLINDFIGHTING,
		TRAIT_LIGHT_STEP
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_rogue/bloodsucker


	spells = list(
		/datum/action/cooldown/spell/undirected/shapeshift/rat_vampire,
		/datum/action/cooldown/spell/undirected/rogue_vanish,
	)

/datum/outfit/adventurer_rogue/bloodsucker
	name = "Bloodsucker"
	head = null
	mask = null
	neck = null
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/black
	armor = null
	shirt = null
	gloves = /obj/item/clothing/gloves/angle/grenzel
	wrists = null
	pants = null
	shoes = /obj/item/clothing/shoes/rare/grenzelhoft
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/plaquegold/adventurers_subclasses
	beltl = /obj/item/ammo_holder/quiver/arrows
	beltr = /obj/item/weapon/sword/rapier/dec
	ring = /obj/item/clothing/ring/gold
	l_hand = null
	r_hand = null

	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/clothing/face/shepherd/rag = 1
	)

/datum/outfit/adventurer_rogue/bloodsucker/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	equipped_human.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
	if(equipped_human.gender == MALE)
		head = /obj/item/clothing/head/fancyhat
		shirt = /obj/item/clothing/shirt/tunic/colored/random
		pants = /obj/item/clothing/pants/tights/colored/black
	else
		head = /obj/item/clothing/head/hatfur
		shirt = /obj/item/clothing/shirt/dress/silkdress/colored/random

/datum/job/advclass/combat/adventurer_rogue/bloodsucker/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.mind)
		var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(/datum/clan/caitiff, TRUE)
		spawned.mind.add_antag_datum(new_antag)

	spawned.grant_undead_eyes()

	if(alert("Do you wish for a random title? You will not receive one if you click No.", "", "Yes", "No") == "Yes")
		var/title
		var/list/titles = list(
			"The Nitebeest", "The Ravenous", "The Reborn", "The Immortal", "The Revenant",
			"The Kindred", "The Coffindweller", "The Hanged Man", "The Second Death",
			"The Bloodsucker", "Of The Blood", "The Childe", "The Dhampiraj", "The Nitewalker",
			"The Blade", "The Strangler", "The Shadowed", "The Lurker", "The Collector"
		)
		title = pick(titles)
		spawned.honorary_suffix = title
