/mob/living/carbon/human/species/elf
	race = /datum/species/elf

/datum/species/elf
	name = "Elfb"
	id = SPEC_ID_ELF
	changesource_flags = WABBAJACK
	native_language = "Elfish"
	exotic_bloodtype = /datum/blood_type/human/elf
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)

	offset_genitals_m = list(
		OFFSET_PENIS = list(0,0),\
		OFFSET_BREASTS = list(0,0),\
		OFFSET_TESTICLES = list(0,0),\
		OFFSET_VAGINA = list(0,0),\
	)

	offset_genitals_f = list(
		OFFSET_PENIS = list(0,0),\
		OFFSET_BREASTS = list(0,0),\
		OFFSET_TESTICLES = list(0,0),\
		OFFSET_VAGINA = list(0,-1),\
	)

/datum/species/elf/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)
	C.grant_language(/datum/language/elvish)

/datum/species/elf/check_roundstart_eligible()
	return FALSE

/datum/species/elf/after_creation(mob/living/carbon/C)
	..()
	C.dna.species.accent_language = C.dna.species.get_accent(native_language, 1)
	C.grant_language(/datum/language/elvish)
	to_chat(C, "<span class='info'>I can speak Elfish with ,e before my speech.</span>")

/datum/species/elf/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/elvish)

/datum/species/elf/qualifies_for_rank(rank, list/features)
	return TRUE
