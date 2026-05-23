/obj/item/organ/genitals
	abstract_type = /obj/item/organ/genitals
	var/organ_size = 1
	var/list/altnames = null
	var/can_change_size = FALSE
	delete_on_drop = TRUE

/obj/item/organ/genitals/Initialize()
	. = ..()
	body_storage_bulk *= organ_size

/obj/item/organ/genitals/can_decay()
	if(owner?.is_player_character())
		return FALSE
	return ..()

/obj/item/organ/genitals/adjust_germ_level(add_germs, minimum_germs = 0, maximum_germs = GERM_LEVEL_MAXIMUM)
	if(owner?.is_player_character())
		germ_level = GERM_LEVEL_STERILE
		return
	return ..()
