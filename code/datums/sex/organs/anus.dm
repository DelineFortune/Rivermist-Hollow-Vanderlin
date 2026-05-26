/obj/item/organ/genitals/filling_organ/anus
	//absorbs faster than womb, less capacity.
	name = "anus"
	icon_state = "anus"
	dropshrink = 0.5
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_ANUS
	accessory_type = /datum/sprite_accessory/none
	max_reagents = 20 //less size than vagene in turn for more effective absorbtion
	absorbing = TRUE
	absorbmult = 1.5 //more effective absorb than others i guess.
	allows_oviposition_pregnancy = TRUE
	oviposition_storage_component_type = /datum/component/body_storage/anus
	oviposition_location_name = "anus"
	altnames = list("ass", "asshole", "butt", "butthole", "guts") //used in thought messages.
	spiller = TRUE
	blocker = ITEM_SLOT_PANTS
	bloatable = TRUE
	additional_blocker = "underwear"
	stretchable = TRUE

/obj/item/organ/genitals/filling_organ/anus/Insert(mob/living/M, special, drop_if_replaced, new_zone = null)
	. = ..()
	if(!.)
		return FALSE
	if(!refilling)
		reagents.clear_reagents()
	add_bodystorage(M, null, /datum/component/body_storage/anus)

/obj/item/organ/genitals/filling_organ/anus/Remove(mob/living/M, special, drop_if_replaced)
	. = ..()
	var/datum/component/body_storage/anus/comp = GetComponent(/datum/component/body_storage/anus)
	comp?.RemoveComponent()
