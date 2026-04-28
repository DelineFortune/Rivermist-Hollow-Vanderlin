/client
	var/preferred_ui_language = "en"

/proc/sanitize_preferred_ui_language(language)
	var/selected_language = lowertext("[language || "en"]")
	if(!(selected_language in list("en", "ru")))
		return "en"
	return selected_language

/proc/get_preferred_ui_language(mob/user)
	var/client/user_client = user?.client
	return sanitize_preferred_ui_language(user_client?.preferred_ui_language)

/client/verb/change_prefered_language()
	set name = "Change Preferred Language"
	set category = "OOC"
	set desc = "Change your preferred UI language for multilingual interfaces."

	var/list/language_choices = list(
		"English" = "en",
		"Russian" = "ru",
	)
	var/current_language = preferred_ui_language
	if(!(current_language in list("en", "ru")))
		current_language = "en"

	var/selection = input(src, "Choose your preferred UI language.", "Preferred Language", current_language == "ru" ? "Russian" : "English") as null|anything in language_choices
	if(!selection)
		return

	preferred_ui_language = sanitize_preferred_ui_language(language_choices[selection])
	prefs?.save_preferences()
	to_chat(src, span_notice("Preferred UI language set to [selection]. Reopen interfaces to apply it."))
