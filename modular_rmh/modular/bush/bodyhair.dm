/proc/hairiness_level_name(level)
	switch(clamp(level, HAIRINESS_MINIMUM, HAIRINESS_MAXIMUM))
		if(HAIRINESS_SHAVED)
			return "shaved"
		if(HAIRINESS_STUBBLE)
			return "stubble"
		if(HAIRINESS_SOME_HAIR)
			return "some hair"
		if(HAIRINESS_HAIRY)
			return "hairy"
		if(HAIRINESS_VERY_HAIRY)
			return "very hairy"
	return "shaved"

/proc/hairiness_level_organ_adjective(level)
	switch(clamp(level, HAIRINESS_MINIMUM, HAIRINESS_MAXIMUM))
		if(HAIRINESS_STUBBLE)
			return "stubbly"
		if(HAIRINESS_SOME_HAIR)
			return "lightly hairy"
		if(HAIRINESS_HAIRY)
			return "hairy"
		if(HAIRINESS_VERY_HAIRY)
			return "very hairy"
	return null

/proc/body_hair_grooming_name(grooming_state)
	switch(grooming_state)
		if(HAIR_GROOMING_SHAVED)
			return "shaved"
		if(HAIR_GROOMING_TRIMMED)
			return "trimmed"
		if(HAIR_GROOMING_STYLED)
			return "styled"
	return "natural"

/proc/body_hair_grooming_choices()
	return list(
		"Natural" = HAIR_GROOMING_NATURAL,
		"Trimmed" = HAIR_GROOMING_TRIMMED,
		"Styled" = HAIR_GROOMING_STYLED,
	)

/proc/body_hair_species_default_accessory(datum/species/species)
	switch(species?.hairyness)
		if("t1")
			return /datum/sprite_accessory/body_hair/body/some_hair
		if("t2")
			return /datum/sprite_accessory/body_hair/body/hairy
		if("t3")
			return /datum/sprite_accessory/body_hair/body/very_hairy
	return /datum/sprite_accessory/body_hair/body/shaved

/datum/sprite_accessory/body_hair
	abstract_type = /datum/sprite_accessory/body_hair
	name = "shaved"
	color_key_name = "Hair"
	color_key_defaults = list(KEY_HAIR_COLOR)
	var/hairiness_level = HAIRINESS_SHAVED
	var/appearance_alpha = 255

/datum/sprite_accessory/body_hair/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(hairiness_level <= HAIRINESS_SHAVED)
		return null
	return ..()

/datum/sprite_accessory/body_hair/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(appearance_alpha >= 255)
		return
	for(var/mutable_appearance/appearance as anything in appearance_list)
		appearance.alpha = appearance_alpha

/datum/sprite_accessory/body_hair/body
	abstract_type = /datum/sprite_accessory/body_hair/body
	icon = 'icons/roguetown/mob/bodies/m/mm.dmi'
	layer = FRONT_MUTATIONS_LAYER

/datum/sprite_accessory/body_hair/body/get_icon(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/human_owner = owner
	var/datum/species/species = human_owner.dna?.species
	if(!species)
		return ..()
	if(human_owner.gender == MALE)
		return species.limbs_icon_m || ..()
	return species.limbs_icon_f || species.limbs_icon_m || ..()

/datum/sprite_accessory/body_hair/body/shaved
	name = "shaved"
	icon_state = null
	hairiness_level = HAIRINESS_SHAVED

/datum/sprite_accessory/body_hair/body/some_hair
	name = "some hair"
	icon_state = "t1"
	hairiness_level = HAIRINESS_SOME_HAIR

/datum/sprite_accessory/body_hair/body/hairy
	name = "hairy"
	icon_state = "t2"
	hairiness_level = HAIRINESS_HAIRY

/datum/sprite_accessory/body_hair/body/very_hairy
	name = "very hairy"
	icon_state = "t3"
	hairiness_level = HAIRINESS_VERY_HAIRY

/datum/sprite_accessory/body_hair/pubic
	abstract_type = /datum/sprite_accessory/body_hair/pubic
	icon = 'modular_rmh/icons/mob/sprite_accessory/bodyhair/bodyhair.dmi'
	layer = BODY_ADJ_LAYER

/datum/sprite_accessory/body_hair/pubic/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	..()
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT)

/datum/sprite_accessory/body_hair/pubic/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDECROTCH)

/datum/sprite_accessory/body_hair/pubic/shaved
	name = "shaved"
	icon_state = null
	hairiness_level = HAIRINESS_SHAVED

/datum/sprite_accessory/body_hair/pubic/stubble
	name = "stubble"
	icon_state = "stubble"
	hairiness_level = HAIRINESS_STUBBLE
	appearance_alpha = 200

/datum/sprite_accessory/body_hair/pubic/some_hair
	name = "some hair"
	icon_state = "furred"
	hairiness_level = HAIRINESS_SOME_HAIR
	appearance_alpha = 200

/datum/sprite_accessory/body_hair/pubic/hairy
	name = "hairy"
	icon_state = "hairy"
	hairiness_level = HAIRINESS_HAIRY

/datum/sprite_accessory/body_hair/pubic/very_hairy
	name = "very hairy"
	icon_state = "extrahairy"
	hairiness_level = HAIRINESS_VERY_HAIRY
