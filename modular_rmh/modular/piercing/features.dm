/datum/bodypart_feature/piercing
	name = "Piercing"
	feature_slot = BODYPART_FEATURE_PIERCINGS
	body_zone = BODY_ZONE_CHEST
	var/obj/item/piercings/piercings_item

/datum/bodypart_feature/piercing/set_accessory_type(new_accessory_type, colors, mob/living/carbon/owner)
	accessory_type = new_accessory_type
	if(!owner)
		return
	var/datum/sprite_accessory/piercing/accessory = SPRITE_ACCESSORY(accessory_type)
	if(!accessory?.piercing_type)
		return
	var/obj/item/piercings/new_piercings = new accessory.piercing_type(owner)
	set_piercings_item(new_piercings, owner)

/datum/bodypart_feature/piercing/proc/set_piercings_item(obj/item/piercings/new_piercings, mob/living/carbon/human/owner)
	if(piercings_item == new_piercings)
		return

	if(piercings_item?.piercings_feature == src)
		piercings_item.piercings_feature = null

	if(owner?.piercings_item && owner.piercings_item != new_piercings)
		qdel(owner.piercings_item)

	piercings_item = new_piercings
	if(!new_piercings)
		return

	new_piercings.piercings_feature = src
	if(owner)
		owner.piercings_item = new_piercings

/datum/bodypart_feature/piercing/Destroy()
	if(piercings_item?.piercings_feature == src)
		piercings_item.piercings_feature = null
	piercings_item = null
	return ..()
