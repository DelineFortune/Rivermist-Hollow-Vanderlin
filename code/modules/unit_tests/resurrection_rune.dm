#define TEST_RUNE_STAGE_SOFT_CRIT 1
#define TEST_RUNE_THRESHOLD_SOFTCRIT 45

/datum/unit_test/resurrection_rune_sleeping_above_crit_is_not_rescue_eligible
#ifdef FOCUS_RESURRECTION_RUNE_TEST
	focus = TRUE
#endif

/datum/unit_test/resurrection_rune_sleeping_above_crit_is_not_rescue_eligible/Run()
	var/datum/resurrection_rune_controller/controller = allocate(/datum/resurrection_rune_controller)
	var/mob/living/carbon/human/sleeper = allocate(/mob/living/carbon/human)

	sleeper.set_health(sleeper.crit_threshold + 30)
	TEST_ASSERT(sleeper.Sleeping(1 MINUTES), "Test human should be able to fall asleep.")
	TEST_ASSERT(sleeper.IsSleeping(), "Test human should be sleeping.")

	var/rescue_stage = controller.get_rescue_stage(sleeper)
	TEST_ASSERT_EQUAL(rescue_stage, 0, "Sleeping above actual crit should not count as a resurrection rune rescue state.")

/datum/unit_test/resurrection_rune_sleeping_at_crit_remains_rescue_eligible
#ifdef FOCUS_RESURRECTION_RUNE_TEST
	focus = TRUE
#endif

/datum/unit_test/resurrection_rune_sleeping_at_crit_remains_rescue_eligible/Run()
	var/datum/resurrection_rune_controller/controller = allocate(/datum/resurrection_rune_controller)
	var/mob/living/carbon/human/sleeper = allocate(/mob/living/carbon/human)

	sleeper.set_health(sleeper.crit_threshold)
	TEST_ASSERT(sleeper.Sleeping(1 MINUTES), "Test human should be able to fall asleep.")
	TEST_ASSERT(sleeper.IsSleeping(), "Test human should be sleeping.")

	var/rescue_stage = controller.get_rescue_stage(sleeper)
	TEST_ASSERT_NOTEQUAL(rescue_stage, 0, "Sleeping in actual crit should still count as a resurrection rune rescue state.")

/datum/unit_test/resurrection_rune_counts_new_bodypart_injuries
#ifdef FOCUS_RESURRECTION_RUNE_TEST
	focus = TRUE
#endif

/datum/unit_test/resurrection_rune_counts_new_bodypart_injuries/Run()
	var/datum/resurrection_rune_controller/controller = allocate(/datum/resurrection_rune_controller)
	var/mob/living/carbon/human/injured = allocate(/mob/living/carbon/human)

	var/remaining_damage = injured.maxHealth - TEST_RUNE_THRESHOLD_SOFTCRIT + 5
	for(var/obj/item/bodypart/bodypart as anything in injured.bodyparts)
		var/bodypart_capacity = bodypart.max_damage - bodypart.get_damage()
		if(bodypart_capacity <= 0)
			continue
		var/injury_damage = min(remaining_damage, bodypart_capacity)
		bodypart.create_injury(WOUND_SLASH, injury_damage)
		bodypart.update_damages()
		remaining_damage -= injury_damage
		if(remaining_damage <= 0)
			break

	injured.updatehealth()

	TEST_ASSERT(remaining_damage <= 0, "Test setup should apply enough injury pressure to cross the rune soft-crit threshold.")
	TEST_ASSERT(injured.getBruteLoss() > injured.maxHealth - TEST_RUNE_THRESHOLD_SOFTCRIT, "Test setup should create visible bodypart injury damage.")
	TEST_ASSERT_EQUAL(injured.health, injured.maxHealth, "Human health currently ignores ordinary bodypart injury, which is the regression this rune test covers.")
	var/rescue_stage = controller.get_rescue_stage(injured)
	TEST_ASSERT_EQUAL(rescue_stage, TEST_RUNE_STAGE_SOFT_CRIT, "The resurrection rune should treat serious new bodypart injuries as rescue-worthy even when health has not dropped.")

#undef TEST_RUNE_STAGE_SOFT_CRIT
#undef TEST_RUNE_THRESHOLD_SOFTCRIT

/*
/datum/unit_test/resurrection_rune_outlaw_voluntary_call_uses_linked_rune
#ifdef FOCUS_RESURRECTION_RUNE_TEST
	focus = TRUE
#endif
	var/list/old_global_resurrunes
	var/list/old_global_resurrune_markers
	var/list/old_outlawed_players

/datum/unit_test/resurrection_rune_outlaw_voluntary_call_uses_linked_rune/New()
	. = ..()
	old_global_resurrunes = GLOB.global_resurrunes
	old_global_resurrune_markers = GLOB.global_resurrune_markers
	old_outlawed_players = GLOB.outlawed_players
	GLOB.global_resurrunes = list()
	GLOB.global_resurrune_markers = list()
	GLOB.outlawed_players = list()

/datum/unit_test/resurrection_rune_outlaw_voluntary_call_uses_linked_rune/Destroy()
	. = ..()
	GLOB.global_resurrunes = old_global_resurrunes
	GLOB.global_resurrune_markers = old_global_resurrune_markers
	GLOB.outlawed_players = old_outlawed_players

/datum/unit_test/resurrection_rune_outlaw_voluntary_call_uses_linked_rune/Run()
	var/turf/city_turf = run_loc_floor_bottom_left
	var/turf/outlaw_turf = locate(city_turf.x + 2, city_turf.y, city_turf.z)
	var/turf/body_turf = locate(city_turf.x + 4, city_turf.y, city_turf.z)
	TEST_ASSERT(isturf(outlaw_turf), "Outlaw rune test turf should exist.")
	TEST_ASSERT(isturf(body_turf), "Outlaw body test turf should exist.")

	var/obj/structure/resurrection_rune/city/city_rune = allocate(/obj/structure/resurrection_rune/city, city_turf)
	var/obj/structure/resurrection_rune/outlaw/outlaw_rune = allocate(/obj/structure/resurrection_rune/outlaw, outlaw_turf)
	city_rune.destination_radius = 0
	outlaw_rune.destination_radius = 0

	var/mob/living/carbon/human/outlaw = allocate(/mob/living/carbon/human, body_turf)
	outlaw.real_name = "Wanted Unit Test Outlaw"
	GLOB.outlawed_players |= outlaw.real_name

	var/turf/forced_destination = city_rune.get_resurrection_destination(body = outlaw)
	TEST_ASSERT_EQUAL(forced_destination, outlaw_turf, "Forceful Outlaw resurrection should still use the Outlaw rune.")

	var/turf/voluntary_destination = city_rune.get_resurrection_destination(body = outlaw, allow_outlaw_redirect = FALSE)
	TEST_ASSERT_EQUAL(voluntary_destination, city_turf, "Voluntary Outlaw resurrection should use the normally linked rune.")*/
