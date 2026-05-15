/mob/living/carbon/human/proc/add_bite_animation()
	remove_overlay(BITE_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('icons/effects/clan.dmi', "bite", -BITE_LAYER)
	overlays_standing[BITE_LAYER] = bite_overlay
	apply_overlay(BITE_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_bite)), 1.5 SECONDS)

/mob/living/carbon/human/proc/remove_bite()
	remove_overlay(BITE_LAYER)


/mob/living/proc/drinksomeblood(mob/living/carbon/victim, sublimb_grabbed)
	if(world.time <= next_move)
		return
	if(world.time < last_drinkblood_use + 2 SECONDS)
		return
	if(victim.dna?.species && (NOBLOOD in victim.dna.species.species_traits))
		to_chat(src, span_warning("Sigh. No blood."))
		return
	if(victim.blood_volume <= 0)
		to_chat(src, span_warning("Sigh. No blood."))
		return
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		for(var/I in victim.contents)
			if(SSenchantment.has_enchantment(I, /datum/enchantment/silver))
				to_chat(src, span_userdanger("THEY ARE WEARING MY BANE! HISSS!!!"))
				Paralyze(1)
				return

		human_victim.add_bite_animation()

	last_drinkblood_use = world.time
	changeNext_move(CLICK_CD_MELEE)

	var/datum/antagonist/vampire/VDrinker = mind?.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/vampire/VVictim = victim.mind?.has_antag_datum(/datum/antagonist/vampire)
	var/used_vitae = 0

	if(VDrinker)
		vampire_detected(length(CheckEyewitness(victim)))

	if(mind && victim.mind)
		if(victim.blood_volume <= BLOOD_VOLUME_BAD && !cmode)
			to_chat(src, "<span class='warning'>You don't want to kill your plaything, do you?</span>")
			to_chat(src, "<span class='info'; font-size: 5px;>turn on the cmode t odrain them dry.</span>")
			return
		if(VVictim)
			to_chat(src, span_userdanger("<b>YOU TRY TO COMMIT DIABLERIE ON [victim].</b>"))
		var/zomwerewolf = victim.mind.has_antag_datum(/datum/antagonist/werewolf)
		if(!zomwerewolf)
			if(victim.stat != DEAD)
				zomwerewolf = victim.mind.has_antag_datum(/datum/antagonist/zombie)
		if(VDrinker)
			if(zomwerewolf)
				to_chat(src, span_danger("I'm going to puke..."))
				addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))
			else
				var/blood_handle
				if(victim.stat == DEAD)
					blood_handle |= BLOOD_PREFERENCE_DEAD
				else
					blood_handle |= BLOOD_PREFERENCE_LIVING

				if(victim.job in list("Priest", "Priestess", "Cleric", "Acolyte", "Templar", "Churchling", "Crusader", "Inquisitor"))
					blood_handle |= BLOOD_PREFERENCE_HOLY
				if(VVictim)
					blood_handle |= BLOOD_PREFERENCE_KIN
					blood_handle  &= ~BLOOD_PREFERENCE_LIVING

				if(HAS_TRAIT(victim, TRAIT_SILVER_BLESSED))
					blood_handle |= BLOOD_PREFERENCE_FANCY
					blood_handle |= BLOOD_PREFERENCE_EUPHORIC

				if(victim.bloodpool > 0)
					victim.blood_volume = max(victim.blood_volume-45, 0)
					if(ishuman(victim))
						used_vitae = 150
						if(victim.bloodpool < used_vitae)
							used_vitae = victim.bloodpool // We assume they're left with 250 vitae or less, so we take it all
							to_chat(src, "<span class='warning'>...But alas, only leftovers...</span>")
						var/modified_vitae = clan?.handle_bloodsuck(src, blood_handle, used_vitae)
						if(!isnull(modified_vitae))
							used_vitae = modified_vitae
						src.adjust_bloodpool(used_vitae)
						src.adjust_hydration(used_vitae * 0.1)
						if(VVictim)
							victim.adjust_bloodpool(-used_vitae) //twice the loss
						victim.adjust_bloodpool(-used_vitae)
						victim.last_vitae_drain = world.time
					else
						clan?.handle_bloodsuck(src, blood_handle)
				else
					if(ishuman(victim))
						if(victim.clan && clan)
							AdjustMasquerade(-1)
							message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
							log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")
							to_chat(src, span_danger("I have... Consumed my kindred!"))
							victim.death()
							victim.adjustBruteLoss(-50, TRUE)
							victim.adjustFireLoss(-50, TRUE)
							return
					if(ishuman(victim) && !victim.clan)
						to_chat(src, span_warning("[victim]'s blood is warm, but spiritually spent."))
						if(victim.stat != DEAD)
							to_chat(src, "<span class='warning'>Your victim faints from the excessive draining.</span>")
							victim.SetUnconscious(50 SECONDS)
					if(!ishuman(victim))
						if(victim.stat != DEAD)
							victim.SetUnconscious(50 SECONDS)
		else // Don't larp as a vampire, kids.
			to_chat(src, span_warning("I'm going to puke..."))
			addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))
	else
		if(mind) // We're drinking from a mob or a person who disconnected from the game
			if(mind.has_antag_datum(/datum/antagonist/vampire))
				victim.blood_volume = max(victim.blood_volume-45, 0)
				if(victim.bloodpool >= 250)
					src.adjust_bloodpool(250, 250)
				else
					to_chat(src, span_warning("And yet, not enough vitae can be extracted from them... Tsk."))

	victim.blood_volume = max(victim.blood_volume-5, 0)
	victim.handle_blood()

	playsound(src, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)

	victim.visible_message(span_danger("[src] drinks from [victim]'s [parse_zone(sublimb_grabbed)]!"), \
					span_userdanger("[src] drinks from my [parse_zone(sublimb_grabbed)]!"), span_hear("..."), COMBAT_MESSAGE_RANGE, src)
	to_chat(src, span_warning("I drink from [victim]'s [parse_zone(sublimb_grabbed)]."))
	log_combat(src, victim, "drank blood from ")

/mob/living/carbon/human/proc/vampire_conversion_prompt(mob/living/carbon/sire)
	if(HAS_TRAIT(src, "offered_vampirism"))
		return
	if(!istype(sire?.mind?.has_antag_datum(/datum/antagonist/vampire), /datum/antagonist/vampire) || !sire.clan)
		return
	var/mob/client_victim = src
	if(!client_victim.client)
		client_victim = get_ghost(FALSE, TRUE)
		if(!client_victim?.client)
			client_victim = get_spirit()
			if(!client_victim?.client)
				to_chat(sire, span_warning("[src]'s soul is beyond your grasp."))
				return

	ADD_TRAIT(src, "offered_vampirism", INNATE_TRAIT)
	if(is_antag_banned(client_victim.ckey, ROLE_VAMPIRE))
		to_chat(sire, span_warning("[src] could not be sired."))
		return

	var/datum/clan/C = sire.clan
	var/choice = browser_alert(client_victim, "You have been offered the immortal blessing. Take it, or perish.", "THE CURSE OF KAIN", list("I ACCEPT", "TO NECRA"), timeout = 15 SECONDS)
	if(QDELETED(src))
		return
	if(choice != "I ACCEPT")
		to_chat(client_victim, span_bloody("So be it."))
		var/obj/item/organ/brain/B = getorgan(/obj/item/organ/brain)
		B?.brain_death = TRUE
		death()
		if(!QDELETED(sire))
			to_chat(sire, span_warning("[src] has refused your blessing."))
		return
	grab_ghost(TRUE, TRUE)
	revive((HEAL_DAMAGE|HEAL_AFFLICTIONS|HEAL_LIMBS|HEAL_WOUNDS), 500, TRUE)
	mind.add_antag_datum(new /datum/antagonist/vampire(C, TRUE))
	set_bloodpool(500)
	visible_message(span_danger("Some dark energy begins to flow into [src]..."))
	visible_message(span_red("[src] rises as a new spawn!"))
