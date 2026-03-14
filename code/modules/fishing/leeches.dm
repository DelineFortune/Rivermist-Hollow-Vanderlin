#define MAX_LEECH_EVILNESS 10

/obj/item/natural/worms/leech
	name = "leech"
	desc = "A disgusting, blood-sucking parasite."
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "leech"
	baitpenalty = 0
	isbait = TRUE
	fishloot = list(/obj/item/reagent_containers/food/snacks/fish/carp = 5,
					/obj/item/reagent_containers/food/snacks/fish/eel = 5,
					/obj/item/reagent_containers/food/snacks/fish/angler = 1)
	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 0,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,
	)
	bundletype = null
	/// Consistent AKA no lore
	var/consistent = FALSE
	/// Are we giving or receiving blood?
	var/giving = FALSE
	/// How much blood we waste away on process()
	var/drainage = 1
	/// How much blood we suck on on_embed_life()
	var/blood_sucking = 2
	/// How much toxin damage we heal on on_embed_life()
	var/toxin_healing = 1.5
	/// Amount of blood we have stored
	var/blood_storage = 0
	/// Maximum amount of blood we can store
	var/blood_maximum = BLOOD_VOLUME_SURVIVE
	// Completely silent, no do_after and no visible_message
	var/completely_silent = FALSE
	bstorage_visible_layer = STORAGE_LAYER_OUTER
	has_body_storage_overlay = TRUE
	storage_overlay_icon = 'modular_rmh/icons/obj/lewd/leeches_overlay.dmi'
	var/obj/item/organ/target_organ = null
	var/trying_to_attach = FALSE
	var/fluid_sucking = 5
	var/fluid_storage = 0
	var/max_storage = 500
	var/horny = FALSE
	var/manually_attached = FALSE


/obj/item/natural/worms/leech/Initialize()
	. = ..()
	//leech lore
	leech_lore()
	create_reagents(max_storage)
	if(drainage)
		START_PROCESSING(SSobj, src)

/obj/item/natural/worms/leech/process()
	if(drainage)
		blood_storage = max(blood_storage - drainage, 0)
		reagents?.remove_any(amount = drainage)

	if(!istype(loc, /obj/item/organ))
		return

	if(!target_organ)
		target_organ = loc

	var/mob/living/carbon/human/H = target_organ.owner

	switch(target_organ.type)
		if(/obj/item/organ/genitals/nipple/left, /obj/item/organ/genitals/nipple/right)

			var/obj/item/organ/genitals/filling_organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)

			SEND_SIGNAL(H, COMSIG_SEX_GENERIC_ACTION, H, rand(2, 6), rand(2, 6), rand(3, 5))
			if(H.reagents?.get_reagent_amount(/datum/reagent/consumable/aphrodisiac) <= 9)
				H.reagents?.add_reagent(/datum/reagent/consumable/aphrodisiac, 0.1)

			if(!breasts.refilling)
				if(H.get_erp_pref(/datum/erp_preference/boolean/allow_forced_lactation))
					breasts.refilling = TRUE
					to_chat(H, "Your nipples start to itch and you feel wetness on your clothes.")
				else
					H.visible_message("<span class='notice'>[src] detaches from [H]'s nipple, unable to force anything out!</span>", "<span class='notice'>[src] detaches from my nipple, unable to force anything out!</span>")
					horny_leech_unattach(H, target_organ, STORAGE_LAYER_OUTER)
					return


			var/fluid_to_take = min(max_storage - fluid_storage, breasts.reagents.total_volume, fluid_sucking)

			breasts.reagents.trans_to(reagents, fluid_to_take)
			fluid_storage += fluid_to_take

			if(fluid_storage >= max_storage)
				horny_leech_unattach(H, target_organ, STORAGE_LAYER_OUTER)
				to_chat(H, span_info("The sated leech falls off my [target_organ.name]."))
				return
			if(prob(25))
				H.adjust_jitter(2 SECONDS)
				to_chat(H, span_warning("You feel the leech squeezing your nipple, injecting a stream of milk into itself."))
			return

		if(/obj/item/organ/genitals/penis)
			var/obj/item/organ/genitals/filling_organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)


			SEND_SIGNAL(H, COMSIG_SEX_GENERIC_ACTION, H, rand(2, 6), rand(2, 6), 1)
			if(H.reagents?.get_reagent_amount(/datum/reagent/consumable/aphrodisiac) <= 9)
				H.reagents?.add_reagent(/datum/reagent/consumable/aphrodisiac, 0.1)
			if(testicles)
				var/fluid_to_take = min(max_storage - fluid_storage, testicles.reagents.total_volume, fluid_sucking)
				testicles.reagents.trans_to(reagents, fluid_to_take)
				fluid_storage += fluid_to_take
			if(fluid_storage >= max_storage)
				horny_leech_unattach(H, target_organ, STORAGE_LAYER_OUTER)
				to_chat(H, span_info("The sated leech falls off my [target_organ.name]."))
				return
			if(prob(25))
				H.adjust_jitter(2 SECONDS)
				var/chosen_verb = pick(list("A leech is sucking my penis!", "It's sucking cum straight from my balls!", "Something slimy is sucking on my dick!"))
				to_chat(H, span_warning(chosen_verb))
			return

		if(/obj/item/organ/genitals/filling_organ/vagina)
			var/obj/item/organ/genitals/filling_organ/vagina/vagina = target_organ
			var/storage_layer = SEND_SIGNAL(vagina, COMSIG_BODYSTORAGE_FIND_ITEM_LAYER, src)
			SEND_SIGNAL(H, COMSIG_SEX_GENERIC_ACTION, H, rand(2, 6), rand(2, 6), rand(3, 5))
			if(H.reagents?.get_reagent_amount(/datum/reagent/consumable/aphrodisiac) <= 9)
				H.reagents?.add_reagent(/datum/reagent/consumable/aphrodisiac, 0.1)
			var/fluid_to_take = min(max_storage - fluid_storage, vagina.reagents.total_volume, fluid_sucking)
			vagina.reagents.trans_to(reagents, fluid_to_take)
			fluid_storage += fluid_to_take
			if(fluid_storage >= max_storage/2)
				if(prob(30))
					if(horny_leech_move_deeper(H, target_organ, storage_layer))
						fluid_storage = 0
						H.adjust_jitter(2 SECONDS)
						to_chat(H, span_info("The greedy leech moves deeper inside your [target_organ.name]!"))
					else if(storage_layer == STORAGE_LAYER_INNER || storage_layer == STORAGE_LAYER_DEEP)
						to_chat(H, span_warn("You feel the leech calm down deep inside you - it doesn't want to come out!"))
						return PROCESS_KILL
					else
						horny_leech_unattach(H, target_organ, storage_layer)
						to_chat(H, span_info("The sated leech falls off my [target_organ.name]."))
					return
				else
					horny_leech_unattach(H, target_organ, storage_layer)
					to_chat(H, span_info("The sated leech falls off my [target_organ.name]."))
					return
			if(prob(25))
				H.adjust_jitter(2 SECONDS)
				var/chosen_verb = pick(list("A leech is sucking my vagina!", "Something slimy is sucking on my clit!", "It's sucking out my juices!"))
				to_chat(H, span_warning(chosen_verb))
			return

/obj/item/natural/worms/leech/examine(mob/user)
	. = ..()
	if(reagents?.total_volume)
		switch(reagents.total_volume)
			if(0.8 to INFINITY)
				. += "<span class='love'><B>[p_theyre(TRUE)] fat and engorged with flids.</B></span>"
			if(0.5 to 0.8)
				. += "<span class='love'>[p_theyre(TRUE)] well-fed.</span>"
			if(0.1 to 0.5)
				. += "<span class='love'>[p_they(TRUE)] want[p_s()] a meal.</span>"
			if(-INFINITY to 0.1)
				. += "<span class='love'>[p_theyre(TRUE)] starved.</span>"
	else
		switch(blood_storage/blood_maximum)
			if(0.8 to INFINITY)
				. += "<span class='bloody'><B>[p_theyre(TRUE)] fat and engorged with blood.</B></span>"
			if(0.5 to 0.8)
				. += "<span class='bloody'>[p_theyre(TRUE)] well-fed.</span>"
			if(0.1 to 0.5)
				. += "<span class='warning'>[p_they(TRUE)] want[p_s()] a meal.</span>"
			if(-INFINITY to 0.1)
				. += "<span class='dead'>[p_theyre(TRUE)] starved.</span>"
		if(!giving)
			. += "<span class='warning'>[p_theyre(TRUE)] [pick("slurping", "sucking", "inhaling")].</span>"
		else
			. += "<span class='notice'>[p_theyre(TRUE)] [pick("vomiting", "gorfing", "exhaling")].</span>"
	if(drainage)
		START_PROCESSING(SSobj, src)

/obj/item/natural/worms/leech/attack(mob/living/M, mob/user, list/modifiers)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
		if(!affecting)
			return
		if(!get_location_accessible(H, check_zone(user.zone_selected)))
			to_chat(user, "<span class='warning'>Something in the way.</span>") //ooooooooooooooo
			return
		var/used_time
		if(completely_silent || horny)
			used_time = 0
		else
			used_time = (7 SECONDS - (GET_MOB_SKILL_VALUE_OLD(H, /datum/attribute/skill/misc/medicine) * 1 SECONDS))/2
		if(!do_after(user, used_time, H))
			return
		if(!H)
			return

		if(H.get_erp_pref(/datum/erp_preference/boolean/allow_horny_leeches))
			var/choice = FALSE
			if(user.zone_selected in list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN))
				choice = alert(user, "Are you aiming for more private areas?", "Love Leech", "Yes", "No")
				if(choice == "Yes")

					var/obj/item/organ/selected_organ
					switch(user.zone_selected)
						if(BODY_ZONE_CHEST)
							var/organ_choice = browser_input_list(user, "Select the side:", "Suck", list("Left Nipple", "Right Nipple"))
							switch(organ_choice)
								if("Left Nipple")
									target_organ = H.getorganslot(ORGAN_SLOT_LEFT_NIP)
									storage_icon_state = target_organ.slot
									if(!target_organ)
										to_chat(user, "This spot won't offer much to the leech...")
										return
									to_chat(user, "The leech begins to crawl towards the area of interest and opens its soft mouth...")
								if("Right Nipple")
									target_organ = H.getorganslot(ORGAN_SLOT_RIGHT_NIP)
									storage_icon_state = target_organ.slot
									if(!target_organ)
										to_chat(user, "This spot won't offer much to the leech...")
										return
									to_chat(user, "The leech begins to crawl towards the area of interest and opens its soft mouth...")
								else
									return

						if(BODY_ZONE_PRECISE_GROIN)
							var/organ_choice = browser_input_list(user, "Select the organ to which you will attach the leech.", "Suck", list("Vagina", "Penis"))
							switch(organ_choice)
								if("Vagina")
									storage_icon_state = ORGAN_SLOT_VAGINA
									target_organ = H.getorganslot(ORGAN_SLOT_VAGINA)
									if(!target_organ)
										to_chat(user, "Seems that your taget doesn't posess the necessary bits...")
										return
									to_chat(user, "The leech begins to crawl towards the vagina and opens its soft mouth...")
								if("Penis")
									storage_icon_state = ORGAN_SLOT_PENIS
									target_organ = H.getorganslot(ORGAN_SLOT_PENIS)
									if(!target_organ)
										to_chat(user, "Seems that your taget doesn't posess the necessary bits...")
										return
									to_chat(user, "The leech opens its mouth wide and swallows the penis, starting to squeeze it...")
								else
									return

					user.dropItemToGround(src)
					var/success = SEND_SIGNAL(target_organ, COMSIG_BODYSTORAGE_TRY_INSERT, src, STORAGE_LAYER_OUTER)
					if(success)
						if(M == user)
							user.visible_message("<span class='notice'>[user] places [src] on [user.p_their()] [selected_organ].</span>", "<span class='notice'>I place a leech on my [target_organ.name].</span>")
						else
							user.visible_message("<span class='notice'>[user] places [src] on [M]'s [selected_organ].</span>", "<span class='notice'>I place a leech on [M]'s [target_organ.name].</span>")
						START_PROCESSING(SSobj, src)
						manually_attached = TRUE
					else
						target_organ = null
						to_chat(user,"<span class='notice'>There's already something in the desired location.</span>")
					return

		user.dropItemToGround(src)
		src.forceMove(H)
		manually_attached = TRUE
		affecting.add_embedded_object(src, silent = TRUE, crit_message = FALSE)
		if(completely_silent)
			return
		if(M == user)
			user.visible_message("<span class='notice'>[user] places [src] on [user.p_their()] [affecting].</span>", "<span class='notice'>I place a leech on my [affecting].</span>")
		else
			user.visible_message("<span class='notice'>[user] places [src] on [M]'s [affecting].</span>", "<span class='notice'>I place a leech on [M]'s [affecting].</span>")
		return
	return ..()

/obj/item/natural/worms/leech/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	if(!user)
		return
	if(trying_to_attach)
		return

	var/mob/living/carbon/human/H = user
	if(H.get_erp_pref(/datum/erp_preference/boolean/allow_horny_leeches) && !manually_attached)
		var/list/slots_to_check = list(ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_LEFT_NIP, ORGAN_SLOT_RIGHT_NIP)
		var/list/available_organs = list()
		for(var/i in slots_to_check)
			var/obj/item/organ/org = H.getorganslot(i)
			if(org)
				if(SEND_SIGNAL(org, COMSIG_BODYSTORAGE_SELECT_RAND_ITEM, STORAGE_LAYER_OUTER))
					continue
				available_organs += org
		if(LAZYLEN(available_organs))
			target_organ = pick(available_organs)
		else
			if(bodypart)
				bodypart.remove_embedded_object(src)
			return

		trying_to_attach = TRUE
		to_chat(user, span_info("You feel as if something slimy on your [bodypart.name] is crawling toward your [target_organ.name]."))
		addtimer(CALLBACK(src, PROC_REF(migrate_to_horny_slot), target_organ, STORAGE_LAYER_OUTER, bodypart), 100)
		return

	if(giving)
		var/blood_given = min(BLOOD_VOLUME_MAXIMUM - user.blood_volume, blood_storage, blood_sucking)
		user.blood_volume += blood_given
		blood_storage = max(blood_storage - blood_given, 0)
		if((blood_storage <= 0) || (user.blood_volume >= BLOOD_VOLUME_MAXIMUM))
			if(bodypart)
				bodypart.remove_embedded_object(src)
			else
				user.simple_remove_embedded_object(src)
			manually_attached = FALSE
			return TRUE
	else
		var/modifier = bodypart.has_wound(/datum/wound/slash/incision) ? 1.5 : 1
		user.adjustToxLoss(-1 * toxin_healing * modifier)
		var/blood_extracted = min(blood_maximum - blood_storage, user.blood_volume, blood_sucking) * modifier
		if(HAS_TRAIT(user, TRAIT_LEECHIMMUNE))
			blood_extracted *= 0.05 // 95% drain reduction
		user.blood_volume = max(user.blood_volume - blood_extracted, 0)
		blood_storage += blood_extracted
		if((blood_storage >= blood_maximum) || (user.blood_volume <= BLOOD_VOLUME_BAD))
			if(bodypart)
				bodypart.remove_embedded_object(src)
			else
				user.simple_remove_embedded_object(src)
			manually_attached = FALSE
			return TRUE
	return FALSE

/obj/item/natural/worms/leech/attack_atom(atom/attacked_atom, mob/living/user)
	if(istype(attacked_atom, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/glass = attacked_atom
		if(istype(glass, /obj/item/reagent_containers/glass/bottle))
			var/obj/item/reagent_containers/glass/bottle/B = glass
			if(B.closed)
				return
		if(reagents.total_volume)
			reagents.trans_to(glass.reagents, 5, transfered_by = user)
			user.visible_message("<span class='notice'>[user] squeezes some liquid out of [src] into [glass].</span>", "<span class='notice'>I squeeze some liquid out of [src] into [glass].</span>")
	. = ..()

/obj/item/natural/worms/leech/proc/horny_leech_unattach(mob/living/user, obj/item/organ/target_organ, storage_layer)
	var/result = SEND_SIGNAL(target_organ, COMSIG_BODYSTORAGE_TRY_REMOVE, src, storage_layer)
	if(!result)
		qdel(src)
	var/drop_location = user?.drop_location() || drop_location()
	target_organ = null
	manually_attached = FALSE
	if(drop_location)
		doMove(drop_location)
	else
		qdel(src)

/obj/item/natural/worms/leech/proc/migrate_to_horny_slot(obj/item/organ/target_organ, storage_layer, obj/item/bodypart/bodypart)
	if(QDELETED(src))
		return
	if(loc != bodypart)
		target_organ = null
		trying_to_attach = FALSE
		return
	var/mob/living/carbon/human/H = target_organ.owner
	if(!H)
		target_organ = null
		trying_to_attach = FALSE
		return

	bodypart.remove_embedded_object(src)
	storage_icon_state = target_organ.slot
	var/success = SEND_SIGNAL(target_organ, COMSIG_BODYSTORAGE_TRY_INSERT, src, storage_layer, FALSE)

	if(success)
		to_chat(H, span_love("It's latched on!"))
		START_PROCESSING(SSobj, src)
	else
		visible_message(span_info("Unble to find a puchase, [src] falls off!"))
		target_organ = null
	trying_to_attach = FALSE

/obj/item/natural/worms/leech/proc/horny_leech_move_deeper(mob/living/user, obj/item/organ/target_organ, storage_layer)
	if(QDELETED(src))
		return
	var/new_storage_layer = SEND_SIGNAL(target_organ, COMSIG_BODYSTORAGE_FIND_ITEM_LAYER, src)
	if(new_storage_layer == STORAGE_LAYER_OUTER)
		new_storage_layer = STORAGE_LAYER_INNER
	else if(new_storage_layer == STORAGE_LAYER_INNER)
		new_storage_layer = STORAGE_LAYER_DEEP
	else
		return
	SEND_SIGNAL(target_organ, COMSIG_BODYSTORAGE_TRY_REMOVE, src, storage_layer)
	//doMove(get_turf(user))
	var/success = SEND_SIGNAL(target_organ, COMSIG_BODYSTORAGE_TRY_INSERT, src, new_storage_layer, TRUE)
	return success


/// LEECH LORE... Collect em all!
/obj/item/natural/worms/leech/proc/leech_lore()
	if(consistent)
		return FALSE
	horny = rand(0, 1)
	drainage = horny
	var/static/list/all_colors = list(
		"#8471a7" = 8,
		"#94ad6a" = 4,
		"#af995e" = 2,
		"#83a7b3" = 2,
		"#b88383" = 1,
		"#bc69b1" = 1,
	)
	var/static/list/horny_colors = list(
		"#b88383" = 1,
		"#bc69b1" = 1,
	)
	var/static/list/all_adjectives = list(
		"blood-sucking" = 20,
		"disgusting" = 10,
		"vile" = 8,
		"repugnant" = 4,
		"revolting" = 4,
		"grotesque" = 4,
		"hideous" = 4,
		"stupid" = 2,
		"dumb" = 2,
		"demonic" = 1,
	)
	var/static/list/horny_adjectives = list(
		"pulsating" = 4,
		"alluring" = 2,
		"mesmerising" = 1,
	)
	var/static/list/all_descs = list(
		"What a disgusting creature." = 10,
		"Fucking gross." = 5,
		"Slippery..." = 3,
		"So yummy and full of blood." = 3,
		"I love this leech!" = 2,
		"It is so beautiful." = 2,
		"I wish I was a leech." = 1,
	)
	var/static/list/horny_descs = list(
		"It's so sexy." = 10,
		"What an alluring creature." = 3,
		"I want to fuck this leech." = 1,
	)
	var/list/possible_adjectives = horny ? horny_adjectives.Copy() : all_adjectives.Copy()
	var/list/possible_descs = horny ? horny_descs.Copy() : all_descs.Copy()
	var/list/adjectives = list()
	var/list/descs = list()
	var/evilness_rating = horny ? 0 : rand(1, MAX_LEECH_EVILNESS)
	switch(evilness_rating)
		if(MAX_LEECH_EVILNESS to INFINITY) //maximized evilness holy shit
			color = "#dc4b4b"
			adjectives += pick("evil", "malevolent", "misanthropic")
			descs += "<span class='danger'>This one is bursting with hatred!</span>"
		if(5) //this leech is painfully average, it gets no adjectives
			if(prob(3))
				adjectives += pick("average", "ordinary", "boring")
				descs += "This one is extremely boring to look at."
		if(1 to 5) //this leech is pretty terrible at being a leech
			adjectives += pick("pitiful", "pathetic", "depressing")
			descs += "<span class='dead'>This one yearns for nothing but death.</span>"
		else
			var/adjective_amount = 1
			if(prob(5))
				adjective_amount = 3
			else if(prob(30))
				adjective_amount = 2
			for(var/i in 1 to adjective_amount)
				var/picked_adjective = pickweight(possible_adjectives)
				possible_adjectives -= picked_adjective
				adjectives += pickweight(possible_adjectives)
				var/picked_desc = pickweight(possible_descs)
				possible_descs -= picked_desc
				descs += pickweight(possible_descs)
	toxin_healing = min(round((MAX_LEECH_EVILNESS - evilness_rating)/MAX_LEECH_EVILNESS * 2 * initial(toxin_healing), 0.1), 1)
	blood_sucking = max(round(evilness_rating/MAX_LEECH_EVILNESS * 2 * initial(blood_sucking), 0.1), 1)
	if(evilness_rating < 10)
		if(horny)
			color = pickweight(horny_colors)
		else
			color = pickweight(all_colors)
	if(length(adjectives))
		name = "[english_list(adjectives)] [name]"
	if(length(descs))
		desc = "[desc] [jointext(descs, " ")]"
	return TRUE


/obj/item/natural/worms/leech/parasite
	name = "the parasite"
	desc = "A foul, wriggling creecher. Known to suck whole villages of their blood, these rare freeks have been domesticated for medical purposes."
	icon_state = "parasite"
	dropshrink = 0.9
	baitpenalty = 0
	isbait = TRUE
	color = null
	consistent = TRUE
	drainage = 0
	blood_sucking = 5
	toxin_healing = 3
	blood_storage = BLOOD_VOLUME_SURVIVE
	blood_maximum = BLOOD_VOLUME_BAD

/obj/item/natural/worms/leech/parasite/attack_self(mob/user, list/modifiers)
	. = ..()
	giving = !giving
	if(giving)
		user.visible_message("<span class='notice'>[user] squeezes [src].</span>",\
							"<span class='notice'>I squeeze [src]. It will now infuse blood.</span>")
	else
		user.visible_message("<span class='notice'>[user] squeezes [src].</span>",\
							"<span class='notice'>I squeeze [src]. It will now extract blood.</span>")

/obj/item/natural/worms/leech/propaganda
	name = "accursed leech"
	desc = "A leech like none other."
	icon_state = "leech"
	drainage = 0
	blood_sucking = 0
	completely_silent = TRUE
	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 0,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
	)

#undef MAX_LEECH_EVILNESS
