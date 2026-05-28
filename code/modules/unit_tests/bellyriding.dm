/datum/unit_test/bellyriding_penetrative_actions_route_internal_climax/Run()
	var/datum/sex_action/bellyriding/anal/anal_action = new
	var/datum/sex_action/bellyriding/vaginal/vaginal_action = new

	TEST_ASSERT_EQUAL(anal_action.hole_id, ORGAN_SLOT_ANUS, "Anal bellyriding should target the victim's anus for climax transfer.")
	TEST_ASSERT_EQUAL(vaginal_action.hole_id, ORGAN_SLOT_VAGINA, "Vaginal bellyriding should target the victim's vagina for climax transfer.")
	TEST_ASSERT_EQUAL(anal_action.handle_climax_message(null, null, FALSE), ORGASM_LOCATION_INTO, "Anal bellyriding should deposit into the target when the harness wearer climaxes.")
	TEST_ASSERT_EQUAL(vaginal_action.handle_climax_message(null, null, FALSE), ORGASM_LOCATION_INTO, "Vaginal bellyriding should deposit into the target when the harness wearer climaxes.")

	qdel(anal_action)
	qdel(vaginal_action)
