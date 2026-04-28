/obj/item/clothing/neck/moonshackle_collar
	name = "moonshackle collar"
	desc = "A heavy silver collar set with costly gemstones. The inner band is engraved to keep the beast bound in mortal flesh."
	icon_state = "collar_of_servitude"
	item_state = "collar_of_servitude"
	blocksound = PLATEHIT
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	break_sound = 'sound/foley/breaksound.ogg'
	smeltresult = /obj/item/ingot/silver
	melting_material = /datum/material/silver
	melt_amount = 100
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	clothing_flags = CANT_SLEEP_IN
	armor = ARMOR_NECK_BAD
	max_integrity = INTEGRITY_STRONG
	prevent_crits = CUT_AND_MINOR_CRITS
	sellprice = 180

/obj/item/clothing/neck/moonshackle_collar/Initialize(mapload)
	. = ..()
	// A dedicated werewolf-only trait keeps the collar local to that mechanic.
	attach_clothing_traits(TRAIT_WEREWOLF_TRANSFORMATION_SUPPRESSED)

/obj/item/clothing/neck/moonshackle_collar/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_NECK)
		return
	if(!IS_WEREWOLF(user))
		return

	to_chat(user, span_warning("The silver collar tightens, forcing the beast back under my skin."))

/obj/item/clothing/neck/moonshackle_collar/dropped(mob/user)
	. = ..()
	if(!IS_WEREWOLF(user))
		return

	to_chat(user, span_notice("The moonshackle's grip slackens, and the beast stirs once more."))

/datum/anvil_recipe/valuables/silver/moonshackle_collar
	name = "Moonshackle collar"
	recipe_name = "a moonshackle collar"
	additional_items = list(
		/obj/item/ingot/silver,
		/obj/item/gem/diamond,
		/obj/item/gem/red,
		/obj/item/gem/blue,
	)
	created_item = /obj/item/clothing/neck/moonshackle_collar
	craftdiff = SKILL_LEVEL_LEGENDARY

/datum/anvil_recipe/valuables/silver/moonshackle_collar/advance(mob/user, breakthrough = FALSE, quality_score = 0)
	if(GET_MOB_SKILL_VALUE_OLD(user, appro_skill) < SKILL_LEVEL_LEGENDARY)
		to_chat(user, span_warning("This silverwork is beyond me. Only a legendary smith could finish it."))
		return FALSE

	return ..()
