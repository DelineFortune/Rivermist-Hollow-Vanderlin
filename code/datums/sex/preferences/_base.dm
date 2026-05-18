/datum/erp_preference
	abstract_type = /datum/erp_preference
	/// User facing name of the preference
	var/name = "ERP Preference"
	/// Description shown to the user
	var/description = ""
	/// Whether this preference is enabled by default
	var/default_value = FALSE
	/// Category for organization in menus
	var/category = "General"

/datum/erp_preference/proc/get_value(datum/preferences/prefs)
	return get_value_from_list(prefs?.ensure_erp_preferences())

/datum/erp_preference/proc/get_value_from_list(list/stored_preferences)
	var/stored_value = stored_preferences?[type]
	if(isnull(stored_value))
		return get_default_value()
	return stored_value

/datum/erp_preference/proc/get_default_value()
	return default_value

/datum/erp_preference/proc/set_value(datum/preferences/prefs, value)
	if(!prefs)
		return
	var/list/stored_preferences = prefs.ensure_erp_preferences()
	stored_preferences[type] = value
	prefs.mark_erp_preferences_dirty()

/datum/erp_preference/proc/show_pref_ui(datum/preferences/prefs, lock_reason = null)
	return

/datum/erp_preference/proc/get_tooltip_attribute(tooltip_text)
	if(!tooltip_text)
		return ""
	return " title='[escape_html_attribute(tooltip_text)]'"

/datum/erp_preference/proc/wrap_with_tooltip(content, tooltip_text)
	var/tooltip_attr = get_tooltip_attribute(tooltip_text)
	if(!tooltip_attr)
		return content
	return "<span[tooltip_attr]>[content]</span>"

/datum/erp_preference/proc/ensure_editable(mob/user, datum/preferences/prefs)
	var/lock_reason = prefs.get_erp_preference_edit_lock_reason(user)
	if(!lock_reason)
		return TRUE
	if(user)
		to_chat(user, span_warning(lock_reason))
	return FALSE

/datum/erp_preference/proc/handle_topic(mob/user, list/href_list, datum/preferences/prefs)
	return

/datum/erp_preference/proc/show_session_ui(datum/preferences/prefs, editable = FALSE, datum/sex_session/session, lock_reason = null)
	var/current_value = get_value(prefs)
	if(editable)
		return "<div class='pref-toggle enabled'>[current_value]</div>"
	return wrap_with_tooltip("<div class='pref-toggle disabled'>[current_value]</div>", lock_reason)

/datum/erp_preference/proc/handle_session_topic(mob/user, list/href_list, datum/preferences/prefs, datum/sex_session/session)
	// Return TRUE if the topic was handled, FALSE otherwise
	return FALSE
