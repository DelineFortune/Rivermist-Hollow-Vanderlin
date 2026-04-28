#define WW_CONTRACT_BROWSER_WINDOW_ID "werewolf_moon_hunt"
#define WW_CONTRACT_BROWSER_TITLE "Moon Hunt"
#define WW_CONTRACT_BROWSER_WIDTH 960
#define WW_CONTRACT_BROWSER_HEIGHT 640
#define WW_CONTRACT_JOURNAL_ICON_STATE "diagnose"
#define WW_CONTRACT_SNIFF_ICON_STATE "howl"
#define WW_SCENT_DISTANCE_IMMEDIATE 1
#define WW_SCENT_DISTANCE_NEAR 7
#define WW_SCENT_DISTANCE_MID 20
#define WW_SCENT_DISTANCE_FAR 60

/datum/antagonist/werewolf
	var/datum/weakref/tracked_contract_scroll_ref
	var/datum/action/innate/werewolf_contract_journal/contract_journal_action
	var/datum/action/innate/werewolf_contract_scent/contract_scent_action

/datum/antagonist/werewolf/proc/initialize_werewolf_contract_interface()
	refresh_werewolf_contract_state()

/datum/antagonist/werewolf/proc/cleanup_werewolf_contract_interface()
	close_werewolf_contract_browser()
	tracked_contract_scroll_ref = null
	QDEL_NULL(contract_journal_action)
	QDEL_NULL(contract_scent_action)

/datum/antagonist/werewolf/proc/refresh_werewolf_contract_state()
	sync_werewolf_contract_assignments()
	sync_werewolf_contract_actions()

/datum/antagonist/werewolf/proc/get_werewolf_contract_scrolls(include_complete = TRUE)
	var/list/contract_scrolls = list()

	for(var/obj/item/paper/scroll/quest/werewolf_hidden/hidden_scroll in GLOB.quest_scrolls)
		if(!hidden_scroll.is_owned_by_werewolf(src))
			continue
		if(!hidden_scroll.assigned_quest)
			continue
		if(!include_complete && hidden_scroll.assigned_quest.complete)
			continue
		contract_scrolls += hidden_scroll

	return contract_scrolls

/datum/antagonist/werewolf/proc/has_werewolf_contract_entries()
	return length(get_werewolf_contract_scrolls(TRUE))

/datum/antagonist/werewolf/proc/has_active_werewolf_contracts()
	return length(get_werewolf_contract_scrolls(FALSE))

/datum/antagonist/werewolf/proc/sync_werewolf_contract_assignments()
	var/mob/living/current_body = owner?.current
	if(!current_body)
		return

	for(var/obj/item/paper/scroll/quest/werewolf_hidden/hidden_scroll in get_werewolf_contract_scrolls(TRUE))
		hidden_scroll.sync_receiver_to_current_owner(current_body)

	sanitize_tracked_werewolf_contract_scroll()

/datum/antagonist/werewolf/proc/sanitize_tracked_werewolf_contract_scroll()
	var/obj/item/paper/scroll/quest/werewolf_hidden/tracked_scroll = tracked_contract_scroll_ref?.resolve()
	if(tracked_scroll && tracked_scroll.is_owned_by_werewolf(src) && tracked_scroll.assigned_quest && !tracked_scroll.assigned_quest.complete)
		return tracked_scroll

	tracked_contract_scroll_ref = null
	for(var/obj/item/paper/scroll/quest/werewolf_hidden/hidden_scroll in get_werewolf_contract_scrolls(FALSE))
		tracked_contract_scroll_ref = WEAKREF(hidden_scroll)
		return hidden_scroll

	return null

/datum/antagonist/werewolf/proc/get_tracked_werewolf_contract_scroll(require_incomplete = TRUE)
	if(require_incomplete)
		return sanitize_tracked_werewolf_contract_scroll()

	var/obj/item/paper/scroll/quest/werewolf_hidden/tracked_scroll = tracked_contract_scroll_ref?.resolve()
	if(tracked_scroll && tracked_scroll.is_owned_by_werewolf(src) && tracked_scroll.assigned_quest)
		return tracked_scroll

	tracked_contract_scroll_ref = null
	for(var/obj/item/paper/scroll/quest/werewolf_hidden/hidden_scroll in get_werewolf_contract_scrolls(TRUE))
		return hidden_scroll

	return null

/datum/antagonist/werewolf/proc/set_tracked_werewolf_contract_scroll(obj/item/paper/scroll/quest/werewolf_hidden/new_tracked_scroll)
	if(!new_tracked_scroll)
		tracked_contract_scroll_ref = null
		refresh_werewolf_contract_browser_if_open()
		return FALSE

	if(!new_tracked_scroll.is_owned_by_werewolf(src))
		return FALSE
	if(!new_tracked_scroll.assigned_quest || new_tracked_scroll.assigned_quest.complete)
		return FALSE

	tracked_contract_scroll_ref = WEAKREF(new_tracked_scroll)
	refresh_werewolf_contract_browser_if_open()
	return TRUE

/datum/antagonist/werewolf/proc/get_werewolf_contract_scroll_by_ref(scroll_ref_text)
	if(!scroll_ref_text)
		return null

	var/obj/item/paper/scroll/quest/werewolf_hidden/hidden_scroll = locate(scroll_ref_text) in GLOB.quest_scrolls
	if(!hidden_scroll || !hidden_scroll.is_owned_by_werewolf(src))
		return null

	return hidden_scroll

/datum/antagonist/werewolf/proc/get_turn_in_werewolf_contract_scroll()
	var/obj/item/paper/scroll/quest/werewolf_hidden/tracked_scroll = get_tracked_werewolf_contract_scroll(FALSE)
	if(tracked_scroll?.assigned_quest?.complete)
		return tracked_scroll

	for(var/obj/item/paper/scroll/quest/werewolf_hidden/hidden_scroll in get_werewolf_contract_scrolls(TRUE))
		if(hidden_scroll.assigned_quest?.complete)
			return hidden_scroll

	return null

/datum/antagonist/werewolf/proc/get_abandonable_werewolf_contract_scroll()
	var/obj/item/paper/scroll/quest/werewolf_hidden/tracked_scroll = get_tracked_werewolf_contract_scroll(TRUE)
	if(tracked_scroll)
		return tracked_scroll

	for(var/obj/item/paper/scroll/quest/werewolf_hidden/hidden_scroll in get_werewolf_contract_scrolls(FALSE))
		return hidden_scroll

	return null

/datum/antagonist/werewolf/proc/sync_werewolf_contract_actions()
	var/mob/living/current_body = owner?.current
	if(!current_body)
		if(contract_journal_action?.owner)
			contract_journal_action.Remove(contract_journal_action.owner)
		if(contract_scent_action?.owner)
			contract_scent_action.Remove(contract_scent_action.owner)
		return

	if(has_werewolf_contract_entries())
		if(!contract_journal_action)
			contract_journal_action = new(src)
		contract_journal_action.Grant(current_body)
	else
		close_werewolf_contract_browser()
		if(contract_journal_action?.owner)
			contract_journal_action.Remove(contract_journal_action.owner)

	if(has_active_werewolf_contracts())
		if(!contract_scent_action)
			contract_scent_action = new(src)
		contract_scent_action.Grant(current_body)
	else if(contract_scent_action?.owner)
		contract_scent_action.Remove(contract_scent_action.owner)

/datum/antagonist/werewolf/proc/can_use_werewolf_contract_interface(mob/living/user)
	return is_current_werewolf_body(user)

/datum/antagonist/werewolf/proc/open_werewolf_contract_browser(mob/living/user = owner?.current)
	if(!can_use_werewolf_contract_interface(user))
		return FALSE

	sync_werewolf_contract_assignments()

	var/datum/browser/popup = new(user, WW_CONTRACT_BROWSER_WINDOW_ID, WW_CONTRACT_BROWSER_TITLE, WW_CONTRACT_BROWSER_WIDTH, WW_CONTRACT_BROWSER_HEIGHT)
	popup.set_content(build_werewolf_contract_browser_html(user))
	popup.open()
	return TRUE

/datum/antagonist/werewolf/proc/close_werewolf_contract_browser()
	var/mob/living/current_body = owner?.current
	if(!current_body?.client)
		return

	current_body << browse(null, "window=[WW_CONTRACT_BROWSER_WINDOW_ID]")

/datum/antagonist/werewolf/proc/refresh_werewolf_contract_browser_if_open()
	// Refreshing browse windows here steals focus and can make Moon Hunt pop open
	// during background quest updates. Keep browser updates manual instead.
	return FALSE

/datum/antagonist/werewolf/proc/build_werewolf_contract_browser_html(mob/living/user)
	var/turf/reference_turf = get_turf(user)
	var/obj/item/paper/scroll/quest/werewolf_hidden/tracked_scroll = get_tracked_werewolf_contract_scroll(TRUE)
	var/list/contract_scrolls = get_werewolf_contract_scrolls(TRUE)
	var/list/content = list()

	content += "<style>"
	content += "body{margin:0;padding:0;background:#0f0f0c;color:#e7dcc0;font-family:Georgia,'Times New Roman',serif;}"
	content += ".moonhunt-shell{padding:18px;background:radial-gradient(circle at top,#363022 0%,#18150f 55%,#0b0a07 100%);min-height:100vh;}"
	content += ".moonhunt-header{border-bottom:1px solid #6d5b2d;padding-bottom:12px;margin-bottom:16px;}"
	content += ".moonhunt-title{font-size:28px;letter-spacing:2px;color:#f4e6a2;text-transform:uppercase;}"
	content += ".moonhunt-subtitle{margin-top:6px;color:#c7ba97;font-size:14px;}"
	content += ".moonhunt-empty{padding:18px;border:1px solid #5c4b21;background:rgba(26,22,16,0.85);color:#d2c59e;}"
	content += ".contract-card{margin-bottom:14px;padding:16px;border:1px solid #5b4b25;background:rgba(20,17,12,0.9);box-shadow:0 6px 20px rgba(0,0,0,0.25);}"
	content += ".contract-card.tracked{border-color:#d1b24a;box-shadow:0 0 0 1px #d1b24a inset,0 8px 22px rgba(0,0,0,0.35);}"
	content += ".contract-top{display:flex;justify-content:space-between;gap:12px;align-items:flex-start;}"
	content += ".contract-title{font-size:21px;color:#f0df9b;margin-bottom:6px;}"
	content += ".contract-status{font-size:12px;text-transform:uppercase;letter-spacing:1px;padding:4px 8px;border:1px solid #8c7631;color:#f6e7a8;background:#2e2819;white-space:nowrap;}"
	content += ".contract-status.complete{border-color:#6aa35f;color:#b9efaf;background:#1d2a19;}"
	content += ".contract-meta{color:#b9ad89;font-size:13px;line-height:1.6;margin-top:10px;}"
	content += ".contract-section{margin-top:10px;padding-top:10px;border-top:1px solid rgba(109,91,45,0.45);}"
	content += ".contract-label{color:#9b8750;text-transform:uppercase;letter-spacing:1px;font-size:11px;margin-bottom:3px;}"
	content += ".contract-text{color:#eadfbf;line-height:1.5;}"
	content += ".contract-reward{display:flex;gap:16px;flex-wrap:wrap;margin-top:8px;color:#dfd0a7;}"
	content += ".track-button{display:inline-block;margin-top:12px;padding:7px 12px;border:1px solid #c7a746;background:#5f4d1f;color:#fff1b0;text-decoration:none;text-transform:uppercase;letter-spacing:1px;font-size:11px;}"
	content += ".track-button:hover{background:#7b6528;}"
	content += ".track-label{display:inline-block;margin-top:12px;padding:7px 12px;border:1px solid #8f7c47;background:#2c2618;color:#efe0ad;text-transform:uppercase;letter-spacing:1px;font-size:11px;}"
	content += ".track-label.done{border-color:#6aa35f;color:#b9efaf;background:#1d2a19;}"
	content += "</style>"
	content += "<div class='moonhunt-shell'>"
	content += "<div class='moonhunt-header'>"
	content += "<div class='moonhunt-title'>Moon Hunt</div>"
	content += "<div class='moonhunt-subtitle'>The ledger binds each contract to instinct. Choose one quarry to follow, then sniff the trail in the wild.</div>"
	content += "</div>"

	if(!length(contract_scrolls))
		content += "<div class='moonhunt-empty'>No moon-hunt contracts cling to my instincts.</div>"
	else
		for(var/obj/item/paper/scroll/quest/werewolf_hidden/hidden_scroll in contract_scrolls)
			var/datum/quest/contract_quest = hidden_scroll.assigned_quest
			if(!contract_quest)
				continue

			var/is_tracked = tracked_scroll == hidden_scroll
			var/card_class = is_tracked ? "contract-card tracked" : "contract-card"
			var/status_class = contract_quest.complete ? "contract-status complete" : "contract-status"
			var/status_label = contract_quest.complete ? "Complete" : "Active"
			var/objective_text = html_encode(contract_quest.get_objective_text())
			var/location_text = html_encode(contract_quest.get_location_text())
			var/map_text = html_encode(reference_turf ? contract_quest.get_target_map_text(reference_turf) : contract_quest.get_turn_in_ledger_name())
			var/title_text = html_encode(contract_quest.get_title())
			var/tier_text = html_encode(contract_quest.get_tier_label())
			var/type_text = html_encode("[contract_quest.quest_type] contract")
			var/progress_text = contract_quest.progress_required > 1 ? "[contract_quest.progress_current]/[contract_quest.progress_required]" : (contract_quest.complete ? "Complete" : "In progress")
			var/track_control

			if(contract_quest.complete)
				track_control = "<span class='track-label done'>Return this to the moon hunt ledger</span>"
			else if(is_tracked)
				track_control = "<span class='track-label'>Currently tracking this quarry</span>"
			else
				track_control = "<a class='track-button' href='?src=[REF(src)];ww_contract_action=track;scroll_ref=[REF(hidden_scroll)]'>Track this quarry</a>"

			content += "<div class='[card_class]'>"
			content += "<div class='contract-top'>"
			content += "<div>"
			content += "<div class='contract-title'>[title_text]</div>"
			content += "<div class='contract-meta'>[type_text] | [tier_text]</div>"
			content += "</div>"
			content += "<div class='[status_class]'>[status_label]</div>"
			content += "</div>"
			content += "<div class='contract-section'>"
			content += "<div class='contract-label'>Objective</div>"
			content += "<div class='contract-text'>[objective_text]</div>"
			content += "</div>"
			content += "<div class='contract-section'>"
			content += "<div class='contract-label'>Trail</div>"
			content += "<div class='contract-text'><b>Map:</b> [map_text]<br><b>Location:</b> [location_text]</div>"
			content += "</div>"
			content += "<div class='contract-section'>"
			content += "<div class='contract-label'>Progress</div>"
			content += "<div class='contract-text'>[progress_text]</div>"
			content += "<div class='contract-reward'><span><b>Reward:</b> [contract_quest.reward_amount] amna</span>"
			if(contract_quest.objective_score_reward > 0)
				content += "<span><b>Hunt Score:</b> [contract_quest.objective_score_reward]</span>"
			content += "</div>"
			content += "[track_control]"
			content += "</div>"
			content += "</div>"

	content += "</div>"
	return content.Join("")

/datum/antagonist/werewolf/proc/get_werewolf_contract_distance_text(turf/reference_turf, turf/target_turf)
	if(!reference_turf || !target_turf)
		return "somewhere beyond my nose"

	var/distance = get_dist(reference_turf, target_turf)
	if(distance <= WW_SCENT_DISTANCE_IMMEDIATE)
		return "right on top of me"
	if(distance <= WW_SCENT_DISTANCE_NEAR)
		return "very close"
	if(distance <= WW_SCENT_DISTANCE_MID)
		return "nearby"
	if(distance <= WW_SCENT_DISTANCE_FAR)
		return "far off"
	return "very far away"

/datum/antagonist/werewolf/proc/sniff_active_werewolf_contract(mob/living/user = owner?.current)
	if(!can_use_werewolf_contract_interface(user))
		return FALSE

	sync_werewolf_contract_assignments()

	var/obj/item/paper/scroll/quest/werewolf_hidden/tracked_scroll = get_tracked_werewolf_contract_scroll(TRUE)
	if(!tracked_scroll)
		to_chat(user, span_warning("No active moon-hunt trail answers my nose."))
		sync_werewolf_contract_actions()
		return FALSE

	var/datum/quest/tracked_quest = tracked_scroll.assigned_quest
	var/turf/reference_turf = get_turf(user)
	if(!tracked_quest || !reference_turf)
		to_chat(user, span_warning("I cannot read the moon hunt from here."))
		return FALSE

	var/list/signal_data = tracked_quest.get_compass_signal_data(reference_turf)
	var/turf/compass_target = signal_data["compass_target"]
	var/turf/resolved_target = signal_data["resolved_target"]
	var/resolved_map_name = tracked_quest.get_target_map_text(reference_turf)
	var/reference_map_file = tracked_quest.get_map_file_for_turf(reference_turf)
	var/resolved_map_file = tracked_quest.get_map_file_for_turf(resolved_target)
	var/direction_text = get_precise_direction_between(reference_turf, compass_target)
	var/distance_text = get_werewolf_contract_distance_text(reference_turf, resolved_target)
	var/title_text = tracked_quest.get_title()

	if(!resolved_target)
		to_chat(user, span_warning("The scent for [title_text] slips out of my grasp."))
		return FALSE

	if(reference_map_file && resolved_map_file && reference_map_file != resolved_map_file)
		if(compass_target)
			var/gate_direction_text = get_precise_direction_between(reference_turf, compass_target) || dir2text(get_dir(reference_turf, compass_target))
			to_chat(user, span_notice("The scent for [title_text] bends to the [gate_direction_text], toward a gate leading to [resolved_map_name]."))
		else
			to_chat(user, span_notice("The scent for [title_text] vanishes off this land. The quarry lies somewhere on [resolved_map_name]."))
		to_chat(user, span_info("Objective: [tracked_quest.get_objective_text()]"))
		return TRUE

	if(!direction_text)
		to_chat(user, span_notice("The scent for [title_text] is [distance_text]."))
	else
		to_chat(user, span_notice("The scent for [title_text] is [distance_text] to the [direction_text]."))

	to_chat(user, span_info("Objective: [tracked_quest.get_objective_text()]"))
	if(tracked_quest.progress_required > 1)
		to_chat(user, span_info("Progress: [tracked_quest.progress_current]/[tracked_quest.progress_required]."))
	return TRUE

/datum/antagonist/werewolf/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(!href_list["ww_contract_action"])
		return

	var/mob/living/user = usr
	if(!can_use_werewolf_contract_interface(user))
		return

	switch(href_list["ww_contract_action"])
		if("track")
			var/obj/item/paper/scroll/quest/werewolf_hidden/hidden_scroll = get_werewolf_contract_scroll_by_ref(href_list["scroll_ref"])
			if(!hidden_scroll || !hidden_scroll.assigned_quest || hidden_scroll.assigned_quest.complete)
				to_chat(user, span_warning("That moon-hunt trail has already gone cold."))
				refresh_werewolf_contract_state()
				return

			set_tracked_werewolf_contract_scroll(hidden_scroll)
			to_chat(user, span_notice("I fix on the scent of [hidden_scroll.assigned_quest.get_title()]."))
			open_werewolf_contract_browser(user)

/obj/item/paper/scroll/quest/werewolf_hidden
	name = "moon hunt scent"
	desc = "A hidden moon-hunt token that should never be seen outside werewolf instincts."
	item_flags = ABSTRACT | DROPDEL
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/datum/weakref/owner_werewolf_ref
	var/datum/weakref/owner_mind_ref

/obj/item/paper/scroll/quest/werewolf_hidden/Initialize(mapload, datum/antagonist/werewolf/owner_werewolf)
	if(!mapload && !owner_werewolf)
		return INITIALIZE_HINT_QDEL
	if(owner_werewolf)
		owner_werewolf_ref = WEAKREF(owner_werewolf)
		if(owner_werewolf.owner)
			owner_mind_ref = WEAKREF(owner_werewolf.owner)

	. = ..()
	moveToNullspace()

/obj/item/paper/scroll/quest/werewolf_hidden/Destroy()
	var/datum/antagonist/werewolf/owner_werewolf = get_owner_werewolf()
	. = ..()
	if(owner_werewolf && !QDELETED(owner_werewolf))
		owner_werewolf.refresh_werewolf_contract_state()

/obj/item/paper/scroll/quest/werewolf_hidden/proc/get_owner_mind()
	var/datum/mind/owner_mind = owner_mind_ref?.resolve()
	if(owner_mind)
		return owner_mind

	owner_mind_ref = null
	var/datum/antagonist/werewolf/owner_werewolf = owner_werewolf_ref?.resolve()
	if(!owner_werewolf?.owner)
		return null

	owner_mind_ref = WEAKREF(owner_werewolf.owner)
	return owner_werewolf.owner

/obj/item/paper/scroll/quest/werewolf_hidden/proc/get_owner_werewolf()
	var/datum/mind/owner_mind = get_owner_mind()
	if(!owner_mind)
		owner_werewolf_ref = null
		return null

	var/datum/antagonist/werewolf/owner_werewolf = owner_mind.has_antag_datum(/datum/antagonist/werewolf)
	if(!owner_werewolf)
		owner_werewolf_ref = null
		return null

	owner_werewolf_ref = WEAKREF(owner_werewolf)
	return owner_werewolf

/obj/item/paper/scroll/quest/werewolf_hidden/proc/is_owned_by_werewolf(datum/antagonist/werewolf/requesting_werewolf)
	if(!istype(requesting_werewolf))
		return FALSE
	return get_owner_mind() == requesting_werewolf.owner

/obj/item/paper/scroll/quest/werewolf_hidden/proc/sync_receiver_to_current_owner(mob/living/current_body = null)
	if(!assigned_quest)
		return FALSE

	if(!current_body)
		var/datum/antagonist/werewolf/owner_werewolf = get_owner_werewolf()
		current_body = owner_werewolf?.owner?.current

	if(!current_body)
		return FALSE

	assigned_quest.quest_receiver_reference = WEAKREF(current_body)
	return TRUE

/obj/item/paper/scroll/quest/werewolf_hidden/get_quest_assignees(var/mob/user, var/include_giver = FALSE)
	var/list/assignees = ..()
	var/datum/antagonist/werewolf/owner_werewolf = get_owner_werewolf()
	var/mob/living/current_body = owner_werewolf?.owner?.current
	if(current_body && !(current_body in assignees))
		assignees += current_body
	return assignees

/obj/item/paper/scroll/quest/werewolf_hidden/update_quest_text()
	var/datum/antagonist/werewolf/owner_werewolf = get_owner_werewolf()
	if(owner_werewolf)
		owner_werewolf.refresh_werewolf_contract_state()

/datum/action/innate/werewolf_contract_journal
	name = "Moon Hunt"
	desc = "Review the contracts bound to your instincts and choose which quarry to follow."
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_PHASED
	button_icon_state = WW_CONTRACT_JOURNAL_ICON_STATE

/datum/action/innate/werewolf_contract_journal/IsAvailable()
	. = ..()
	if(!.)
		return FALSE

	var/datum/antagonist/werewolf/owner_werewolf = target
	if(!istype(owner_werewolf))
		return FALSE

	return owner_werewolf.has_werewolf_contract_entries()

/datum/action/innate/werewolf_contract_journal/Activate()
	. = ..()
	var/datum/antagonist/werewolf/owner_werewolf = target
	if(!istype(owner_werewolf))
		return

	if(!owner_werewolf.open_werewolf_contract_browser(owner))
		to_chat(owner, span_warning("The moon hunt stays quiet."))

/datum/action/innate/werewolf_contract_scent
	name = "Sniff Trail"
	desc = "Taste the wind and follow the currently tracked moon-hunt quarry."
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_PHASED
	button_icon_state = WW_CONTRACT_SNIFF_ICON_STATE

/datum/action/innate/werewolf_contract_scent/IsAvailable()
	. = ..()
	if(!.)
		return FALSE

	var/datum/antagonist/werewolf/owner_werewolf = target
	if(!istype(owner_werewolf))
		return FALSE

	return owner_werewolf.has_active_werewolf_contracts()

/datum/action/innate/werewolf_contract_scent/Activate()
	. = ..()
	var/datum/antagonist/werewolf/owner_werewolf = target
	if(!istype(owner_werewolf))
		return

	owner_werewolf.sniff_active_werewolf_contract(owner)

#undef WW_CONTRACT_BROWSER_WINDOW_ID
#undef WW_CONTRACT_BROWSER_TITLE
#undef WW_CONTRACT_BROWSER_WIDTH
#undef WW_CONTRACT_BROWSER_HEIGHT
#undef WW_CONTRACT_JOURNAL_ICON_STATE
#undef WW_CONTRACT_SNIFF_ICON_STATE
#undef WW_SCENT_DISTANCE_IMMEDIATE
#undef WW_SCENT_DISTANCE_NEAR
#undef WW_SCENT_DISTANCE_MID
#undef WW_SCENT_DISTANCE_FAR
