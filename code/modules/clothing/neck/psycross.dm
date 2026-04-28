
/obj/item/clothing/neck/psycross
	name = "cross"
	desc = "A religious amulet of some sorts."
	icon_state = "psycross_wood"
	//dropshrink = 0.75
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	sellprice = 10
	experimental_onhip = TRUE

// INHUMEN PSYCROSSES

/obj/item/clothing/neck/psycross/zizo
	name = "Profane Amulet"
	desc = "A cross of some ancient, dead religion."
	icon_state = "zcross"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	sellprice = 0
	experimental_onhip = TRUE

// SILVER PSYCROSS START

/obj/item/clothing/neck/psycross/silver
	name = "silver cross"
	desc = "A religious amulet of some sorts."
	icon_state = "psycross_silver"
	resistance_flags = FIRE_PROOF
	sellprice = 50
	smeltresult = /obj/item/ingot/silver
	melting_material = /datum/material/silver
	melt_amount = 100

/obj/item/clothing/neck/psycross/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/clothing/neck/psycross/silver/divine
	parent_type = /obj/item/clothing/neck/psycross/silver

/obj/item/clothing/neck/psycross/silver/divine/astrata
	parent_type = /obj/item/clothing/neck/psycross/silver/astrata

/obj/item/clothing/neck/psycross/silver/divine/noc
	parent_type = /obj/item/clothing/neck/psycross/silver/noc

/obj/item/clothing/neck/psycross/silver/divine/dendor
	parent_type = /obj/item/clothing/neck/psycross/silver/dendor

/obj/item/clothing/neck/psycross/silver/divine/abyssor
	parent_type = /obj/item/clothing/neck/psycross/silver/abyssor

/obj/item/clothing/neck/psycross/silver/divine/necra
	parent_type = /obj/item/clothing/neck/psycross/silver/necra

/obj/item/clothing/neck/psycross/silver/divine/ravox
	parent_type = /obj/item/clothing/neck/psycross/silver/ravox

/obj/item/clothing/neck/psycross/silver/divine/xylix
	parent_type = /obj/item/clothing/neck/psycross/silver/xylix

/obj/item/clothing/neck/psycross/silver/divine/eora
	parent_type = /obj/item/clothing/neck/psycross/silver/eora

/obj/item/clothing/neck/psycross/silver/divine/pestra
	parent_type = /obj/item/clothing/neck/psycross/silver/pestra

/obj/item/clothing/neck/psycross/silver/divine/malum
	parent_type = /obj/item/clothing/neck/psycross/silver/malum

// PANTHEON SILVER PSYCROSSES START

/obj/item/clothing/neck/psycross/silver/astrata
	name = "solar amulet"
	desc = "Blessed be everything the light of the sun touches."
	icon_state = "astrata"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/noc
	name = "amulet of wizdom"
	desc = "Diligence, study, pursuit of truth and wisdom. Let nothing deter you from it."
	icon_state = "noc"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/dendor
	name = "amulet of nature"
	desc = "Nature is a body of which we are but its entrails."
	icon_state = "dendor"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/abyssor
	name = "amulet of the seas"
	desc = "May the seas protect."
	icon_state = "abyssor"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/necra
	name = "death ward"
	desc = "May Death pass by us all."
	icon_state = "necra"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/ravox
	name = "amulet of battle"
	desc = "Struggle. Challenge. And rise to struggle again."
	icon_state = "ravox"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/xylix
	name = "amulet of trickery"
	desc = "Be not fooled, and be not afraid to."
	icon_state = "xylix"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/eora
	name = "amulet of love"
	desc = "And I love thee because thou art love."
	icon_state = "eora"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/holy/eora
	name = "amulet of love"
	desc = "Use me on someone else and you shall be soulbond."
	icon_state = "eora"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/holy/eora/attack(mob/living/love_target, mob/user, list/modifiers)
	if(!isliving(love_target) || love_target.stat == DEAD)
		to_chat(user, span_warning("The love potion only works on living things, sicko!"))
		return ..()
	if(user == love_target)
		to_chat(user, span_warning("You can't drink the love potion. What are you, a narcissist?"))
		return ..()
	if(love_target.has_status_effect(/datum/status_effect/in_love))
		to_chat(user, span_warning("[love_target] is already lovestruck!"))
		return ..()

	love_target.visible_message(span_danger("[user] starts to feed [love_target] a love potion!"),
		span_userdanger("[user] starts to feed you a love potion!"))

	if(!do_after(user, 5 SECONDS, love_target))
		return
	to_chat(user, span_notice("You feed [love_target] the love potion!"))
	to_chat(love_target, span_notice("You develop feelings for [user], and anyone [user.p_they()] like[user.p_s()]."))
	love_target.faction |= "[REF(user)]"
	love_target.apply_status_effect(/datum/status_effect/in_love, user)
	qdel(src)

/obj/item/clothing/neck/psycross/silver/pestra
	name = "ward of pestilence"
	desc = "When pure, alcohol is best used as a cleanser of wounds and a cleanser of the palate."
	icon_state = "pestra"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/malum
	name = "amulet of diligence"
	desc = "Blessed be our works, made in toil and hardship."
	icon_state = "malum"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/malum/steel
	name = "amulet of diligence"
	desc = "Let the tools strike true."
	icon_state = "malum_alt"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/g
	name = "golden cross"
	desc = "A religious amulet of some sorts."
	icon_state = "psycross_gold"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 100
	smeltresult = /obj/item/ingot/gold
	melting_material = /datum/material/gold
	melt_amount = 100

