/datum/unit_test/amputation/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)

	TEST_ASSERT_EQUAL(patient.get_missing_limbs().len, 0, "Patient is somehow missing limbs before surgery")

	var/datum/surgery/amputation/surgery = new(patient, BODY_ZONE_R_ARM, patient.get_bodypart(BODY_ZONE_R_ARM))

	var/datum/surgery_step/amputate/amputate = new
	amputate.success(user, patient, BODY_ZONE_R_ARM, null, surgery)

	TEST_ASSERT_EQUAL(patient.get_missing_limbs().len, 1, "Patient did not lose any limbs")
	TEST_ASSERT_EQUAL(patient.get_missing_limbs()[1], BODY_ZONE_R_ARM, "Patient is missing a limb that isn't the one we operated on")

/datum/unit_test/head_transplant/Run()
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/alice = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/bob = allocate(/mob/living/carbon/human)

	alice.fully_replace_character_name(null, "Alice")
	bob.fully_replace_character_name(null, "Bob")

	var/obj/item/bodypart/head/alices_head = alice.get_bodypart(BODY_ZONE_HEAD)
	alices_head.drop_limb()

	var/obj/item/bodypart/head/bobs_head = bob.get_bodypart(BODY_ZONE_HEAD)
	bobs_head.drop_limb()

	TEST_ASSERT_NULL(alice.get_bodypart(BODY_ZONE_HEAD), "Alice still has a head after dismemberment")
	TEST_ASSERT_EQUAL(alice.get_visible_name(), "Unknown", "Alice's head was dismembered, but they are not Unknown")

	TEST_ASSERT_EQUAL(bobs_head.real_name, "Bob", "Bob's head does not remember that it is from Bob")

	// Put Bob's head onto Alice's body
	var/datum/surgery_step/add_prosthetic/add_prosthetic = new
	user.put_in_active_hand(bobs_head)
	add_prosthetic.success(user, alice, BODY_ZONE_HEAD, bobs_head)

	TEST_ASSERT_NOTNULL(alice.get_bodypart(BODY_ZONE_HEAD), "Alice has no head after prosthetic replacement")
	TEST_ASSERT_EQUAL(alice.get_visible_name(), "Bob", "Bob's head was transplanted onto Alice's body, but their name is not Bob")

/datum/unit_test/proc/open_test_organ_storage(mob/living/carbon/human/patient)
	var/datum/component/storage/concrete/organ/organ_storage = patient.GetComponent(/datum/component/storage/concrete/organ)
	TEST_ASSERT_NOTNULL(organ_storage, "Patient has no organ storage component")

	var/obj/item/bodypart/chest = patient.get_bodypart(BODY_ZONE_CHEST)
	TEST_ASSERT_NOTNULL(chest, "Patient has no chest to open for organ storage")

	var/datum/injury/incision = chest.create_injury(WOUND_SLASH, 49, TRUE, FALSE)
	if(incision)
		incision.injury_flags |= INJURY_SURGICAL

	var/obj/item/weapon/surgery/retractor/retractor = allocate(/obj/item/weapon/surgery/retractor)
	chest.add_embedded_object(retractor, silent = TRUE, crit_message = FALSE)
	organ_storage.assign_bodypart(chest)

	TEST_ASSERT(organ_storage.is_accessible(), "Organ storage was not accessible after incision and retraction")
	return organ_storage

/datum/unit_test/genital_organs_cannot_be_inserted_through_surgery
#ifdef FOCUS_SURGERY_TEST
	focus = TRUE
#endif

/datum/unit_test/genital_organs_cannot_be_inserted_through_surgery/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	user.used_intent = user.a_intent

	var/datum/component/storage/concrete/organ/organ_storage = open_test_organ_storage(patient)
	var/obj/item/organ/genitals/penis/penis = allocate(/obj/item/organ/genitals/penis)

	TEST_ASSERT(!organ_storage.can_be_inserted(penis, TRUE, user), "Surgery storage accepted a genital organ for insertion")

/datum/unit_test/genital_organs_cannot_be_removed_through_surgery_storage
#ifdef FOCUS_SURGERY_TEST
	focus = TRUE
#endif

/datum/unit_test/genital_organs_cannot_be_removed_through_surgery_storage/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)

	var/datum/component/storage/concrete/organ/organ_storage = open_test_organ_storage(patient)
	var/obj/item/organ/genitals/penis/penis = allocate(/obj/item/organ/genitals/penis)
	penis.Insert(patient, TRUE, TRUE)
	penis.organ_flags |= ORGAN_CUT_AWAY

	TEST_ASSERT(penis in organ_storage.contents(), "Inserted genital organ was not visible in open organ storage")
	TEST_ASSERT(!organ_storage.remove_from_storage(penis, get_turf(patient)), "Surgery storage removed a genital organ")
	TEST_ASSERT_EQUAL(penis.owner, patient, "Blocked genital removal still detached the organ from its owner")
