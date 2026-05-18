/datum/unit_test/circle_on_turf_aoe_respects_ignore_openspace
#ifdef FOCUS_SPELL_AOE_ON_TURF_TEST
	focus = TRUE
#endif
	var/turf/changed_turf
	var/original_turf_type
	var/original_baseturfs

/datum/unit_test/circle_on_turf_aoe_respects_ignore_openspace/Run()
	var/turf/center = run_loc_floor_bottom_left
	changed_turf = locate(center.x + 1, center.y, center.z)
	TEST_ASSERT_NOTNULL(changed_turf, "Expected an adjacent turf in the unit test room.")

	original_turf_type = changed_turf.type
	original_baseturfs = islist(changed_turf.baseturfs) ? changed_turf.baseturfs.Copy() : changed_turf.baseturfs

	changed_turf = changed_turf.ChangeTurf(/turf/open/openspace)
	TEST_ASSERT(isopenspace(changed_turf), "Expected test turf to become openspace.")
	TEST_ASSERT(changed_turf in circle_view_turfs(center, 1), "Expected test openspace to be inside the circle AOE.")

	var/datum/action/cooldown/spell/aoe/on_turf/circle/test_spell = allocate(/datum/action/cooldown/spell/aoe/on_turf/circle/unit_test_ignore_openspace)

	var/list/targets = test_spell.get_things_to_cast_on(center)
	TEST_ASSERT(!(changed_turf in targets), "Circle on-turf AOE included openspace despite ignore_openspace.")

/datum/unit_test/circle_on_turf_aoe_respects_ignore_openspace/Destroy()
	if(changed_turf && original_turf_type)
		changed_turf.ChangeTurf(original_turf_type, original_baseturfs)
	return ..()

/datum/action/cooldown/spell/aoe/on_turf/circle/unit_test_ignore_openspace
	charge_required = FALSE
	aoe_radius = 1
	ignore_openspace = TRUE
