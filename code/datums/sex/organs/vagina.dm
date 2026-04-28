/obj/item/organ/genitals/filling_organ/vagina
	name = "vagina"
	icon = 'modular_rmh/icons/eaglephntm/icons/obj/surgery.dmi'
	icon_state = "vagina"
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_VAGINA
	//var/fertility = TRUE
	reagent_to_make = /datum/reagent/consumable/femcum
	refilling = FALSE
	reagent_generate_rate = 0.5
	max_femcum = 5
	max_reagents = 40 //big cap, ordinary absorbtion.
	altnames = list("vagina", "cunt", "womb", "pussy", "slit", "kitty", "snatch") //used in thought messages.
	absorbing = TRUE
	fertility = TRUE
	allows_conventional_impregnation = TRUE
	allows_oviposition_pregnancy = TRUE
	spawn_embryo_on_fertilization = TRUE
	oviposition_storage_component_type = /datum/component/body_storage/vagina
	oviposition_location_name = "womb"
	spiller = TRUE
	blocker = ITEM_SLOT_PANTS
	additional_blocker = "underwear"
	bloatable = TRUE
	stretchable = FALSE
	// Passive egg production is enabled by a mob trait; these vars only tune the output.
	var/oviposition_egg_production_type = null // Null keeps the default safe egg type.
	var/oviposition_egg_production_interval = 20 MINUTES
	var/oviposition_egg_production_limit = 6
	var/next_oviposition_egg_generation = 0
	// Player-customizable egg appearance overrides
	var/custom_egg_name = ""
	var/custom_egg_desc = ""
	var/custom_organ_desc = ""
	var/custom_egg_color = null
	var/custom_auto_hatch = null
	var/egg_scale = OVI_EGG_DEFAULT_SCALE
	var/list/egg_traits = list()
	var/resource_dependent_yield = FALSE

/obj/item/organ/genitals/filling_organ/vagina/Insert(mob/living/M, special, drop_if_replaced)
	. = ..()
	if(M.femcum)
		reagent_to_make = M.femcum
	add_bodystorage(M, null, /datum/component/body_storage/vagina)
	next_oviposition_egg_generation = 0
	if(isharpy(M))
		oviposition_egg_production_limit = max(oviposition_egg_production_limit, 12)

/obj/item/organ/genitals/filling_organ/vagina/Remove(mob/living/M, special, drop_if_replaced)
	. = ..()
	var/datum/component/body_storage/vagina/comp = GetComponent(/datum/component/body_storage/vagina)
	comp?.RemoveComponent()

/obj/item/organ/genitals/filling_organ/vagina/attack_self(mob/user, list/modifiers)
	if(!ishuman(owner))
		to_chat(user, span_warning("The womb must be attached before I can tune its egg-laying."))
		return
	var/mob/living/carbon/human/human_owner = owner
	var/datum/oviposition_status_menu/menu = new(human_owner)
	menu.ui_interact(user)

/obj/item/organ/genitals/filling_organ/vagina/proc/get_womb_storage()
	return get_oviposition_storage()

/obj/item/organ/genitals/filling_organ/vagina/proc/update_custom_organ_desc()
	desc = custom_organ_desc || initial(desc)

/obj/item/organ/genitals/filling_organ/vagina/proc/is_womb_egg(obj/item/oviposition_egg/egg)
	return is_oviposition_egg(egg)

/obj/item/organ/genitals/filling_organ/vagina/proc/get_womb_oviposition_eggs(include_growing = null)
	return get_oviposition_eggs(include_growing)

/obj/item/organ/genitals/filling_organ/vagina/proc/get_generated_oviposition_egg_type()
	if(oviposition_egg_production_type)
		return oviposition_egg_production_type

	var/species_egg_type = get_species_oviposition_egg_type(owner)
	if(species_egg_type)
		return species_egg_type

	var/datum/quirk/peculiarity/egg_layer/egg_layer_quirk = owner?.get_quirk(/datum/quirk/peculiarity/egg_layer)
	if(!egg_layer_quirk)
		return null
	if(egg_layer_quirk.customization_value in egg_layer_quirk.customization_options)
		return egg_layer_quirk.customization_value
	return null

/obj/item/organ/genitals/filling_organ/vagina/proc/get_oviposition_egg_generation_interval(egg_type = null)
	if(!egg_type)
		egg_type = get_generated_oviposition_egg_type() || OVI_EGG_NORMAL

	var/effective_interval = oviposition_egg_production_interval
	effective_interval *= get_oviposition_egg_type_interval_multiplier(egg_type)
	effective_interval *= get_oviposition_capacity_interval_multiplier(oviposition_egg_production_limit)
	effective_interval *= sanitize_oviposition_scale(egg_scale)
	effective_interval *= get_oviposition_trait_interval_multiplier(egg_traits)
	return max(1 MINUTES, round(effective_interval))

// Slowly forms unfertilized eggs directly in the womb when the owner has the egg-layer trait.
/obj/item/organ/genitals/filling_organ/vagina/proc/try_generate_oviposition_egg()
	if(!owner || owner.stat == DEAD || !HAS_TRAIT(owner, TRAIT_EGG_LAYER))
		return FALSE
	if(!fertility || !supports_oviposition_pregnancy())
		return FALSE
	if(oviposition_egg_production_limit <= 0 || oviposition_egg_production_interval <= 0)
		return FALSE

	var/egg_type = get_generated_oviposition_egg_type()
	var/effective_interval = get_oviposition_egg_generation_interval(egg_type)
	// Resource-dependent: nutriment speeds up egg formation (halved interval at 10+ nutriment)
	if(resource_dependent_yield && owner)
		var/nutriment = owner.get_reagent_amount(/datum/reagent/consumable/nutriment)
		if(nutriment <= 0)
			// Only warn occasionally (when timer would have fired)
			if(next_oviposition_egg_generation && world.time >= next_oviposition_egg_generation)
				to_chat(owner, span_warning("My [get_oviposition_location_name()] aches faintly — I need to eat for my body to form eggs."))
				next_oviposition_egg_generation = world.time + effective_interval
			return FALSE // No nutriment = no egg production
		var/speed_multiplier = 1.5 - clamp(nutriment / 10, 0, 1)
		effective_interval = round(effective_interval * speed_multiplier)

	if(!next_oviposition_egg_generation)
		next_oviposition_egg_generation = world.time + effective_interval
		return FALSE
	if(world.time < next_oviposition_egg_generation)
		return FALSE

	if(length(get_oviposition_eggs()) >= oviposition_egg_production_limit)
		next_oviposition_egg_generation = world.time + effective_interval
		if(prob(5)) // Occasional reminder
			to_chat(owner, span_love("My [get_oviposition_location_name()] feels full and heavy with eggs."))
		return FALSE

	var/nutrient_cost = get_oviposition_nutrient_cost(egg_type || OVI_EGG_NORMAL, egg_scale, egg_traits, oviposition_egg_production_limit)
	if(resource_dependent_yield && !can_pay_oviposition_nutrients(owner, nutrient_cost))
		next_oviposition_egg_generation = world.time + effective_interval
		to_chat(owner, span_warning("My [get_oviposition_location_name()] aches faintly — I need more nutrition to finish forming an egg."))
		return FALSE

	var/obj/item/oviposition_egg/egg = new
	// Apply player custom overrides before setting type
	egg.apply_custom_overrides(custom_egg_name, custom_egg_desc, custom_egg_color, egg_scale, egg_traits, custom_auto_hatch)
	if(egg_type)
		egg.set_egg_type(egg_type)
	egg.set_oviposition_mother(owner)

	var/fit_result = SEND_SIGNAL(src, COMSIG_BODYSTORAGE_TRY_INSERT, egg, STORAGE_LAYER_DEEP, FALSE, TRUE)
	switch(fit_result)
		if(INSERT_FEEDBACK_OK, INSERT_FEEDBACK_OK_FORCE, INSERT_FEEDBACK_OK_OVERRIDE, INSERT_FEEDBACK_ALMOST_FULL)
			if(resource_dependent_yield)
				consume_oviposition_nutrients(owner, nutrient_cost)
			next_oviposition_egg_generation = world.time + effective_interval
			to_chat(owner, span_love("I feel a new egg form in my [get_oviposition_location_name()]."))
			return TRUE

	qdel(egg)
	next_oviposition_egg_generation = world.time + 30 SECONDS
	return FALSE

/obj/item/organ/genitals/filling_organ/vagina/get_availability(datum/species/owner_species, mob/living/C, datum/preferences/pref_load)
	if(issimple(C))
		return C.gender == FEMALE
	else
		if(pref_load)
			return pref_load.has_enabled_customizer_entry(/datum/customizer_entry/organ/genitals/vagina)
		else
			return C.gender == FEMALE

