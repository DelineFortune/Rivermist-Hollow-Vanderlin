/datum/unit_test/leech_variants_validate_target_slots
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/leech_variants_validate_target_slots/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	var/datum/erp_preference/boolean/allow_horny_leeches/horny_pref = new
	horny_pref.set_value(prefs, TRUE)
	var/datum/erp_preference/boolean/allow_forced_lactation/lactation_pref = new
	lactation_pref.set_value(prefs, TRUE)
	human.cache_erp_preferences_from_prefs(prefs)

	var/obj/item/organ/genitals/penis/penis = allocate(/obj/item/organ/genitals/penis)
	penis.Insert(human, TRUE, FALSE)
	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	vagina.Insert(human, TRUE, FALSE)
	var/obj/item/organ/genitals/filling_organ/anus/anus = allocate(/obj/item/organ/genitals/filling_organ/anus)
	anus.Insert(human, TRUE, FALSE)
	var/obj/item/organ/genitals/filling_organ/breasts/breasts = allocate(/obj/item/organ/genitals/filling_organ/breasts)
	breasts.Insert(human, TRUE, FALSE)
	var/obj/item/organ/genitals/nipple/left/left_nipple = allocate(/obj/item/organ/genitals/nipple/left)
	left_nipple.Insert(human, TRUE, FALSE)

	var/obj/item/natural/worms/leech/erotic/basic/basic = allocate(/obj/item/natural/worms/leech/erotic/basic)
	TEST_ASSERT(basic.can_attach_to_organ(human, penis), "Basic leeches should accept penises.")
	TEST_ASSERT(basic.can_attach_to_organ(human, vagina), "Basic leeches should accept vaginas.")
	TEST_ASSERT(basic.can_attach_to_organ(human, anus), "Basic leeches should accept anuses.")
	TEST_ASSERT(basic.can_attach_to_organ(human, left_nipple), "Basic leeches should accept nipples.")

	var/obj/item/natural/worms/leech/erotic/milky/milky = allocate(/obj/item/natural/worms/leech/erotic/milky)
	TEST_ASSERT(milky.can_attach_to_organ(human, left_nipple), "Milky leeches should accept nipples when breasts and forced lactation are allowed.")
	TEST_ASSERT(!milky.can_attach_to_organ(human, penis), "Milky leeches should not accept penises.")

	var/obj/item/natural/worms/leech/erotic/burrowing/burrowing = allocate(/obj/item/natural/worms/leech/erotic/burrowing)
	TEST_ASSERT(burrowing.can_attach_to_organ(human, vagina), "Burrowing leeches should accept vaginas.")
	TEST_ASSERT(burrowing.can_attach_to_organ(human, anus), "Burrowing leeches should accept anuses.")
	TEST_ASSERT(!burrowing.can_attach_to_organ(human, penis), "Burrowing leeches should not accept penises.")

	var/obj/item/natural/worms/leech/erotic/condom/condom = allocate(/obj/item/natural/worms/leech/erotic/condom)
	TEST_ASSERT(condom.can_attach_to_organ(human, penis), "Condom leeches should accept penises.")
	TEST_ASSERT(!condom.can_attach_to_organ(human, vagina), "Condom leeches should not accept vaginas.")

/datum/unit_test/milky_leech_requires_breasts
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/milky_leech_requires_breasts/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	var/datum/erp_preference/boolean/allow_horny_leeches/horny_pref = new
	horny_pref.set_value(prefs, TRUE)
	var/datum/erp_preference/boolean/allow_forced_lactation/lactation_pref = new
	lactation_pref.set_value(prefs, TRUE)
	human.cache_erp_preferences_from_prefs(prefs)

	var/obj/item/organ/genitals/nipple/left/left_nipple = allocate(/obj/item/organ/genitals/nipple/left)
	left_nipple.Insert(human, TRUE, FALSE)
	var/obj/item/natural/worms/leech/erotic/milky/milky = allocate(/obj/item/natural/worms/leech/erotic/milky)

	TEST_ASSERT(!milky.can_attach_to_organ(human, left_nipple), "Milky leeches should reject nipples when the host has no breasts to lactate.")

/datum/unit_test/lactation_inducer_restores_refilling_state
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/lactation_inducer_restores_refilling_state/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/filling_organ/breasts/breasts = allocate(/obj/item/organ/genitals/filling_organ/breasts)
	breasts.Insert(human, TRUE, FALSE)
	breasts.refilling = FALSE

	breasts.add_temporary_lactation_source("unit_test")
	TEST_ASSERT(breasts.refilling, "Temporary lactation should enable breast refilling.")
	breasts.remove_temporary_lactation_source("unit_test")
	TEST_ASSERT(!breasts.refilling, "Temporary lactation should restore a previously disabled refilling state.")

	breasts.refilling = TRUE
	breasts.add_temporary_lactation_source("unit_test")
	breasts.remove_temporary_lactation_source("unit_test")
	TEST_ASSERT(breasts.refilling, "Temporary lactation should preserve a previously enabled refilling state.")

/datum/unit_test/lactation_induced_breasts_refill_through_organ_life
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/lactation_induced_breasts_refill_through_organ_life/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	human.nutrition = NUTRITION_LEVEL_WELL_FED + 100
	var/obj/item/organ/genitals/filling_organ/breasts/breasts = allocate(/obj/item/organ/genitals/filling_organ/breasts)
	breasts.Insert(human, TRUE, FALSE)
	breasts.reagents.clear_reagents()
	breasts.refilling = FALSE
	breasts.add_temporary_lactation_source("unit_test")

	human.handle_organs(1, 1)

	TEST_ASSERT(breasts.reagents.total_volume > 0, "Lactation-induced breasts should refill through the normal organ life processing path.")

/datum/unit_test/lactation_inducer_reagent_refills_breasts_through_organ_life
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/lactation_inducer_reagent_refills_breasts_through_organ_life/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	human.nutrition = NUTRITION_LEVEL_WELL_FED + 100
	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	var/datum/erp_preference/boolean/allow_forced_lactation/lactation_pref = new
	lactation_pref.set_value(prefs, TRUE)
	human.cache_erp_preferences_from_prefs(prefs)

	var/obj/item/organ/genitals/filling_organ/breasts/breasts = allocate(/obj/item/organ/genitals/filling_organ/breasts)
	breasts.Insert(human, TRUE, FALSE)
	breasts.reagents.clear_reagents()
	breasts.refilling = FALSE
	human.reagents.add_reagent(/datum/reagent/consumable/lactation_inducer, 1)

	human.reagents.metabolize(human)
	human.handle_organs(1, 1)

	TEST_ASSERT(breasts.refilling, "The lactation inducer reagent should enable breast refilling while present.")
	TEST_ASSERT(breasts.reagents.total_volume > 0, "The lactation inducer reagent should let breasts refill through the normal organ life processing path.")

/datum/unit_test/leech_important_feedback_bypasses_ambient_cooldown
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/leech_important_feedback_bypasses_ambient_cooldown/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/natural/worms/leech/erotic/burrowing/burrowing = allocate(/obj/item/natural/worms/leech/erotic/burrowing)
	burrowing.next_feedback_time = world.time + 5 MINUTES

	TEST_ASSERT(burrowing.feedback(human, span_warning("test leech message"), TRUE), "Important leech feedback should bypass the ambient feedback cooldown.")

/datum/unit_test/leech_squeeze_fluids_uses_primary_attack
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/leech_squeeze_fluids_uses_primary_attack/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/natural/worms/leech/leech = allocate(/obj/item/natural/worms/leech)
	var/obj/item/reagent_containers/glass/glass = allocate(/obj/item/reagent_containers/glass)
	leech.reagents.add_reagent(/datum/reagent/consumable/milk, 10)

	TEST_ASSERT(leech.pre_attack(glass, human, list()), "Left-clicking a reagent container with a leech should squeeze stored fluids and stop the normal attack chain.")
	TEST_ASSERT_EQUAL(glass.reagents.total_volume, 5, "Left-click squeezing should transfer five units into the container.")
	TEST_ASSERT_EQUAL(leech.reagents.total_volume, 5, "Left-click squeezing should remove transferred fluid from the leech.")

	var/obj/item/natural/worms/leech/right_click_leech = allocate(/obj/item/natural/worms/leech)
	var/obj/item/reagent_containers/glass/right_click_glass = allocate(/obj/item/reagent_containers/glass)
	right_click_leech.reagents.add_reagent(/datum/reagent/consumable/milk, 10)
	var/list/right_click_modifiers = list()
	right_click_modifiers[RIGHT_CLICK] = TRUE

	TEST_ASSERT(!right_click_leech.pre_attack(right_click_glass, human, right_click_modifiers), "Right-clicking a reagent container with a leech should not squeeze fluids, leaving submerge behavior available.")
	TEST_ASSERT_EQUAL(right_click_glass.reagents.total_volume, 0, "Right-click should not move fluid into the container during leech pre-attack.")
	TEST_ASSERT_EQUAL(right_click_leech.reagents.total_volume, 10, "Right-click should not remove fluid from the leech during leech pre-attack.")

/datum/unit_test/leech_grab_path_finds_and_pulls_off_attached_leech
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/leech_grab_path_finds_and_pulls_off_attached_leech/Run()
	var/mob/living/carbon/human/host = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/helper = allocate(/mob/living/carbon/human)
	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	var/datum/erp_preference/boolean/allow_horny_leeches/horny_pref = new
	horny_pref.set_value(prefs, TRUE)
	host.cache_erp_preferences_from_prefs(prefs)

	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	vagina.Insert(host, TRUE, FALSE)
	var/obj/item/natural/worms/leech/erotic/burrowing/burrowing = allocate(/obj/item/natural/worms/leech/erotic/burrowing)

	TEST_ASSERT(burrowing.attach_to_organ(host, vagina, STORAGE_LAYER_OUTER, TRUE), "The test burrowing leech should attach to the host.")
	TEST_ASSERT(host.get_grabbable_leech_for_zone(BODY_ZONE_PRECISE_GROIN) == burrowing, "Grabbing the host's groin should target the attached leech.")
	TEST_ASSERT(burrowing.pull_off_host(helper, host, null, vagina), "Pulling off an attached leech should always succeed once the leech is still present.")
	TEST_ASSERT(!SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_FIND_ITEM_LAYER, burrowing), "The pulled leech should no longer be inside the host organ storage.")
	TEST_ASSERT(!QDELETED(burrowing), "Pulling off a leech should preserve the item.")

/datum/unit_test/burrowing_leech_egg_laying_requires_both_prefs
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/burrowing_leech_egg_laying_requires_both_prefs/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	vagina.Insert(human, TRUE, FALSE)
	var/obj/item/natural/worms/leech/erotic/burrowing/burrowing = allocate(/obj/item/natural/worms/leech/erotic/burrowing)

	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	var/datum/erp_preference/boolean/allow_horny_leeches/horny_pref = new
	horny_pref.set_value(prefs, TRUE)
	var/datum/erp_preference/boolean/allow_mob_oviposition/oviposition_pref = new
	oviposition_pref.set_value(prefs, TRUE)
	var/datum/erp_preference/boolean/allow_mob_breeding/breeding_pref = new
	breeding_pref.set_value(prefs, FALSE)
	human.cache_erp_preferences_from_prefs(prefs)

	TEST_ASSERT(!burrowing.can_lay_leech_egg(human, vagina), "Burrowing leeches should not lay eggs unless breeding is also allowed.")

	breeding_pref.set_value(prefs, TRUE)
	human.cache_erp_preferences_from_prefs(prefs)
	TEST_ASSERT(burrowing.can_lay_leech_egg(human, vagina), "Burrowing leeches should lay eggs when both breeding and oviposition are allowed.")

/datum/unit_test/leech_egg_profile_hatches_burrowing_leech_item
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/leech_egg_profile_hatches_burrowing_leech_item/Run()
	var/datum/oviposition_egg_profile/profile = get_oviposition_egg_profile(OVI_EGG_LEECH)

	TEST_ASSERT_EQUAL(profile.requires_fertilization, FALSE, "Leech eggs should not require fertilization.")
	TEST_ASSERT_EQUAL(profile.incubation_stage_duration, 90 SECONDS, "Leech eggs should advance through 90 second stages.")
	TEST_ASSERT_EQUAL(profile.hatch_result_type, /obj/item/natural/worms/leech/erotic/burrowing, "Leech eggs should hatch into burrowing leeches.")
	TEST_ASSERT(profile.hatch_inside_host, "Leech eggs should hatch inside the host when still internal.")

/datum/unit_test/condom_leech_exposes_sex_action_effect
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/condom_leech_exposes_sex_action_effect/Run()
	var/mob/living/carbon/human/wearer = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/partner = allocate(/mob/living/carbon/human)
	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	var/datum/erp_preference/boolean/allow_horny_leeches/horny_pref = new
	horny_pref.set_value(prefs, TRUE)
	wearer.cache_erp_preferences_from_prefs(prefs)
	partner.cache_erp_preferences_from_prefs(prefs)

	var/obj/item/organ/genitals/penis/penis = allocate(/obj/item/organ/genitals/penis)
	penis.Insert(wearer, TRUE, FALSE)
	var/obj/item/natural/worms/leech/erotic/condom/condom = allocate(/obj/item/natural/worms/leech/erotic/condom)
	var/fit_result = SEND_SIGNAL(penis, COMSIG_BODYSTORAGE_TRY_INSERT, condom, STORAGE_LAYER_OUTER, TRUE)
	TEST_ASSERT(fit_result in list(INSERT_FEEDBACK_OK, INSERT_FEEDBACK_OK_FORCE, INSERT_FEEDBACK_OK_OVERRIDE, INSERT_FEEDBACK_ALMOST_FULL), "The condom leech should fit on the test penis.")
	var/datum/sex_action_effect_context/context = new(wearer, partner, null, wearer, partner, TRUE)
	var/list/effects = condom.get_sex_action_effects(context)

	TEST_ASSERT_EQUAL(length(effects), 1, "A condom leech should expose exactly one sex action effect.")
	for(var/datum/sex_action_effect/effect as anything in effects)
		qdel(effect)

/datum/unit_test/condom_leech_consumes_climax_fluids
#ifdef FOCUS_LEECH_TEST
	focus = TRUE
#endif

/datum/unit_test/condom_leech_consumes_climax_fluids/Run()
	var/mob/living/carbon/human/wearer = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/partner = allocate(/mob/living/carbon/human)
	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	var/datum/erp_preference/boolean/allow_horny_leeches/horny_pref = new
	horny_pref.set_value(prefs, TRUE)
	wearer.cache_erp_preferences_from_prefs(prefs)
	partner.cache_erp_preferences_from_prefs(prefs)

	var/obj/item/organ/genitals/penis/penis = allocate(/obj/item/organ/genitals/penis)
	penis.Insert(wearer, TRUE, FALSE)
	var/obj/item/organ/genitals/filling_organ/testicles/testicles = allocate(/obj/item/organ/genitals/filling_organ/testicles)
	testicles.Insert(wearer, TRUE, FALSE)
	testicles.reagents.clear_reagents()
	testicles.reagents.add_reagent(/datum/reagent/consumable/cum, 20)

	var/obj/item/natural/worms/leech/erotic/condom/condom = allocate(/obj/item/natural/worms/leech/erotic/condom)
	var/fit_result = SEND_SIGNAL(penis, COMSIG_BODYSTORAGE_TRY_INSERT, condom, STORAGE_LAYER_OUTER, TRUE)
	TEST_ASSERT(fit_result in list(INSERT_FEEDBACK_OK, INSERT_FEEDBACK_OK_FORCE, INSERT_FEEDBACK_OK_OVERRIDE, INSERT_FEEDBACK_ALMOST_FULL), "The condom leech should fit on the test penis.")

	var/datum/sex_action_effect_context/context = new(wearer, partner, null, wearer, partner, TRUE)
	context.climaxer = wearer
	var/consumed = condom.consume_climax_fluids(context, testicles.reagents, 10)

	TEST_ASSERT_EQUAL(consumed, 10, "Condom leeches should consume climax fluids up to their capacity.")
	TEST_ASSERT_EQUAL(condom.reagents.total_volume, 10, "Consumed climax fluids should be stored in the condom leech.")
	TEST_ASSERT_EQUAL(testicles.reagents.total_volume, 10, "Consumed climax fluids should be removed from the source organ.")
