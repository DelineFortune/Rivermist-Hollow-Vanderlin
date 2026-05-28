/datum/surgery_step
	/// Name of the surgery step
	var/name
	/// Description of the surgery step
	var/desc
	/// Typepaths or tool behaviors that can be used to perform this surgery step, associated to success chance
	var/list/implements = list()
	/// Typepaths or tool behaviors that can be used to perform this surgery step, associated to speed modification
	var/list/implements_speed = list()
	/// Does the surgery step accept open hand? If true, ignores implements. Compatible with accept_any_item.
	var/accept_hand = FALSE
	/// Does the surgery step accept any item? If true, ignores implements. Compatible with accept_hand.
	var/accept_any_item = FALSE

	/// Best case scenario time for this step
	var/minimum_time = 10
	/// Worst case scenario time for this step
	var/maximum_time = 20
	/// Random surgery flags that mostly indicate additional requirements
	var/surgery_flags = SURGERY_BLOODY | SURGERY_INCISED
	/// Random surgery flags blocking certain flags
	var/surgery_flags_blocked = NONE
	/// Intents that can be used to perform this surgery step
	var/list/possible_intents
	/// Body zones this surgery can be performed on, set to null for everywhere
	var/list/possible_locs
	/// Does this step require a non-missing bodypart? Incompatible with requires_missing_bodypart
	var/requires_bodypart = TRUE
	/// Does this step require the bodypart to be missing? (Limb attachment)
	var/requires_missing_bodypart = FALSE
	/// If true, this surgery step cannot be done on pseudo limbs (like chainsaw arms)
	var/requires_real_bodypart = TRUE
	/// What type of bodypart we require, in case requires_bodypart
	var/requires_bodypart_type = BODYPART_ORGANIC
	/// Some surgeries require specific organs to be present in the patient
	var/list/required_organs
	/**
	* list of chems needed to complete the step.
	* Even on success, the step will have no effect if there aren't the chems required in the mob.
	*/
	var/list/chems_needed
	/// Any chem on the list required, or all of them?
	var/require_all_chems = TRUE
	/// This surgery ignores clothes on the targeted bodypart
	var/ignore_clothes = FALSE
	/// Does the patient need to be lying down?
	var/lying_required = FALSE
	/// Does this step allow self surgery?
	var/self_operable = TRUE
	/// Acceptable mob types for this surgery
	var/list/target_mobtypes = list(/mob/living/carbon, /mob/living/simple_animal)

	/// Skill used to perform this surgery step
	var/datum/attribute/skill/skill_used = /datum/attribute/skill/misc/medicine
	/// Necessary skill MINIMUM to perform this surgery step, of skill_used
	var/skill_min = SKILL_RANK_NOVICE
	/// Skill rank used as this step's expected training level
	var/skill_median = SKILL_RANK_JOURNEYMAN

	/// Minimum chance a surgery step can have after modifiers
	var/minimum_success_chance = 5
	/// Maximum chance a surgery step can have after modifiers
	var/maximum_success_chance = 99
	/// Medicine skill where critical failures stop occurring through normal odds
	var/critical_failure_skill_cutoff = 15

	/**
	* type; doesn't show up if this type exists.
	* Set to /datum/surgery_step if you want to hide a "base" surgery  (useful for typing parents IE healing.dm just make sure to null it out again)
	*/
	var/replaced_by
	/// Repeatable surgery steps will repeat until failure
	var/repeating = FALSE
	var/preop_sound //Sound played when the step is started
	var/success_sound //Sound played if the step succeeded
	var/failure_sound //Sound played if the step fails

/datum/surgery_step/proc/can_do_step(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, try_to_fail = FALSE)
	if(!user || !target)
		return FALSE
	if(!user.Adjacent(target))
		return FALSE
	if(!tool_check(user, tool))
		return FALSE
	if(!validate_user(user, target, target_zone, intent))
		return FALSE
	if(!validate_target(user, target, target_zone, intent))
		return FALSE

	return TRUE

/datum/surgery_step/proc/validate_user(mob/user, mob/living/target, target_zone, datum/intent/intent)
	SHOULD_CALL_PARENT(TRUE)
	if(possible_locs && !(target_zone in possible_locs))
		return FALSE
	if(possible_intents)
		var/found_intent = FALSE
		for(var/possible_intent in possible_intents)
			if(istype(intent, possible_intent))
				found_intent = TRUE
				break
		if(!found_intent)
			return FALSE
	if(skill_used && skill_min && (GET_MOB_SKILL_VALUE_OLD(user, skill_used) < skill_min))
		return FALSE
	return TRUE

/datum/surgery_step/proc/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	SHOULD_CALL_PARENT(TRUE)
	if(!self_operable && (user == target))
		return FALSE

	if(target_mobtypes)
		var/valid_mobtype = FALSE
		for(var/mobtype in target_mobtypes)
			if(istype(target, mobtype))
				valid_mobtype = TRUE
				break
		if(!valid_mobtype)
			return FALSE

	if(lying_required && target.body_position != LYING_DOWN)
		return FALSE

	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/bodypart = carbon_target.get_bodypart(check_zone(target_zone))
		if(!validate_bodypart(user, target, bodypart, target_zone))
			return FALSE
		for(var/required_organ in required_organs)
			var/obj/item/organ/organ = carbon_target.getorganslot(required_organ)
			if(!organ)
				return FALSE

	//no surgeries in the same body zone
	if(target_zone && LAZYACCESS(target.surgeries, target_zone))
		return FALSE

	return TRUE

/datum/surgery_step/proc/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	SHOULD_CALL_PARENT(TRUE)
	if(requires_bodypart && !bodypart)
		return FALSE
	else if(!requires_bodypart)
		if(requires_missing_bodypart && bodypart)
			return FALSE
		return TRUE

	if(requires_bodypart_type && (bodypart.status != requires_bodypart_type))
		return FALSE

	var/bodypart_flags = bodypart.get_surgery_flags()
	if((surgery_flags & bodypart_flags) != surgery_flags)
		return FALSE
	if((surgery_flags_blocked & bodypart_flags))
		return FALSE

	/*
	if(user == target)
		var/obj/item/bodypart/active_hand = user.get_active_hand()
		if(active_hand)
			var/static/list/r_hand_zones = list(BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND)
			var/static/list/l_hand_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND)
			if((active_hand?.body_zone in r_hand_zones) && (bodypart.body_zone in r_hand_zones))
				return FALSE
			if((active_hand?.body_zone in l_hand_zones) && (bodypart.body_zone in l_hand_zones))
				return FALSE
	*/

	if(!ignore_clothes && !get_location_accessible(target, target_zone || bodypart.body_zone))
		return FALSE

	return TRUE

/datum/surgery_step/proc/tool_check(mob/user, obj/item/tool)
	SHOULD_CALL_PARENT(TRUE)
	var/implement_type = FALSE
	if(accept_hand && (!tool))
		implement_type = TOOL_HAND

	if(tool)
		for(var/key in implements)
			if(ispath(key) && istype(tool, key))
				implement_type = key
				break
			if(tool.tool_behaviour == key)
				implement_type = key
				break
			if((key == TOOL_SHARP) && tool.get_sharpness())
				implement_type = key
				break
			if((key == TOOL_HOT) && (tool.get_temperature() >= 100+T0C))
				implement_type = key
				break

		if(!implement_type && accept_any_item)
			implement_type = TOOL_NONE

	return implement_type

/datum/surgery_step/proc/chem_check(mob/living/target)
	if(!LAZYLEN(chems_needed))
		return TRUE

	if(require_all_chems)
		for(var/reagent_needed in chems_needed)
			if(!target.has_reagent(reagent_needed))
				return FALSE
		return TRUE

	for(var/reagent_needed in chems_needed)
		if(target.has_reagent(reagent_needed))
			return TRUE

	return FALSE

/// Returns a string of the chemicals needed for this surgery step
/datum/surgery_step/proc/get_chem_string()
	if(!LAZYLEN(chems_needed))
		return
	var/list/chems = list()
	for(var/R in chems_needed)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[R]
		if(temp)
			var/chemname = temp.name
			chems += chemname
	return english_list(chems, and_text = require_all_chems ? " and " : " or ")

/datum/surgery_step/proc/try_op(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, try_to_fail = FALSE)
	if(!can_do_step(user, target, target_zone, tool, intent, try_to_fail))
		return FALSE

	initiate(user, target, target_zone, tool, intent, try_to_fail)
	return TRUE	//returns TRUE so we don't stab the guy in the dick or wherever.

/datum/surgery_step/proc/initiate(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, try_to_fail = FALSE)
	LAZYSET(target.surgeries, target_zone, src)
	//var/obj/item/bodypart/affecting = target.get_bodypart(target_zone)
	if(!preop(user, target, target_zone, tool, intent))
		LAZYREMOVE(target.surgeries, target_zone)
		return FALSE

	play_preop_sound(user, target, target_zone, tool)

	var/speed_mod = get_speed_modifier(user, target, target_zone, tool, intent)

	var/modded_min = round(minimum_time * speed_mod, 1)
	var/modded_max = round(maximum_time * speed_mod, 1)
	var/final_time = rand(modded_min, modded_max)

	if(!do_after(user, final_time, target))
		LAZYREMOVE(target.surgeries, target_zone)
		return FALSE

	LAZYREMOVE(target.surgeries, target_zone)

	var/roll_result = DICE_FAILURE
	var/success_chance
	var/critical_failure_chance
	if(!try_to_fail)
		success_chance = get_success_chance(user, target, target_zone, tool, intent)
		critical_failure_chance = get_critical_failure_chance(user)
		roll_result = roll_surgery_result(success_chance, critical_failure_chance)

	var/chem_ok = chem_check(target)

	switch(roll_result)
		if(DICE_CRIT_SUCCESS)
			if(!chem_ok)
				// chems missing: degrade to normal failure path even on crit
				if(failure(user, target, target_zone, tool, intent))
					play_failure_sound(user, target, target_zone, tool)
					display_roll(user, "CRIT SUCCESS (chem fail)", success_chance, critical_failure_chance)
					if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
						initiate(user, target, target_zone, tool, intent, try_to_fail)
				return FALSE
			if(crit_success(user, target, target_zone, tool, intent))
				add_surgery_xp(user)
				play_success_sound(user, target, target_zone, tool)
				display_roll(user, "CRIT SUCCESS", success_chance, critical_failure_chance)
				if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
					initiate(user, target, target_zone, tool, intent, try_to_fail)
				return TRUE
			return FALSE

		if(DICE_SUCCESS)
			if(!chem_ok)
				if(failure(user, target, target_zone, tool, intent))
					play_failure_sound(user, target, target_zone, tool)
					display_roll(user, "SUCCESS (chem fail)", success_chance, critical_failure_chance)
					if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
						initiate(user, target, target_zone, tool, intent, try_to_fail)
				return FALSE
			if(success(user, target, target_zone, tool, intent))
				add_surgery_xp(user)
				play_success_sound(user, target, target_zone, tool)
				display_roll(user, "SUCCESS", success_chance, critical_failure_chance)
				if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
					initiate(user, target, target_zone, tool, intent, try_to_fail)
				return TRUE
			return FALSE

		if(DICE_CRIT_FAILURE)
			if(crit_failure(user, target, target_zone, tool, intent))
				play_failure_sound(user, target, target_zone, tool)
				display_roll(user, "CRIT FAILURE", success_chance, critical_failure_chance)
				if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
					initiate(user, target, target_zone, tool, intent, try_to_fail)
			return FALSE

		else // DICE_FAILURE or try_to_fail
			if(failure(user, target, target_zone, tool, intent))
				play_failure_sound(user, target, target_zone, tool)
				display_roll(user, try_to_fail ? "INTENTIONAL FAIL" : "FAILURE", try_to_fail ? null : success_chance, critical_failure_chance)
				if(repeating && can_do_step(user, target, target_zone, tool, intent, try_to_fail))
					initiate(user, target, target_zone, tool, intent, try_to_fail)
			return FALSE

/datum/surgery_step/proc/roll_surgery_result(success_chance, critical_failure_chance)
	success_chance = clamp(success_chance, 0, 100)
	critical_failure_chance = clamp(critical_failure_chance, 0, 100 - success_chance)
	var/roll = rand(1, 1000) / 10
	if(roll <= critical_failure_chance)
		return DICE_CRIT_FAILURE
	if(roll <= critical_failure_chance + success_chance)
		return DICE_SUCCESS
	return DICE_FAILURE

/datum/surgery_step/proc/get_success_chance(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/success_chance = get_base_success_chance_for_skill(get_surgery_skill(user))
	success_chance += get_tool_success_modifier(user, tool)
	success_chance += get_location_success_modifier(target)
	success_chance += get_diceroll_success_modifier(user)
	var/overseer_bonus = get_overseer_bonus(user, target, target_zone)
	success_chance += overseer_bonus
	if(overseer_bonus > 0)
		to_chat(user, span_notice("You feel more confident with an experienced eye watching over you."))
	return clamp(round(success_chance, 0.1), minimum_success_chance, maximum_success_chance)

/datum/surgery_step/proc/get_critical_failure_chance(mob/user)
	return get_critical_failure_chance_for_skill(get_surgery_skill(user))

/datum/surgery_step/proc/get_surgery_skill(mob/user)
	if(!skill_used)
		return SKILL_LEVEL_LEGENDARY
	return clamp(GET_MOB_SKILL_VALUE(user, skill_used) || 0, SKILL_LEVEL_NONE, SKILL_LEVEL_LEGENDARY)

/datum/surgery_step/proc/get_base_success_chance_for_skill(skill_level)
	skill_level = clamp(skill_level || 0, SKILL_LEVEL_NONE, SKILL_LEVEL_LEGENDARY)
	if(skill_level < critical_failure_skill_cutoff)
		return 20 + skill_level * 2
	if(skill_level < 35)
		return 50 + (skill_level - critical_failure_skill_cutoff) * 2
	if(skill_level < 40)
		return 90 + (skill_level - 35)
	return min(maximum_success_chance, 95 + (skill_level - 40) * 0.2)

/datum/surgery_step/proc/get_critical_failure_chance_for_skill(skill_level)
	skill_level = clamp(skill_level || 0, SKILL_LEVEL_NONE, SKILL_LEVEL_LEGENDARY)
	if(skill_level >= critical_failure_skill_cutoff)
		return 0
	return round((critical_failure_skill_cutoff - skill_level) * 0.7, 0.1)

/datum/surgery_step/proc/get_tool_success_modifier(mob/user, obj/item/tool)
	if(!implements)
		return 0
	var/implement_type = tool_check(user, tool)
	if(!implement_type)
		return 0
	return get_tool_quality_success_modifier(implements[implement_type] || 100)

/datum/surgery_step/proc/get_tool_quality_success_modifier(tool_chance)
	return clamp(round((tool_chance - 80) / 5, 0.1), -10, 5)

/datum/surgery_step/proc/get_location_success_modifier(mob/living/target)
	if(!target)
		return 0
	var/location_modifier = get_location_modifier(target)
	if(location_modifier >= 1.1)
		return 3
	if(location_modifier >= 1)
		return 1
	if(location_modifier >= 0.8)
		return -2
	if(location_modifier >= 0.7)
		return -5
	return -10

/datum/surgery_step/proc/get_diceroll_success_modifier(mob/user)
	if(!user?.attributes)
		return 0
	return clamp(round(user.attributes.get_diceroll_modifier(DICE_CONTEXT_PHYSICAL) * 2, 0.1), -15, 15)

/datum/surgery_step/proc/get_overseer_bonus(mob/user, mob/living/target, target_zone)
	var/best_bonus = 0
	var/user_skill = get_surgery_skill(user)
	var/minimum_overseer_skill = skill_median * 10
	for(var/mob/living/carbon/human/nearby in view(3, user))
		if(nearby == user)
			continue
		if(nearby.stat != CONSCIOUS)
			continue
		var/overseer_skill = GET_MOB_SKILL_VALUE(nearby, /datum/attribute/skill/misc/medicine) || 0
		if(overseer_skill <= minimum_overseer_skill)
			continue
		if(overseer_skill <= user_skill)
			continue
		var/bonus = clamp(round((overseer_skill - max(user_skill, minimum_overseer_skill)) / 5, 0.1), 1, 5)
		if(bonus > best_bonus)
			best_bonus = bonus
	return best_bonus

/datum/surgery_step/proc/add_surgery_xp(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/doctor = user
	user.mind.add_sleep_experience(/datum/attribute/skill/misc/medicine, GET_MOB_ATTRIBUTE_VALUE(doctor, STAT_INTELLIGENCE) * (skill_min / 3))

/datum/surgery_step/proc/display_roll(mob/user, result_label, success_chance, critical_failure_chance)
	if(!user.client?.prefs.showrolls)
		return
	if(success_chance != null)
		to_chat(user, span_warning("[result_label] ([success_chance]% success, [critical_failure_chance || 0]% critical failure)"))
	else
		to_chat(user, span_warning("[result_label]"))

/datum/surgery_step/proc/crit_success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	return success(user, target, target_zone, tool, intent)

/datum/surgery_step/proc/crit_failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	return failure(user, target, target_zone, tool, intent)

/datum/surgery_step/proc/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I begin to perform surgery on [target]...</span>",
		"<span class='notice'>[user] begins to perform surgery on [target].</span>",
		"<span class='notice'>[user] begins to perform surgery on [target].</span>")
	return TRUE

/datum/surgery_step/proc/play_preop_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!preop_sound)
		return
	var/sound_file_use
	if(islist(preop_sound))
		for(var/typepath in preop_sound)//iterate and assign subtype to a list, works best if list is arranged from subtype first and parent last
			if(istype(tool, typepath))
				sound_file_use = preop_sound[typepath]
				break
	else
		sound_file_use = preop_sound
	playsound(target, sound_file_use, 75, TRUE, -2)

/datum/surgery_step/proc/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I succeed.</span>",
		"<span class='notice'>[user] succeeds!</span>",
		"<span class='notice'>[user] finishes.</span>")
	return TRUE

/datum/surgery_step/proc/play_success_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!success_sound)
		return
	playsound(target, success_sound, 75, TRUE, -2)

/datum/surgery_step/proc/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, "<span class='warning'>I screw up!</span>",
		"<span class='warning'>[user] screws up!</span>",
		"<span class='notice'>[user] finishes.</span>", TRUE) //By default the patient will notice if the wrong thing has been cut
	return TRUE

/datum/surgery_step/proc/play_failure_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!failure_sound)
		return
	playsound(target, failure_sound, 75, TRUE, -2)

/// Replaces visible_message during operations so only people looking over the surgeon can tell what they're doing, allowing for shenanigans.
/datum/surgery_step/proc/display_results(mob/user, mob/living/carbon/target, self_message, detailed_message, vague_message, target_detailed = FALSE)
	var/list/detailed_mobs = get_hearers_in_view(1, user) //Only the surgeon and people looking over his shoulder can see the operation clearly
	if(!target_detailed)
		detailed_mobs -= target //The patient can't see well what's going on, unless it's something like getting cut
	user.visible_message(detailed_message, self_message, vision_distance = 1, ignored_mobs = target_detailed ? null : target)
	user.visible_message(vague_message, "", ignored_mobs = detailed_mobs)
	return TRUE

/datum/surgery_step/proc/get_speed_modifier(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/speed_mod = 1
	if(tool)
		speed_mod *= tool.toolspeed
	if(implements_speed)
		var/implement_type = tool_check(user, tool)
		if(implement_type)
			speed_mod *= implements_speed[implement_type] || 1
	speed_mod *= get_location_modifier(target)

	return speed_mod

/datum/surgery_step/proc/get_location_modifier(mob/living/target)
	var/turf/patient_turf = get_turf(target)
	var/is_lying = (target.body_position == LYING_DOWN)
	if(!is_lying)
		return 0.6
	if(locate(/obj/structure/table/optable) in patient_turf)
		return 1.1
	if(locate(/obj/structure/bed) in patient_turf)
		return 1
	else if(locate(/obj/structure/table) in patient_turf)
		return 0.8
	return 0.7
	/*
	if(locate(/obj/structure/table/optable) in patient_turf)
		return 1
	else if(locate(/obj/machinery/stasis) in patient_turf)
		return 0.9
	else if(locate(/obj/structure/table) in patient_turf)
		return 0.8
	else if(locate(/obj/structure/bed) in patient_turf)
		return 0.7
	return 0.5
	*/
