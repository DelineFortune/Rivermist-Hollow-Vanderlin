//rogue innate vanish from dreamkeep by videnoir/eaglephntm
/datum/action/cooldown/spell/undirected/rogue_vanish
	name = "Vanish"
	cooldown_time = 20 SECONDS
	button_icon_state = "blindness"
	sound = 'sound/magic/barbroar.ogg'
	antimagic_flags = NONE
	charge_required = FALSE
	has_visual_effects = FALSE
	cooldown_time = 2 MINUTES
	spell_cost = 0
	sound = 'sound/misc/explode/incendiary (1).ogg'
	invocation = "pulls out a smoke bomb and slams it to the ground!"
	invocation_type = INVOCATION_EMOTE
	invocation_self_message = "I pull out a smoke bomb and slam it to the ground!"
	associated_skill = /datum/skill/misc/sneaking
	cooldown_reduction_per_rank = 2 SECONDS

/datum/action/cooldown/spell/undirected/rogue_vanish/cast(mob/living/carbon/human/user)
	. = ..()
	new /obj/effect/particle_effect/smoke(get_turf(user))
	user.visible_message(span_warning("[user] tosses a smokebomb to the ground and vanishes in a puff of smoke!"), span_notice("I toss a smokebomb to the ground and vanish in a puff of smoke!"))
	playsound(user.loc, 'sound/misc/explode/incendiary (1).ogg', 50, FALSE, -1)
	for(var/mob/living/simple_animal/hostile/nearmob in viewers(12, user))
		if(nearmob.ai_controller)
			nearmob.ai_controller.CancelActions()
	for(var/mob/living/carbon/human/nearmob in viewers(12, user))
		if(nearmob.ai_controller)
			nearmob.ai_controller.CancelActions()
	ADD_TRAIT(user, TRAIT_IMPERCEPTIBLE, "[type]")
	animate(user, alpha = 100, time = 0.5 SECONDS, easing = EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(unvanish), user), 6 SECONDS)
	return FALSE

/datum/action/cooldown/spell/undirected/rogue_vanish/proc/unvanish(mob/living/carbon/human/user)
	user.update_sneak_invis(TRUE)
	REMOVE_TRAIT(user, TRAIT_IMPERCEPTIBLE, "[type]")
	user.visible_message(span_warning("[user] comes into view."), span_warning("I become visible again."))
