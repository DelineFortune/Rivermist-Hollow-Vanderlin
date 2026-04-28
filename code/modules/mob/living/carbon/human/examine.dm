/mob/living/carbon/human/get_examine_string(mob/user, thats = FALSE)
	. = ..()
	var/used_title = get_role_title()
	if(!used_title)
		return
	if(!IsAdminGhost(user))
		if(!get_face_name("")) // face covered?
			return
		var/is_family_member = FALSE
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			is_family_member = H.family_datum && H.family_datum == family_datum
		if(!is_family_member)
			if(HAS_TRAIT(src, TRAIT_FOREIGNER) && !HAS_ANY_OF_TRAITS(src, list(TRAIT_RECRUITED, TRAIT_RECOGNIZED)))
				return
			if(!user.mind?.do_i_know(mind, real_name))
				return
	. += ", the [used_title]"

/mob/living/carbon/human/get_examine_list(mob/user, list/P)
	. = ..()
	for(var/datum/quirk/Q in quirks)
		Q.on_examined(user, P, .)

	var/trait_exam = common_trait_examine()
	if(!isnull(trait_exam))
		LAZYADDASSOCLIST(., EXAMINE_SECT_HEALTH+0.9, trait_exam)

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/hierarchy_text = get_clan_hierarchy_examine(human_user)
		if(hierarchy_text)
			LAZYADDASSOCLIST(., EXAMINE_SECT_BODY, hierarchy_text)


/mob/living/carbon/human/get_examine_face(mob/user, list/P, list/examine_list)
	var/self_inspect = user == src
	var/mob/dead/observer/O = isobserver(user) ? user : null
	var/mob/living/carbon/human/H = ishuman(user) ? user : null

	if(!self_inspect && !HAS_TRAIT(src, TRAIT_FACELESS))
		user.mind?.learn_target_identity(src.mind)

	var/do_i_know = user.mind?.do_i_know(src.mind, real_name)

	/*var/datum/species/species = dna?.species
	if(species?.use_skintones)
		LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_SPECIES+0.6, \
			"[capitalize(P[THEIR])] [lowertext(species.skin_tone_wording || "skin tone")] \
			is [find_key_by_value(species.get_skin_list(), skin_tone) || "incomprehensible"].")*/

	. = list()

	if(culture)
		if((do_i_know || O || istype(culture, H?.culture?.type)) && !istype(culture, /datum/culture/universal/ambiguous))
			var/culture_msg = self_inspect ? P[THEYRE] : "I believe [lowertext(P[THEYRE])]"
			LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_SPECIES+0.6, "[culture_msg] from [culture.examined_string(src, user)].")
		else if(!self_inspect)
			LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_SPECIES+0.6, "[P[THEY]] could be from anywhere.")

	if(!self_inspect)
		var/is_family = FALSE
		var/parenthood_text = GetParenthoodExamineText(H)
		if(parenthood_text)
			. += parenthood_text
			is_family = TRUE
		else if(family_datum && family_datum == H?.family_datum)
			var/family_text = ReturnRelation(user)
			if(family_text)
				. += family_text
			is_family = TRUE

		if(!is_family && !O)
			if(do_i_know)
				. += span_tinynotice("I know [P[THEM]].")
			else
				. += span_tinywarning("I do not know [P[THEM]].")

	. += ..()

	if(lip_style)
		switch(lip_color)
			if("red")
				. += span_info("[capitalize(P[THEYRE])] wearing red lipstick.")
			if("purple")
				. += span_info("[capitalize(P[THEYRE])] wearing purple lipstick.")
			if("lime")
				. += span_info("[capitalize(P[THEYRE])] wearing lime lipstick.")
			if("black")
				. += span_info("[capitalize(P[THEYRE])] wearing black lipstick.")

	if(!self_inspect)
		if(family_datum == SSfamilytree.ruling_family && length(culinary_preferences) && HAS_MIND_TRAIT(user, TRAIT_ROYALSERVANT))
			var/obj/item/reagent_containers/food/snacks/fav_food = culinary_preferences[CULINARY_FAVOURITE_FOOD]
			var/datum/reagent/consumable/fav_drink = culinary_preferences[CULINARY_FAVOURITE_DRINK]
			if(fav_food)
				if(fav_drink)
					. += span_tinynotice("[capitalize(P[THEIR])] favourites are [fav_food.name] and [fav_drink.name].")
				else
					. += span_tinynotice("[capitalize(P[THEIR])] favourite is [fav_food.name].")
			else if(fav_drink)
				. += span_tinynotice("[capitalize(P[THEIR])] favourite is [fav_drink.name].")

			var/obj/item/reagent_containers/food/snacks/hated_food = culinary_preferences[CULINARY_HATED_FOOD]
			var/datum/reagent/consumable/hated_drink = culinary_preferences[CULINARY_HATED_DRINK]
			if(hated_food)
				if(hated_drink)
					. += span_tinynotice("[P[THEY]] hate [hated_food.name] and [hated_drink.name].")
				else
					. += span_tinynotice("[P[THEY]] hate [hated_food.name].")
			else if(hated_drink)
				. += span_tinynotice("[P[THEY]] hate [hated_drink.name].")

	if(!HAS_TRAIT(src, TRAIT_FACELESS))
		if(client?.is_donator() && headshot_link)
			LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_HEADSHOT, "<img src=[headshot_link] width=100 height=100/>")
		if(flavortext || headshot_link || ooc_extra_link)
			LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_HEADSHOT, "<a href='?src=[REF(src)];task=view_flavor_text;'>Examine Closer</a>")
		if((do_i_know || O) && (length(rumour) || length(noble_gossip)))
			LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_HEADSHOT, "<a href='?src=[REF(src)];task=view_rumours_gossip;'>Recall Rumours & Gossip</a>")
		LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_HEADSHOT, "<a href='byond://?src=[REF(src)];view_descriptors=1'>Look at Features</a>")


//You can include this in any mob's examine() to show the examine texts of status effects!
/mob/living/proc/status_effect_examines(mob/user, pronoun_replacement, list/P)
	var/list/examine_list = list()
	if(!pronoun_replacement)
		pronoun_replacement = p_they(TRUE)

	for(var/datum/status_effect/effect as anything in status_effects)
		var/effect_text = effect.get_examine_text(user, P)
		if(!effect_text)
			continue

		var/new_text = replacetext(effect_text, "SUBJECTPRONOUN", pronoun_replacement)
		new_text = replacetext(new_text, "[pronoun_replacement] is", "[pronoun_replacement] [p_are()]")
		examine_list += new_text

	if(!length(examine_list))
		return

	return examine_list.Join("\n")



/mob/living/carbon/human/get_examine_body(mob/user, list/P, list/examine_list)
	. = ..()
	var/list/organ_desc = list()
	var/show_undie_desc = FALSE
	var/show_naked_desc = FALSE
	var/list/arousal_data = list()
	SEND_SIGNAL(src, COMSIG_SEX_GET_AROUSAL, arousal_data)
	if(wear_pants)
		var/obj/item/clothing/pantsies = wear_pants
		var/obj/item/clothing/undies = underwear
		if(pantsies.flags_inv & HIDECROTCH)
			if(!pantsies.genital_access)
				if(arousal_data["arousal"] > VISIBLE_AROUSAL_THRESHOLD)
					if(getorganslot(ORGAN_SLOT_PENIS))
						organ_desc += "[capitalize(P[THEYVE])] a visible bulge in [P[THEIR]] [pantsies.name]."
					if(getorganslot(ORGAN_SLOT_VAGINA))
						organ_desc += "[capitalize(P[THEYRE])] shifting [P[THEIR]] legs uncomfortably."
					//show_pant_desc = TRUE
		else if(undies)
			if(arousal_data["arousal"] > VISIBLE_AROUSAL_THRESHOLD)
				if(getorganslot(ORGAN_SLOT_PENIS))
					organ_desc += "[capitalize(P[THEYRE])] pitching a tent in [P[THEIR]] [underwear.name]."
				if(getorganslot(ORGAN_SLOT_VAGINA))
					organ_desc += "[capitalize(P[THEYVE])] a wet spot on [P[THEIR]] [underwear.name]."
				show_undie_desc = TRUE
		else
			if(arousal_data["arousal"] > VISIBLE_AROUSAL_THRESHOLD)
				if(getorganslot(ORGAN_SLOT_PENIS))
					var/obj/item/organ/genitals/penis/pen = getorganslot(ORGAN_SLOT_PENIS)
					organ_desc += "[capitalize(P[THEIR])] [pen.name] is visibly erect!"
				if(getorganslot(ORGAN_SLOT_VAGINA))
					var/obj/item/organ/genitals/filling_organ/vagina/vag = getorganslot(ORGAN_SLOT_VAGINA)
					organ_desc += "[capitalize(P[THEIR])] [vag.name] is glistening with arousal!"
				show_naked_desc = TRUE

	else if(underwear && !show_undie_desc)
		if(arousal_data["arousal"] > VISIBLE_AROUSAL_THRESHOLD)
			if(getorganslot(ORGAN_SLOT_PENIS))
				organ_desc += "[capitalize(P[THEYRE])] pitching a tent in [P[THEIR]] [underwear.name]."
			if(getorganslot(ORGAN_SLOT_VAGINA))
				organ_desc += "[capitalize(P[THEYVE])] a wet spot on [P[THEIR]] [underwear.name]."
			show_undie_desc = TRUE

	else if(arousal_data["arousal"] > VISIBLE_AROUSAL_THRESHOLD && !show_naked_desc)
		if(getorganslot(ORGAN_SLOT_PENIS))
			var/obj/item/organ/genitals/penis/pen = getorganslot(ORGAN_SLOT_PENIS)
			organ_desc += "[capitalize(P[THEIR])] [pen.name] is visibly erect!"
		if(getorganslot(ORGAN_SLOT_VAGINA))
			var/obj/item/organ/genitals/filling_organ/vagina/vag = getorganslot(ORGAN_SLOT_VAGINA)
			organ_desc += "[capitalize(P[THEIR])] [vag.name] is glistening with arousal!"
		show_naked_desc = TRUE

	if(length(organ_desc))
		. += span_love("[organ_desc.Join("\n")]")
