/datum/sprite_accessory/genitals/belly
	icon = 'modular_rmh/icons/mob/sprite_accessory/genitals/belly.dmi'
	color_key_name = "Belly"
	relevant_layers = list(BODY_ADJ_UPPER_LAYER)

/datum/sprite_accessory/genitals/belly/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/genitals/belly/belleh = organ
	return "[icon_state]_[belleh.get_visible_belly_size()]"

/datum/sprite_accessory/genitals/belly/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	gender_genitals_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELLY)
	//generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT)//, OFFSET_BELT_F)

/datum/sprite_accessory/genitals/belly/is_visible(obj/item/organ/genitals/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	draw_above_clothes = FALSE
	if(organ.visible_through_clothes)
		if(organ.visible_through_clothes == DRAW_ABOVE)
			draw_above_clothes = TRUE
		return TRUE
	return is_human_part_visible(owner, HIDEBELLY|HIDEJUMPSUIT)

/datum/sprite_accessory/genitals/belly
	icon_state = "pair"
	name = "Belly"
	color_key_defaults = list(KEY_CHEST_COLOR)
