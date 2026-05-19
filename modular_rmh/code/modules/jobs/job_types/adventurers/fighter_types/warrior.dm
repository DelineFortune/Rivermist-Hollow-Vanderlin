/datum/attribute_holder/sheet/job/advclass/combat/adventurer_fighter/warrior
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/crossbows = 10,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 20
	)

/datum/job/advclass/combat/adventurer_fighter/warrior
	title = "Warrior"
	tutorial = "On the Sword Coast, steel speaks louder than promises. \
	Warriors are mercenaries, caravan guards, militia veterans, \
	and hardened survivors of countless skirmishes."

	outfit = /datum/outfit/adventurer_fighter/warrior
	category_tags = list(CAT_ADVENTURER_FIGHTER)
	give_bank_account = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/combat/adventurer_fighter/warrior


	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_BLINDFIGHTING,
	)


// ------------------------------------------------------------

/datum/outfit/adventurer_fighter/warrior
	name = "Warrior"
	head = null
	mask = null
	neck = null
	cloak = null
	armor = null
	shirt = null
	wrists = null
	gloves = null
	pants = null
	shoes = null
	backr = null
	backl = null
	belt = /obj/item/storage/belt/leather/adventurers_subclasses
	beltl = null
	beltr = null
	ring = null
	l_hand = null
	r_hand = /obj/item/flashlight/flare/torch/prelit

	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
	)


// ------------------------------------------------------------

/datum/outfit/adventurer_fighter/warrior/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(visuals_only)
		return

	head = pick(/obj/item/clothing/head/helmet/skullcap, /obj/item/clothing/head/helmet/ironpot, /obj/item/clothing/head/helmet/sallet/iron, /obj/item/clothing/head/helmet/leather/headscarf)
	neck = pick(/obj/item/clothing/neck/chaincoif/iron, /obj/item/clothing/neck/gorget, /obj/item/clothing/neck/highcollier/iron, /obj/item/clothing/neck/coif/cloth, /obj/item/clothing/neck/coif)
	armor = pick(/obj/item/clothing/armor/chainmail/hauberk/iron, /obj/item/clothing/armor/leather/splint, /obj/item/clothing/armor/cuirass/iron)
	shirt = pick(/obj/item/clothing/armor/gambeson, /obj/item/clothing/armor/gambeson/light)
	wrists = pick(/obj/item/clothing/wrists/bracers/leather, /obj/item/clothing/wrists/bracers/ironjackchain)
	gloves = pick(/obj/item/clothing/gloves/leather, /obj/item/clothing/gloves/leather/advanced, /obj/item/clothing/gloves/fingerless, /obj/item/clothing/gloves/chain/iron)
	pants = pick(/obj/item/clothing/pants/tights/colored/black, /obj/item/clothing/pants/trou/leather/splint, /obj/item/clothing/pants/trou/leather)
	shoes = pick(/obj/item/clothing/shoes/boots, /obj/item/clothing/shoes/boots/furlinedboots)

// ------------------------------------------------------------

/datum/outfit/adventurer_fighter/warrior/post_equip(mob/living/carbon/human/H)
	. = ..()

	var/list/selectableweapon = list(
		"Sword" = pick(list(/obj/item/weapon/sword/iron, /obj/item/weapon/sword/scimitar/messer, /obj/item/weapon/sword/sabre/scythe)),
		"Axe" = /obj/item/weapon/axe/iron,
		"Mace" = pick(list(/obj/item/weapon/mace/bludgeon, /obj/item/weapon/mace/warhammer, /obj/item/weapon/mace/spiked, /obj/item/weapon/hammer/sledgehammer)),
		"Spear" = /obj/item/weapon/polearm/spear,
		"Flail" = pick(list(/obj/item/weapon/flail, /obj/item/weapon/flail/militia)),
		"Great flail" = /obj/item/weapon/flail/peasant,
		"Goedendag" = /obj/item/weapon/mace/goden,
		"Great axe" = /obj/item/weapon/polearm/halberd/bardiche/woodcutter,
	)

	var/weaponchoice = H.select_equippable(H, selectableweapon, message = "Choose Your Martial Training", title = "Warrior")

	if(!weaponchoice)
		return

	var/grant_shield = TRUE
	var/shield_path = null

	switch(weaponchoice)
		if("Sword")
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Axe", "Mace")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		if("Spear")
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			grant_shield = new /obj/item/weapon/shield/tower/buckleriron
		if("Flail", "Great flail")
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			if(weaponchoice == "Great flail")
				grant_shield = FALSE
		if("Goedendag", "Great axe")
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
			grant_shield = FALSE

	if(grant_shield == TRUE)
		shield_path = pick(list(/obj/item/weapon/shield/heater, /obj/item/weapon/shield/wood))
		var/obj/item/shield = new shield_path()
		if(!H.equip_to_appropriate_slot(shield))
			qdel(shield)
	else if(ispath(grant_shield))
		var/obj/item/shield = new grant_shield()
		if(!H.equip_to_appropriate_slot(shield))
			qdel(shield)
