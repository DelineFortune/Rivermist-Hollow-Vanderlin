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
