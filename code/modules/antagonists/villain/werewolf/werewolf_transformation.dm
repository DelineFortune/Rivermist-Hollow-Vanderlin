/datum/antagonist/werewolf/on_life(mob/user)
	if(!user) return
	var/mob/living/carbon/human/human_user = user
	if(human_user.stat == DEAD) return
	if(human_user.advsetup) return
	if(forced_transform) return
	if(GLOB.tod == "night")
		var/turf/user_loc = human_user.loc
		if(isturf(user_loc))
			if(user_loc.can_see_sky())
				if(!transformed)
					if(COOLDOWN_FINISHED(src, message_cooldown))
						to_chat(human_user, span_userdanger("The moonlight scorns me, inflaming my rage!"))
						COOLDOWN_START(src, message_cooldown, 5 SECONDS)
				human_user.rage_datum.update_rage(10)

	if(transformed && !HAS_TRAIT(human_user, TRAIT_PARALYSIS))
		if(human_user.rage_datum.check_rage(text2num(WW_RAGE_MEDIUM)))
			if(human_user.blood_volume > BLOOD_VOLUME_SURVIVE)
				for(var/datum/wound/wound as anything in human_user.get_wounds())
					wound.heal_wound(1.2)

/datum/antagonist/werewolf/proc/try_transform_checks()
	if(QDELETED(src))
		return FALSE
	var/mob/living/carbon/human/human_user = owner.current
	if(QDELETED(human_user) || human_user.stat >= UNCONSCIOUS || !human_user.mind)
		return FALSE
	if(HAS_TRAIT(human_user, TRAIT_NO_TRANSFORM))
		return FALSE
	if(HAS_TRAIT(human_user, TRAIT_SILVER_BLESSED))
		return FALSE
	if(transformed)
		return FALSE
	return TRUE

/datum/antagonist/werewolf/proc/begin_transform()
	set waitfor = 0

	if(!try_transform_checks()) return

	var/mob/living/carbon/human/human_user = owner.current
	ADD_TRAIT(human_user, TRAIT_NO_TRANSFORM, REF(src))
	human_user.flash_fullscreen("redflash3")
	human_user.emote("agony", forced = TRUE)
	to_chat(human_user, span_userdanger("UNIMAGINABLE PAIN!"))
	human_user.Stun(5.1 SECONDS, ignore_canstun = TRUE)
	human_user.Knockdown(5.1 SECONDS, ignore_canstun = TRUE)
	sleep(2.5 SECONDS)
	human_user.emote("agony", forced = TRUE)
	sleep(2.5 SECONDS)
	REMOVE_TRAIT(human_user, TRAIT_NO_TRANSFORM, REF(src))

	if(!try_transform_checks()) return

	werewolf_transform()

/datum/antagonist/werewolf/proc/werewolf_transform()
	if(!try_transform_checks()) return

	var/mob/living/carbon/human/human_user = owner.current

	if(human_user.cmode)
		human_user.toggle_cmode()

	pre_transformation()

	// Actual transformation step
	var/mob/living/carbon/human/species/werewolf/new_werewolf = generate_werewolf(human_user)
	new_werewolf.apply_status_effect(/datum/status_effect/shapechange_mob/die_with_form, human_user, FALSE)
	new_werewolf.dna?.species.after_creation(new_werewolf) // funny accented werewolf
	new_werewolf.set_patron(human_user.patron)
	human_user.rage_datum.grant_to_secondary(new_werewolf)
	human_user.rage_datum.rage_change_on_life -= transformed_rage_decay

	new_werewolf.adjustBruteLoss(human_user.getBruteLoss() / 2)
	new_werewolf.adjustFireLoss(human_user.getFireLoss() / 2)
	new_werewolf.adjustToxLoss(human_user.getToxLoss() / 2)
	new_werewolf.adjustOxyLoss(human_user.getOxyLoss() / 2)
	new_werewolf.adjustCloneLoss(human_user.getCloneLoss() / 2)
	new_werewolf.blood_volume = human_user.blood_volume
	human_user.fully_heal(HEAL_DAMAGE|HEAL_BLOOD|HEAL_WOUNDS|HEAL_RESTRAINTS)

	playsound(new_werewolf, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	new_werewolf.playsound_local(get_turf(new_werewolf), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
	to_chat(new_werewolf, span_userdanger("I transform into a horrible beast!"))
	new_werewolf.emote("rage")
	new_werewolf.spawn_gibs(FALSE)

	transformed = TRUE
	RegisterSignal(new_werewolf, COMSIG_LIVING_UNSHAPESHIFTED, PROC_REF(werewolf_untransform))

/datum/antagonist/werewolf/proc/pre_transformation()
	var/mob/living/carbon/human/human_user = owner.current
	for(var/obj/item/item as anything in human_user.get_equipped_items(FALSE))
		if(istype(item, /obj/item/clothing) || istype(item, /obj/item/storage/belt))
			item.take_damage(damage_amount = item.max_integrity * 0.15, sound_effect = FALSE)
		else
			human_user.dropItemToGround(item, silent = TRUE)

/datum/antagonist/werewolf/proc/generate_werewolf(mob/living/carbon/human/user)
	var/mob/living/carbon/human/species/werewolf/new_werewolf = new (get_turf(user))
	new_werewolf.age = user.age
	new_werewolf.real_name = wolfname
	new_werewolf.name = wolfname
	new_werewolf.skin_armor = new /obj/item/clothing/armor/regenerating/skin/werewolf_skin(new_werewolf)

	new_werewolf.adjust_skill_level(/datum/attribute/skill/combat/wrestling, 50, TRUE)
	new_werewolf.adjust_skill_level(/datum/attribute/skill/combat/unarmed, 50, TRUE)
	new_werewolf.adjust_skill_level(/datum/attribute/skill/misc/climbing, 60, TRUE)

	for(var/datum/action/werewolf_power as anything in werewolf_form_powers)
		new_werewolf.add_spell(werewolf_power)

	return new_werewolf

/// Helper to remove werewolf transformation effect from owner.current
/datum/antagonist/werewolf/proc/remove_werewolf(forced)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/werewolf_user = owner.current
	if(!transformed)
		return
	if(!forced && HAS_TRAIT(werewolf_user, TRAIT_NO_TRANSFORM))
		return
	werewolf_user.remove_status_effect(/datum/status_effect/shapechange_mob/die_with_form)

/// Called with COMSIG_LIVING_UNSHAPESHIFTED signal
/datum/antagonist/werewolf/proc/werewolf_untransform(mob/living/status_owner, mob/living/status_caster_mob)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/werewolf_user = status_owner
	for(var/obj/item/dropped_item in werewolf_user)
		werewolf_user.dropItemToGround(dropped_item, silent = TRUE)
	var/mob/living/carbon/human/caster_mob = status_caster_mob
	INVOKE_ASYNC(werewolf_user, TYPE_PROC_REF(/mob, emote), "scream")

	to_chat(caster_mob, span_userdanger("The beast within returns to slumber."))
	playsound(caster_mob, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	caster_mob.Knockdown(30)
	caster_mob.Stun(30)
	caster_mob.rage_datum.remove_secondary()
	caster_mob.rage_datum.rage_change_on_life += transformed_rage_decay

	caster_mob.adjustBruteLoss(werewolf_user.getBruteLoss() / 2)
	caster_mob.adjustFireLoss(werewolf_user.getFireLoss() / 2)
	caster_mob.adjustToxLoss(werewolf_user.getToxLoss() / 2)
	caster_mob.adjustOxyLoss(werewolf_user.getOxyLoss() / 2)
	caster_mob.adjustCloneLoss(werewolf_user.getCloneLoss() / 2)
	// caster_mob.blood_volume = werewolf_user.blood_volume

	UnregisterSignal(werewolf_user, COMSIG_LIVING_UNSHAPESHIFTED)
	transformed = FALSE

	/*fully_heal(FALSE)

	var/ww_path
	if(gender == MALE)
		ww_path = /mob/living/carbon/human/species/werewolf/male
	else
		ww_path = /mob/living/carbon/human/species/werewolf/female

	var/mob/living/carbon/human/species/werewolf/W = new ww_path(loc)

	W.verbs |= /mob/living/carbon/human/proc/toggle_werewolf_transform

	if(getorganslot(ORGAN_SLOT_PENIS))
		var/obj/item/organ/genitals/penis/penis = W.getorganslot(ORGAN_SLOT_PENIS)
		penis = new /obj/item/organ/genitals/penis/knotted/big
		penis.Insert(W, TRUE)
	if(getorganslot(ORGAN_SLOT_TESTICLES))
		var/obj/item/organ/genitals/filling_organ/testicles/testicles = W.getorganslot(ORGAN_SLOT_TESTICLES)
		testicles = new /obj/item/organ/genitals/filling_organ/testicles/internal
		testicles.Insert(W, TRUE)
	if(getorganslot(ORGAN_SLOT_BREASTS))
		var/obj/item/organ/genitals/filling_organ/breasts/breasts = W.getorganslot(ORGAN_SLOT_BREASTS)
		breasts = new /obj/item/organ/genitals/filling_organ/breasts
		breasts.Insert(W, TRUE)
	if(getorganslot(ORGAN_SLOT_VAGINA))
		var/obj/item/organ/genitals/filling_organ/vagina/vagina = W.getorganslot(ORGAN_SLOT_VAGINA)
		vagina = new /obj/item/organ/genitals/filling_organ/vagina
		vagina.Insert(W, TRUE)

	W.set_patron(src.patron)
	W.gender = gender
	W.rage_datum = rage_datum
	W.regenerate_icons()
	W.stored_mob = src
	W.limb_destroyer = TRUE
	W.ambushable = FALSE
	W.skin_armor = new /obj/item/clothing/armor/regenerating/skin/werewolf_skin(W)
	playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	W.spawn_gibs(FALSE)
	src.forceMove(W)

	W.after_creation()
	W.stored_language = new
	W.stored_language.copy_known_languages_from(src)
	W.stored_skills = ensure_skills().known_skills.Copy()
	W.stored_experience = ensure_skills().skill_experience.Copy()
	mind.transfer_to(W)
	skills?.known_skills = list()
	skills?.skill_experience = list()
	W.grant_language(/datum/language/beast)

	W.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	W.update_a_intents()

	to_chat(W, span_userdanger("I transform into a horrible beast!"))
	W.emote("rage")

	W.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	W.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	W.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)

	W.base_constitution = 10 //werewolf.dm in the species has their ACTUAL stats, don't edit these, they'll make them stack ontop of each other.
	W.base_strength = 10
	W.base_endurance = 10
	W.recalculate_stats()

	W.add_spell(/datum/action/cooldown/spell/undirected/howl)
	W.add_spell(/datum/action/cooldown/spell/undirected/claws)
	W.add_spell(/datum/action/cooldown/spell/aoe/repulse/howl)
	W.add_spell(/datum/action/cooldown/spell/woundlick)
	W.add_spell(/datum/action/cooldown/spell/lunge)
	W.add_spell(/datum/action/cooldown/spell/throw_target)

	W.rage_datum.grant_to_secondary(W)


	W.adjustBruteLoss(brute_transfer)
	W.adjustFireLoss(burn_transfer)
	W.adjustToxLoss(tox_transfer)
	W.adjustOxyLoss(oxy_transfer)
	W.adjustCloneLoss(clone_transfer)

	invisibility = oldinv

/mob/living/carbon/human/proc/werewolf_untransform(mob/bleh, dead,gibbed)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return
	if(!stored_mob)
		var/mob/living/carbon/human/species/werewolf/wolf = loc
		if(istype(wolf))
			wolf.werewolf_untransform(null, dead, gibbed)
		return
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN UNTRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	for(var/obj/item/W in src)
		dropItemToGround(W)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	var/mob/living/carbon/human/W = stored_mob
	stored_mob = null
	REMOVE_TRAIT(W, TRAIT_NOSLEEP, TRAIT_GENERIC)
	if(dead)
		W.death(gibbed)

	W.forceMove(get_turf(src))

	var/brute_transfer = getBruteLoss()
	var/burn_transfer = getFireLoss()
	var/tox_transfer = getToxLoss()
	var/oxy_transfer = getOxyLoss()
	var/clone_transfer = getCloneLoss()

	REMOVE_TRAIT(W, TRAIT_NOMOOD, TRAIT_GENERIC)

	mind.transfer_to(W)

	var/mob/living/carbon/human/species/werewolf/WA = src
	W.copy_known_languages_from(WA.stored_language)
	skills?.known_skills = WA.stored_skills.Copy()
	skills?.skill_experience = WA.stored_experience.Copy()

	W.remove_spell(/datum/action/cooldown/spell/undirected/howl)
	W.remove_spell(/datum/action/cooldown/spell/undirected/claws)
	W.remove_spell(/datum/action/cooldown/spell/aoe/repulse/howl)
	W.remove_spell(/datum/action/cooldown/spell/woundlick)
	W.remove_spell(/datum/action/cooldown/spell/lunge)
	W.remove_spell(/datum/action/cooldown/spell/throw_target)
	W.rage_datum.remove_secondary()
	W.regenerate_icons()

	REMOVE_TRAIT(W, TRAIT_WEREWOLF_RAGE, INNATE_TRAIT)
	W.rage_datum.rage_decay_rate -= 5

	to_chat(W, span_userdanger("I return to my facade."))
	playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	W.Knockdown(30)
	W.Stun(30)

	W.adjustBruteLoss(brute_transfer)
	W.adjustFireLoss(burn_transfer)
	W.adjustToxLoss(tox_transfer)
	W.adjustOxyLoss(oxy_transfer)
	W.adjustCloneLoss(clone_transfer)

	qdel(src)*/
