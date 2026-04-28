
/obj/item/organ/genitals/penis/ovipositor
	name = "ovipositor"
	penis_type = PENIS_TYPE_OVIPOSITOR
	sheath_type = SHEATH_TYPE_NORMAL
	ovi_egg_type = OVI_EGG_NORMAL
	egg_clutch_size = 1
	var/egg_storage_capacity = OVI_EGG_MAX_CLUTCH
	var/custom_egg_name = ""
	var/custom_egg_desc = ""
	var/custom_organ_desc = ""
	var/custom_egg_color = null
	var/custom_auto_hatch = null
	var/egg_scale = OVI_EGG_DEFAULT_SCALE
	var/list/egg_traits = list()
	var/resource_dependent_yield = FALSE

/obj/item/organ/genitals/penis/ovipositor/Insert(mob/living/M, special, drop_if_replaced)
	. = ..()
	if(!GetComponent(/datum/component/ovipositor))
		AddComponent(/datum/component/ovipositor)

/obj/item/organ/genitals/penis/ovipositor/Remove(mob/living/M, special, drop_if_replaced)
	. = ..()
	var/datum/component/body_storage/pubes/comp = GetComponent(/datum/component/body_storage/pubes)
	comp?.RemoveComponent()
	qdel(comp)

/obj/item/organ/genitals/penis/ovipositor/attack_self(mob/user, list/modifiers)
	if(!ishuman(owner))
		to_chat(user, span_warning("The ovipositor must be attached before I can tune its egg-laying."))
		return
	var/mob/living/carbon/human/human_owner = owner
	var/datum/oviposition_status_menu/menu = new(human_owner)
	menu.ui_interact(user)

/obj/item/organ/genitals/penis/ovipositor/proc/set_egg_type(new_egg_type)
	if(new_egg_type)
		ovi_egg_type = new_egg_type
	return ovi_egg_type

/obj/item/organ/genitals/penis/ovipositor/proc/set_clutch_size(new_size)
	if(isnull(new_size))
		return egg_clutch_size

	egg_clutch_size = clamp(round(new_size), 1, OVI_EGG_MAX_CLUTCH)
	egg_storage_capacity = max(egg_storage_capacity, egg_clutch_size)

	var/datum/component/ovipositor/ovipositor_component = GetComponent(/datum/component/ovipositor)
	ovipositor_component?.set_clutch_size(egg_clutch_size)
	return egg_clutch_size

/obj/item/organ/genitals/penis/ovipositor/proc/set_storage_capacity(new_capacity)
	if(isnull(new_capacity))
		return egg_storage_capacity

	egg_storage_capacity = clamp(round(new_capacity), egg_clutch_size, OVI_EGG_MAX_CLUTCH)
	var/datum/component/ovipositor/ovipositor_component = GetComponent(/datum/component/ovipositor)
	ovipositor_component?.sync_storage_capacity()
	return egg_storage_capacity

/obj/item/organ/genitals/penis/ovipositor/proc/update_custom_organ_desc()
	desc = custom_organ_desc || initial(desc)

// Keep the organ type and the oviposition behavior separate so character prefs can pick
// the anatomy while quirks or mob setup decide whether it is actually functional.
/proc/set_ovipositor_functionality(obj/item/organ/genitals/penis/ovipositor, enabled = TRUE)
	if(!ovipositor)
		return FALSE

	var/datum/component/ovipositor/ovipositor_component = ovipositor.GetComponent(/datum/component/ovipositor)

	if(enabled)
		if(!ovipositor_component)
			ovipositor.AddComponent(/datum/component/ovipositor)
		return TRUE

	if(ovipositor_component)
		qdel(ovipositor_component)
	return TRUE

/proc/ensure_typed_ovipositor(mob/living/owner, egg_type = OVI_EGG_NORMAL)
	if(!owner)
		return null

	var/obj/item/organ/genitals/penis/current_penis = owner.getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/genitals/penis/ovipositor/ovipositor = current_penis

	if(!istype(ovipositor))
		if(current_penis)
			current_penis.Remove(owner, FALSE, FALSE)
			qdel(current_penis)
		ovipositor = new /obj/item/organ/genitals/penis/ovipositor()
		ovipositor.Insert(owner, FALSE, FALSE)

	ovipositor.set_egg_type(egg_type)
	set_ovipositor_functionality(ovipositor, TRUE)
	return ovipositor

/proc/ensure_spider_ovipositor(mob/living/owner)
	return ensure_typed_ovipositor(owner, OVI_EGG_SPIDER)

/proc/ensure_bog_bug_ovipositor(mob/living/owner)
	return ensure_typed_ovipositor(owner, OVI_EGG_BOG_BUG)

/proc/get_oviposition_egg_type_option_name(option)
	switch(option)
		if(OVI_EGG_NORMAL)
			return "Hardshell"
		if(OVI_EGG_AVIAN)
			return "Avian"
		if(OVI_EGG_SOFTSHELL)
			return "Softshell"
		if(OVI_EGG_PARASITIC)
			return "Parasitic"
		if(OVI_EGG_HARPY)
			return "Harpy"
		if(OVI_EGG_SPIDER)
			return "Spider"
		if(OVI_EGG_BOG_BUG)
			return "Bog Bug"
		if(OVI_EGG_EMBRYO)
			return "Embryo"
	return "[option]"

/datum/sprite_accessory/genitals/penis/ovipositor
	name = "Ovipositor"
	icon_state = "tapered"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/customizer_choice/organ/genitals/penis/ovipositor
	name = "Ovipositor"
	organ_type = /obj/item/organ/genitals/penis/ovipositor
	sprite_accessories = list(/datum/sprite_accessory/genitals/penis/ovipositor)

/datum/preferences/cleanup_quirks_for_customizer_entry(datum/customizer_entry/entry)
	. = ..()
	if(istype(entry, /datum/customizer_entry/organ/genitals/vagina))
		var/datum/customizer_entry/organ/genitals/vagina/vagina_entry = entry
		if(vagina_entry.disabled)
			if(remove_quirk(/datum/quirk/peculiarity/egg_layer))
				. = TRUE
		return

	if(istype(entry, /datum/customizer_entry/organ/genitals/penis))
		var/datum/customizer_entry/organ/genitals/penis/penis_entry = entry
		var/is_ovipositor_choice = (penis_entry.customizer_choice_type == /datum/customizer_choice/organ/genitals/penis/ovipositor)
		if(penis_entry.disabled || !is_ovipositor_choice)
			if(remove_quirk(/datum/quirk/peculiarity/ovipositor))
				. = TRUE

/datum/quirk/peculiarity/ovipositor
	name = "Oviposition"
	desc = "My 'penis' is a functional ovipositor and can be used to lay eggs."
	customization_label = "Choose Egg Type"
	customization_options = list(
		OVI_EGG_NORMAL,
		OVI_EGG_AVIAN,
		OVI_EGG_SOFTSHELL,
		OVI_EGG_PARASITIC,
		OVI_EGG_HARPY
	)
	extra_customization_fields = list(
		list("key" = "clutch_size", "label" = "Clutch Size", "type" = QUIRK_NUMBER, "default" = 1, "min" = 1, "max" = OVI_EGG_MAX_CLUTCH),
		list("key" = "storage_capacity", "label" = "Stored Egg Capacity", "type" = QUIRK_NUMBER, "default" = OVI_EGG_MAX_CLUTCH, "min" = 1, "max" = OVI_EGG_MAX_CLUTCH),
		list("key" = "egg_scale_percent", "label" = "Egg Size %", "type" = QUIRK_NUMBER, "default" = 100, "min" = 50, "max" = 200),
		list("key" = "custom_name", "label" = "Custom Egg Name", "type" = QUIRK_TEXT, "default" = "", "placeholder" = "Leave blank for default", "max_length" = OVI_EGG_MAX_CUSTOM_NAME_LENGTH),
		list("key" = "custom_desc", "label" = "Custom Egg Desc", "type" = QUIRK_TEXT, "default" = "", "placeholder" = "Leave blank for default", "max_length" = OVI_EGG_MAX_CUSTOM_DESC_LENGTH, "multiline" = TRUE),
		list("key" = "custom_organ_desc", "label" = "Custom Organ Desc", "type" = QUIRK_TEXT, "default" = "", "placeholder" = "Leave blank for default", "max_length" = OVI_EGG_MAX_CUSTOM_DESC_LENGTH, "multiline" = TRUE),
		list("key" = "custom_color", "label" = "Egg Color", "type" = QUIRK_COLOR, "default" = ""),
		list("key" = "egg_trait", "label" = "Egg Modifier", "type" = QUIRK_SELECT, "default" = "None", "options" = list("None", OVI_EGG_TRAIT_APHRODISIAC, OVI_EGG_TRAIT_POISON, OVI_EGG_TRAIT_PARASITE, OVI_EGG_TRAIT_FAST_GROWTH)),
		list("key" = "auto_hatch", "label" = "Auto Hatch", "type" = QUIRK_SELECT, "default" = "Profile", "options" = list("Profile", "Yes", "No")),
		list("key" = "resource_dependent", "label" = "Resource-Dependent Yield", "type" = QUIRK_SELECT, "default" = "No", "options" = list("No", "Yes"))
	)

/datum/quirk/peculiarity/ovipositor/is_available(datum/preferences/prefs)
	if(!..())
		return FALSE
	if(!prefs)
		return TRUE

	var/datum/customizer_entry/organ/genitals/penis/penis_entry = prefs.get_customizer_entry_of_type(/datum/customizer_entry/organ/genitals/penis)
	if(!penis_entry || penis_entry.disabled)
		return FALSE

	return penis_entry.customizer_choice_type == /datum/customizer_choice/organ/genitals/penis/ovipositor

/datum/quirk/peculiarity/ovipositor/on_spawn()
	if(!customization_value || !(customization_value in customization_options))
		customization_value = OVI_EGG_NORMAL

	var/obj/item/organ/genitals/penis/ovipositor/ovipositor_organ = owner?.getorganslot(ORGAN_SLOT_PENIS)
	if(!ovipositor_organ)
		return
	ovipositor_organ.set_egg_type(customization_value)

	var/clutch = text2num(get_extra_value("clutch_size", 1))
	ovipositor_organ.set_clutch_size(clutch)
	var/storage_capacity = text2num(get_extra_value("storage_capacity", OVI_EGG_MAX_CLUTCH))
	if(isnull(storage_capacity))
		storage_capacity = OVI_EGG_MAX_CLUTCH
	ovipositor_organ.set_storage_capacity(storage_capacity)

	var/scale_percent = text2num(get_extra_value("egg_scale_percent", 100))
	if(isnull(scale_percent))
		scale_percent = 100
	ovipositor_organ.egg_scale = sanitize_oviposition_scale(scale_percent / 100)
	ovipositor_organ.custom_egg_name = sanitize_oviposition_text(get_extra_value("custom_name", ""), OVI_EGG_MAX_CUSTOM_NAME_LENGTH, FALSE)
	ovipositor_organ.custom_egg_desc = sanitize_oviposition_text(get_extra_value("custom_desc", ""), OVI_EGG_MAX_CUSTOM_DESC_LENGTH, TRUE)
	ovipositor_organ.custom_organ_desc = sanitize_oviposition_text(get_extra_value("custom_organ_desc", ""), OVI_EGG_MAX_CUSTOM_DESC_LENGTH, TRUE)
	ovipositor_organ.custom_egg_color = sanitize_oviposition_color(get_extra_value("custom_color", ""))
	var/egg_trait = get_extra_value("egg_trait", "None")
	ovipositor_organ.egg_traits = (egg_trait && egg_trait != "None") ? sanitize_oviposition_trait_list(list(egg_trait)) : list()
	var/auto_hatch = get_extra_value("auto_hatch", "Profile")
	ovipositor_organ.custom_auto_hatch = (auto_hatch == "Profile") ? null : (auto_hatch == "Yes")
	ovipositor_organ.resource_dependent_yield = (get_extra_value("resource_dependent", "No") == "Yes")
	ovipositor_organ.update_custom_organ_desc()

	set_ovipositor_functionality(ovipositor_organ, TRUE)

/datum/quirk/peculiarity/ovipositor/on_remove()
	var/obj/item/organ/genitals/penis/ovipositor/ovipositor_organ = owner?.getorganslot(ORGAN_SLOT_PENIS)
	set_ovipositor_functionality(ovipositor_organ, FALSE)

/datum/quirk/peculiarity/ovipositor/get_option_name(option)
	return get_oviposition_egg_type_option_name(option)

/datum/quirk/peculiarity/egg_layer
	name = "Egg Layer"
	desc = "My womb slowly forms eggs on its own."
	customization_label = "Choose Egg Type"
	customization_options = list(
		OVI_EGG_NORMAL,
		OVI_EGG_AVIAN,
		OVI_EGG_SOFTSHELL,
		OVI_EGG_PARASITIC,
		OVI_EGG_HARPY
	)
	extra_customization_fields = list(
		list("key" = "clutch_size", "label" = "Max Eggs in Womb", "type" = QUIRK_NUMBER, "default" = 6, "min" = 1, "max" = OVI_EGG_MAX_CLUTCH),
		list("key" = "egg_scale_percent", "label" = "Egg Size %", "type" = QUIRK_NUMBER, "default" = 100, "min" = 50, "max" = 200),
		list("key" = "custom_name", "label" = "Custom Egg Name", "type" = QUIRK_TEXT, "default" = "", "placeholder" = "Leave blank for default", "max_length" = OVI_EGG_MAX_CUSTOM_NAME_LENGTH),
		list("key" = "custom_desc", "label" = "Custom Egg Desc", "type" = QUIRK_TEXT, "default" = "", "placeholder" = "Leave blank for default", "max_length" = OVI_EGG_MAX_CUSTOM_DESC_LENGTH, "multiline" = TRUE),
		list("key" = "custom_organ_desc", "label" = "Custom Womb Desc", "type" = QUIRK_TEXT, "default" = "", "placeholder" = "Leave blank for default", "max_length" = OVI_EGG_MAX_CUSTOM_DESC_LENGTH, "multiline" = TRUE),
		list("key" = "custom_color", "label" = "Egg Color", "type" = QUIRK_COLOR, "default" = ""),
		list("key" = "egg_trait", "label" = "Egg Modifier", "type" = QUIRK_SELECT, "default" = "None", "options" = list("None", OVI_EGG_TRAIT_APHRODISIAC, OVI_EGG_TRAIT_POISON, OVI_EGG_TRAIT_PARASITE, OVI_EGG_TRAIT_FAST_GROWTH)),
		list("key" = "auto_hatch", "label" = "Auto Hatch", "type" = QUIRK_SELECT, "default" = "Profile", "options" = list("Profile", "Yes", "No")),
		list("key" = "resource_dependent", "label" = "Resource-Dependent Yield", "type" = QUIRK_SELECT, "default" = "No", "options" = list("No", "Yes"))
	)

/datum/quirk/peculiarity/egg_layer/is_available(datum/preferences/prefs)
	if(!..())
		return FALSE
	if(!prefs)
		return TRUE

	var/datum/customizer_entry/organ/genitals/vagina/vagina_entry = prefs.get_customizer_entry_of_type(/datum/customizer_entry/organ/genitals/vagina)
	return vagina_entry && !vagina_entry.disabled

/datum/quirk/peculiarity/egg_layer/on_spawn()
	if(!customization_value || !(customization_value in customization_options))
		customization_value = OVI_EGG_NORMAL

	if(!owner)
		return

	ADD_TRAIT(owner, TRAIT_EGG_LAYER, "[type]")
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.update_check_eggs_verb()

	var/obj/item/organ/genitals/filling_organ/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)
	if(vagina)
		var/clutch = text2num(get_extra_value("clutch_size", 6))
		if(isnull(clutch))
			clutch = 6
		vagina.oviposition_egg_production_limit = clamp(round(clutch), 1, OVI_EGG_MAX_CLUTCH)
		var/scale_percent = text2num(get_extra_value("egg_scale_percent", 100))
		if(isnull(scale_percent))
			scale_percent = 100
		vagina.egg_scale = sanitize_oviposition_scale(scale_percent / 100)
		vagina.custom_egg_name = sanitize_oviposition_text(get_extra_value("custom_name", ""), OVI_EGG_MAX_CUSTOM_NAME_LENGTH, FALSE)
		vagina.custom_egg_desc = sanitize_oviposition_text(get_extra_value("custom_desc", ""), OVI_EGG_MAX_CUSTOM_DESC_LENGTH, TRUE)
		vagina.custom_organ_desc = sanitize_oviposition_text(get_extra_value("custom_organ_desc", ""), OVI_EGG_MAX_CUSTOM_DESC_LENGTH, TRUE)
		vagina.custom_egg_color = sanitize_oviposition_color(get_extra_value("custom_color", ""))
		var/egg_trait = get_extra_value("egg_trait", "None")
		vagina.egg_traits = (egg_trait && egg_trait != "None") ? sanitize_oviposition_trait_list(list(egg_trait)) : list()
		var/auto_hatch = get_extra_value("auto_hatch", "Profile")
		vagina.custom_auto_hatch = (auto_hatch == "Profile") ? null : (auto_hatch == "Yes")
		vagina.resource_dependent_yield = (get_extra_value("resource_dependent", "No") == "Yes")
		vagina.update_custom_organ_desc()

/datum/quirk/peculiarity/egg_layer/on_remove()
	if(!owner)
		return

	REMOVE_TRAIT(owner, TRAIT_EGG_LAYER, "[type]")
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.update_check_eggs_verb()

	var/obj/item/organ/genitals/filling_organ/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)
	if(vagina)
		vagina.oviposition_egg_production_limit = initial(vagina.oviposition_egg_production_limit)
		vagina.custom_egg_name = ""
		vagina.custom_egg_desc = ""
		vagina.custom_organ_desc = ""
		vagina.custom_egg_color = null
		vagina.custom_auto_hatch = null
		vagina.egg_scale = OVI_EGG_DEFAULT_SCALE
		vagina.egg_traits = list()
		vagina.resource_dependent_yield = FALSE
		vagina.update_custom_organ_desc()

/datum/quirk/peculiarity/egg_layer/get_option_name(option)
	return get_oviposition_egg_type_option_name(option)

/// Validates a hex color string for oviposition egg tinting. Returns null if invalid.
/proc/sanitize_oviposition_color(color_input)
	if(!color_input || !istext(color_input))
		return null
	var/color = trim(color_input)
	if(!length(color))
		return null
	// Accept #RGB, #RRGGBB, #RRGGBBAA formats
	var/static/regex/hex_color = regex("^#\[0-9a-fA-F\]{3}(\[0-9a-fA-F\]{3}(\[0-9a-fA-F\]{2})?)?$")
	if(!hex_color.Find(color))
		return null
	return color
