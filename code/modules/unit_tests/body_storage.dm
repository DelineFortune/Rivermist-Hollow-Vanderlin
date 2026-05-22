/datum/unit_test/body_storage_insert_spills_genital_liquid/Run()
	var/mob/living/carbon/human/test_subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	vagina.Insert(test_subject, TRUE, TRUE)

	TEST_ASSERT_NOTNULL(vagina.reagents, "Inserted vagina did not create a reagent holder.")

	vagina.reagents.add_reagent(/datum/reagent/water, vagina.reagents.maximum_volume)
	var/starting_volume = vagina.reagents.total_volume
	var/starting_capacity = vagina.reagents.maximum_volume

	var/obj/item/dildo/wood/dildo = allocate(/obj/item/dildo/wood)
	var/fit_result = SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_TRY_INSERT, dildo, STORAGE_LAYER_INNER, FALSE)
	TEST_ASSERT(fit_result in list(INSERT_FEEDBACK_OK, INSERT_FEEDBACK_OK_FORCE, INSERT_FEEDBACK_OK_OVERRIDE, INSERT_FEEDBACK_ALMOST_FULL), "Body storage rejected an item that should displace genital liquids.")
	TEST_ASSERT(dildo in vagina.contents, "Inserted item was not stored in the vagina.")
	TEST_ASSERT(vagina.reagents.total_volume < starting_volume, "Inserted item did not force any liquid out of a full vagina.")
	TEST_ASSERT(vagina.reagents.maximum_volume < starting_capacity, "Inserted item did not reduce immediate genital liquid capacity.")
	TEST_ASSERT(vagina.reagents.total_volume <= vagina.reagents.maximum_volume, "Vagina still had more liquid than its immediate capacity after insertion.")

/datum/unit_test/body_storage_inserted_blocker_only_blocks_own_layer
#ifdef FOCUS_BODY_STORAGE_TEST
	focus = TRUE
#endif

/datum/unit_test/body_storage_inserted_blocker_only_blocks_own_layer/Run()
	var/mob/living/carbon/human/test_subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	vagina.Insert(test_subject, TRUE, TRUE)

	var/obj/item/deep_blocker = allocate(/obj/item)
	deep_blocker.body_storage_bulk = 1
	deep_blocker.body_storage_blocks_insertions = TRUE
	SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_FORCE_INSERT, deep_blocker, STORAGE_LAYER_DEEP)

	var/obj/item/inner_candidate = allocate(/obj/item)
	inner_candidate.body_storage_bulk = 1
	var/inner_result = SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_TRY_INSERT, inner_candidate, STORAGE_LAYER_INNER, FALSE)
	TEST_ASSERT(inner_result in list(INSERT_FEEDBACK_OK, INSERT_FEEDBACK_OK_FORCE, INSERT_FEEDBACK_OK_OVERRIDE, INSERT_FEEDBACK_ALMOST_FULL), "A deep layer blocker should not block inner layer insertion.")
	TEST_ASSERT(inner_candidate in vagina.contents, "The inner layer candidate should be stored when only the deep layer is blocked.")

	var/obj/item/deep_candidate = allocate(/obj/item)
	deep_candidate.body_storage_bulk = 1
	var/deep_result = SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_TRY_INSERT, deep_candidate, STORAGE_LAYER_DEEP, FALSE)
	TEST_ASSERT_EQUAL(deep_result, INSERT_FEEDBACK_BLOCKED, "A blocker should reject new insertions into its own layer.")
	TEST_ASSERT(!(deep_candidate in vagina.contents), "Blocked items should not be inserted.")

/datum/unit_test/body_storage_inserted_blocker_can_declare_additional_blocked_layers
#ifdef FOCUS_BODY_STORAGE_TEST
	focus = TRUE
#endif

/datum/unit_test/body_storage_inserted_blocker_can_declare_additional_blocked_layers/Run()
	var/mob/living/carbon/human/test_subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	vagina.Insert(test_subject, TRUE, TRUE)

	var/obj/item/deep_blocker = allocate(/obj/item)
	deep_blocker.body_storage_bulk = 1
	deep_blocker.body_storage_blocks_insertions = TRUE
	deep_blocker.body_storage_additional_blocked_layers = list(STORAGE_LAYER_INNER)
	SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_FORCE_INSERT, deep_blocker, STORAGE_LAYER_DEEP)

	var/obj/item/inner_candidate = allocate(/obj/item)
	inner_candidate.body_storage_bulk = 1
	var/inner_result = SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_TRY_INSERT, inner_candidate, STORAGE_LAYER_INNER, FALSE)
	TEST_ASSERT_EQUAL(inner_result, INSERT_FEEDBACK_BLOCKED, "A blocker should reject insertions into its declared extra layers.")
	TEST_ASSERT(!(inner_candidate in vagina.contents), "Items rejected by an extra blocked layer should not be inserted.")

	var/obj/item/outer_candidate = allocate(/obj/item)
	outer_candidate.body_storage_bulk = 1
	var/outer_result = SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_TRY_INSERT, outer_candidate, STORAGE_LAYER_OUTER, FALSE)
	TEST_ASSERT(outer_result in list(INSERT_FEEDBACK_OK, INSERT_FEEDBACK_OK_FORCE, INSERT_FEEDBACK_OK_OVERRIDE, INSERT_FEEDBACK_ALMOST_FULL), "A blocker should not reject layers it neither occupies nor declares.")
	TEST_ASSERT(outer_candidate in vagina.contents, "Items should still insert into layers the blocker does not cover.")

/*/datum/unit_test/body_storage_equipped_clothing_can_block_hole_slot
#ifdef FOCUS_BODY_STORAGE_TEST
	focus = TRUE
#endif

/datum/unit_test/body_storage_equipped_clothing_can_block_hole_slot/Run()
	var/mob/living/carbon/human/test_subject = allocate(/mob/living/carbon/human)
	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	vagina.Insert(test_subject, TRUE, TRUE)

	var/obj/item/clothing/blocking_clothing = allocate(/obj/item/clothing)
	blocking_clothing.body_storage_blocked_slots = list(ORGAN_SLOT_VAGINA)
	test_subject.wear_pants = blocking_clothing

	var/obj/item/blocked_candidate = allocate(/obj/item)
	blocked_candidate.body_storage_bulk = 1
	var/blocked_result = SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_TRY_INSERT, blocked_candidate, STORAGE_LAYER_INNER, FALSE)
	TEST_ASSERT_EQUAL(blocked_result, INSERT_FEEDBACK_BLOCKED, "Equipped clothing should block insertions into matching hole slots.")
	TEST_ASSERT(!(blocked_candidate in vagina.contents), "Items rejected by clothing should not be inserted.")

	blocking_clothing.body_storage_blocked_slots = list(ORGAN_SLOT_ANUS)

	var/obj/item/allowed_candidate = allocate(/obj/item)
	allowed_candidate.body_storage_bulk = 1
	var/allowed_result = SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_TRY_INSERT, allowed_candidate, STORAGE_LAYER_INNER, FALSE)
	TEST_ASSERT(allowed_result in list(INSERT_FEEDBACK_OK, INSERT_FEEDBACK_OK_FORCE, INSERT_FEEDBACK_OK_OVERRIDE, INSERT_FEEDBACK_ALMOST_FULL), "Clothing should not block non-matching hole slots.")
	TEST_ASSERT(allowed_candidate in vagina.contents, "The item should be inserted after the clothing no longer blocks this hole slot.")*/

/datum/unit_test/body_storage_blocker_makes_insertive_sex_storage_unavailable
#ifdef FOCUS_BODY_STORAGE_TEST
	focus = TRUE
#endif

/datum/unit_test/body_storage_blocker_makes_insertive_sex_storage_unavailable/Run()
	var/mob/living/carbon/human/insertor = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/receiver = allocate(/mob/living/carbon/human)

	var/obj/item/organ/genitals/penis/penis = allocate(/obj/item/organ/genitals/penis)
	penis.Insert(insertor, TRUE, TRUE)

	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	vagina.Insert(receiver, TRUE, TRUE)

	var/obj/item/inner_blocker = allocate(/obj/item)
	inner_blocker.body_storage_bulk = 1
	inner_blocker.body_storage_blocks_insertions = TRUE
	SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_FORCE_INSERT, inner_blocker, STORAGE_LAYER_INNER)

	var/datum/sex_action/sex/vaginal/action = allocate(/datum/sex_action/sex/vaginal)
	TEST_ASSERT(!action.can_fit_item_in_hole(receiver, ORGAN_SLOT_VAGINA, penis, FALSE), "Insertive sex storage should be unavailable when the target layer is blocked.")

/datum/unit_test/body_storage_admin_revive_preserves_stored_items
#ifdef FOCUS_BODY_STORAGE_TEST
	focus = TRUE
#endif

/datum/unit_test/body_storage_admin_revive_preserves_stored_items/Run()
	var/mob/living/carbon/human/test_subject = allocate(/mob/living/carbon/human)

	var/obj/item/organ/genitals/filling_organ/vagina/vagina = allocate(/obj/item/organ/genitals/filling_organ/vagina)
	test_subject.dna.organ_dna[ORGAN_SLOT_VAGINA] = vagina.create_organ_dna()
	vagina.Insert(test_subject, TRUE, TRUE)

	var/obj/item/organ/guts/guts = test_subject.getorganslot(ORGAN_SLOT_GUTS)
	TEST_ASSERT_NOTNULL(guts, "Test subject spawned without guts to exercise stomach/oral storage.")

	var/obj/item/vaginal_item = allocate(/obj/item)
	vaginal_item.body_storage_bulk = 1
	SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_FORCE_INSERT, vaginal_item, STORAGE_LAYER_INNER)

	var/obj/item/gut_item = allocate(/obj/item)
	gut_item.body_storage_bulk = 1
	SEND_SIGNAL(guts, COMSIG_BODYSTORAGE_FORCE_INSERT, gut_item, STORAGE_LAYER_DEEP)

	test_subject.revive(ADMIN_HEAL_ALL)

	var/obj/item/organ/genitals/filling_organ/vagina/revived_vagina = test_subject.getorganslot(ORGAN_SLOT_VAGINA)
	TEST_ASSERT_NOTNULL(revived_vagina, "Admin revive should regenerate the stored vagina.")
	TEST_ASSERT(vaginal_item in revived_vagina.contents, "Admin revive should preserve items stored in regenerated genital storage.")
	TEST_ASSERT_EQUAL(SEND_SIGNAL(revived_vagina, COMSIG_BODYSTORAGE_FIND_ITEM_LAYER, vaginal_item), STORAGE_LAYER_INNER, "Admin revive should preserve genital storage layers.")

	var/obj/item/organ/guts/revived_guts = test_subject.getorganslot(ORGAN_SLOT_GUTS)
	TEST_ASSERT_NOTNULL(revived_guts, "Admin revive should regenerate guts.")
	TEST_ASSERT(gut_item in revived_guts.contents, "Admin revive should preserve items stored in regenerated stomach/oral storage.")
	TEST_ASSERT_EQUAL(SEND_SIGNAL(revived_guts, COMSIG_BODYSTORAGE_FIND_ITEM_LAYER, gut_item), STORAGE_LAYER_DEEP, "Admin revive should preserve stomach/oral storage layers.")
