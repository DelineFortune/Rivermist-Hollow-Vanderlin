#define TRAP_PROMPT_TITLE "A Way Out"
#define TRAP_PROMPT_CHOICE_RUNE "Rune Rescue"
#define TRAP_PROMPT_CHOICE_LOBBY "Return to Lobby"
#define TRAP_PROMPT_CHOICE_CONTINUE "Keep Going"

/datum/pocket_dimension/trap
	var/orgasm_trigger_count = 0
	var/time_trigger_delay = 0
	var/trigger_on_soft_crit = FALSE
	var/trigger_on_hard_crit = FALSE
	var/reset_cooldown = 0
	var/captive_release_mode = TRAP_RELEASE_NONE
	var/list/forced_captive_refs = list()
	var/list/captive_trackers_by_mind = list()

/datum/pocket_dimension/trap/Destroy(force)
	for(var/datum/mind/captive_mind as anything in captive_trackers_by_mind)
		var/datum/trap_pocket_tracker/tracker = captive_trackers_by_mind[captive_mind]
		if(QDELETED(tracker))
			continue
		qdel(tracker)

	forced_captive_refs = null
	captive_trackers_by_mind = null
	return ..()

/datum/pocket_dimension/trap/process_pocket()
	prune_forced_captives()

	var/list/tracked_minds = captive_trackers_by_mind.Copy()
	for(var/datum/mind/captive_mind as anything in tracked_minds)
		var/datum/trap_pocket_tracker/tracker = tracked_minds[captive_mind]
		if(QDELETED(tracker))
			captive_trackers_by_mind.Remove(captive_mind)
			continue
		tracker.process_tracker()

/datum/pocket_dimension/trap/can_exit_mob(mob/user, obj/structure/pocket_dimension_exit/exit_object, show_feedback = TRUE)
	if(!istype(user))
		return FALSE
	if(!is_forced_captive(user))
		return TRUE
	if(can_captive_use_exit(user))
		return TRUE
	if(show_feedback)
		to_chat(user, span_warning(get_captive_exit_denial_message(user)))
	return FALSE

/datum/pocket_dimension/trap/proc/can_captive_use_exit(mob/user)
	switch(captive_release_mode)
		if(TRAP_RELEASE_FREE_EXIT)
			return TRUE
		if(TRAP_RELEASE_NONE)
			return FALSE
		if(TRAP_RELEASE_OWNER_ONLY)
			return FALSE
	return FALSE

/datum/pocket_dimension/trap/proc/get_captive_exit_denial_message(mob/user)
	return "The trap refuses to let me leave that easily."

/datum/pocket_dimension/trap/proc/mark_forced_captive(mob/living/captive)
	if(!istype(captive))
		return FALSE

	forced_captive_refs["[REF(captive)]"] = WEAKREF(captive)
	return TRUE

/datum/pocket_dimension/trap/proc/unmark_forced_captive(mob/living/captive)
	if(!istype(captive))
		return FALSE
	return !!forced_captive_refs.Remove("[REF(captive)]")

/datum/pocket_dimension/trap/proc/prune_forced_captives()
	for(var/captive_ref_text in forced_captive_refs.Copy())
		var/datum/weakref/captive_ref = forced_captive_refs[captive_ref_text]
		var/mob/living/captive = captive_ref?.resolve()
		if(!istype(captive))
			forced_captive_refs.Remove(captive_ref_text)
			continue
		if(!contains_turf(get_turf(captive)))
			forced_captive_refs.Remove(captive_ref_text)

/datum/pocket_dimension/trap/proc/get_forced_captives()
	var/list/forced_captives = list()

	prune_forced_captives()
	for(var/captive_ref_text in forced_captive_refs)
		var/datum/weakref/captive_ref = forced_captive_refs[captive_ref_text]
		var/mob/living/captive = captive_ref?.resolve()
		if(!istype(captive))
			continue
		forced_captives += captive

	return forced_captives

/datum/pocket_dimension/trap/proc/is_forced_captive(mob/living/captive)
	if(!istype(captive))
		return FALSE
	if(!forced_captive_refs["[REF(captive)]"])
		return FALSE
	return contains_turf(get_turf(captive))

/datum/pocket_dimension/trap/proc/get_captive_tracker(datum/mind/captive_mind)
	if(!captive_mind)
		return null
	return captive_trackers_by_mind[captive_mind]

/datum/pocket_dimension/trap/proc/arm_forced_captive(mob/living/captive, atom/release_anchor = null, atom/trap_controller = null)
	if(!istype(captive))
		return null

	mark_forced_captive(captive)
	if(!captive.mind)
		return null
	if(!istype(captive, /mob/living/carbon))
		return null

	var/mob/living/carbon/carbon_captive = captive
	var/datum/trap_pocket_tracker/tracker = get_captive_tracker(carbon_captive.mind)
	if(tracker)
		tracker.rearm_trap_tracker(carbon_captive, release_anchor, trap_controller)
		return tracker

	tracker = new(src, carbon_captive, release_anchor, trap_controller)
	captive_trackers_by_mind[carbon_captive.mind] = tracker
	return tracker

/datum/pocket_dimension/trap/proc/release_captive(mob/living/captive, atom/destination = null, message = null)
	if(!istype(captive))
		return FALSE
	if(!is_forced_captive(captive))
		return FALSE

	var/atom/release_destination = destination || get_exit_destination()
	if(!release_destination)
		return FALSE

	unmark_forced_captive(captive)

	var/datum/trap_pocket_tracker/tracker = get_captive_tracker(captive.mind)
	if(tracker)
		qdel(tracker)

	if(message)
		to_chat(captive, span_notice(message))

	return captive.forceMove(release_destination)

/datum/trap_pocket_tracker
	var/datum/pocket_dimension/trap/parent_pocket
	var/datum/mind/captive_mind
	var/datum/weakref/captive_ref
	var/datum/weakref/release_anchor_ref
	var/datum/weakref/trap_controller_ref
	var/entered_at = 0
	var/orgasm_count = 0
	var/popup_pending = FALSE
	var/suppress_until = 0
	var/trap_reason_flags = 0
	var/datum/browser/modal/trap_pocket_prompt/active_prompt

/datum/trap_pocket_tracker/New(datum/pocket_dimension/trap/parent_pocket, mob/living/carbon/captive, atom/release_anchor = null, atom/trap_controller = null)
	src.parent_pocket = parent_pocket
	rearm_trap_tracker(captive, release_anchor, trap_controller)
	. = ..()

/datum/trap_pocket_tracker/Destroy(force)
	var/mob/living/carbon/captive = get_captive()
	if(captive)
		UnregisterSignal(captive, list(COMSIG_SEX_CLIMAX, COMSIG_LIVING_HEALTH_UPDATE, COMSIG_PARENT_QDELETING))

	if(parent_pocket?.captive_trackers_by_mind && parent_pocket.captive_trackers_by_mind[captive_mind] == src)
		parent_pocket.captive_trackers_by_mind.Remove(captive_mind)

	QDEL_NULL(active_prompt)
	parent_pocket = null
	captive_mind = null
	captive_ref = null
	release_anchor_ref = null
	trap_controller_ref = null
	return ..()

/datum/trap_pocket_tracker/proc/rearm_trap_tracker(mob/living/carbon/captive, atom/release_anchor = null, atom/trap_controller = null)
	var/mob/living/carbon/old_captive = get_captive()
	if(old_captive)
		UnregisterSignal(old_captive, list(COMSIG_SEX_CLIMAX, COMSIG_LIVING_HEALTH_UPDATE, COMSIG_PARENT_QDELETING))

	if(!istype(captive))
		captive_ref = null
		captive_mind = null
		return FALSE

	captive_ref = WEAKREF(captive)
	captive_mind = captive.mind
	release_anchor_ref = release_anchor ? WEAKREF(release_anchor) : null
	trap_controller_ref = trap_controller ? WEAKREF(trap_controller) : null
	entered_at = world.time
	orgasm_count = 0
	popup_pending = FALSE
	suppress_until = 0
	trap_reason_flags = 0
	RegisterSignal(captive, COMSIG_SEX_CLIMAX, PROC_REF(handle_captive_climax))
	RegisterSignal(captive, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(handle_captive_health_update))
	RegisterSignal(captive, COMSIG_PARENT_QDELETING, PROC_REF(handle_captive_deletion))
	return TRUE

/datum/trap_pocket_tracker/proc/get_captive()
	var/mob/living/carbon/captive = captive_ref?.resolve()
	if(istype(captive))
		return captive

	captive_ref = null
	return null

/datum/trap_pocket_tracker/proc/get_release_anchor()
	var/atom/release_anchor = release_anchor_ref?.resolve()
	if(release_anchor && !QDELETED(release_anchor))
		return release_anchor

	release_anchor_ref = null
	return null

/datum/trap_pocket_tracker/proc/get_trap_controller()
	var/atom/trap_controller = trap_controller_ref?.resolve()
	if(trap_controller && !QDELETED(trap_controller))
		return trap_controller

	trap_controller_ref = null
	return null

/datum/trap_pocket_tracker/proc/process_tracker()
	var/mob/living/carbon/captive = get_captive()
	if(!istype(captive))
		qdel(src)
		return FALSE
	if(!parent_pocket?.contains_turf(get_turf(captive)))
		qdel(src)
		return FALSE

	evaluate_prompt_state()
	return TRUE

/datum/trap_pocket_tracker/proc/evaluate_prompt_state()
	var/mob/living/carbon/captive = get_captive()
	if(!istype(captive))
		return FALSE
	if(!parent_pocket?.contains_turf(get_turf(captive)))
		return FALSE

	trap_reason_flags = get_trigger_reason_flags(captive)
	if(!trap_reason_flags)
		return FALSE
	if(world.time < suppress_until)
		return FALSE
	if(popup_pending)
		return FALSE
	if(!captive.client)
		return FALSE

	popup_pending = TRUE
	INVOKE_ASYNC(src, PROC_REF(show_trigger_prompt))
	return TRUE

/datum/trap_pocket_tracker/proc/get_trigger_reason_flags(mob/living/carbon/captive = get_captive())
	if(!istype(captive))
		return 0

	var/trigger_flags = 0
	if(parent_pocket.orgasm_trigger_count > 0 && orgasm_count >= parent_pocket.orgasm_trigger_count)
		trigger_flags |= TRAP_TRIGGER_ORGASM
	if(parent_pocket.time_trigger_delay > 0 && world.time >= entered_at + parent_pocket.time_trigger_delay)
		trigger_flags |= TRAP_TRIGGER_TIME

	var/in_full_critical = captive.InFullCritical()
	if(parent_pocket.trigger_on_hard_crit && in_full_critical)
		trigger_flags |= TRAP_TRIGGER_HARD_CRIT
	else if(parent_pocket.trigger_on_soft_crit && captive.InCritical())
		trigger_flags |= TRAP_TRIGGER_SOFT_CRIT

	return trigger_flags

/datum/trap_pocket_tracker/proc/get_trigger_reason_list(trigger_flags = trap_reason_flags)
	var/list/reasons = list()

	if(trigger_flags & TRAP_TRIGGER_ORGASM)
		reasons += "I have climaxed [parent_pocket.orgasm_trigger_count] times inside this trap."
	if(trigger_flags & TRAP_TRIGGER_TIME)
		reasons += "I have been trapped here for [DisplayTimeText(parent_pocket.time_trigger_delay)]."
	if(trigger_flags & TRAP_TRIGGER_HARD_CRIT)
		reasons += "My body has slipped into deadly critical condition."
	else if(trigger_flags & TRAP_TRIGGER_SOFT_CRIT)
		reasons += "My body is failing in critical condition."

	return reasons

/datum/trap_pocket_tracker/proc/show_trigger_prompt()
	var/mob/living/carbon/captive = get_captive()
	if(!istype(captive))
		popup_pending = FALSE
		return FALSE
	if(!captive.client)
		popup_pending = FALSE
		return FALSE
	if(!parent_pocket?.contains_turf(get_turf(captive)))
		popup_pending = FALSE
		return FALSE

	var/current_trigger_flags = get_trigger_reason_flags(captive)
	trap_reason_flags = current_trigger_flags
	if(!current_trigger_flags)
		popup_pending = FALSE
		return FALSE
	if(world.time < suppress_until)
		popup_pending = FALSE
		return FALSE

	var/datum/browser/modal/trap_pocket_prompt/prompt = new(captive, src, current_trigger_flags, can_offer_rune_rescue(captive))
	active_prompt = prompt
	prompt.open()
	prompt.wait()
	if(active_prompt == prompt)
		active_prompt = null

	var/prompt_choice = prompt.choice
	qdel(prompt)

	popup_pending = FALSE
	if(QDELETED(src))
		return FALSE

	captive = get_captive()
	if(!istype(captive))
		return FALSE
	if(!parent_pocket?.contains_turf(get_turf(captive)))
		return FALSE

	switch(prompt_choice)
		if(TRAP_PROMPT_CHOICE_RUNE)
			return choose_rune_rescue(captive)
		if(TRAP_PROMPT_CHOICE_LOBBY)
			return choose_lobby_escape(captive)
		if(TRAP_PROMPT_CHOICE_CONTINUE)
			return choose_keep_going(captive)

	return FALSE

/datum/trap_pocket_tracker/proc/get_rune_controller(mob/living/carbon/captive = get_captive())
	return get_resurrection_rune_controller_for_user(captive)

/datum/trap_pocket_tracker/proc/can_offer_rune_rescue(mob/living/carbon/captive = get_captive())
	var/datum/resurrection_rune_controller/rune_controller = get_rune_controller(captive)
	if(!rune_controller)
		return FALSE
	return rune_controller.can_trigger_trap_rescue(captive)

/datum/trap_pocket_tracker/proc/choose_rune_rescue(mob/living/carbon/captive)
	var/datum/resurrection_rune_controller/rune_controller = get_rune_controller(captive)
	if(!rune_controller?.trigger_trap_rescue(captive))
		to_chat(captive, span_warning("No resurrection rune answers my plea."))
		return FALSE

	parent_pocket.unmark_forced_captive(captive)
	qdel(src)
	return TRUE

/datum/trap_pocket_tracker/proc/choose_lobby_escape(mob/living/carbon/captive)
	parent_pocket.unmark_forced_captive(captive)
	qdel(src)

	var/datum/job/J = SSjob.GetJob(captive.job)
	if(J.parent_job)
		J.parent_job.adjust_current_positions(-1)
		J.adjust_current_positions(-1)
	else
		J.adjust_current_positions(-1)

	for(var/obj/structure/resurrection_rune/rr in GLOB.global_resurrunes)
		if(captive in rr.resrunecontroler.linked_users)
			rr.resrunecontroler.remove_user(captive)
			GLOB.rune_roundstart_mobs -= captive
	GLOB.chosen_names -= captive.real_name
	captive.returntolobby()
	qdel(captive)
	return TRUE

/datum/trap_pocket_tracker/proc/choose_keep_going(mob/living/carbon/captive)
	entered_at = world.time
	orgasm_count = 0
	trap_reason_flags = 0
	suppress_until = world.time + parent_pocket.reset_cooldown
	to_chat(captive, span_notice("I steady myself and press on. If the trap breaks me again, it will have to ask anew."))
	return TRUE

/datum/trap_pocket_tracker/proc/handle_captive_climax(mob/living/carbon/source)
	SIGNAL_HANDLER

	orgasm_count += 1
	evaluate_prompt_state()

/datum/trap_pocket_tracker/proc/handle_captive_health_update(mob/living/carbon/source)
	SIGNAL_HANDLER

	evaluate_prompt_state()

/datum/trap_pocket_tracker/proc/handle_captive_deletion(datum/source)
	SIGNAL_HANDLER

	qdel(src)

/datum/browser/modal/trap_pocket_prompt
	var/datum/trap_pocket_tracker/tracker
	var/trigger_flags = 0
	var/rune_available = FALSE

/datum/browser/modal/trap_pocket_prompt/New(mob/user, datum/trap_pocket_tracker/tracker, trigger_flags, rune_available)
	if(!user)
		closed = TRUE
		return

	src.tracker = tracker
	src.trigger_flags = trigger_flags
	src.rune_available = rune_available

	..(user, ckey("[user]-trap-pocket-[world.time]-[rand(1, 10000)]"), TRAP_PROMPT_TITLE, 430, 280, src, TRUE, 0)
	set_head_content({"
		<style>
			body {
				margin: 0;
				padding: 18px;
				background: #120f0c;
				color: #e7d8be;
				font-family: Georgia, 'Times New Roman', serif;
			}

			.trap-shell {
				border: 1px solid #5b4831;
				background: radial-gradient(circle at top, #2b2117 0%, #150f0b 60%, #0a0705 100%);
				padding: 16px;
			}

			.trap-title {
				font-size: 24px;
				color: #f2d89d;
				text-transform: uppercase;
				letter-spacing: 1px;
				margin-bottom: 10px;
			}

			.trap-copy {
				line-height: 1.5;
				margin-bottom: 12px;
			}

			.trap-reasons {
				margin: 0 0 16px 18px;
				padding: 0;
				color: #ebdfc0;
			}

			.trap-reasons li {
				margin-bottom: 6px;
			}

			.trap-actions {
				display: flex;
				flex-wrap: wrap;
				gap: 8px;
			}

			.trap-actions button {
				flex: 1 1 30%;
				padding: 10px 12px;
				border: 1px solid #7b633c;
				background: #2b2116;
				color: #f3e0ab;
				font-weight: bold;
				cursor: pointer;
			}

			.trap-actions button:hover {
				background: #3a2a19;
			}

			.trap-actions button:disabled {
				border-color: #473a2d;
				background: #16120d;
				color: #7f7463;
				cursor: default;
			}

			.trap-note {
				margin-top: 12px;
				color: #ab9b7e;
				font-size: 12px;
			}
		</style>
	"})
	set_content(build_prompt_html())

/datum/browser/modal/trap_pocket_prompt/proc/build_prompt_html()
	var/list/reasons = tracker?.get_trigger_reason_list(trigger_flags) || list()
	var/list/reason_lines = list()
	for(var/reason in reasons)
		reason_lines += "<li>[html_encode("[reason]")]</li>"

	return {"
		<form action='byond://'>
			<input type='hidden' name='src' value='[REF(src)]'>
			<div class='trap-shell'>
				<div class='trap-title'>The Trap Gives Me A Choice</div>
				<div class='trap-copy'>The prison tightens around me. Something in the dark offers three doors.</div>
				<ul class='trap-reasons'>[reason_lines.Join("")]</ul>
				<div class='trap-actions'>
					<button type='submit' name='choice' value='[TRAP_PROMPT_CHOICE_RUNE]' [!rune_available ? "disabled" : ""]>[TRAP_PROMPT_CHOICE_RUNE]</button>
					<button type='submit' name='choice' value='[TRAP_PROMPT_CHOICE_LOBBY]'>[TRAP_PROMPT_CHOICE_LOBBY]</button>
					<button type='submit' name='choice' value='[TRAP_PROMPT_CHOICE_CONTINUE]'>[TRAP_PROMPT_CHOICE_CONTINUE]</button>
				</div>
				<div class='trap-note'>Choosing [TRAP_PROMPT_CHOICE_CONTINUE] resets the trap's count and buys me a brief reprieve.</div>
			</div>
		</form>
	"}

/datum/browser/modal/trap_pocket_prompt/Topic(href, href_list)
	if(href_list["close"] || !user || !user.client)
		closed = TRUE
		return
	if(href_list["choice"])
		set_choice(href_list["choice"])

	closed = TRUE
	close()

/datum/browser/modal/trap_pocket_prompt/set_choice(choice)
	if(choice == TRAP_PROMPT_CHOICE_RUNE && !rune_available)
		return
	if(choice != TRAP_PROMPT_CHOICE_RUNE && choice != TRAP_PROMPT_CHOICE_LOBBY && choice != TRAP_PROMPT_CHOICE_CONTINUE)
		return

	..()

#undef TRAP_PROMPT_TITLE
#undef TRAP_PROMPT_CHOICE_RUNE
#undef TRAP_PROMPT_CHOICE_LOBBY
#undef TRAP_PROMPT_CHOICE_CONTINUE
