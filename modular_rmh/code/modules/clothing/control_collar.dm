// ---- Global registries for slave collar phrase system ----

GLOBAL_LIST_INIT(generated_slave_phrases, list())
GLOBAL_LIST_INIT(slave_collars, list())

/// Maps internal phrase keys to human-readable display names.
GLOBAL_LIST_INIT(slave_phrases_translations, list(
	"touch_phrase" = "Touch Themself",
	"orgasm_phrase" = "Orgasm",
	"drop_phrase" = "Fall",
	"sleep_phrase" = "Sleep",
	"stop_phrase" = "Stay",
	"pleasure_phrase" = "Lust",
	"submission_phrase" = "Submit",
	"lock_phrase" = "Toggle Lock",
	"come_phrase" = "Come",
	"silence_phrase" = "Silence",
))

/// Reverse lookup: display name -> internal key.
GLOBAL_LIST_INIT(reverse_slave_phrases_translations, list(
	"Touch Themself" = "touch_phrase",
	"Orgasm" = "orgasm_phrase",
	"Fall" = "drop_phrase",
	"Sleep" = "sleep_phrase",
	"Stay" = "stop_phrase",
	"Lust" = "pleasure_phrase",
	"Submit" = "submission_phrase",
	"Toggle Lock" = "lock_phrase",
	"Come" = "come_phrase",
	"Silence" = "silence_phrase",
))

/// Generates a unique two-word arcane phrase for collar commands.
/proc/generate_slave_code()
	var/static/list/syllables1 = list("ka", "zu", "lo", "da", "ra", "ve", "so", "ti", "ma", "xi", "no", "qu", "ga", "shi", "ni", "fa", "jo", "li", "pa", "re", "sa", "do", "ke", "mi")
	var/static/list/syllables2 = list("th", "gor", "lek", "ram", "dra", "von", "nar", "zeth", "mir", "kul", "tar", "mol", "shan", "ruk", "vek", "zun", "bel", "thrall", "grim")

	var/code
	var/tries = 0
	do
		var/code1 = "[pick(syllables1)][pick(syllables2)]"
		var/code2 = "[pick(syllables1)][pick(syllables2)]"
		while(code1 == code2)
			code2 = "[pick(syllables1)][pick(syllables2)]"
		code = "[capitalize(code1)] [capitalize(code2)]"
		tries++
	while((code in GLOB.generated_slave_phrases) && tries < 100)

	GLOB.generated_slave_phrases += code
	return code

/// Normalizes text for phrase comparison: lowercase, strip HTML, strip punctuation, trim.
/proc/normalize_slave_phrase(text)
	text = lowertext(strip_html(text))
	text = strip_punctuation(text)
	text = trim(text)
	return text

// ---- Slave Collar ----

/obj/item/clothing/neck/slave_collar
	name = "slave collar"
	desc = "A sturdy leather collar with ominous arcane engravings."
	icon_state = "collar"
	item_state = "collar"
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron
	melt_amount = 100
	anvilrepair = /datum/skill/craft/armorsmithing
	max_integrity = 150
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = PLATEHIT
	flags_1 = HEAR_1
	leashable = TRUE

	/// Maps internal phrase keys to their generated arcane words.
	var/list/phrases_list = list(
		"touch_phrase" = null,
		"orgasm_phrase" = null,
		"drop_phrase" = null,
		"sleep_phrase" = null,
		"stop_phrase" = null,
		"pleasure_phrase" = null,
		"submission_phrase" = null,
		"lock_phrase" = null,
		"come_phrase" = null,
		"silence_phrase" = null,
	)
	/// Whether this collar has been bound to a control ring.
	var/collar_bound = FALSE
	/// The control ring currently bound to this collar.
	var/obj/item/clothing/ring/slave_control/bound_ring
	/// Whether the arcane lock is engaged (prevents removal).
	var/stuck = FALSE
	/// Whether the bearer is currently magically silenced by the collar.
	var/silenced = FALSE
	/// The mob currently wearing this collar.
	var/mob/living/carbon/human/bearer
	/// Display name used as the key in GLOB.slave_collars.
	var/list_name
	COOLDOWN_DECLARE(collar_phrase_usage)

/obj/item/clothing/neck/slave_collar/male
	name = "Cruel slave gorget"
	icon = 'modular_rmh/icons/clothing/neck.dmi'
	desc = "A brutal-looking iron gorget inscribed with cruel arcane patterns. There's no mistaking its purpose."
	icon_state = "m_collar"
	item_state = "gorget"
	armor = ARMOR_NECK_BAD

/obj/item/clothing/neck/slave_collar/female
	name = "Elegant slave collar"
	icon = 'modular_rmh/icons/clothing/neck.dmi'
	desc = "An elegant black choker with faint arcane patterns along its trim. Beautiful, yet deeply symbolic."
	icon_state = "f_collar"
	item_state = "collar_f"

/obj/item/clothing/neck/slave_collar/New()
	. = ..()
	for(var/el in phrases_list)
		phrases_list[el] = generate_slave_code()

// ---- Equip / Drop / Destroy ----

/obj/item/clothing/neck/slave_collar/equipped(mob/living/carbon/human/human)
	. = ..()
	if(!ishuman(human))
		return
	var/mob/living/carbon/human/wearer = loc
	if(!ismob(wearer) || wearer.wear_neck != src)
		return
	RegisterSignal(human, COMSIG_MOVABLE_HEAR, PROC_REF(process_phrase), override = TRUE)
	list_name = wearer.name
	if(wearer.job)
		list_name += " the [wearer.job]"
	GLOB.slave_collars[list_name] = src
	bearer = wearer

/obj/item/clothing/neck/slave_collar/dropped(mob/user)
	. = ..()
	cleanup_bearer()

/obj/item/clothing/neck/slave_collar/Destroy()
	cleanup_bearer()
	stuck = FALSE
	return ..()

/// Shared cleanup: unregister signals, remove from global list, clear silence.
/obj/item/clothing/neck/slave_collar/proc/cleanup_bearer()
	if(!bearer)
		return
	GLOB.slave_collars.Remove(list_name)
	UnregisterSignal(bearer, COMSIG_MOVABLE_HEAR)
	// Clear silence if active.
	if(silenced)
		REMOVE_TRAIT(bearer, TRAIT_MUTE, "slave_collar")
		silenced = FALSE
	bearer = null

// ---- Ring Binding ----

/obj/item/clothing/neck/slave_collar/attackby(obj/item/I, mob/living/user)
	if(!ismob(user))
		return ..()
	if(istype(I, /obj/item/clothing/ring/slave_control))
		bind_collar(I, user)
		return
	return ..()

/// Bind a control ring to this collar, transferring phrase codes.
/obj/item/clothing/neck/slave_collar/proc/bind_collar(obj/item/clothing/ring/slave_control/ring, mob/living/user, master_ring = FALSE)
	if(collar_bound && !master_ring)
		to_chat(user, span_warning("The collar is already bound."))
		return FALSE

	to_chat(user, span_info("You bind the ring to the collar, transferring the control words."))
	if(!master_ring)
		user.visible_message(span_info("<b>[user] touches the ring and collar together, producing a dull chime.</b>"))
	else if(bearer)
		to_chat(bearer, span_info("<b>Some unknown force seems to *yank* you by your collar.</b>"))

	// Unbind old ring if one exists — clear its data safely.
	if(bound_ring)
		bound_ring.bound_collar = null
		bound_ring.phrases_list = list()
	collar_bound = TRUE
	bound_ring = ring

	ring.phrases_list = phrases_list
	ring.bound_collar = src
	return TRUE

// ---- Voice Phrase Processing ----

/// Called via COMSIG_MOVABLE_HEAR when the bearer hears speech. Checks if a command phrase was spoken.
/obj/item/clothing/neck/slave_collar/proc/process_phrase(datum/source, list/hear_args)
	SIGNAL_HANDLER

	var/raw_message = hear_args[HEARING_RAW_MESSAGE]
	var/atom/movable/speaker = hear_args[HEARING_SPEAKER]

	if(!ismob(speaker))
		return

	var/mob/living/carbon/human/H = src.loc
	if(!ismob(H))
		return

	var/msg = normalize_slave_phrase(raw_message)

	// Check if the spoken phrase matches any command. Break on first match.
	var/phrase_found = FALSE
	for(var/el in phrases_list)
		if(normalize_slave_phrase(phrases_list[el]) == msg)
			phrase_found = TRUE
			break

	if(!phrase_found)
		return

	// Validate that the speaker has the bound ring equipped.
	var/ring_found = FALSE
	if(ishuman(speaker))
		ring_found = speaker_has_ring(speaker)

	// Self-punishment: bearer says a command phrase without wearing the ring — mute them.
	if(H == speaker && !ring_found)
		H.visible_message(span_warning("<b>The collar around [H]'s neck flashes brightly, muting the wearer in punishment.</b>"))
		ADD_TRAIT(H, TRAIT_MUTE, "rune")
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_mute), H), 30 SECONDS)
		return

	if(!ring_found)
		return

	// Cooldown check comes AFTER ring validation — invalid speakers are always rejected,
	// and the cooldown only gates legitimate commands.
	if(!COOLDOWN_FINISHED(src, collar_phrase_usage))
		return

	INVOKE_ASYNC(src, PROC_REF(perform_command), msg)

/// Returns TRUE if the speaker is wearing/holding the bound ring.
/obj/item/clothing/neck/slave_collar/proc/speaker_has_ring(mob/living/carbon/human/speaker)
	if(!bound_ring || !ishuman(speaker))
		return FALSE
	for(var/obj/item/I in speaker.get_equipped_items())
		if(I == bound_ring)
			return TRUE
	return FALSE

// ---- Command Execution ----

/// Execute a collar command by matching the normalized phrase. Returns TRUE on success.
/obj/item/clothing/neck/slave_collar/proc/perform_command(msg)
	if(!msg)
		return FALSE

	var/mob/living/carbon/human/H = src.loc
	if(!ismob(H))
		return FALSE

	if(!COOLDOWN_FINISHED(src, collar_phrase_usage))
		return FALSE

	COOLDOWN_START(src, collar_phrase_usage, 10 SECONDS)

	// Notify the bearer that the collar is activating.
	to_chat(H, span_userdanger("Your collar compels you!"))

	// Touch — forced masturbation.
	if(msg == normalize_slave_phrase(phrases_list["touch_phrase"]))
		H.visible_message(span_danger("<b>[H] starts masturbating uncontrollably!</b>"))
		H.emote("moan")
		H.start_sex_session(H, FALSE)
		var/current_action = /datum/sex_action/masturbate/anus
		if(H.getorganslot(ORGAN_SLOT_VAGINA))
			current_action = /datum/sex_action/masturbate/vagina
		else if(H.getorganslot(ORGAN_SLOT_PENIS))
			current_action = /datum/sex_action/masturbate/penis
		var/datum/sex_session/session = get_sex_session(H, H)
		session.try_start_action(current_action)
		session.set_current_force(SEX_FORCE_HIGH)
		session.set_current_speed(SEX_SPEED_MAX)
		return TRUE

	// Orgasm — forced climax.
	if(msg == normalize_slave_phrase(phrases_list["orgasm_phrase"]))
		H.visible_message(span_danger("<b>[H] convulses in a sudden orgasm!</b>"))
		var/datum/component/arousal/aro = H.GetComponent(/datum/component/arousal)
		if(aro)
			aro.ejaculate(null, H, null, FALSE)
			SEND_SIGNAL(H, COMSIG_SEX_ADJUST_AROUSAL, 60)
			SEND_SIGNAL(H, COMSIG_SEX_ADJUST_EDGING, 15)
			SEND_SIGNAL(H, COMSIG_SEX_ADJUST_ORGASM_PROG, 10)
			COOLDOWN_START(src, collar_phrase_usage, 30 SECONDS)
		return TRUE

	// Fall — knockdown.
	if(msg == normalize_slave_phrase(phrases_list["drop_phrase"]))
		H.visible_message(span_danger("<b>[H] falls prone!</b>"))
		H.Knockdown(10 SECONDS)
		return TRUE

	// Sleep — forced unconsciousness.
	if(msg == normalize_slave_phrase(phrases_list["sleep_phrase"]))
		H.visible_message(span_danger("<b>[H] has their eyes shut — falling asleep instantly!</b>"))
		H.Sleeping(15 SECONDS)
		return TRUE

	// Stay — immobilize.
	if(msg == normalize_slave_phrase(phrases_list["stop_phrase"]))
		H.visible_message(span_danger("<b>[H] freezes in place, unable to move!</b>"))
		H.apply_status_effect(/datum/status_effect/collar_stun)
		return TRUE

	// Lust — forced arousal.
	if(msg == normalize_slave_phrase(phrases_list["pleasure_phrase"]))
		H.visible_message(span_danger("<b>[H] shivers, pleasure forced upon them!</b>"))
		H.emote("moan")
		SEND_SIGNAL(H, COMSIG_SEX_ADJUST_AROUSAL, 120)
		SEND_SIGNAL(H, COMSIG_SEX_ADJUST_EDGING, 30)
		SEND_SIGNAL(H, COMSIG_SEX_ADJUST_ORGASM_PROG, 50)
		return TRUE

	// Submit — shock and choke with spark VFX. Oxyloss capped at 45 to prevent death.
	if(msg == normalize_slave_phrase(phrases_list["submission_phrase"]))
		H.visible_message(span_warning("<b>[H] is shocked, the collar tightening!</b>"))
		do_sparks(2, FALSE, get_turf(H))
		playsound(H, 'sound/effects/sparks1.ogg', 50, TRUE)
		H.electrocute_act(5, src)
		H.emote("choke")
		var/oxy_to_apply = min(15, max(0, 45 - H.getOxyLoss()))
		if(oxy_to_apply > 0)
			H.adjustOxyLoss(oxy_to_apply)
		COOLDOWN_START(src, collar_phrase_usage, 15 SECONDS)
		return TRUE

	// Toggle Lock — engage/disengage arcane lock.
	if(msg == normalize_slave_phrase(phrases_list["lock_phrase"]))
		if(!stuck)
			H.visible_message(span_notice("<b>The collar around [H]'s neck engages its arcane lock.</b>"))
			stuck = TRUE
		else
			H.visible_message(span_notice("<b>The collar around [H]'s neck releases its arcane lock.</b>"))
			stuck = FALSE
		return TRUE

	// Come — force the bearer to walk toward the ring-holder.
	if(msg == normalize_slave_phrase(phrases_list["come_phrase"]))
		if(!bound_ring)
			return FALSE
		// Find who is wearing the ring within view.
		var/mob/living/ring_holder
		for(var/mob/living/carbon/human/candidate in view(7, H))
			if(candidate == H)
				continue
			for(var/obj/item/I in candidate.get_equipped_items())
				if(I == bound_ring)
					ring_holder = candidate
					break
			if(ring_holder)
				break
		if(!ring_holder)
			return FALSE
		H.visible_message(span_danger("<b>[H]'s legs move on their own, compelled toward [ring_holder]!</b>"))
		come_to_master(H, ring_holder)
		return TRUE

	// Silence — toggle mute on the bearer.
	if(msg == normalize_slave_phrase(phrases_list["silence_phrase"]))
		if(!silenced)
			H.visible_message(span_warning("<b>The collar around [H]'s neck glows faintly — [H] has been silenced.</b>"))
			ADD_TRAIT(H, TRAIT_MUTE, "slave_collar")
			silenced = TRUE
		else
			H.visible_message(span_notice("<b>The collar around [H]'s neck dims — [H] may speak again.</b>"))
			REMOVE_TRAIT(H, TRAIT_MUTE, "slave_collar")
			silenced = FALSE
		return TRUE

	return FALSE

// ---- Come Command Helper ----

/// Async proc: steps the bearer toward the master over a short period.
/obj/item/clothing/neck/slave_collar/proc/come_to_master(mob/living/carbon/human/target, mob/living/master)
	set waitfor = FALSE
	for(var/i in 1 to 6)
		if(QDELETED(target) || QDELETED(master))
			return
		if(get_dist(target, master) <= 1)
			return
		step_towards(target, master)
		sleep(3)

// ---- Stuck / Lock Checks ----

/// Returns TRUE if the collar is locked and worn by the user (blocks removal).
/obj/item/clothing/neck/slave_collar/proc/stuck_check(mob/living/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.get_item_by_slot(ITEM_SLOT_NECK) && stuck)
			to_chat(user, span_userdanger("I can't take it off!"))
			return TRUE
	return FALSE

/obj/item/clothing/neck/slave_collar/attack_hand(mob/user)
	if(!stuck_check(user))
		return ..()

/obj/item/clothing/neck/slave_collar/MouseDrop(atom/over_object)
	if(!stuck_check(usr))
		return ..()

// ---- Examine ----

/obj/item/clothing/neck/slave_collar/get_examine_string(mob/user, thats)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/h_user = user
	// The ring holder and certain authority figures can read the phrases.
	var/can_read = FALSE
	if(bound_ring)
		for(var/obj/item/I in h_user.get_equipped_items())
			if(I == bound_ring)
				can_read = TRUE
				break
	if(!can_read)
		var/job_lower = lowertext(h_user.job)
		if(job_lower == "town master" || job_lower == "consort")
			can_read = TRUE
	if(can_read)
		. += span_userdanger("You notice engraved phrases on the collar:")
		for(var/el in phrases_list)
			. += "<br><b>[GLOB.slave_phrases_translations[el]]:</b> \"[phrases_list[el]]\""

// ---- Collar Stun Status Effect ----

/datum/status_effect/collar_stun
	id = "stun_collar"
	alert_type = /atom/movable/screen/alert/status_effect/collar_stun
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 10
	duration = 20 SECONDS

/atom/movable/screen/alert/status_effect/collar_stun
	name = "Stunned"
	desc = ""
	icon_state = "stun"

/datum/status_effect/collar_stun/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/collar_stun/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	return ..()

// ---- Crafting Recipes ----

/datum/repeatable_crafting_recipe/arcyne/slavecollar
	name = "slave collar"
	reagent_requirements = list()
	tool_usage = list()
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/gem/red = 1,
		/obj/item/gem/blue = 1,
		/obj/item/gem/diamond = 1,
	)
	output = /obj/item/clothing/neck/slave_collar
	starting_atom = /obj/item/gem/diamond
	attacked_atom = /obj/item/natural/hide/cured
	craftdiff = 4

/datum/repeatable_crafting_recipe/arcyne/slavecollar/cruel
	name = "cruel slave collar"
	output = /obj/item/clothing/neck/slave_collar/male

/datum/repeatable_crafting_recipe/arcyne/slavecollar/elegant
	name = "elegant slave collar"
	output = /obj/item/clothing/neck/slave_collar/female
