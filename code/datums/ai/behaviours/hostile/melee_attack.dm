#define ERP_SUBDUE_DISARM_SUCCESS_CHANCE 30

/datum/ai_behavior/basic_melee_attack
	action_cooldown = 0.2 SECONDS // We gotta check unfortunately often because we're in a race condition with nextmove
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	var/sidesteps_after = FALSE

/datum/ai_behavior/basic_melee_attack/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	if(isnull(targetting_datum))
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	//Hiding location is priority
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, (target))
	SEND_SIGNAL(controller.pawn, COMSIG_COMBAT_TARGET_SET, TRUE)

/datum/ai_behavior/proc/attempt_nonlethal_mob_erp_subdue(datum/targetting_datum/targetting_datum, mob/living/attacker, mob/living/carbon/human/human_target)
	if(!targetting_datum || !attacker || !human_target)
		return FALSE
	if(!attacker.Adjacent(human_target))
		return TRUE
	if(attacker.next_click >= world.time)
		return TRUE

	if(mob_has_ai_disarmable_held_item(human_target))
		var/static/datum/intent/unarmed/shove/disarm_intent = new()
		var/datum/intent/cached_intent = attacker.used_intent
		attacker.used_intent = disarm_intent
		var/disarm_was_defended = human_target.checkdefense(disarm_intent, attacker)
		attacker.used_intent = cached_intent

		if(!disarm_was_defended)
			if(!prob(ERP_SUBDUE_DISARM_SUCCESS_CHANCE))
				human_target.visible_message(span_danger("[attacker] swats at [human_target]'s hands, but fails to disarm them!"), \
					span_userdanger("[attacker] swats at my hands, but I keep hold of my weapon!"), span_hear("I hear a rough struggle over a weapon!"), COMBAT_MESSAGE_RANGE)
			else
				var/disarmed_anything = FALSE
				for(var/obj/item/held_item as anything in human_target.held_items)
					if(!is_ai_disarmable_held_item(held_item))
						continue
					if(human_target.dropItemToGround(held_item, force = FALSE, silent = FALSE))
						disarmed_anything = TRUE
				if(!disarmed_anything)
					return TRUE
				human_target.Stun(2)
				human_target.visible_message(span_danger("[attacker] disarms [human_target]!"), \
					span_userdanger("[attacker] disarms me!"), span_hear("I hear someone getting punished!"), COMBAT_MESSAGE_RANGE)
	else
		var/prob2defend
		var/obj/item/mainhand = human_target.get_active_held_item()
		var/obj/item/offhand = human_target.get_inactive_held_item()
		var/list/parry_data = human_target.calculate_parry_values(mainhand, offhand)
		prob2defend += CLAMP(parry_data["defense_bonus"] / 80, 0, 40)
		prob2defend += CLAMP(human_target.STASPD / 20 * 50, 0, 50)
		if(human_target.cmode)
			prob2defend *= 1.2
		if(human_target.surrendering)
			prob2defend *= 0.1
		prob2defend = CLAMP(prob2defend + 60, 0, 100)

		// Once only 20% stamina remains, the takedown becomes guaranteed.
		var/stamina_exhaustion = (human_target.maximum_stamina - human_target.stamina) / human_target.maximum_stamina <= 0.2 ? 0 : (human_target.maximum_stamina - human_target.stamina) / human_target.maximum_stamina
		prob2defend = prob2defend * stamina_exhaustion
		var/down_chance = CLAMP(prob2defend, 0, 100)

		if(prob(100 - down_chance))
			human_target.SetStun(20)
			human_target.SetKnockdown(50)
			if(human_target.body_position != LYING_DOWN)
				human_target.emote("gasp")
			attacker.visible_message(span_danger("[attacker] batters [human_target]'s guard down and drags them to the ground!"))
		else
			attacker.visible_message(span_danger("[attacker] tries to pull [human_target] to the ground, exhausting them!"))

		var/stamina_drain = max(round(human_target.maximum_stamina * 0.60 * (1 - ((100 - prob2defend) * 0.01))), 25)
		human_target.adjust_stamina(stamina_drain, null, FALSE, FALSE)

	attacker.next_click = world.time + attacker.melee_attack_cooldown
	SEND_SIGNAL(attacker, COMSIG_MOB_BREAK_SNEAK)
	return TRUE

#undef ERP_SUBDUE_DISARM_SUCCESS_CHANCE

/datum/ai_behavior/basic_melee_attack/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/simple_animal/basic_mob = controller.pawn
	//targetting datum will kill the action if not real anymore
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum.can_attack(basic_mob, target) && !targetting_datum.should_disarm(basic_mob, target))
		finish_action(controller, FALSE, target_key)
		return

	if(ismob(target))
		if(target:stat == DEAD)
			finish_action(controller, FALSE, target_key)
			return

	var/hiding_target = targetting_datum.find_hidden_mobs(basic_mob, target) //If this is valid, theyre hidden in something!

	controller.set_blackboard_key(hiding_location_key, hiding_target)

	basic_mob.face_atom(target)


	if(targetting_datum.should_disarm(basic_mob, target))
		if(ishuman(target))
			var/mob/living/carbon/human/h_target = target
			if(attempt_nonlethal_mob_erp_subdue(targetting_datum, basic_mob, h_target))
				return

	var/list/possible_intents = list()
	for(var/datum/intent/intent as anything in basic_mob.possible_a_intents)
		if(istype(intent, /datum/intent/unarmed/help) || istype(intent, /datum/intent/unarmed/shove) || istype(intent, /datum/intent/unarmed/grab))
			continue
		possible_intents |= intent

	if(length(possible_intents))
		basic_mob.a_intent = pick(possible_intents)
		basic_mob.used_intent = basic_mob.a_intent

	if(!basic_mob.CanReach(target))
		finish_action(controller, FALSE, target_key)
		return

	if(hiding_target) //Slap it!
		controller.ai_interact(hiding_target, TRUE, TRUE)
	else
		controller.ai_interact(target, TRUE, TRUE)
	if(basic_mob.next_click < world.time && istype(basic_mob)) //oopsie I hate that roguecode fucks change_nextMove
		basic_mob.next_click = world.time + basic_mob.melee_attack_cooldown
		SEND_SIGNAL(basic_mob, COMSIG_MOB_BREAK_SNEAK)

	if(sidesteps_after && prob(33)) //this is so fucking hacky, but going off og code this is exactly how it goes ignoring movetimers
		if(!target || !isturf(target.loc) || !isturf(basic_mob.loc) || basic_mob.stat == DEAD)
			return
		var/target_dir = get_dir(basic_mob,target)

		var/static/list/cardinal_sidestep_directions = list(-90,-45,0,45,90)
		var/static/list/diagonal_sidestep_directions = list(-45,0,45)
		var/chosen_dir = 0
		if (target_dir & (target_dir - 1))
			chosen_dir = pick(diagonal_sidestep_directions)
		else
			chosen_dir = pick(cardinal_sidestep_directions)
		if(chosen_dir)
			chosen_dir = turn(target_dir,chosen_dir)
			basic_mob.Move(get_step(basic_mob,chosen_dir))
			basic_mob.face_atom(target) //Looks better if they keep looking at you when dodging

/datum/ai_behavior/basic_melee_attack/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)
	var/mob/living/simple_animal/basic_mob = controller.pawn
	basic_mob.cmode = FALSE
	SEND_SIGNAL(controller.pawn, COMSIG_COMBAT_TARGET_SET, FALSE)

/datum/ai_behavior/basic_ranged_attack
	action_cooldown = 0.6 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION //we want to weave
	required_distance = 3

/datum/ai_behavior/basic_ranged_attack/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, (target))


/datum/ai_behavior/basic_ranged_attack/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/simple_animal/basic_mob = controller.pawn
	//targetting datum will kill the action if not real anymore
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]


	if(!targetting_datum.can_attack(basic_mob, target))
		finish_action(controller, FALSE, target_key)
		return

	var/atom/hiding_target = targetting_datum.find_hidden_mobs(basic_mob, target) //If this is valid, theyre hidden in something!

	controller.set_blackboard_key(hiding_location_key, hiding_target)

	basic_mob.face_atom()
	if(hiding_target) //Shoot it!
		basic_mob.RangedAttack(hiding_target)
	else
		basic_mob.RangedAttack(target)

/datum/ai_behavior/basic_ranged_attack/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)

/datum/ai_behavior/basic_melee_attack/meatvine/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	var/atom/target = controller.blackboard[target_key]
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)
		controller.set_blackboard_key_assoc(BB_MEATVINE_ATTACK_FAIL, target, world.time)

/datum/ai_behavior/basic_melee_attack/mimic/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)
		controller.pawn.icon_state = "mimic"

/datum/ai_behavior/basic_melee_attack/saiga
	action_cooldown = 0.2 SECONDS // We gotta check unfortunately often because we're in a race condition with nextmove
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/basic_melee_attack/saiga/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	var/mob/living/simple_animal/basic_mob = controller.pawn
	//targetting datum will kill the action if not real anymore
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum.can_attack(basic_mob, target))
		finish_action(controller, FALSE, target_key)
		return

	if(ismob(target))
		if(target:stat == DEAD)
			finish_action(controller, FALSE, target_key)
			return

	var/hiding_target = targetting_datum.find_hidden_mobs(basic_mob, target) //If this is valid, theyre hidden in something!

	controller.set_blackboard_key(hiding_location_key, hiding_target)

	var/list/possible_intents = list()
	for(var/datum/intent/intent as anything in basic_mob.possible_a_intents)
		if(istype(intent, /datum/intent/unarmed/help) || istype(intent, /datum/intent/unarmed/shove) || istype(intent, /datum/intent/unarmed/grab))
			continue
		possible_intents |= intent

	if(length(possible_intents))
		basic_mob.a_intent = pick(possible_intents)
		basic_mob.used_intent = basic_mob.a_intent

	if(!basic_mob.CanReach(target))
		finish_action(controller, FALSE, target_key)
		return

	if(hiding_target) //Slap it!
		controller.ai_interact(hiding_target, TRUE, TRUE)
	else
		controller.ai_interact(target, TRUE, TRUE)
	if(basic_mob.next_click < world.time && istype(basic_mob)) //oopsie I hate that roguecode fucks change_nextMove
		basic_mob.next_click = world.time + basic_mob.melee_attack_cooldown
		SEND_SIGNAL(basic_mob, COMSIG_MOB_BREAK_SNEAK)
		finish_action(controller, TRUE, target_key)

/datum/ai_behavior/basic_melee_attack/hellhound/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	var/mob/living/simple_animal/basic_mob = controller.pawn
	//targetting datum will kill the action if not real anymore
	var/mob/living/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum.can_attack(basic_mob, target))
		finish_action(controller, FALSE, target_key)
		return

	if(ismob(target))
		if(target:stat == DEAD)
			finish_action(controller, FALSE, target_key)
			return

	var/hiding_target = targetting_datum.find_hidden_mobs(basic_mob, target) //If this is valid, theyre hidden in something!

	controller.set_blackboard_key(hiding_location_key, hiding_target)

	basic_mob.face_atom(target)
	var/list/possible_intents = list()
	for(var/datum/intent/intent as anything in basic_mob.possible_a_intents)
		if(istype(intent, /datum/intent/unarmed/help) || istype(intent, /datum/intent/unarmed/shove) || istype(intent, /datum/intent/unarmed/grab))
			continue
		possible_intents |= intent

	if(length(possible_intents))
		basic_mob.a_intent = pick(possible_intents)
		basic_mob.used_intent = basic_mob.a_intent

	if(!basic_mob.CanReach(target))
		finish_action(controller, FALSE, target_key)
		return

	if(hiding_target) //Slap it!
		controller.ai_interact(hiding_target, TRUE, TRUE)
	else
		controller.ai_interact(target, TRUE, TRUE)
	if(basic_mob.next_click < world.time && istype(basic_mob)) //oopsie I hate that roguecode fucks change_nextMove
		basic_mob.next_click = world.time + basic_mob.melee_attack_cooldown
		SEND_SIGNAL(basic_mob, COMSIG_MOB_BREAK_SNEAK)

	if(sidesteps_after && prob(33)) //this is so fucking hacky, but going off og code this is exactly how it goes ignoring movetimers
		if(!target || !isturf(target.loc) || !isturf(basic_mob.loc) || basic_mob.stat == DEAD)
			return
		var/target_dir = get_dir(basic_mob,target)

		var/static/list/cardinal_sidestep_directions = list(-90,-45,0,45,90)
		var/static/list/diagonal_sidestep_directions = list(-45,0,45)
		var/chosen_dir = 0
		if (target_dir & (target_dir - 1))
			chosen_dir = pick(diagonal_sidestep_directions)
		else
			chosen_dir = pick(cardinal_sidestep_directions)
		if(chosen_dir)
			chosen_dir = turn(target_dir,chosen_dir)
			basic_mob.Move(get_step(basic_mob,chosen_dir))
			basic_mob.face_atom(target) //Looks better if they keep looking at you when dodging


	if((controller.blackboard[BB_HELLHOUND_FIRE] < world.time) && isliving(target))
		controller.set_blackboard_key(BB_HELLHOUND_FIRE, world.time + 10 SECONDS)
		target.adjust_fire_stacks(5)
		target.IgniteMob()
		target.visible_message(span_danger("[basic_mob] sets [target] on fire!"))


/datum/ai_behavior/basic_melee_attack/warden/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/simple_animal/basic_mob = controller.pawn
	//targetting datum will kill the action if not real anymore
	var/mob/living/target = controller.blackboard[target_key]
	if(!isliving(target))
		return
	var/atom/throw_target = get_edge_target_turf(basic_mob, get_dir(basic_mob, target)) //ill be real I got no idea why this worked.
	target.throw_at(throw_target, 7, 4)
	target.adjustBruteLoss(20)

/datum/ai_behavior/basic_melee_attack/species_hostile/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()

	var/mob/living/pawn = controller.pawn
	//targetting datum will kill the action if not real anymore
	var/mob/living/target = controller.blackboard[target_key]
	if(!isliving(target))
		return
	if(!pawn.cmode)
		pawn.cmode = TRUE
	var/obj/item/weapon = pawn.get_active_held_item()
	var/obj/item/offweapon = pawn.get_inactive_held_item()
	if(HAS_TRAIT(pawn, TRAIT_DODGEEXPERT))
		pawn.d_intent = INTENT_DODGE
	else
		if(weapon)
			if(pawn.d_intent != INTENT_PARRY)
				pawn.d_intent = INTENT_PARRY
	if(weapon)
		if(!HAS_TRAIT(weapon, TRAIT_WIELDED))
			if(weapon.force_wielded > weapon.force)
				if(!offweapon)
					weapon.attack_self(pawn)
	if(!weapon && !offweapon)
		pawn.d_intent = INTENT_DODGE
