/obj/effect/buildmode_search_unit_test_alpha
	name = "Alpha Search Target"
	icon = 'icons/effects/alphacolors.dmi'

/obj/effect/buildmode_search_unit_test_beta
	name = "Beta Placeholder"
	icon = 'icons/effects/alphacolors.dmi'

/datum/unit_test/buildmode_search_filters_full_category_list/Run()
	var/list/category_items = list(
		/obj/effect/buildmode_search_unit_test_alpha,
		/obj/effect/buildmode_search_unit_test_beta,
	)

	var/list/name_matches = filter_buildmode_types_for_search(category_items, "target")
	TEST_ASSERT_EQUAL(length(name_matches), 1, "Search should filter the full category list by item name.")
	TEST_ASSERT_EQUAL(name_matches[1], /obj/effect/buildmode_search_unit_test_alpha, "Search returned the wrong name match.")

	var/list/path_matches = filter_buildmode_types_for_search(category_items, "unit_test_beta")
	TEST_ASSERT_EQUAL(length(path_matches), 1, "Search should filter the full category list by type path.")
	TEST_ASSERT_EQUAL(path_matches[1], /obj/effect/buildmode_search_unit_test_beta, "Search returned the wrong path match.")

	var/list/empty_search = filter_buildmode_types_for_search(category_items, "")
	TEST_ASSERT_EQUAL(length(empty_search), length(category_items), "Empty search should leave the category list unfiltered.")
