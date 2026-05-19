/datum/attribute_holder/sheet/job/advclass/combat/adventurer_barbarian/giant
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -2,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/butchering = 10,
		/datum/attribute/skill/misc/medicine = 10
	)

/datum/job/advclass/combat/adventurer_barbarian/giant
	title = "Giant"
	tutorial = "You walk the path of giants, \
	invoking their elemental might and size by drawing strength from the same primal forces as them.."

	outfit = /datum/outfit/adventurer_barbarian/giant
	category_tags = list(CAT_ADVENTURER_BARBARIAN)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_barbarian/giant


	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_STRONGBITE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
		TRAIT_DUALWIELDER,
		TRAIT_DEADNOSE,
		TRAIT_BLINDFIGHTING,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/giant_shape
	)

/datum/job/advclass/combat/adventurer_barbarian/giant/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/selectableweapon = list(
		"MY BARE HANDS!!!" = /obj/item/weapon/knuckles,
		"Great Axe" = /obj/item/weapon/greataxe/steel,
		"Mace" = /obj/item/weapon/mace/goden/steel,
		"Sword" = /obj/item/weapon/sword/arming
	)

	var/choice = spawned.select_equippable(player_client, selectableweapon, message = "Choose Your Specialisation", title = "BERSERKER")
	if(!choice)
		return

	switch(choice)
		if("MY BARE HANDS!!!")
			spawned.adjust_skillrank(/datum/skill/combat/unarmed, 5)
		if("Great Axe")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 5)
		if("Mace")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 5)
		if("Sword")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 5)

/datum/outfit/adventurer_barbarian/giant
	name = "Giant"
	head = /obj/item/clothing/head/helmet/horned
	mask = /obj/item/clothing/face/skullmask
	neck = /obj/item/clothing/neck/chaincoif/iron
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	armor = /obj/item/clothing/armor/leather/hide
	shirt = null
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/leather/advanced
	pants = /obj/item/clothing/pants/trou/leather/advanced
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/weapon/shield/wood
	belt = /obj/item/storage/belt/leather/adventurers_subclasses
	beltl = null
	beltr = null
	ring = null
	l_hand = null
	r_hand = null

	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/weapon/scabbard/knife = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1
	)
