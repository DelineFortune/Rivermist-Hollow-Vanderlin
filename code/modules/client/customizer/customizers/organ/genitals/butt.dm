
/datum/customizer_entry/organ/genitals/butt
	var/butt_size = DEFAULT_BUTT_SIZE

/datum/customizer/organ/genitals/butt
	abstract_type = /datum/customizer/organ/genitals/butt
	name = "Butt"
	allows_disabling = TRUE
	default_disabled = FALSE

/datum/customizer_choice/organ/genitals/butt
	abstract_type = /datum/customizer_choice/organ/genitals/butt
	name = "Butt"
	customizer_entry_type = /datum/customizer_entry/organ/genitals/butt
	organ_type = /obj/item/organ/genitals/butt
	organ_slot = ORGAN_SLOT_BUTT
	organ_dna_type = /datum/organ_dna/butt

/datum/customizer_choice/organ/genitals/butt/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/genitals/butt/butt_entry = entry
	var/max_butt_size = prefs.get_max_butt_size()
	butt_entry.butt_size = prefs.sanitize_body_size_choice(butt_entry.butt_size, MIN_BUTT_SIZE, max_butt_size, DEFAULT_BUTT_SIZE)

/datum/customizer_choice/organ/genitals/butt/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/butt/butt_dna = organ_dna
	var/datum/customizer_entry/organ/genitals/butt/butt_entry = entry
	butt_dna.butt_size = butt_entry.butt_size

/datum/customizer_choice/organ/genitals/butt/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/genitals/butt/butt_entry = entry
	var/list/butt_sizes = prefs.get_butt_size_choices()
	dat += "<br>Butt size: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=butt_size''>[find_key_by_value(butt_sizes, butt_entry.butt_size)]</a>"

/datum/customizer_choice/organ/genitals/butt/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/genitals/butt/butt_entry = entry
	switch(href_list["customizer_task"])
		if("butt_size")
			var/list/butt_sizes = prefs.get_butt_size_choices()
			var/named_size = browser_input_list(user, "Choose your butt size:", "Character Preference", butt_sizes, butt_entry.butt_size)
			if(isnull(named_size))
				return
			var/new_size = butt_sizes[named_size]
			butt_entry.butt_size = prefs.sanitize_body_size_choice(new_size, MIN_BUTT_SIZE, prefs.get_max_butt_size(), DEFAULT_BUTT_SIZE)

/datum/customizer/organ/genitals/butt/human
	customizer_choices = list(/datum/customizer_choice/organ/genitals/butt/human)

/datum/customizer_choice/organ/genitals/butt/human
	sprite_accessories = list(/datum/sprite_accessory/genitals/butt/pair)
	allows_accessory_color_customization = FALSE

/datum/customizer/organ/genitals/butt/animal
	customizer_choices = list(/datum/customizer_choice/organ/genitals/butt/animal)

/datum/customizer_choice/organ/genitals/butt/animal
	sprite_accessories = list(
		/datum/sprite_accessory/genitals/butt/pair
		)
