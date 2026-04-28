#define CHECK_EGGS_VERB /mob/living/carbon/human/proc/check_eggs

/mob/living/carbon/human
	var/tmp/oviposition_status_unlocked = FALSE

/// Verb for checking egg status via TGUI.
/mob/living/carbon/human/proc/check_eggs()
	set name = "Check wombs"
	set category = "IC"
	set desc = "Focus inward to feel the state of your wombs."

	if(stat == DEAD)
		to_chat(src, span_warning("I can't feel anything. I'm dead."))
		return

	var/datum/oviposition_status_menu/menu = new(src)
	menu.ui_interact(src)

/mob/living/carbon/human/proc/grant_check_eggs_verb(persistent = FALSE)
	if(persistent)
		oviposition_status_unlocked = TRUE
	if(!(CHECK_EGGS_VERB in verbs))
		add_verb(src, CHECK_EGGS_VERB)

/mob/living/carbon/human/proc/update_check_eggs_verb()
	if(oviposition_status_unlocked || HAS_TRAIT(src, TRAIT_EGG_LAYER))
		grant_check_eggs_verb()
	else if(CHECK_EGGS_VERB in verbs)
		remove_verb(src, CHECK_EGGS_VERB)

/datum/oviposition_status_menu
	var/mob/living/carbon/human/owner

/datum/oviposition_status_menu/New(mob/living/carbon/human/_owner)
	owner = _owner

/datum/oviposition_status_menu/Destroy()
	owner = null
	return ..()

/datum/oviposition_status_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/oviposition_status_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, get_interface_name(user))
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/oviposition_status_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui?.user
	if(!owner || QDELETED(owner) || user != owner)
		return FALSE

	switch(action)
		if("set_organ_setting")
			return set_organ_setting(params)
		if("toggle_organ_trait")
			return toggle_organ_trait(params)
		if("edit_organ_text")
			return edit_organ_text(params, user)
		if("pick_organ_color")
			return pick_organ_color(params, user)
		if("toggle_egg_auto_hatch")
			return toggle_egg_auto_hatch(params)
		if("extract_egg")
			return extract_egg(params)
		if("extract_organ_eggs")
			return extract_organ_eggs(params)
		if("lay_ovipositor_eggs")
			return lay_ovipositor_eggs()

	return FALSE

/datum/oviposition_status_menu/ui_close(mob/user)
	qdel(src)

/datum/oviposition_status_menu/proc/get_interface_name(mob/user)
	return get_preferred_ui_language(user) == "ru" ? "OvipositionStatusRu" : "OvipositionStatus"

/datum/oviposition_status_menu/ui_data(mob/user)
	var/list/data = list()
	if(!owner || QDELETED(owner))
		return data

	data["nutriment"] = round(owner.get_reagent_amount(/datum/reagent/consumable/nutriment), 0.1)
	data["organs"] = list()

	// --- Ovipositor ---
	var/obj/item/organ/genitals/penis/ovipositor/ovi_organ = owner.getorganslot(ORGAN_SLOT_PENIS)
	if(istype(ovi_organ))
		var/datum/component/ovipositor/ovi_comp = ovi_organ.GetComponent(/datum/component/ovipositor)
		if(ovi_comp)
			var/list/ovi = list()
			ovi["id"] = "ovipositor"
			ovi["title"] = "OVIPOSITOR"
			ovi["icon"] = "mars"
			ovi["egg_count"] = ovi_comp.eggs_stored
			ovi["egg_capacity"] = ovi_comp.get_max_stored_eggs()
			ovi["clutch_size"] = ovi_comp.get_clutch_size()
			ovi["egg_type_name"] = get_egg_type_short_name(ovi_organ.ovi_egg_type)
			ovi["custom_color"] = ovi_organ.custom_egg_color
			ovi["custom_name"] = ovi_organ.custom_egg_name
			ovi["resource_dependent"] = ovi_organ.resource_dependent_yield
			ovi["egg_stage"] = ovi_comp.egg_stage
			ovi["interval_seconds"] = round((ovi_comp.get_egg_stage_time() * 2) / 10, 1)
			ovi["settings"] = build_ovipositor_settings(ovi_organ, ovi_comp)
			ovi["eggs"] = list()
			UNTYPED_LIST_ADD(data["organs"], ovi)

	// --- Womb ---
	var/obj/item/organ/genitals/filling_organ/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)
	var/list/vagina_eggs
	if(vagina && vagina.supports_oviposition_pregnancy())
		vagina_eggs = vagina.get_oviposition_eggs()

	var/is_egg_layer = HAS_TRAIT(owner, TRAIT_EGG_LAYER)
	var/hatchling_count = 0
	if(vagina)
		hatchling_count = vagina.count_internal_womb_hatchlings()

	if(length(vagina_eggs) || hatchling_count || is_egg_layer)
		var/list/womb = list()
		womb["id"] = "womb"
		womb["title"] = "WOMB"
		womb["icon"] = "venus"
		womb["egg_count"] = length(vagina_eggs)
		womb["is_egg_layer"] = is_egg_layer
		womb["hatchling_count"] = hatchling_count
		if(is_egg_layer && vagina)
			womb["egg_capacity"] = vagina.oviposition_egg_production_limit
			womb["resource_dependent"] = vagina.resource_dependent_yield
			womb["settings"] = build_womb_settings(vagina)
			if(vagina.next_oviposition_egg_generation > 0 && length(vagina_eggs) < vagina.oviposition_egg_production_limit)
				var/remaining = max(0, vagina.next_oviposition_egg_generation - world.time)
				womb["next_egg_seconds"] = round(remaining / 10, 1)
				womb["interval_seconds"] = round(vagina.get_oviposition_egg_generation_interval() / 10, 1)
		womb["eggs"] = list()
		for(var/obj/item/oviposition_egg/egg as anything in vagina_eggs)
			UNTYPED_LIST_ADD(womb["eggs"], build_single_egg(egg))
		UNTYPED_LIST_ADD(data["organs"], womb)

	// --- Other organs (Anus, Guts) ---
	for(var/slot in list(ORGAN_SLOT_ANUS, ORGAN_SLOT_GUTS))
		var/obj/item/organ/organ = owner.getorganslot(slot)
		if(!organ || !organ.supports_oviposition_pregnancy())
			continue
		var/list/organ_eggs = organ.get_oviposition_eggs()
		if(!length(organ_eggs))
			continue
		var/list/od = list()
		od["id"] = slot
		od["title"] = uppertext(organ.get_oviposition_location_name())
		od["icon"] = "circle"
		od["egg_count"] = length(organ_eggs)
		od["eggs"] = list()
		for(var/obj/item/oviposition_egg/egg as anything in organ_eggs)
			UNTYPED_LIST_ADD(od["eggs"], build_single_egg(egg))
		UNTYPED_LIST_ADD(data["organs"], od)

	return data

/datum/oviposition_status_menu/proc/build_egg_type_options()
	var/list/options = list()
	for(var/egg_type in get_oviposition_egg_type_options(FALSE))
		UNTYPED_LIST_ADD(options, list(
			"id" = egg_type,
			"name" = get_egg_type_short_name(egg_type),
		))
	return options

/datum/oviposition_status_menu/proc/build_trait_options()
	var/list/options = list()
	for(var/trait_flag in get_oviposition_egg_trait_options())
		UNTYPED_LIST_ADD(options, list(
			"id" = trait_flag,
			"name" = get_oviposition_egg_trait_name(trait_flag),
		))
	return options

/datum/oviposition_status_menu/proc/build_ovipositor_settings(obj/item/organ/genitals/penis/ovipositor/ovipositor, datum/component/ovipositor/ovipositor_component)
	var/list/settings = list()
	settings["can_configure"] = TRUE
	settings["egg_type"] = ovipositor.ovi_egg_type
	settings["egg_type_name"] = get_egg_type_short_name(ovipositor.ovi_egg_type)
	settings["clutch_size"] = ovipositor_component?.get_clutch_size() || ovipositor.egg_clutch_size
	settings["capacity"] = ovipositor_component?.get_max_stored_eggs() || OVI_EGG_MAX_CLUTCH
	settings["max_capacity"] = OVI_EGG_MAX_CLUTCH
	settings["max_clutch"] = OVI_EGG_MAX_CLUTCH
	settings["custom_name"] = ovipositor.custom_egg_name
	settings["custom_desc"] = ovipositor.custom_egg_desc
	settings["custom_organ_desc"] = ovipositor.custom_organ_desc
	settings["custom_color"] = ovipositor.custom_egg_color
	settings["auto_hatch"] = ovipositor.custom_auto_hatch
	settings["resource_dependent"] = ovipositor.resource_dependent_yield
	settings["egg_scale"] = sanitize_oviposition_scale(ovipositor.egg_scale)
	settings["egg_traits"] = islist(ovipositor.egg_traits) ? ovipositor.egg_traits.Copy() : list()
	settings["available_egg_types"] = build_egg_type_options()
	settings["available_traits"] = build_trait_options()
	settings["color_presets"] = get_oviposition_color_presets(owner)
	settings["nutrient_cost"] = get_oviposition_nutrient_cost(ovipositor.ovi_egg_type, ovipositor.egg_scale, ovipositor.egg_traits, settings["clutch_size"])
	return settings

/datum/oviposition_status_menu/proc/build_womb_settings(obj/item/organ/genitals/filling_organ/vagina/vagina)
	var/egg_type = vagina.get_generated_oviposition_egg_type() || OVI_EGG_NORMAL
	var/list/settings = list()
	settings["can_configure"] = TRUE
	settings["egg_type"] = egg_type
	settings["egg_type_name"] = get_egg_type_short_name(egg_type)
	settings["clutch_size"] = vagina.oviposition_egg_production_limit
	settings["capacity"] = vagina.oviposition_egg_production_limit
	settings["max_clutch"] = OVI_EGG_MAX_CLUTCH
	settings["custom_name"] = vagina.custom_egg_name
	settings["custom_desc"] = vagina.custom_egg_desc
	settings["custom_organ_desc"] = vagina.custom_organ_desc
	settings["custom_color"] = vagina.custom_egg_color
	settings["auto_hatch"] = vagina.custom_auto_hatch
	settings["resource_dependent"] = vagina.resource_dependent_yield
	settings["egg_scale"] = sanitize_oviposition_scale(vagina.egg_scale)
	settings["egg_traits"] = islist(vagina.egg_traits) ? vagina.egg_traits.Copy() : list()
	settings["available_egg_types"] = build_egg_type_options()
	settings["available_traits"] = build_trait_options()
	settings["color_presets"] = get_oviposition_color_presets(owner)
	settings["nutrient_cost"] = get_oviposition_nutrient_cost(egg_type, vagina.egg_scale, vagina.egg_traits, vagina.oviposition_egg_production_limit)
	return settings

/datum/oviposition_status_menu/proc/build_single_egg(obj/item/oviposition_egg/egg)
	var/list/d = list()
	d["ref"] = REF(egg)
	d["name"] = egg.name
	d["desc"] = egg.desc
	d["type_name"] = get_egg_type_short_name(egg.egg_type)
	d["is_hatchling"] = egg.egg_type == OVI_EGG_EMBRYO
	d["display_color"] = egg.custom_egg_color || egg.color
	d["color_hex"] = egg.custom_egg_color
	d["scale"] = egg.get_egg_scale()
	d["traits"] = islist(egg.egg_traits) ? egg.egg_traits.Copy() : list()
	d["can_remove"] = egg.can_remove_from_body_storage(BODYSTORAGE_REMOVE_MANUAL)
	d["auto_hatch"] = egg.auto_hatch_when_laid
	d["mother_name"] = egg.oviposition_mother_name

	var/datum/component/pregnancy/preg = egg.get_pregnancy_component()
	if(preg)
		d["has_preg"] = TRUE
		d["stage"] = preg.stage
		d["max_stage"] = preg.max_stage
		d["progress_pct"] = round((preg.stage / max(1, preg.max_stage)) * 100)
		d["fertilized"] = preg.fertilized
		d["hatch_inside"] = egg.hatch_inside_host
		d["auto_hatch"] = egg.auto_hatch_when_laid
		d["mother_name"] = egg.oviposition_mother_name
		d["father_name"] = preg.father_name
		if(preg.stage >= preg.max_stage)
			d["status"] = "ready"
		else if(preg.stage > 0)
			d["status"] = "growing"
		else
			d["status"] = "dormant"
		if(preg.stage < preg.max_stage && preg.max_stage > 0)
			d["time_left"] = round(((preg.max_stage - preg.stage) * preg.stage_duration) / 10, 1)
		else
			d["time_left"] = 0
	else
		d["has_preg"] = FALSE
		d["stage"] = 0
		d["max_stage"] = 0
		d["progress_pct"] = 0
		d["status"] = "dormant"
		d["time_left"] = 0

	return d

/datum/oviposition_status_menu/proc/get_configurable_organ(organ_id)
	if(!owner)
		return null
	switch(organ_id)
		if("ovipositor")
			var/obj/item/organ/genitals/penis/ovipositor/ovipositor = owner.getorganslot(ORGAN_SLOT_PENIS)
			return istype(ovipositor) ? ovipositor : null
		if("womb")
			var/obj/item/organ/genitals/filling_organ/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)
			return istype(vagina) ? vagina : null
	return null

/datum/oviposition_status_menu/proc/set_organ_setting(list/params)
	var/organ_id = params["organ_id"]
	var/field = params["field"]
	var/value = params["value"]
	var/obj/item/organ/organ = get_configurable_organ(organ_id)
	if(!organ || !field)
		return FALSE

	var/obj/item/organ/genitals/penis/ovipositor/ovipositor
	var/obj/item/organ/genitals/filling_organ/vagina/vagina
	if(istype(organ, /obj/item/organ/genitals/penis/ovipositor))
		ovipositor = organ
	else if(istype(organ, /obj/item/organ/genitals/filling_organ/vagina))
		vagina = organ

	switch(field)
		if("egg_type")
			if(!(value in get_oviposition_egg_type_options(FALSE)))
				return FALSE
			if(istype(ovipositor))
				ovipositor.set_egg_type(value)
			else if(istype(vagina))
				vagina.oviposition_egg_production_type = value
		if("clutch_size")
			var/clutch_size = text2num("[value]")
			if(isnull(clutch_size))
				return FALSE
			clutch_size = clamp(round(clutch_size), 1, OVI_EGG_MAX_CLUTCH)
			if(istype(ovipositor))
				ovipositor.set_clutch_size(clutch_size)
			else if(istype(vagina))
				vagina.oviposition_egg_production_limit = clutch_size
		if("storage_capacity")
			var/storage_capacity = text2num("[value]")
			if(isnull(storage_capacity) || !istype(ovipositor))
				return FALSE
			ovipositor.set_storage_capacity(storage_capacity)
		if("egg_scale")
			var/scale = sanitize_oviposition_scale(value)
			if(istype(ovipositor))
				ovipositor.egg_scale = scale
			else if(istype(vagina))
				vagina.egg_scale = scale
		if("custom_name")
			var/custom_name = sanitize_oviposition_text(value, OVI_EGG_MAX_CUSTOM_NAME_LENGTH, FALSE)
			if(istype(ovipositor))
				ovipositor.custom_egg_name = custom_name
			else if(istype(vagina))
				vagina.custom_egg_name = custom_name
		if("custom_desc")
			var/custom_desc = sanitize_oviposition_text(value, OVI_EGG_MAX_CUSTOM_DESC_LENGTH, TRUE)
			if(istype(ovipositor))
				ovipositor.custom_egg_desc = custom_desc
			else if(istype(vagina))
				vagina.custom_egg_desc = custom_desc
		if("custom_organ_desc")
			var/custom_organ_desc = sanitize_oviposition_text(value, OVI_EGG_MAX_CUSTOM_DESC_LENGTH, TRUE)
			if(istype(ovipositor))
				ovipositor.custom_organ_desc = custom_organ_desc
				ovipositor.update_custom_organ_desc()
			else if(istype(vagina))
				vagina.custom_organ_desc = custom_organ_desc
				vagina.update_custom_organ_desc()
		if("custom_color")
			var/custom_color = sanitize_oviposition_color(value)
			if(istype(ovipositor))
				ovipositor.custom_egg_color = custom_color
			else if(istype(vagina))
				vagina.custom_egg_color = custom_color
		if("resource_dependent")
			var/enabled = text2num("[value]") ? TRUE : FALSE
			if(istype(ovipositor))
				ovipositor.resource_dependent_yield = enabled
			else if(istype(vagina))
				vagina.resource_dependent_yield = enabled
		if("auto_hatch")
			var/auto_hatch = "[value]"
			var/new_value = (auto_hatch == "profile") ? null : (auto_hatch == "true")
			if(istype(ovipositor))
				ovipositor.custom_auto_hatch = new_value
			else if(istype(vagina))
				vagina.custom_auto_hatch = new_value
		else
			return FALSE
	return TRUE

/datum/oviposition_status_menu/proc/edit_organ_text(list/params, mob/user)
	if(!user)
		return FALSE
	var/organ_id = params["organ_id"]
	var/field = params["field"]
	var/obj/item/organ/organ = get_configurable_organ(organ_id)
	if(!organ || !(field in list("custom_name", "custom_desc", "custom_organ_desc")))
		return FALSE

	var/current_value = ""
	var/title = "Egg Setting"
	var/message = "Enter a value."
	var/max_length = OVI_EGG_MAX_CUSTOM_DESC_LENGTH
	var/multiline = TRUE

	var/obj/item/organ/genitals/penis/ovipositor/ovipositor
	var/obj/item/organ/genitals/filling_organ/vagina/vagina
	if(istype(organ, /obj/item/organ/genitals/penis/ovipositor))
		ovipositor = organ
	else if(istype(organ, /obj/item/organ/genitals/filling_organ/vagina))
		vagina = organ

	switch(field)
		if("custom_name")
			current_value = ovipositor ? ovipositor.custom_egg_name : vagina.custom_egg_name
			title = "Egg Name"
			message = "Choose the custom egg name."
			max_length = OVI_EGG_MAX_CUSTOM_NAME_LENGTH
			multiline = FALSE
		if("custom_desc")
			current_value = ovipositor ? ovipositor.custom_egg_desc : vagina.custom_egg_desc
			title = "Egg Description"
			message = "Write the custom egg description."
		if("custom_organ_desc")
			current_value = ovipositor ? ovipositor.custom_organ_desc : vagina.custom_organ_desc
			title = "Organ Description"
			message = "Write the custom organ description."

	var/new_value = tgui_input_text(user, message, title, current_value, max_length, multiline, encode = FALSE)
	if(isnull(new_value))
		return FALSE
	return set_organ_setting(list("organ_id" = organ_id, "field" = field, "value" = new_value))

/datum/oviposition_status_menu/proc/pick_organ_color(list/params, mob/user)
	if(!user)
		return FALSE
	var/organ_id = params["organ_id"]
	var/obj/item/organ/organ = get_configurable_organ(organ_id)
	if(!organ)
		return FALSE

	var/current_color = "#eee3c7"
	var/obj/item/organ/genitals/penis/ovipositor/ovipositor
	var/obj/item/organ/genitals/filling_organ/vagina/vagina
	if(istype(organ, /obj/item/organ/genitals/penis/ovipositor))
		ovipositor = organ
		current_color = ovipositor.custom_egg_color || current_color
	else if(istype(organ, /obj/item/organ/genitals/filling_organ/vagina))
		vagina = organ
		current_color = vagina.custom_egg_color || current_color

	var/new_color = tgui_color_picker(user, "Choose the custom egg color.", "Egg Color", current_color)
	if(!new_color)
		return FALSE
	return set_organ_setting(list("organ_id" = organ_id, "field" = "custom_color", "value" = new_color))

/datum/oviposition_status_menu/proc/toggle_organ_trait(list/params)
	var/organ_id = params["organ_id"]
	var/trait_flag = params["trait"]
	if(!(trait_flag in get_oviposition_egg_trait_options()))
		return FALSE
	var/obj/item/organ/organ = get_configurable_organ(organ_id)
	if(!organ)
		return FALSE

	var/list/traits
	var/obj/item/organ/genitals/penis/ovipositor/ovipositor
	var/obj/item/organ/genitals/filling_organ/vagina/vagina
	if(istype(organ, /obj/item/organ/genitals/penis/ovipositor))
		ovipositor = organ
	else if(istype(organ, /obj/item/organ/genitals/filling_organ/vagina))
		vagina = organ
	if(istype(ovipositor))
		traits = islist(ovipositor.egg_traits) ? ovipositor.egg_traits.Copy() : list()
		if(trait_flag in traits)
			traits -= trait_flag
		else
			traits += trait_flag
		ovipositor.egg_traits = sanitize_oviposition_trait_list(traits)
		return TRUE
	if(istype(vagina))
		traits = islist(vagina.egg_traits) ? vagina.egg_traits.Copy() : list()
		if(trait_flag in traits)
			traits -= trait_flag
		else
			traits += trait_flag
		vagina.egg_traits = sanitize_oviposition_trait_list(traits)
		return TRUE
	return FALSE

/datum/oviposition_status_menu/proc/find_owned_egg(egg_ref)
	if(!egg_ref)
		return null
	for(var/slot in list(ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS, ORGAN_SLOT_GUTS))
		var/obj/item/organ/organ = owner.getorganslot(slot)
		if(!organ || !organ.supports_oviposition_pregnancy())
			continue
		for(var/obj/item/oviposition_egg/egg as anything in organ.get_oviposition_eggs())
			if(REF(egg) == egg_ref)
				return egg
	return null

/datum/oviposition_status_menu/proc/toggle_egg_auto_hatch(list/params)
	var/obj/item/oviposition_egg/egg = find_owned_egg(params["egg_ref"])
	if(!egg)
		return FALSE
	egg.custom_auto_hatch = !egg.auto_hatch_when_laid
	egg.update_egg_appearance()
	return TRUE

/datum/oviposition_status_menu/proc/extract_egg(list/params)
	var/obj/item/oviposition_egg/egg = find_owned_egg(params["egg_ref"])
	if(!egg)
		return FALSE
	var/obj/item/organ/container = egg.loc
	if(!istype(container))
		return FALSE
	if(!SEND_SIGNAL(container, COMSIG_BODYSTORAGE_TRY_REMOVE, egg, null, BODYSTORAGE_REMOVE_MANUAL))
		to_chat(owner, span_warning("That egg cannot be removed by hand."))
		return FALSE
	egg.forceMove(get_turf(owner))
	to_chat(owner, span_notice("I carefully remove [egg] from my [container.get_oviposition_location_name()]."))
	return TRUE

/datum/oviposition_status_menu/proc/extract_organ_eggs(list/params)
	var/obj/item/organ/organ = get_configurable_organ(params["organ_id"])
	if(!organ || !organ.supports_oviposition_pregnancy())
		return FALSE
	var/removed = 0
	for(var/obj/item/oviposition_egg/egg as anything in organ.get_oviposition_eggs())
		if(SEND_SIGNAL(organ, COMSIG_BODYSTORAGE_TRY_REMOVE, egg, null, BODYSTORAGE_REMOVE_MANUAL))
			egg.forceMove(get_turf(owner))
			removed += 1
	if(removed)
		to_chat(owner, span_notice("I carefully remove [removed] egg\s from my [organ.get_oviposition_location_name()]."))
		return TRUE
	to_chat(owner, span_warning("There are no removable eggs there."))
	return FALSE

/datum/oviposition_status_menu/proc/lay_ovipositor_eggs()
	var/obj/item/organ/genitals/penis/ovipositor/ovipositor = owner.getorganslot(ORGAN_SLOT_PENIS)
	var/datum/component/ovipositor/ovipositor_component = ovipositor?.GetComponent(/datum/component/ovipositor)
	if(!ovipositor_component)
		return FALSE
	return ovipositor_component.lay_egg(get_turf(owner))

/// Short display name for egg types.
/proc/get_egg_type_short_name(egg_type)
	switch(egg_type)
		if(OVI_EGG_NORMAL)
			return "Hardshell"
		if(OVI_EGG_AVIAN)
			return "Avian"
		if(OVI_EGG_SOFTSHELL)
			return "Softshell"
		if(OVI_EGG_PARASITIC)
			return "Parasitic"
		if(OVI_EGG_SPIDER)
			return "Spider"
		if(OVI_EGG_BOG_BUG)
			return "Bog Bug"
		if(OVI_EGG_HARPY)
			return "Harpy"
		if(OVI_EGG_EMBRYO)
			return "Embryo"
	return "[egg_type]"

/proc/get_oviposition_egg_trait_name(trait_flag)
	switch(trait_flag)
		if(OVI_EGG_TRAIT_APHRODISIAC)
			return "Aphrodisiac"
		if(OVI_EGG_TRAIT_POISON)
			return "Poison"
		if(OVI_EGG_TRAIT_PARASITE)
			return "Parasite"
		if(OVI_EGG_TRAIT_FAST_GROWTH)
			return "Accelerated"
	return "[trait_flag]"

#undef CHECK_EGGS_VERB
