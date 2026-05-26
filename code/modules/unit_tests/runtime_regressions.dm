/datum/unit_test/pottery_recipe_handles_missing_step_time
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/pottery_recipe_handles_missing_step_time/Run()
	var/datum/pottery_recipe/recipe = new
	recipe.step_to_time = list()

	var/delay = recipe.get_delay(null, 0)
	TEST_ASSERT(isnum(delay), "Pottery recipes with missing step timings should still return a numeric delay.")

/datum/unit_test/structure_examine_status_handles_zero_integrity
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/structure_examine_status_handles_zero_integrity/Run()
	var/obj/structure/structure = allocate(/obj/structure)
	structure.uses_integrity = TRUE
	structure.max_integrity = 0

	TEST_ASSERT_NULL(structure.examine_status(null), "Zero-integrity structures should not divide by zero while examined.")

/datum/unit_test/footstep_data_includes_wood_barefoot
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/footstep_data_includes_wood_barefoot/Run()
	TEST_ASSERT((FOOTSTEP_WOOD_BAREFOOT in GLOB.barefootstep), "Wood barefoot footstep data should exist when a turf override asks for it.")

/datum/unit_test/language_holder_handles_missing_atom
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/language_holder_handles_missing_atom/Run()
	var/datum/language_holder/holder = new
	holder.remove_language(/datum/language/common)

	TEST_ASSERT_EQUAL(holder.has_language(/datum/language/elvish), FALSE, "Detached language holders should not ask a null atom for shadow languages.")

/*/datum/unit_test/loinspent_ignores_nonhuman_owner
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/loinspent_ignores_nonhuman_owner/Run()
	var/mob/living/simple_animal/animal = allocate(/mob/living/simple_animal)
	var/datum/status_effect/debuff/loinspent/effect = new(list(animal))
	animal.mob_timers["chafing_loins"] = 0

	effect.tick()

	TEST_ASSERT_NOTEQUAL(animal.mob_timers["chafing_loins"], 0, "Loinspent should still update its cooldown before ignoring non-human owners.")*/

/datum/unit_test/human_smoke_protection_ignores_nonclothing_mask
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/human_smoke_protection_ignores_nonclothing_mask/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/reagent_containers/food/snacks/produce/poppy/poppy = allocate(/obj/item/reagent_containers/food/snacks/produce/poppy)
	human.vars["wear_mask"] = poppy

	var/has_protection = human.has_smoke_protection()
	human.vars["wear_mask"] = null

	TEST_ASSERT_EQUAL(has_protection, FALSE, "Human smoke protection should ignore non-clothing mask-slot contents.")

/datum/unit_test/carbon_cremation_handles_missing_chest
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/carbon_cremation_handles_missing_chest/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/chest/chest = human.get_bodypart(BODY_ZONE_CHEST)
	human.remove_bodypart(chest)
	human.on_fire = TRUE
	human.stat = DEAD

	human.check_cremation()

	TEST_ASSERT_NULL(human.get_bodypart(BODY_ZONE_CHEST), "Cremation should stop cleanly when a carbon has no chest bodypart.")

/mob/living/carbon/human/runtime_regression_null_blood/get_blood_type()
	return null

/datum/unit_test/bodypart_blood_splatter_handles_null_blood_type
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/bodypart_blood_splatter_handles_null_blood_type/Run()
	var/mob/living/carbon/human/runtime_regression_null_blood/original_owner = allocate(/mob/living/carbon/human/runtime_regression_null_blood)
	var/obj/item/bodypart/l_arm/arm = allocate(/obj/item/bodypart/l_arm, run_loc_floor_bottom_left)
	arm.original_owner = original_owner

	arm.throw_impact(get_turf(arm), null)

	TEST_ASSERT_EQUAL(arm.get_blood_splatter_color(), COLOR_BLOOD, "Dropped bodyparts should fall back to normal blood color when their owner has no blood type.")

/datum/unit_test/alchemy_examine_handles_observer
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/alchemy_examine_handles_observer/Run()
	var/mob/dead/observer/observer = allocate(/mob/dead/observer)
	var/obj/item/reagent_containers/food/snacks/produce/poppy/poppy = allocate(/obj/item/reagent_containers/food/snacks/produce/poppy)

	var/list/examine_lines = poppy.examine(observer)

	TEST_ASSERT(islist(examine_lines), "Alchemy precursor examine should not ask observers for living skill data.")

/datum/unit_test/tgui_payload_handles_missing_client
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/tgui_payload_handles_missing_client/Run()
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/datum/host = allocate(/datum)
	var/datum/tgui/ui = allocate(/datum/tgui, user, host, "RuntimeRegression", "Runtime Regression")

	var/list/payload = ui.get_payload()
	var/list/config = payload["config"]
	var/list/window_config = config["window"]

	TEST_ASSERT_EQUAL(window_config["fancy"], FALSE, "TGUI payloads should use safe client defaults when a user has disconnected.")

/datum/unit_test/chat_message_ignores_clientless_viewer
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/chat_message_ignores_clientless_viewer/Run()
	var/mob/living/carbon/human/viewer = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/speaker = allocate(/mob/living/carbon/human)

	viewer.create_chat_message(speaker, null, "hello", list())

	TEST_ASSERT_NULL(viewer.client, "Runechat should not create chatmessage datums for mobs without clients.")

/datum/unit_test/crafting_move_products_ignores_qdeleted_outputs
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/crafting_move_products_ignores_qdeleted_outputs/Run()
	var/datum/repeatable_crafting_recipe/recipe = allocate(/datum/repeatable_crafting_recipe)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/item/natural/stone/stone = allocate(/obj/item/natural/stone, run_loc_floor_bottom_left)
	qdel(stone)

	recipe.move_products(list(stone), user)

	TEST_ASSERT(QDELETED(stone), "Crafting product handoff should skip outputs that were already consumed by qdel.")

/datum/unit_test/looping_sound_start_ignores_qdeleted_sound
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/looping_sound_start_ignores_qdeleted_sound/Run()
	var/datum/looping_sound/loop = new(run_loc_floor_bottom_left)
	qdel(loop)

	loop.start()

	TEST_ASSERT(QDELETED(loop), "Looping sounds should not schedule timers after they have started qdel.")

/datum/unit_test/putrid_feed_corpse_handles_missing_master
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/putrid_feed_corpse_handles_missing_master/Run()
	var/mob/living/simple_animal/hostile/retaliate/meatvine/our_mob = allocate(/mob/living/simple_animal/hostile/retaliate/meatvine)
	our_mob.master = null
	var/datum/ai_controller/controller = allocate(/datum/ai_controller, our_mob)
	var/datum/ai_planning_subtree/papameat_feed_corpse/subtree = allocate(/datum/ai_planning_subtree/papameat_feed_corpse)

	subtree.SelectBehaviors(controller, 1)

	TEST_ASSERT_NULL(controller.blackboard[BB_CORPSE_TO_FEED], "Putrid corpse-feeding planning should stop cleanly when its meatvine has no master.")

/datum/unit_test/listed_action_group_handles_missing_palette
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/listed_action_group_handles_missing_palette/Run()
	var/datum/action_group/listed/group = allocate(/datum/action_group/listed)

	group.refresh_actions()

	TEST_ASSERT_EQUAL(group.size(), 0, "Listed action groups should tolerate being refreshed during HUD teardown.")

/datum/unit_test/tgui_window_handles_missing_client
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/tgui_window_handles_missing_client/Run()
	var/datum/tgui_window/window = new(null, "runtime_regression")

	window.initialize()

	TEST_ASSERT_EQUAL(window.status, TGUI_WINDOW_CLOSED, "TGUI windows should ignore initialize calls when they have no valid client.")
	qdel(window)

/datum/unit_test/wild_plant_harvest_ignores_abstract_family_defs
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/wild_plant_harvest_ignores_abstract_family_defs/Run()
	var/list/abstract_plant_defs = list(
		/datum/plant_def/alchemical,
		/datum/plant_def/mushroom,
	)

	for(var/plant_def_type as anything in abstract_plant_defs)
		var/obj/structure/wild_plant/plant = allocate(/obj/structure/wild_plant, run_loc_floor_bottom_left, plant_def_type, -1)
		plant.yield_produce()
		TEST_ASSERT(QDELETED(plant), "Wild plants should not try to spawn produce from abstract plant family definitions.")

/datum/unit_test/soil_yield_ignores_abstract_family_defs
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/soil_yield_ignores_abstract_family_defs/Run()
	var/obj/structure/soil/soil = allocate(/obj/structure/soil, run_loc_floor_bottom_left)
	soil.plant = allocate(/datum/plant_def/mushroom)
	soil.plant_genetics = allocate(/datum/plant_genetics, soil.plant)
	soil.produce_ready = TRUE

	soil.yield_produce()

	TEST_ASSERT_EQUAL(soil.produce_ready, FALSE, "Soil should clear ready produce when its plant definition cannot yield produce.")

/datum/unit_test/visible_non_genital_organs_accept_visibility_toggle
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/visible_non_genital_organs_accept_visibility_toggle/Run()
	var/obj/item/organ/tail/tail = allocate(/obj/item/organ/tail)
	var/was_visible = tail.visible_organ

	call(tail, "toggle_visibility")("Show Above clothes")

	TEST_ASSERT_EQUAL(tail.visible_organ, was_visible, "Visible non-genital organs should accept the visibility toggle hook without runtiming.")

/datum/unit_test/quest_turn_in_markers_are_indexed
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/quest_turn_in_markers_are_indexed/Run()
	var/obj/effect/decal/marker_export/marker = allocate(/obj/effect/decal/marker_export, run_loc_floor_bottom_left)

	TEST_ASSERT((marker in GLOB.quest_turn_in_markers), "Quest turn-in markers should be indexed instead of found by scanning the whole world.")

/datum/unit_test/retrieval_quest_turn_in_defers_item_deletion
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/retrieval_quest_turn_in_defers_item_deletion/Run()
	var/datum/quest/quest = allocate(/datum/quest)
	quest.quest_type = QUEST_RETRIEVAL
	quest.target_item_type = /obj/item/natural/stone
	var/obj/item/natural/stone/stone = allocate(/obj/item/natural/stone, run_loc_floor_bottom_left)
	var/datum/component/quest_object/retrieval/retrieval = stone.AddComponent(/datum/component/quest_object/retrieval, quest)
	allocate(/obj/effect/decal/marker_export, run_loc_floor_bottom_left)

	retrieval.on_item_dropped(stone, null)

	TEST_ASSERT_EQUAL(quest.progress_current, 1, "Retrieval turn-in should count quest progress.")
	TEST_ASSERT_EQUAL(quest.complete, TRUE, "Retrieval turn-in should complete the quest when enough progress is made.")
	TEST_ASSERT(!QDELETED(stone), "Retrieval turn-in should not qdel the item inside the drop signal.")

/datum/unit_test/smallrat_death_spawns_dead_rat_on_turf
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/smallrat_death_spawns_dead_rat_on_turf/Run()
	var/turf/start_turf = get_turf(run_loc_floor_bottom_left)
	var/obj/item/reagent_containers/food/snacks/smallrat/rat = allocate(/obj/item/reagent_containers/food/snacks/smallrat, start_turf)

	rat.atom_destruction()

	var/obj/item/reagent_containers/food/snacks/smallrat/dead/dead_rat = locate(/obj/item/reagent_containers/food/snacks/smallrat/dead) in start_turf
	TEST_ASSERT_NOTNULL(dead_rat, "Killing a live smallrat should leave a dead smallrat on the turf instead of inside the qdeleted rat.")
	TEST_ASSERT(QDELETED(rat), "The live smallrat should still be qdeleted after atom destruction.")
	qdel(dead_rat)

/datum/unit_test/piercing_feature_binds_existing_item
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/piercing_feature_binds_existing_item/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/datum/bodypart_feature/piercing/feature = allocate(/datum/bodypart_feature/piercing)
	var/obj/item/piercings/rings/rings = allocate(/obj/item/piercings/rings, run_loc_floor_bottom_left)

	feature.set_accessory_type(rings.sprite_acc, rings.color, null)
	feature.set_piercings_item(rings, human)

	TEST_ASSERT_EQUAL(human.piercings_item, rings, "Applying piercings should bind the worn item to the human.")
	TEST_ASSERT_EQUAL(rings.piercings_feature, feature, "Applying piercings should bind the worn item to its bodypart feature.")

	if(human.piercings_item == rings)
		human.piercings_item = null
	if(feature.piercings_item == rings)
		feature.piercings_item = null
	if(rings.piercings_feature == feature)
		rings.piercings_feature = null

/datum/unit_test/visual_ui_teardown_clears_mind_backrefs
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/visual_ui_teardown_clears_mind_backrefs/Run()
	var/datum/mind/test_mind = allocate(/datum/mind)
	var/datum/visual_ui/test_hello_world_parent/ui = new /datum/visual_ui/test_hello_world_parent(test_mind)
	var/obj/abstract/visual_ui_element/first_element = ui.elements[1]

	TEST_ASSERT_EQUAL(test_mind.active_uis[ui.uniqueID], ui, "Visual UIs should register on their owner mind.")

	qdel(ui)

	TEST_ASSERT(!("Hello World" in test_mind.active_uis), "Deleting a visual UI should remove it from the owner mind.")
	TEST_ASSERT(!("Hello World Panel" in test_mind.active_uis), "Deleting a visual UI should remove child UIs from the owner mind.")
	TEST_ASSERT_NULL(first_element.parent, "Deleting a visual UI should clear element parent backrefs.")

/datum/unit_test/disinfectant_soaked_bandage_treats_injury
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/disinfectant_soaked_bandage_treats_injury/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/chest = patient.get_bodypart(BODY_ZONE_CHEST)
	TEST_ASSERT_NOTNULL(chest, "Test human should have a chest bodypart.")

	var/datum/injury/injury = chest.create_injury(WOUND_SLASH, 20)
	TEST_ASSERT_NOTNULL(injury, "Test setup should create a slash injury.")
	injury.adjust_germ_level(10)

	var/obj/item/natural/cloth/bandage/soaked_bandage = allocate(/obj/item/natural/cloth/bandage)
	soaked_bandage.reagents.add_reagent(/datum/reagent/consumable/ethanol, 3)
	chest.try_bandage(soaked_bandage)

	TEST_ASSERT(injury.is_disinfected(), "A disinfectant-soaked bandage should disinfect the injury as soon as it is applied.")
	TEST_ASSERT(injury.germ_level < 10, "A disinfectant-soaked bandage should reduce injury germs when it is applied.")

/datum/unit_test/player_bodypart_attacks_do_not_roll_violent_organ_damage
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/player_bodypart_attacks_do_not_roll_violent_organ_damage/Run()
	var/mob/living/carbon/human/player_body = allocate(/mob/living/carbon/human)
	var/datum/mind/player_mind = allocate(/datum/mind, "organ-damage-test")
	player_mind.current = player_body
	player_body.mind = player_mind
	var/obj/item/bodypart/chest = player_body.get_bodypart(BODY_ZONE_CHEST)
	TEST_ASSERT_NOTNULL(chest, "Test human should have a chest bodypart.")

	var/organ_damage_before = 0
	for(var/obj/item/organ/organ as anything in player_body.internal_organs)
		organ_damage_before += organ.damage

	var/rolled_organ_damage = chest.damage_internal_organs(WOUND_PIERCE, 200, 200, forced = TRUE)

	var/organ_damage_after = 0
	for(var/obj/item/organ/organ as anything in player_body.internal_organs)
		organ_damage_after += organ.damage

	TEST_ASSERT(!rolled_organ_damage, "Violent bodypart attacks should not roll organ damage for player characters until the system is reworked.")
	TEST_ASSERT_EQUAL(organ_damage_after, organ_damage_before, "Violent bodypart attacks should not change player character organ damage until the system is reworked.")
	player_body.mind = null
	player_mind.current = null

/datum/unit_test/admin_revive_refills_organ_blood
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/admin_revive_refills_organ_blood/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/list/arteries = patient.getorganslotlist(ORGAN_SLOT_ARTERY)
	TEST_ASSERT(length(arteries), "Test human should have at least one artery.")

	var/obj/item/organ/artery = arteries[1]
	artery.applyOrganDamage(artery.maxHealth)
	artery.current_blood = 0

	patient.revive(ADMIN_HEAL_ALL)

	TEST_ASSERT_EQUAL(artery.damage, 0, "Admin revive should clear artery organ damage.")
	TEST_ASSERT_EQUAL(artery.current_blood, artery.max_blood_storage, "Admin revive should refill local organ blood so healed organs do not immediately fail again.")

/datum/unit_test/wounds_do_not_infect_from_ordinary_movement
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/wounds_do_not_infect_from_ordinary_movement/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/chest = patient.get_bodypart(BODY_ZONE_CHEST)
	TEST_ASSERT_NOTNULL(chest, "Test human should have a chest bodypart.")

	var/datum/injury/injury = chest.create_injury(WOUND_SLASH, 60)
	TEST_ASSERT_NOTNULL(injury, "Test setup should create a slash injury.")

	injury.movement_infect(patient)

	TEST_ASSERT_EQUAL(injury.germ_level, 0, "Ordinary movement should not infect wounds; infection should require explicit contamination.")

/datum/unit_test/poison_splash_contaminates_wounds
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/poison_splash_contaminates_wounds/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/chest = patient.get_bodypart(BODY_ZONE_CHEST)
	TEST_ASSERT_NOTNULL(chest, "Test human should have a chest bodypart.")

	var/datum/injury/injury = chest.create_injury(WOUND_SLASH, 20)
	TEST_ASSERT_NOTNULL(injury, "Test setup should create a slash injury.")

	var/datum/reagent/strongpoison/poison = allocate(/datum/reagent/strongpoison)
	poison.reaction_mob(patient, TOUCH, 2, target_zone = BODY_ZONE_CHEST)

	TEST_ASSERT(injury.germ_level > 0, "Poison splashes should explicitly contaminate wounds.")

/datum/unit_test/health_potions_heal_organ_damage_by_strength
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/health_potions_heal_organ_damage_by_strength/Run()
	var/mob/living/carbon/human/weak_patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/strong_patient = allocate(/mob/living/carbon/human)
	var/obj/item/organ/weak_heart = weak_patient.getorganslot(ORGAN_SLOT_HEART)
	var/obj/item/organ/strong_heart = strong_patient.getorganslot(ORGAN_SLOT_HEART)
	TEST_ASSERT_NOTNULL(weak_heart, "Weak potion test patient should have a heart.")
	TEST_ASSERT_NOTNULL(strong_heart, "Strong potion test patient should have a heart.")

	var/starting_damage = 40
	weak_heart.applyOrganDamage(starting_damage)
	strong_heart.applyOrganDamage(starting_damage)

	var/datum/reagent/medicine/healthpot/weak_potion = allocate(/datum/reagent/medicine/healthpot)
	var/datum/reagent/medicine/stronghealth/strong_potion = allocate(/datum/reagent/medicine/stronghealth)
	weak_potion.volume = 5
	strong_potion.volume = 5

	weak_potion.on_mob_life(weak_patient, 1)
	strong_potion.on_mob_life(strong_patient, 1)

	var/weak_healing = starting_damage - weak_heart.damage
	var/strong_healing = starting_damage - strong_heart.damage
	TEST_ASSERT(weak_healing > 0, "Weak healing potions should restore some organ damage.")
	TEST_ASSERT(strong_healing > weak_healing, "Strong healing potions should restore more organ damage than weak healing potions.")
