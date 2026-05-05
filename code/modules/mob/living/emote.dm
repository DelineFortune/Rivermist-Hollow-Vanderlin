
/* EMOTE DATUMS */
/datum/emote/living
	mob_type_allowed_typecache = /mob/living
	mob_type_blacklist_typecache = list(/mob/living/brain)



// ............... Pray ..................
/datum/emote/living/pray
	key = "pray"
	key_third_person = "prays"
	message = "prays something."
	restraint_check = FALSE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_pray()
	set name = "Pray"
	set category = "Emotes.Silent"

	emote("pray", intentional = TRUE)
	SEND_SIGNAL(src, COMSIG_PRAYER_COMPLETED)

/datum/emote/living/pray/run_emote(mob/user, params, type_override, intentional)
	if(HAS_TRAIT(user, TRAIT_ATHEISM_CURSE))
		to_chat(user, span_danger("Praying is for fools."))
		return

	if(!intentional || (!ishuman(user) && !isroguespirit(user)))
		return ..() //they get to do a fake prayer cause they SUCK

	var/mob/living/carbon/follower = user
	var/datum/patron/patron = follower.patron

	var/in_literal_hell = ( istype(get_area(user), /area/underworld) )
	if(!in_literal_hell && !patron?.can_pray(follower))
		return

	var/prayer = input("Whisper your prayer:", "Prayer") as text|null
	if(!prayer)
		return

	/* admin stuff */
	send_prayer(follower, prayer, patron.name)
	user.log_message("(follower of [patron]) prays: [prayer]", LOG_GAME)

	follower.whisper(prayer)

	if(SEND_SIGNAL(follower, COMSIG_CARBON_PRAY, prayer) & CARBON_PRAY_CANCEL)
		return

	for(var/mob/living/crit_guy in hearers(2, follower)) //as of writing succumb_timer does literally nothing btw
		crit_guy.succumb_timer = world.time

/proc/send_prayer(mob/living/follower, prayer, patron_name, bigger = FALSE)
	var/ident_string = "[follower.key]/([follower.real_name]) (follower of [patron_name])"
	if(follower.has_quirk(/datum/quirk/vice/godfearing))
		ident_string += "[SPAN_GOD_GENERIC("(GODFEARING)")]"
	/// Usually I hate not using spans properly, but in this case it's going to make my life easier.
	var/lowercase_god = "generic"
	if(patron_name in COLORFUL_PATRONS)
		lowercase_god = ckey(patron_name)//Getting the game to correctly pull this has been the biggest pain in the butt.
	var/message = SPAN_PRAYER_WRAPPER(span_admin("[span_prefix("PRAYER: ")][ident_string] [ADMIN_SM(follower)] [ADMIN_NRT(follower)] [ADMIN_FLW(follower)] prays: <span class='god_[lowercase_god]'>[html_encode(prayer)]</span>"))
	if(bigger)
		message = span_slightlylarger(message)
	for(var/client/admin_client in GLOB.admins)
		if(check_rights_for(admin_client, R_ADMIN))
			to_chat(admin_client, message)
			if(admin_client.prefs.toggles & SOUND_PRAYERS)
				admin_client.mob.playsound_local(admin_client, 'sound/misc/yeoldebwoink.ogg', 100)


// ............... Me (custom emote) ..................
/datum/emote/living/custom
	key = "me"
	key_third_person = "custom"
	message_param = "%t"
	mute_time = 1

/datum/emote/living/custom/can_run_emote(mob/user, status_check, intentional)
	. = ..() && intentional

/datum/emote/living/custom/proc/check_invalid(mob/user, input)
	. = TRUE
	if(copytext(input,1,5) == "says")
		to_chat(user, "<span class='danger'>Invalid emote.</span>")
	else if(copytext(input,1,9) == "exclaims")
		to_chat(user, "<span class='danger'>Invalid emote.</span>")
	else if(copytext(input,1,6) == "yells")
		to_chat(user, "<span class='danger'>Invalid emote.</span>")
	else if(copytext(input,1,5) == "asks")
		to_chat(user, "<span class='danger'>Invalid emote.</span>")
	else
		. = FALSE

/datum/emote/living/custom/run_emote(mob/user, params, type_override = null, intentional = FALSE)
	if(QDELETED(user))
		return FALSE

	if(!can_run_emote(user, TRUE, intentional))
		return FALSE

	if(user.client?.prefs.muted & MUTE_IC)
		to_chat(user, "<span class='boldwarning'>I cannot send IC messages (muted).</span>")
		return FALSE

	message = params
	if(type_override)
		emote_type = type_override
	. = ..()
	message = null
	emote_type = EMOTE_VISIBLE

/datum/emote/living/custom/replace_pronoun(mob/user, message)
	return message

// ............... A ..................
/datum/emote/living/attnwhistle
	key = "attnwhistle"
	message = "whistles for attention!"
	emote_type = EMOTE_AUDIBLE
/mob/living/carbon/human/verb/emote_attnwhistle()
	set name = "Attnwhistle"
	set category = "Emotes.Noises"
	emote("attnwhistle", intentional = TRUE)
/datum/emote/living/attnwhistle/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(!C.can_speak_vocal())
			message = "makes a muffled noise."

/datum/emote/living/scream/agony
	key = "agony"
	message = "screams in agony!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/scream/agony/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/L in viewers(7,user))
			if(L.has_quirk(/datum/quirk/vice/sadist))
				L.sate_addiction(/datum/quirk/vice/sadist)

/datum/emote/living/scream/painscream/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/L in viewers(7,user))
			if(L.has_quirk(/datum/quirk/vice/sadist))
				L.sate_addiction(/datum/quirk/vice/sadist)

/datum/emote/living/scream/firescream/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/L in viewers(7,user))
			if(L.has_quirk(/datum/quirk/vice/sadist))
				L.sate_addiction(/datum/quirk/vice/sadist)

/datum/emote/living/aggro
	key = "aggro"
	key_third_person = "aggro"
	message = ""
	nomsg = TRUE
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

// ............... B ..................
/datum/emote/living/blush
	key = "blush"
	key_third_person = "blushes"
	message = "blushes."

/datum/emote/living/breathgasp
	key = "breathgasp"
	key_third_person = "breathgasps"
	message = "gasps for air!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/bow
	key = "bow"
	key_third_person = "bows"
	message = "bows."
	message_param = "bows to %t."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_bow()
	set name = "Bow"
	set category = "Emotes.Silent"
	emote("bow", intentional = TRUE)

/datum/emote/living/burp
	key = "burp"
	key_third_person = "burps"
	message = "burps."
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_burp()
	set name = "Burp"
	set category = "Emotes.Noises"
	emote("burp", intentional = TRUE)


// ............... C ..................
/datum/emote/living/chuckle
	key = "chuckle"
	key_third_person = "chuckles"
	message = "chuckles."
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_chuckle()
	set name = "Chuckle"
	set category = "Emotes.Noises"
	emote("chuckle", intentional = TRUE)

/datum/emote/living/choke
	key = "choke"
	key_third_person = "chokes"
	message = "chokes!"
	emote_type = EMOTE_AUDIBLE
	ignore_silent = TRUE
/mob/living/carbon/human/verb/emote_choke()
	set name = "Choke"
	set category = "Emotes.Noises"
	emote("choke", intentional = TRUE)

/datum/emote/living/cross
	key = "crossarms"
	key_third_person = "crossesarms"
	message = "crosses their arms."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_crossarms()
	set name = "Crossarms"
	set category = "Emotes.Silent"
	emote("crossarms", intentional = TRUE)

/datum/emote/living/collapse
	key = "collapse"
	key_third_person = "collapses"
	message = "collapses."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/collapse/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.SetKnockdown(40)

/datum/emote/living/choke
	key = "choke"
	key_third_person = "chokes"
	message = "chokes!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/cough
	key = "cough"
	key_third_person = "coughs"
	message = "coughs."
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_cough()
	set name = "Cough"
	set category = "Emotes.Noises"
	emote("cough", intentional = TRUE)

/datum/emote/living/clearthroat
	key = "clearthroat"
	key_third_person = "clearsthroat"
	message = "clears their throat."
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/mob/living/carbon/human/verb/emote_clearthroat()
	set name = "Clearthroat"
	set category = "Emotes.Noises"
	emote("clearthroat", intentional = TRUE)

// ............... D ..................
/datum/emote/living/dance
	key = "dance"
	key_third_person = "dances"
	message = "dances."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_dance()
	set name = "Dance"
	set category = "Emotes.Silent"
	emote("dance", intentional = TRUE)

/datum/emote/living/death
	key = "death"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living)

/datum/emote/living/deathgasp
	key = ""
	key_third_person = ""
	message = "gasps out their last breath."
	message_monkey = "lets out a faint chimper as it collapses and stops moving..."
	message_simple =  "falls limp."
	stat_allowed = UNCONSCIOUS

/datum/emote/living/deathgasp/run_emote(mob/user, params, type_override, intentional)
	var/mob/living/simple_animal/S = user
	if(istype(S) && S.deathmessage)
		message_simple = S.deathmessage
	. = ..()
	message_simple = initial(message_simple)
	if(. && user.deathsound)
		if(isliving(user))
			var/mob/living/L = user
			if(!L.can_speak_vocal() || L.oxyloss >= 50)
				return //stop the sound if oxyloss too high/cant speak
		playsound(user, user.deathsound, 200, TRUE, TRUE)

/datum/emote/living/drool
	key = "drool"
	key_third_person = "drools"
	message = "drools."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_drool()
	set name = "Drool"
	set category = "Emotes.Silent"
	emote("drool", intentional = TRUE)

/datum/emote/living/drown
	key = "drown"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	ignore_silent = TRUE

// ............... E ..................
/datum/emote/living/embed
	key = "embed"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

// ............... F ..................
/datum/emote/living/faint
	key = "faint"
	key_third_person = "faints"
	message = "faints."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_faint()
	set name = "Faint"
	set category = "Emotes.Silent"
	emote("faint", intentional = TRUE)

/datum/emote/living/faint/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/L = user
		if(L.getPainLoss() > (GET_MOB_ATTRIBUTE_VALUE(L, STAT_ENDURANCE) * 9))
			L.setDir(2)
			L.SetUnconscious(200)
		else
			L.Knockdown(10)

/datum/emote/living/fatigue
	key = "fatigue"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/frown
	key = "frown"
	key_third_person = "frowns"
	message = "frowns."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_frown()
	set name = "Frown"
	set category = "Emotes.Silent"
	emote("frown", intentional = TRUE)

/datum/emote/living/scream/firescream
	key = "firescream"
	nomsg = TRUE
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	nomsg = TRUE

// ............... G ..................
/datum/emote/living/gag
	key = "gag"
	key_third_person = "gags"
	message = "gags."
	emote_type = EMOTE_AUDIBLE
	ignore_silent = TRUE
/mob/living/carbon/human/verb/emote_gag()
	set name = "Gag"
	set category = "Emotes.Noises"
	emote("gag", intentional = TRUE)

/datum/emote/living/gasp
	key = "gasp"
	key_third_person = "gasps"
	message = "gasps!"
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS
/mob/living/carbon/human/verb/emote_gasp()
	set name = "Gasp"
	set category = "Emotes.Noises"
	emote("gasp", intentional = TRUE)
/datum/emote/living/gasp/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(!C.can_speak_vocal())
			message = "makes a muffled noise."

/datum/emote/living/giggle
	key = "giggle"
	key_third_person = "giggles"
	message = "giggles."
	message_mime = "giggles silently!"
	emote_type = EMOTE_AUDIBLE
/mob/living/carbon/human/verb/emote_giggle()
	set name = "Giggle"
	set category = "Emotes.Noises"
	emote("giggle", intentional = TRUE)
/datum/emote/living/giggle/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(!C.can_speak_vocal())
			message = "makes a muffled laugh."

/datum/emote/living/glare
	key = "glare"
	key_third_person = "glares"
	message = "glares."
	message_param = "glares at %t."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_glare()
	set name = "Glare"
	set category = "Emotes.Silent"
	emote("glare", intentional = TRUE)

/datum/emote/living/grin
	key = "grin"
	key_third_person = "grins"
	message = "grins."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_grin()
	set name = "Grin"
	set category = "Emotes.Silent"
	emote("grin", intentional = TRUE)

/datum/emote/living/groan
	key = "groan"
	key_third_person = "groans"
	message = "groans."
	message_muffled = "makes a muffled groan."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_groan()
	set name = "Groan"
	set category = "Emotes.Noises"
	emote("groan", intentional = TRUE)

/datum/emote/living/grimace
	key = "grimace"
	key_third_person = "grimaces"
	message = "grimaces."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_grimace()
	set name = "Grimace"
	set category = "Emotes.Silent"
	emote("grimace", intentional = TRUE)

/datum/emote/living/groin
	key = "groin"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

// ............... H ..................
/datum/emote/living/haltyell
	key = "haltyell"
	message = "shouts a halt!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/haltyellorphan

	key = "haltyellorphan"
	message = "tries to shout a convincing halt!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/hmm
	key = "hmm"
	key_third_person = "hmms"
	message = "hmms."
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/mob/living/carbon/human/verb/emote_hmm()
	set name = "Hmm"
	set category = "Emotes.Noises"
	emote("hmm", intentional = TRUE)
/datum/emote/living/hmm/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(!C.can_speak_vocal())
			message = "makes a muffled hmm."

/datum/emote/living/huh
	key = "huh"
	key_third_person = "huhs"
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/mob/living/carbon/human/verb/emote_huh()
	set name = "Huh"
	set category = "Emotes.Noises"
	emote("huh", intentional = TRUE)

/datum/emote/living/hum
	key = "hum"
	key_third_person = "hums"
	message = "hums."
	message_muffled = "makes a muffled hum."
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/mob/living/carbon/human/verb/emote_hum()
	set name = "Hum"
	set category = "Emotes.Noises"
	emote("hum", intentional = TRUE)

/datum/emote/living/hug
	key = "hug"
	key_third_person = "hugs"
	message = ""
	message_param = "hugs %t."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/mob/living/carbon/human/verb/emote_hug()
	set name = "Hug"
	set category = "Emotes.Silent"
	emote("hug", intentional = TRUE, targetted = TRUE)

/datum/emote/living/hug/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_EORA_CURSE))
		var/mob/living/carbon/human/H = user
		to_chat(H, "<span class='warning'>The idea repulses me!</span>")
		H.cursed_freak_out()
		return FALSE

/datum/emote/living/hug/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		// cursed is the one being hugged
		if(HAS_TRAIT(H, TRAIT_EORA_CURSE))
			to_chat(H, "<span class='warning'>I feel inexplicably repelled!</span>")
			H.cursed_freak_out()
			return

/datum/emote/living/hug/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/H = target
		H.add_stress(/datum/stress_event/hug)
		playsound(target, pick('sound/vo/hug.ogg'), 100, FALSE, -1)

		if(user.mind)
			SEND_SIGNAL(user, COMSIG_MOB_HUGGED, H)
			record_round_statistic(STATS_HUGS_MADE)

/datum/emote/living/headpat
	key = "headpat"
	key_third_person = "pats"
	message = ""
	message_param = "pats %t on the head."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/mob/living/carbon/human/verb/emote_headpat()
	set name = "Headpat"
	set category = "Emotes.Silent"
	emote("headpat", intentional = TRUE, targetted = TRUE)

/datum/emote/living/headpat/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		playsound(target, pick('sound/vo/hug.ogg'), 100, FALSE, -1)
		if(israkshari(H))
			if(prob(10))
				H.emote("purr")


// ............... I ..................
/datum/emote/living/idle
	key = "idle"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

// ............... J ..................
/datum/emote/living/jump
	key = "jump"
	key_third_person = "jumps"
	message = "jumps!"
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

// ............... K ..................
/datum/emote/living/kiss
	key = "kiss"
	key_third_person = "kisses"
	message = "blows a kiss."
	message_param = "kisses %t."
	emote_type = EMOTE_VISIBLE


/datum/emote/living/kiss/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_EORA_CURSE))
		var/mob/living/carbon/human/H = user
		to_chat(H, "<span class='warning'>The idea repulses me!</span>")
		H.cursed_freak_out()
		return FALSE

/mob/living/carbon/human/verb/emote_kiss()
	set name = "Kiss"
	set category = "Emotes.Silent"
	emote("kiss", intentional = TRUE, targetted = TRUE)

/datum/emote/living/kiss/adjacentaction(mob/user, mob/target)
	. = ..()
	message_param = initial(message_param) // re
	if(!user || !target)
		return
	if(ishuman(user) && ishuman(target))
		var/mob/living/carbon/human/H = user
		var/mob/living/carbon/human/E = target

		// cursed is the one being kissed
		if(HAS_TRAIT(E, TRAIT_EORA_CURSE))
			to_chat(E, "<span class='warning'>I feel inexplicably repelled!</span>")
			E.cursed_freak_out()

		var/do_change
		if(target.loc == user.loc)
			do_change = TRUE
		if(!do_change)
			if(H.pulling == target)
				do_change = TRUE
		if(do_change)
			if(H.zone_selected == BODY_ZONE_PRECISE_MOUTH)
				message_param = "kisses %t deeply."
			else if(H.zone_selected == BODY_ZONE_PRECISE_EARS)
				message_param = "kisses %t on the ear."
				if(E.dna.species?.id == "elf")
					if(!E.cmode)
						to_chat(target, span_love("It tickles..."))
			else if(H.zone_selected == BODY_ZONE_PRECISE_R_EYE || H.zone_selected == BODY_ZONE_PRECISE_L_EYE)
				message_param = "kisses %t on the brow."
			else
				message_param = "kisses %t on \the [parse_zone(H.zone_selected)]."
	playsound(target, pick('sound/vo/kiss (1).ogg','sound/vo/kiss (2).ogg'), 100, FALSE, -1)
	if(user.mind)
		record_round_statistic(STATS_KISSES_MADE)

// ............... L ..................
/datum/emote/living/laugh
	key = "laugh"
	key_third_person = "laughs"
	message = "laughs."
	message_mime = "laughs silently!"
	message_muffled = "makes a muffled laugh."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/laugh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	return ..() && user.can_speak()

/datum/emote/living/laugh/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(. && user.mind)
		record_featured_stat(FEATURED_STATS_JOKESTERS, user)
		record_round_statistic(STATS_LAUGHS_MADE)

/mob/living/carbon/human/verb/emote_laugh()
	set name = "Laugh"
	set category = "Emotes.Noises"
	emote("laugh", intentional = TRUE)

/datum/emote/living/leap
	key = "leap"
	key_third_person = "leaps"
	message = "leaps!"
	restraint_check = TRUE
	only_forced_audio = TRUE

/datum/emote/living/look
	key = "look"
	key_third_person = "looks"
	message = "stares blankly."
	message_param = "looks at %t."

/datum/emote/living/lower	// the emote that signals an animal is tamed. Previously smile was used. The chicken smiles. The pig smiles. Wut.
	key = "lower_head"
	key_third_person = "lowers_head"
	message = "lowers its head."
	message_param = "lowers its head."
	emote_type = EMOTE_VISIBLE


// ............... M ..................
/datum/emote/living/meditate
	key = "meditate"
	key_third_person = "meditate"
	message = "meditates."
	restraint_check = FALSE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_meditate()
	set name = "Meditate"
	set hidden = 1

	emote("meditate", intentional = TRUE)

/datum/emote/living/meditate/run_emote(mob/user, params, type_override, intentional)
	if(isliving(user))
		if(!COOLDOWN_FINISHED(user, schizohelp_cooldown))
			to_chat(user, span_warning("I need to wait before meditating again."))
			return
		var/msg = input("Say your meditation:", "Voices in your head") as text|null
		if(msg)
			user.schizohelp(msg)

/datum/emote/living/moan
	key = "moan"
	key_third_person = "moans"
	message = "moans."
	message_mime = "appears to moan!"
	emote_type = EMOTE_AUDIBLE

// ............... N ..................
/datum/emote/living/nod
	key = "nod"
	key_third_person = "nods"
	message = "nods."
	message_param = "nods at %t."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_nod()
	set name = "Nod"
	set category = "Emotes.Silent"
	emote("nod", intentional = TRUE)

// ............... O ..................

// ............... P ..................
/datum/emote/living/pinch
	key = "pinch"
	key_third_person = "pinches"
	message = ""
	message_param = "pinches %t."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/datum/emote/living/pinch/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.flash_fullscreen("redflash1")

/mob/living/carbon/human/verb/emote_pinch()
	set name = "Pinch"
	set category = "Emotes.Silent"
	emote("pinch", intentional = TRUE, targetted = TRUE)

/datum/emote/living/point
	key = "point"
	key_third_person = "points"
	message = "points."
	message_param = "points at %t."
	restraint_check = TRUE

/datum/emote/living/point/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.usable_hands == 0)
			if(H.usable_legs != 0)
				message_param = "tries to point at %t with a leg, <span class='danger'>falling down</span> in the process!"
				H.Paralyze(20)
			else
				message_param = "<span class='danger'>bumps [user.p_their()] head on the ground</span> trying to motion towards %t."
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
	..()

/datum/emote/living/pout
	key = "pout"
	key_third_person = "pouts"
	message = "pouts."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/preen
	key = "preen"
	key_third_person = "preens"
	message = "preens their feathers."
	emote_type = EMOTE_AUDIBLE
	COOLDOWN_DECLARE(time_to_next_preen)


/mob/living/carbon/human/verb/emote_preen()
	set hidden = TRUE
	set name = "Preen"
	set category = "Emotes.Silent"
	emote("preen", intentional = TRUE)

/datum/emote/living/preen/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(!isharpy(user))
		return FALSE

/datum/emote/living/preen/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!isharpy(H))
			return
		var/time_left = COOLDOWN_TIMELEFT(src, time_to_next_preen)
		if(time_left)
			to_chat(H, span_warning("I have preened my feathers recently! It has no effect on my hygiene."))
		else
			COOLDOWN_START(src, time_to_next_preen, HARPY_PREENING_COOLDOWN)
			H.set_hygiene(HYGIENE_LEVEL_NORMAL)
			if(prob(50))
				var/preened_feather = /obj/item/natural/feather
				new preened_feather(user.loc)



/datum/emote/living/scream/painscream
	key = "painscream"
	message = "screams in pain!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/scream/agony
	key = "agony"
	message = "screams in agony!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/scream/firescream
	key = "firescream"
	nomsg = TRUE
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/aggro
	key = "aggro"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/death
	key = "death"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living)

/datum/emote/living/pain
	key = "pain"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/paincrit
	key = "paincrit"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

/datum/emote/living/painmoan
	key = "painmoan"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE

// ............... Q ..................

// ............... R ..................
/datum/emote/living/rage
	key = "rage"
	message = "screams in rage!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/rage/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(. && user.mind)
		record_round_statistic(STATS_WARCRIES)

/mob/living/carbon/human/verb/emote_rage()
	set name = "Rage"
	set category = "Emotes.Noises"
	emote("rage", intentional = TRUE)

// ............... S ..................
/datum/emote/living/spit
	key = "spit"
	key_third_person = "spits"
	message = "spits on the ground."
	message_param = "spits on %t."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_spit()
	set name = "Spit"
	set category = "Emotes.Silent"
	emote("spit", intentional = TRUE, targetted = TRUE)

/datum/emote/living/spit/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	var/mob/living/carbon/human/H = user
	if(ishuman(user))
		if(H.mouth)
			if(H.mouth.spitoutmouth)
				var/full_message = "<span class='warning'>[H] spits out [H.mouth].</span>"
				var/obfuscated_message = "<span class='warning'>[H] [stars("spits out [H.mouth].")]</span>"
				send_visible_emote_message(user, H, full_message, intentional = intentional, obfuscated_message = obfuscated_message)
				H.dropItemToGround(H.mouth, silent = FALSE)
			return
	..()

/datum/emote/living/spit/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(isliving(target))
		if(user.gender == MALE)
			playsound(target, pick('sound/vo/male/gen/spit.ogg','sound/vo/male/gen/spit_floor.ogg'), 100, FALSE, -1)
		else
			playsound(target, pick('sound/vo/female/gen/spit.ogg', 'sound/vo/female/gen/spit_floor.ogg'), 100, FALSE, -1)
		SEND_SIGNAL(user, COMSIG_SPAT_ON, target)

/datum/emote/living/slap
	key = "slap"
	key_third_person = "slaps"
	message = ""
	message_param = "slaps %t in the face."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/datum/emote/living/slap/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.zone_selected == BODY_ZONE_PRECISE_GROIN)
			message_param = "slaps %t on the ass!"

	..()
/mob/living/carbon/human/verb/emote_slap()
	set name = "Slap"
	set category = "Emotes.Silent"
	emote("slap", intentional = TRUE, targetted = TRUE)

/datum/emote/living/slap/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.flash_fullscreen("redflash3")
		H.AdjustSleeping(-50)
		playsound(target, pick('sound/foley/slap (1).ogg','sound/foley/slap (2).ogg'), 50, FALSE, -1)

/datum/emote/living/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams!"
	message_muffled = "makes a muffled scream."
	message_mime = "acts out a scream!"
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_scream()
	set name = "Scream"
	set category = "Emotes.Noises"
	emote("scream", intentional = TRUE)

/datum/emote/living/scream/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(intentional)
			if(!C.adjust_stamina(3)) // I guess this is here to reduce spamming? Or some other concept? Reduced from 10
				to_chat(C, "<span class='warning'>I try to scream but my voice fails me.</span>")
				. = FALSE

/datum/emote/living/scream/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(. && user.mind)
		record_featured_stat(FEATURED_STATS_SCREAMERS, user)

/datum/emote/living/scowl
	key = "scowl"
	key_third_person = "scowls"
	message = "scowls."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/shakehead
	key = "shakehead"
	key_third_person = "shakeshead"
	message = "shakes their head."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_shakehead()
	set name = "Shakehead"
	set category = "Emotes.Silent"
	emote("shakehead", intentional = TRUE)

/datum/emote/living/shiver
	key = "shiver"
	key_third_person = "shiver"
	message = "shivers."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_shiver()
	set name = "Shiver"
	set category = "Emotes.Silent"
	emote("shiver", intentional = TRUE)

#define SHIVER_LOOP_DURATION (1 SECONDS)
/datum/emote/living/shiver/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()

	animate(user, pixel_w = 1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
	for(var/i in 1 to SHIVER_LOOP_DURATION / (0.2 SECONDS)) //desired total duration divided by the iteration duration to give the necessary iteration count
		animate(pixel_w = -2, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
		animate(pixel_w = 2, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
	animate(pixel_w = -1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)
#undef SHIVER_LOOP_DURATION

/datum/emote/living/sigh
	key = "sigh"
	key_third_person = "sighs"
	message = "sighs."
	message_muffled = "makes a muffled sigh."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_sigh()
	set name = "Sigh"
	set category = "Emotes.Noises"
	emote("sigh", intentional = TRUE)

/datum/emote/living/snore
	key = "snore"
	key_third_person = "snores"
	message = "snores."
	message_mime = "sleeps soundly."
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS
	snd_range = -4

/datum/emote/living/stare
	key = "stare"
	key_third_person = "stares"
	message = "stares."
	message_param = "stares at %t."

/datum/emote/living/strech
	key = "stretch"
	key_third_person = "stretches"
	message = "stretches their arms."

/datum/emote/living/sulk
	key = "sulk"
	key_third_person = "sulks"
	message = "sulks down sadly."

/datum/emote/living/sway
	key = "sway"
	key_third_person = "sways"
	message = "sways around dizzily."

/datum/emote/living/shh
	key = "shh"
	key_third_person = "shhs"
	message = "shooshes."
	message_muffled = "makes a muffled shh."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_shh()
	set name = "Shh"
	set category = "Emotes.Noises"
	emote("shh", intentional = TRUE)

/datum/emote/living/smug
	key = "smug"
	key_third_person = "smugs"
	message = "grins smugly."

/datum/emote/living/sniff
	key = "sniff"
	key_third_person = "sniffs"
	message = "sniffs."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/smile
	key = "smile"
	key_third_person = "smiles"
	message = "smiles."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_smile()
	set name = "Smile"
	set category = "Emotes.Silent"
	emote("smile", intentional = TRUE)

/datum/emote/living/sneeze
	key = "sneeze"
	key_third_person = "sneezes"
	message = "sneezes."
	message_muffled = "makes a muffled sneeze."
	emote_type = EMOTE_AUDIBLE

// ............... T ..................
/datum/emote/living/tremble
	key = "tremble"
	key_third_person = "trembles"
	message = "trembles in fear!"

/datum/emote/living/twitch
	key = "twitch"
	key_third_person = "twitches"
	message = "twitches violently."

/datum/emote/living/twitch_s
	key = "twitch_s"
	message = "twitches."
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living/carbon/human)

// ............... U ..................



// ............... W ..................
/datum/emote/living/wave
	key = "wave"
	key_third_person = "waves"
	message = "waves."

/datum/emote/living/whisper
	key = "whisper"
	key_third_person = "whispers"
	message = "whispers."
	message_mime = "appears to whisper."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/whimper
	key = "whimper"
	key_third_person = "whimpers"
	message = "whimpers."
	message_muffled = "makes a muffled whimper."
	message_mime = "appears hurt."

/mob/living/carbon/human/verb/emote_whimper()
	set name = "Whimper"
	set category = "Emotes.Noises"
	emote("whimper", intentional = TRUE)

/datum/emote/living/whistle
	key = "whistle"
	key_third_person = "whistles"
	message = "whistles."
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_whistle()
	set name = "Whistle"
	set category = "Emotes.Noises"
	emote("whistle", intentional = TRUE)

/datum/emote/living/wsmile
	key = "wsmile"
	key_third_person = "wsmiles"
	message = "smiles weakly."

// ............... Z ..................
/datum/emote/living/zombiemoan // sort of bandaid since zombie voicepacks got issues, maybe related to new pitch or who knows
	key = "zmoan"
	key_third_person = "moans"
	message = "moans."
	emote_type = EMOTE_AUDIBLE
/datum/emote/living/zombiemoan/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(user.gender == MALE)
		playsound(user, pick('sound/vo/mobs/zombie/idle (1).ogg','sound/vo/mobs/zombie/idle (2).ogg','sound/vo/mobs/zombie/idle (3).ogg'), 80, FALSE, -1)
	else
		playsound(user, pick('sound/vo/mobs/zombie/f/idle (1).ogg','sound/vo/mobs/zombie/f/idle (2).ogg','sound/vo/mobs/zombie/f/idle (3).ogg'), 80, FALSE, -1)


// ............... Y ..................
/datum/emote/living/yawn
	key = "yawn"
	key_third_person = "yawns"
	message = "yawns."
	message_muffled = "makes a muffled yawn."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_yawn()
	set name = "Yawn"
	set category = "Emotes.Noises"
	emote("yawn", intentional = TRUE)

// ............... Help ..................
/datum/emote/living/help
	key = "help"

/datum/emote/living/help/run_emote(mob/user, params, type_override, intentional)
/*	var/list/keys = list()
	var/list/message = list("Available emotes, you can use them with say \"*emote\": ")

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/P in GLOB.emote_list[key])
			if(P.key in keys)
				continue
			if(P.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += P.key

	keys = sortList(keys)

	for(var/emote in keys)
		if(LAZYLEN(message) > 1)
			message += ", [emote]"
		else
			message += "[emote]"

	message += "."

	message = jointext(message, "")

	to_chat(user, message)


/datum/emote/beep
	key = "beep"
	key_third_person = "beeps"
	message = "beeps."
	message_param = "beeps at %t."
	sound = 'sound/blank.ogg'
	mob_type_allowed_typecache = list(/mob/living/brain, /mob/living/silicon)

/datum/emote/living/circle
	key = "circle"
	key_third_person = "circles"
	restraint_check = TRUE

/datum/emote/living/circle/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/obj/item/circlegame/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, "<span class='notice'>I make a circle with your hand.</span>")
	else
		qdel(N)
		to_chat(user, "<span class='warning'>I don't have any free hands to make a circle with.</span>")

/datum/emote/living/slap
	key = "slap"
	key_third_person = "slaps"
	restraint_check = TRUE

/datum/emote/living/slap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/slapper/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, "<span class='notice'>I ready your slapping hand.</span>")
	else
		to_chat(user, "<span class='warning'>You're incapable of slapping in your current state.</span>")
*/

/datum/emote/living/stat_roll
	var/delay = 2.5 SECONDS
	var/list/attempt_message_list
	var/list/success_message_list
	var/list/failure_message_list

/datum/emote/living/stat_roll/run_emote(mob/user, params, type_override, intentional = FALSE)
	. = ..()
	if(.)
		sleep(delay)

		var/mob/living/living = user
		//var/chance_per_point = 5
		//var/success = FALSE
		//var/chance = 0
		var/roll = 0
		var/bonus = 0
		var/msg = "rolls a [roll][bonus >= 0 ? "+[bonus]" : "[bonus]"] on dice"
		switch(key)
			if("strength")
				/*success = living.stat_roll(STATKEY_STR, chance_per_point)
				chance = living.get_stat(STATKEY_STR)*/
				roll = rand(1,20)
				bonus = floor((living.get_stat(STATKEY_STR)-10)/2)
				msg = "rolls a [roll][bonus >= 0 ? "+[bonus]" : "[bonus]"] on strength dice"
			if("perception")
				/*uccess = living.stat_roll(STATKEY_PER, chance_per_point)
				chance = living.get_stat(STATKEY_PER)*/
				roll = rand(1,20)
				bonus = floor((living.get_stat(STATKEY_PER)-10)/2)
				msg = "rolls a [roll][bonus >= 0 ? "+[bonus]" : "[bonus]"] on perception dice"
			if("intelligence")
				/*success = living.stat_roll(STATKEY_INT, chance_per_point)
				chance = living.get_stat(STATKEY_INT)*/
				roll = rand(1,20)
				bonus = floor((living.get_stat(STATKEY_INT)-10)/2)
				msg = "rolls a [roll][bonus >= 0 ? "+[bonus]" : "[bonus]"] on intelligence dice"
			if("constitution")
				/*success = living.stat_roll(STATKEY_CON, chance_per_point)
				chance = living.get_stat(STATKEY_CON)*/
				roll = rand(1,20)
				bonus = floor((living.get_stat(STATKEY_CON)-10)/2)
				msg = "rolls a [roll][bonus >= 0 ? "+[bonus]" : "[bonus]"] on constitution dice"
			if("endurance")
				/*success = living.stat_roll(STATKEY_END, chance_per_point)
				chance = living.get_stat(STATKEY_END)*/
				roll = rand(1,20)
				bonus = floor((living.get_stat(STATKEY_END)-10)/2)
				msg = "rolls a [roll][bonus >= 0 ? "+[bonus]" : "[bonus]"] on endurance dice"
			if("speed")
				/*success = living.stat_roll(STATKEY_SPD, chance_per_point)
				chance = living.get_stat(STATKEY_SPD)*/
				roll = rand(1,20)
				bonus = floor((living.get_stat(STATKEY_SPD)-10)/2)
				msg = "rolls a [roll][bonus >= 0 ? "+[bonus]" : "[bonus]"] on speed dice"
			if("fortune")
				/*success = living.stat_roll(STATKEY_LCK, chance_per_point)
				chance = living.get_stat(STATKEY_LCK)*/
				roll = rand(1,20)
				bonus = floor((living.get_stat(STATKEY_LCK)-10)/2)
				msg = "rolls a [roll][bonus >= 0 ? "+[bonus]" : "[bonus]"] on fortune dice"


		//chance *= chance_per_point
		/*var/msg = success ? span_green("rolls a [roll][bonus >= 0 ? "+[bonus]" : "[bonus]"] on dice") : span_danger("FAILS and [pick(failure_message_list)] [chance]%")*/

		msg = replace_pronoun(user, msg)

		if(!msg)
			return

		// A COMSIG here would be nice, in my attempts it sadly didn't work out well for the relay.
		var/atom/movable/emotelocation = user
		var/mob/living/carbon/human/human
		if(ishuman(user))
			human = user

		/*var/obj/item/organ/dullahan_vision/vision
		var/datum/species/dullahan/dullahan
		if(isdullahan(user))
			dullahan = human.dna.species
			vision = human.getorganslot(ORGAN_SLOT_HUD)
			if(dullahan.headless && vision.viewing_head)
				emotelocation = dullahan.my_head*/

		user.log_message(msg, LOG_EMOTE)
		var/pre_color_msg = msg
		//if (use_params_for_runechat) // apply puncutation stripping here where appropriate
		var/static/regex/regex = regex(@"[,.!?]", "g")
		pre_color_msg = regex.Replace(pre_color_msg, "")
		pre_color_msg = trim(pre_color_msg, MAX_MESSAGE_LEN)
		// Checks to see if we're emoting on the body while we have a head, or if we're emoting on the head.
		if(human && human.voice_color)
			msg = "<span style='color:#[human.voice_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[emotelocation]</b></span> " + msg
		else
			msg = "<b>[emotelocation]</b> " + msg
		for(var/mob/M in GLOB.dead_mob_list)
			if(!M.client || isnewplayer(M))
				continue
			var/T = get_turf(emotelocation)
			if(M.stat == DEAD && M.client && (M.client.prefs?.chat_toggles & CHAT_GHOSTSIGHT) && !(M in viewers(T, null)))
				M.show_message(msg)
		var/runechat_msg_to_use = null
		var/obfuscated_runechat_msg_to_use = null
		if(show_runechat)
			runechat_msg_to_use = runechat_msg ? runechat_msg : pre_color_msg
			obfuscated_runechat_msg_to_use = stars(runechat_msg_to_use)
		var/speaker_prefix = "<b>[emotelocation]</b>"
		if(human && human.voice_color)
			speaker_prefix = "<span style='color:#[human.voice_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[emotelocation]</b></span>"
		var/obfuscated_msg = "[speaker_prefix] [stars(pre_color_msg)]"
		send_visible_emote_message(user, emotelocation, msg, runechat_message = runechat_msg_to_use, intentional = intentional, obfuscated_message = obfuscated_msg, obfuscated_runechat_message = obfuscated_runechat_msg_to_use)

/datum/emote/living/stat_roll/select_message_type(mob/user, msg, intentional)
	return pick(attempt_message_list)

/datum/emote/living/stat_roll/strength
	key = "strength"
	key_third_person = "str"
	attempt_message_list = list(
		"tests their strength...",
		"puts their back into it...",
		"begins to flex...",
	)

	success_message_list = list(
		"is brimming with power!",
		"is truly beefy!",
		"shows off their muscle!",
	)

	failure_message_list = list(
		"is a little wet noodle...",
		"would lose in an arm wrestling match against a rous...",
		"should eat more sausage...",
	)

/mob/living/carbon/human/verb/emote_strength_roll()
	set name = "Roll Strength"
	set category = "Emotes"

	emote("strength", intentional = TRUE)

/datum/emote/living/stat_roll/perception
	key = "perception"
	key_third_person = "per"
	attempt_message_list = list(
		"takes a good, long look...",
		"focuses in...",
		"squints...",
	)

	success_message_list = list(
		"has eyes like a hawk!",
		"sees what others don't!",
		"has perfect 20/20 vision!",
	)

	failure_message_list = list(
		"is totally oblivious...",
		"has cataracts in their eyes...",
		"is blind...",
	)

/mob/living/carbon/human/verb/emote_perception_roll()
	set name = "Roll Perception"
	set category = "Emotes"

	emote("perception", intentional = TRUE)


/datum/emote/living/stat_roll/intelligence
	key = "intelligence"
	key_third_person = "int"
	attempt_message_list = list(
		"thinks hard...",
		"furrows their brows...",
		"rubs their chin...",
	)

	success_message_list = list(
		"is a genius!",
		"has a mind sharp as a whip!",
		"knows what they're doing!",
	)

	failure_message_list = list(
		"is as dumb as a rock...",
		"has an empty head...",
		"couldn't put 2 and 2 together...",
	)

/mob/living/carbon/human/verb/emote_intelligence_roll()
	set name = "Roll Intelligence"
	set category = "Emotes"

	emote("intelligence", intentional = TRUE)

/datum/emote/living/stat_roll/constitution
	key = "constitution"
	key_third_person = "con"
	attempt_message_list = list(
		"tests their toughness...",
		"braces for impact...",
		"prepares to endure...",
	)

	success_message_list = list(
		"doesn't even flinch!",
		"is solid as an oak!",
		"is one tough nut to crack!",
	)

	failure_message_list = list(
		"has paper skin...",
		"would be torn to shreds by a light breeze...",
		"has a glass jaw...",
	)

/mob/living/carbon/human/verb/emote_constitution_roll()
	set name = "Roll Constitution"
	set category = "Emotes"

	emote("constitution", intentional = TRUE)

/datum/emote/living/stat_roll/endurance
	key = "endurance"
	key_third_person = "end"
	attempt_message_list = list(
		"tests their endurance...",
		"gathers their courage...",
		"prepares to use their determination...",
	)

	success_message_list = list(
		"proves mighty!",
		"never gives up!",
		"persists through anything!",
	)

	failure_message_list = list(
		"is a weak willed chicken...",
		"gives up trying...",
		"faints when they get a splinter...",
	)

/mob/living/carbon/human/verb/emote_endurance_roll()
	set name = "Roll Endurance"
	set category = "Emotes"

	emote("endurance", intentional = TRUE)

/datum/emote/living/stat_roll/speed
	key = "speed"
	key_third_person = "spd"
	attempt_message_list = list(
		"prepares their moves...",
		"starts to get limber...",
		"tries to get speedy...",
	)

	success_message_list = list(
		"is in perfect control!",
		"is as agile as a cat!",
		"is very flexible!",
	)

	failure_message_list = list(
		"has two left feet...",
		"trips over themselves...",
		"is slower than a snail...",
	)

/mob/living/carbon/human/verb/emote_speed_roll()
	set name = "Roll Speed"
	set category = "Emotes"

	emote("speed", intentional = TRUE)

/datum/emote/living/stat_roll/fortune
	key = "fortune"
	key_third_person = "for"
	attempt_message_list = list(
		"tries their fortune...",
		"takes a chance...",
		"prepares to gamble...",
	)

	success_message_list = list(
		"could make an arrow turn around and climb back into the bow!",
		"has a rabbit's paw in their pocket!",
		"persists through pure luck!",
	)

	failure_message_list = list(
		"realizes the game was rigged from the start...",
		"gets dealt a bad hand...",
		"has the odds stacked against them...",
	)

/mob/living/carbon/human/verb/emote_fortune_roll()
	set name = "Roll Fortune"
	set category = "Emotes"

	emote("fortune", intentional = TRUE)
