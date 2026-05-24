/datum/unit_test/bellyriding_jdeer_uses_dedicated_victim_offset/Run()
	var/obj/item/bodypart/taur/jdeer/jdeer_body = allocate(/obj/item/bodypart/taur/jdeer)

	TEST_ASSERT_EQUAL(jdeer_body.body_offset_y, 17, "Jenny Body should keep its raised wearer body offset.")
	TEST_ASSERT_EQUAL(jdeer_body.bellyride_victim_y_offset, 9, "Jenny Body should use a separate bellyrider victim offset.")

/datum/unit_test/bellyriding_penetrative_actions_route_internal_climax/Run()
	var/datum/sex_action/bellyriding/anal/anal_action = new
	var/datum/sex_action/bellyriding/vaginal/vaginal_action = new

	TEST_ASSERT_EQUAL(anal_action.hole_id, ORGAN_SLOT_ANUS, "Anal bellyriding should target the victim's anus for climax transfer.")
	TEST_ASSERT_EQUAL(vaginal_action.hole_id, ORGAN_SLOT_VAGINA, "Vaginal bellyriding should target the victim's vagina for climax transfer.")
	TEST_ASSERT_EQUAL(anal_action.handle_climax_message(null, null, FALSE), ORGASM_LOCATION_INTO, "Anal bellyriding should deposit into the target when the harness wearer climaxes.")
	TEST_ASSERT_EQUAL(vaginal_action.handle_climax_message(null, null, FALSE), ORGASM_LOCATION_INTO, "Vaginal bellyriding should deposit into the target when the harness wearer climaxes.")

	qdel(anal_action)
	qdel(vaginal_action)
