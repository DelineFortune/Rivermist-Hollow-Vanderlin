/proc/belly_fullness_visible_state(obj/item/organ/genitals/belly/belly, mob/living/carbon/owner)
	var/datum/sprite_accessory/genitals/belly/accessory = SPRITE_ACCESSORY(/datum/sprite_accessory/genitals/belly)
	return accessory.get_icon_state(belly, null, owner)

/proc/belly_fullness_make_average_fake_penis()
	var/obj/item/penis_fake/fake = new
	fake.body_storage_bulk = WEIGHT_CLASS_SMALL * DEFAULT_PENIS_SIZE
	return fake

/datum/unit_test/belly_fullness_keeps_resting_size_when_reinserted
#ifdef FOCUS_BELLY_FULLNESS_TEST
	focus = TRUE
#endif

/datum/unit_test/belly_fullness_keeps_resting_size_when_reinserted/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/belly/belly = allocate(/obj/item/organ/genitals/belly)
	belly.resting_size = BELLY_SIZE_FLAT
	belly.organ_size = BELLY_SIZE_MEDIUM

	belly.Insert(human, TRUE, FALSE)

	TEST_ASSERT_EQUAL(belly.resting_size, BELLY_SIZE_FLAT, "Temporary belly display size should not become the resting size when inserted.")

/datum/unit_test/belly_fullness_single_average_inner_insert_stays_flat
#ifdef FOCUS_BELLY_FULLNESS_TEST
	focus = TRUE
#endif

/datum/unit_test/belly_fullness_single_average_inner_insert_stays_flat/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/belly/belly = allocate(/obj/item/organ/genitals/belly)
	belly.resting_size = BELLY_SIZE_FLAT
	belly.organ_size = BELLY_SIZE_FLAT
	belly.Insert(human, TRUE, FALSE)

	var/obj/item/organ/guts/guts = human.getorganslot(ORGAN_SLOT_GUTS)
	if(!guts)
		guts = allocate(/obj/item/organ/guts)
		guts.Insert(human, TRUE)

	var/obj/item/penis_fake/fake = belly_fullness_make_average_fake_penis()
	var/fit_result = SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_INSERT, fake, STORAGE_LAYER_INNER, FALSE)

	TEST_ASSERT(fit_result in list(INSERT_FEEDBACK_OK, INSERT_FEEDBACK_OK_FORCE, INSERT_FEEDBACK_OK_OVERRIDE, INSERT_FEEDBACK_ALMOST_FULL), "Average fake penis should fit in inner storage for this regression.")
	TEST_ASSERT_EQUAL(belly_fullness_visible_state(belly, human), "pair_[BELLY_SIZE_FLAT]", "A single average inner insertion should not visibly grow the belly.")

/datum/unit_test/belly_fullness_multiple_average_inner_insertions_show
#ifdef FOCUS_BELLY_FULLNESS_TEST
	focus = TRUE
#endif

/datum/unit_test/belly_fullness_multiple_average_inner_insertions_show/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/belly/belly = allocate(/obj/item/organ/genitals/belly)
	belly.resting_size = BELLY_SIZE_FLAT
	belly.organ_size = BELLY_SIZE_FLAT
	belly.Insert(human, TRUE, FALSE)

	var/obj/item/organ/guts/guts = human.getorganslot(ORGAN_SLOT_GUTS)
	if(!guts)
		guts = allocate(/obj/item/organ/guts)
		guts.Insert(human, TRUE)

	var/obj/item/penis_fake/first_fake = belly_fullness_make_average_fake_penis()
	var/obj/item/penis_fake/second_fake = belly_fullness_make_average_fake_penis()
	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_INSERT, first_fake, STORAGE_LAYER_INNER, FALSE)
	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_INSERT, second_fake, STORAGE_LAYER_INNER, FALSE)

	TEST_ASSERT_NOTEQUAL(belly_fullness_visible_state(belly, human), "pair_[BELLY_SIZE_FLAT]", "Multiple average inner insertions should visibly grow the belly.")
	TEST_ASSERT_EQUAL(belly.organ_size, BELLY_SIZE_FLAT, "Fullness should be a transient display offset, not a mutation of the saved belly size.")

/datum/unit_test/belly_fullness_deflates_when_inner_bulk_is_removed
#ifdef FOCUS_BELLY_FULLNESS_TEST
	focus = TRUE
#endif

/datum/unit_test/belly_fullness_deflates_when_inner_bulk_is_removed/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/belly/belly = allocate(/obj/item/organ/genitals/belly)
	belly.resting_size = BELLY_SIZE_FLAT
	belly.organ_size = BELLY_SIZE_FLAT
	belly.Insert(human, TRUE, FALSE)

	var/obj/item/organ/guts/guts = human.getorganslot(ORGAN_SLOT_GUTS)
	if(!guts)
		guts = allocate(/obj/item/organ/guts)
		guts.Insert(human, TRUE)

	var/obj/item/penis_fake/first_fake = belly_fullness_make_average_fake_penis()
	var/obj/item/penis_fake/second_fake = belly_fullness_make_average_fake_penis()
	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_INSERT, first_fake, STORAGE_LAYER_INNER, FALSE)
	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_INSERT, second_fake, STORAGE_LAYER_INNER, FALSE)
	TEST_ASSERT_NOTEQUAL(belly_fullness_visible_state(belly, human), "pair_[BELLY_SIZE_FLAT]", "The test setup should visibly grow the belly first.")

	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_REMOVE, first_fake, STORAGE_LAYER_INNER, BODYSTORAGE_REMOVE_MANUAL)
	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_REMOVE, second_fake, STORAGE_LAYER_INNER, BODYSTORAGE_REMOVE_MANUAL)

	TEST_ASSERT_EQUAL(belly_fullness_visible_state(belly, human), "pair_[BELLY_SIZE_FLAT]", "Removing the inner bulk should deflate the visible belly.")

/datum/unit_test/belly_fullness_messages_are_cooldowned
#ifdef FOCUS_BELLY_FULLNESS_TEST
	focus = TRUE
#endif

/datum/unit_test/belly_fullness_messages_are_cooldowned/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/belly/belly = allocate(/obj/item/organ/genitals/belly)
	belly.resting_size = BELLY_SIZE_FLAT
	belly.organ_size = BELLY_SIZE_FLAT
	belly.Insert(human, TRUE, FALSE)

	var/datum/component/belly_fullness/fullness = belly.GetComponent(/datum/component/belly_fullness)
	TEST_ASSERT_NOTNULL(fullness, "Inserted belly should have a fullness component.")
	TEST_ASSERT(!fullness.vars["fullness_expand_message_cooldown"], "Initial belly fullness sync should not start the expansion message cooldown.")
	TEST_ASSERT(!fullness.vars["fullness_shrink_message_cooldown"], "Initial belly fullness sync should not start the shrink message cooldown.")

	var/obj/item/organ/guts/guts = human.getorganslot(ORGAN_SLOT_GUTS)
	if(!guts)
		guts = allocate(/obj/item/organ/guts)
		guts.Insert(human, TRUE)

	var/obj/item/penis_fake/first_fake = belly_fullness_make_average_fake_penis()
	var/obj/item/penis_fake/second_fake = belly_fullness_make_average_fake_penis()
	var/obj/item/penis_fake/third_fake = belly_fullness_make_average_fake_penis()
	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_INSERT, first_fake, STORAGE_LAYER_INNER, FALSE)
	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_INSERT, second_fake, STORAGE_LAYER_INNER, FALSE)

	TEST_ASSERT(fullness.vars["fullness_expand_message_cooldown"] > world.time, "Visible belly expansion should start the expansion message cooldown.")
	TEST_ASSERT(!fullness.vars["fullness_shrink_message_cooldown"], "Expansion should not start the shrink message cooldown.")
	var/first_expand_cooldown = fullness.vars["fullness_expand_message_cooldown"]

	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_INSERT, third_fake, STORAGE_LAYER_INNER, TRUE)
	TEST_ASSERT_EQUAL(fullness.vars["fullness_expand_message_cooldown"], first_expand_cooldown, "Repeated visible belly expansion should not restart the message cooldown.")

	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_REMOVE, third_fake, STORAGE_LAYER_INNER, BODYSTORAGE_REMOVE_MANUAL)
	TEST_ASSERT(fullness.vars["fullness_shrink_message_cooldown"] > world.time, "Visible belly shrinkage should start the shrink message cooldown.")
	var/first_shrink_cooldown = fullness.vars["fullness_shrink_message_cooldown"]

	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_TRY_REMOVE, first_fake, STORAGE_LAYER_INNER, BODYSTORAGE_REMOVE_MANUAL)
	TEST_ASSERT_EQUAL(fullness.vars["fullness_shrink_message_cooldown"], first_shrink_cooldown, "Repeated visible belly shrinkage should not restart the message cooldown.")

/datum/unit_test/body_storage_random_layer_swap_leaves_fake_penis_inner
#ifdef FOCUS_BELLY_FULLNESS_TEST
	focus = TRUE
#endif

/datum/unit_test/body_storage_random_layer_swap_leaves_fake_penis_inner/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	vagina.Insert(human, TRUE, FALSE)
	var/datum/component/body_storage/storage = vagina.GetComponent(/datum/component/body_storage)
	TEST_ASSERT_NOTNULL(storage, "Inserted vagina should have body storage.")

	var/obj/item/penis_fake/fake = belly_fullness_make_average_fake_penis()
	SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_TRY_INSERT, fake, STORAGE_LAYER_INNER, TRUE)
	SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_SWAP_LAYERS_RAND, STORAGE_LAYER_INNER, STORAGE_LAYER_DEEP, TRUE)

	TEST_ASSERT(fake in storage.all_layers[STORAGE_LAYER_INNER], "Fake penises should stay in inner storage when random layer swaps occur.")
	TEST_ASSERT(!(fake in storage.all_layers[STORAGE_LAYER_DEEP]), "Fake penises should not be randomly moved to deep storage.")

/datum/unit_test/sex_action_removes_stored_item_from_actual_layer
#ifdef FOCUS_BELLY_FULLNESS_TEST
	focus = TRUE
#endif

/datum/unit_test/sex_action_removes_stored_item_from_actual_layer/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	vagina.Insert(human, TRUE, FALSE)
	var/datum/component/body_storage/storage = vagina.GetComponent(/datum/component/body_storage)
	TEST_ASSERT_NOTNULL(storage, "Inserted vagina should have body storage.")

	var/obj/item/penis_fake/fake = belly_fullness_make_average_fake_penis()
	SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_FORCE_INSERT, fake, STORAGE_LAYER_DEEP)
	TEST_ASSERT(fake in storage.all_layers[STORAGE_LAYER_DEEP], "The test setup should place the fake penis in deep storage.")

	var/datum/sex_action/sex/vaginal/action = allocate(/datum/sex_action/sex/vaginal)
	action.tracked_storage += new /datum/storage_tracking_entry(fake, human, ORGAN_SLOT_VAGINA, human)

	action.remove_from_hole(human, human, TRUE)

	TEST_ASSERT(!(fake in storage.all_layers[STORAGE_LAYER_DEEP]), "Sex action cleanup should remove stored items from their actual layer.")
	TEST_ASSERT_EQUAL(storage.layer_storage_cur_bulk[STORAGE_LAYER_DEEP], 0, "Sex action cleanup should clear deep-layer bulk for removed items.")
