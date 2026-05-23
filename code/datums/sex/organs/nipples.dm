/obj/item/organ/genitals/nipple
	abstract_type = /obj/item/organ/genitals/nipple
	visible_organ = FALSE
	zone = BODY_ZONE_CHEST
	altnames = list("nip", "bud", "nipple") //used in thought messages.

/obj/item/organ/genitals/nipple/Insert(mob/living/M, special, drop_if_replaced, new_zone = null)
	. = ..()
	if(!.)
		return FALSE
	add_bodystorage(M, null, /datum/component/body_storage/nipple)

/obj/item/organ/genitals/nipple/Remove(mob/living/M, special, drop_if_replaced)
	. = ..()
	var/datum/component/body_storage/nipple/comp = GetComponent(/datum/component/body_storage/nipple)
	comp?.RemoveComponent()
	qdel(comp)
	if(!QDELETED(src))
		qdel(src)

/obj/item/organ/genitals/nipple/left
	name = "left nipple"
	slot = ORGAN_SLOT_LEFT_NIP

/obj/item/organ/genitals/nipple/right
	name = "right nipple"
	slot = ORGAN_SLOT_RIGHT_NIP

