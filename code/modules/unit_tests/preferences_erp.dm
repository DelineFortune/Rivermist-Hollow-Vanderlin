/datum/unit_test/erp_preferences_recover_from_missing_storage
#ifdef FOCUS_ERP_PREFERENCES_TEST
	focus = TRUE
#endif

/datum/unit_test/erp_preferences_recover_from_missing_storage/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.erp_preferences = null

	var/datum/erp_preference/boolean/allow_mob_breeding/boolean_pref = new
	TEST_ASSERT_EQUAL(boolean_pref.get_value(prefs), boolean_pref.default_value, "Boolean ERP preferences should use defaults when storage is missing.")

	var/datum/erp_preference/bitflag/horny_mob_types/bitflag_pref = new
	TEST_ASSERT_EQUAL(bitflag_pref.get_value(prefs), bitflag_pref.default_value, "Bitflag ERP preferences should use defaults when storage is missing.")

	var/datum/kink/bondage/kink = new
	var/kink_ui = prefs.show_kink_ui(kink)
	TEST_ASSERT_NOTNULL(kink_ui, "Kink preference UI should render when ERP storage is missing.")
	TEST_ASSERT(islist(prefs.erp_preferences), "Rendering kink preferences should initialize ERP storage.")
	TEST_ASSERT(islist(prefs.erp_preferences["kinks"]), "Rendering kink preferences should initialize kink storage.")
	TEST_ASSERT_EQUAL(prefs.erp_preferences["kinks"][kink.name]["enabled"], FALSE, "Missing kink data should use the configured default enabled state.")
	TEST_ASSERT_EQUAL(prefs.erp_preferences["kinks"][kink.name]["intensity"], 1, "Missing kink data should use the configured default intensity.")

/datum/unit_test/erp_preferences_setup_defaults
#ifdef FOCUS_ERP_PREFERENCES_TEST
	focus = TRUE
#endif

/datum/unit_test/erp_preferences_setup_defaults/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.erp_preferences = null

	prefs.setup_default_erp_preferences()

	TEST_ASSERT(islist(prefs.erp_preferences), "Default setup should initialize ERP storage.")
	TEST_ASSERT((/datum/erp_preference/boolean/allow_mob_breeding in prefs.erp_preferences), "Default setup should populate concrete ERP preferences.")
	var/datum/erp_preference/bitflag/horny_mob_types/bitflag_pref = new
	TEST_ASSERT_EQUAL(prefs.erp_preferences[bitflag_pref.type], bitflag_pref.default_value, "Default setup should populate concrete bitflag ERP preferences.")
	TEST_ASSERT(!(/datum/erp_preference/bitflag in prefs.erp_preferences), "Default setup should not populate abstract ERP preferences.")

/datum/unit_test/erp_preferences_nonmatching_horny_mobs_are_nonlethal_by_default
#ifdef FOCUS_ERP_PREFERENCES_TEST
	focus = TRUE
#endif

/datum/unit_test/erp_preferences_nonmatching_horny_mobs_are_nonlethal_by_default/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.erp_preferences = null

	prefs.setup_default_erp_preferences()

	var/datum/erp_preference/boolean/nonmatching_horny_mobs_are_nonlethal/nonlethal_pref = new
	TEST_ASSERT((nonlethal_pref.type in prefs.erp_preferences), "Default setup should populate the nonmatching horny mob handling preference.")
	TEST_ASSERT_EQUAL(nonlethal_pref.get_value(prefs), TRUE, "Nonmatching horny mobs should use nonlethal handling by default.")

	nonlethal_pref.set_value(prefs, FALSE)
	TEST_ASSERT_EQUAL(nonlethal_pref.get_value(prefs), FALSE, "Nonmatching horny mob handling should be player-configurable.")

/datum/unit_test/erp_preferences_clientless_targets_require_cached_consent
#ifdef FOCUS_ERP_PREFERENCES_TEST
	focus = TRUE
#endif

/datum/unit_test/erp_preferences_clientless_targets_require_cached_consent/Run()
	var/mob/living/simple_animal/actor = allocate(/mob/living/simple_animal)
	var/mob/living/carbon/human/target = allocate(/mob/living/carbon/human)
	var/datum/mind/target_mind = allocate(/datum/mind, "erp-pref-test")
	target_mind.current = target
	target.mind = target_mind

	TEST_ASSERT_EQUAL(target_allows_mob_erp_action(actor, target, /datum/erp_preference/boolean/allow_mob_breeding), FALSE, "Clientless ERP targets should deny intrusive mob actions unless a cached preference allows them.")
	target.mind = null
	target_mind.current = null

/datum/unit_test/erp_preferences_clientless_targets_use_cached_consent
#ifdef FOCUS_ERP_PREFERENCES_TEST
	focus = TRUE
#endif

/datum/unit_test/erp_preferences_clientless_targets_use_cached_consent/Run()
	var/mob/living/simple_animal/actor = allocate(/mob/living/simple_animal)
	var/mob/living/carbon/human/target = allocate(/mob/living/carbon/human)
	var/datum/mind/target_mind = allocate(/datum/mind, "erp-pref-cache-test")
	target_mind.current = target
	target.mind = target_mind

	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	var/datum/erp_preference/boolean/allow_mob_breeding/breeding_pref = new

	breeding_pref.set_value(prefs, FALSE)
	target.cache_erp_preferences_from_prefs(prefs)
	TEST_ASSERT_EQUAL(target_allows_mob_erp_action(actor, target, breeding_pref.type), FALSE, "Clientless targets should keep denying intrusive mob actions when their cached preference is disabled.")

	breeding_pref.set_value(prefs, TRUE)
	target.cache_erp_preferences_from_prefs(prefs)
	TEST_ASSERT_EQUAL(target_allows_mob_erp_action(actor, target, breeding_pref.type), TRUE, "Clientless targets should allow intrusive mob actions when their cached preference explicitly allows them.")
	target.mind = null
	target_mind.current = null

/datum/unit_test/erp_preferences_mind_transfer_preserves_cached_consent
#ifdef FOCUS_ERP_PREFERENCES_TEST
	focus = TRUE
#endif

/datum/unit_test/erp_preferences_mind_transfer_preserves_cached_consent/Run()
	var/mob/living/carbon/human/old_body = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/new_body = allocate(/mob/living/carbon/human)
	var/datum/mind/target_mind = allocate(/datum/mind, "erp-pref-transfer-test")
	target_mind.current = old_body
	old_body.mind = target_mind

	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	var/datum/erp_preference/boolean/allow_mob_breeding/breeding_pref = new
	breeding_pref.set_value(prefs, TRUE)
	old_body.cache_erp_preferences_from_prefs(prefs)

	target_mind.transfer_to(new_body)

	TEST_ASSERT_EQUAL(new_body.get_cached_erp_pref(breeding_pref.type), TRUE, "Mind transfers should mirror cached ERP consent onto the new body.")
	old_body.mind = null
	old_body.last_mind = null
	new_body.mind = null
	new_body.last_mind = null
	target_mind.current = null

/datum/sex_action/unit_test_disconnected_erp
	name = "Unit Test Disconnected ERP"
	check_distance = FALSE
	stamina_cost = 0

/datum/unit_test/erp_preferences_disconnected_players_deny_sex_sessions_by_default
#ifdef FOCUS_ERP_PREFERENCES_TEST
	focus = TRUE
#endif

/datum/unit_test/erp_preferences_disconnected_players_deny_sex_sessions_by_default/Run()
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/target = allocate(/mob/living/carbon/human)
	var/datum/mind/target_mind = allocate(/datum/mind, "erp-pref-disconnected-default-test")
	target_mind.current = target
	target.mind = target_mind

	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	target.cache_erp_preferences_from_prefs(prefs)

	var/datum/sex_session/session = user.start_sex_session(target, FALSE)
	if(session)
		qdel(session)
	target.mind = null
	target.last_mind = null
	target_mind.current = null

	TEST_ASSERT_NULL(session, "Disconnected player bodies should not accept player ERP sessions by default.")

/datum/unit_test/erp_preferences_disconnected_players_allow_sex_sessions_when_enabled
#ifdef FOCUS_ERP_PREFERENCES_TEST
	focus = TRUE
#endif

/datum/unit_test/erp_preferences_disconnected_players_allow_sex_sessions_when_enabled/Run()
	var/disconnected_pref_type = text2path("/datum/erp_preference/boolean/allow_player_erp_when_disconnected")
	TEST_ASSERT_NOTNULL(disconnected_pref_type, "The disconnected-player ERP preference should exist.")

	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/target = allocate(/mob/living/carbon/human)
	var/datum/mind/target_mind = allocate(/datum/mind, "erp-pref-disconnected-enabled-test")
	target_mind.current = target
	target.mind = target_mind

	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	var/datum/erp_preference/boolean/disconnected_pref = new disconnected_pref_type
	disconnected_pref.set_value(prefs, TRUE)
	target.cache_erp_preferences_from_prefs(prefs)

	var/datum/sex_session/session = user.start_sex_session(target, FALSE)
	var/session_created = !isnull(session)
	if(session)
		qdel(session)
	target.mind = null
	target.last_mind = null
	target_mind.current = null

	TEST_ASSERT(session_created, "Disconnected player bodies should accept player ERP sessions when their cached preference allows it.")

/datum/unit_test/erp_preferences_disconnected_players_block_existing_sex_actions
#ifdef FOCUS_ERP_PREFERENCES_TEST
	focus = TRUE
#endif

/datum/unit_test/erp_preferences_disconnected_players_block_existing_sex_actions/Run()
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/target = allocate(/mob/living/carbon/human)
	var/datum/mind/target_mind = allocate(/datum/mind, "erp-pref-disconnected-action-test")
	target_mind.current = target
	target.mind = target_mind

	var/datum/preferences/prefs = allocate(/datum/preferences)
	prefs.setup_default_erp_preferences()
	target.cache_erp_preferences_from_prefs(prefs)

	var/datum/sex_session/session = allocate(/datum/sex_session, user, target)
	var/can_perform = session.can_perform_action(/datum/sex_action/unit_test_disconnected_erp)
	target.mind = null
	target.last_mind = null
	target_mind.current = null

	TEST_ASSERT_EQUAL(can_perform, FALSE, "Existing sex sessions should not perform actions with disconnected player bodies that have not opted in.")
