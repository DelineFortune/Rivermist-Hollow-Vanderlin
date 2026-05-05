/mob
	var/hud_typing = FALSE //set when typing in an input window instead of chatline
	var/typing
	var/last_typed
	var/last_typed_time
	var/afk_indicator_active = FALSE

	var/static/mutable_appearance/typing_indicator
	var/static/mutable_appearance/afk_indicator

/mob/proc/set_typing_indicator(state, hudt)
	if(!typing_indicator)
		typing_indicator = mutable_appearance('icons/mob/talk.dmi', "default0", FLY_LAYER)
		typing_indicator.alpha = 175

	if(state)
		if(!typing)
			if(hudt)
				hud_typing = TRUE
			add_overlay(typing_indicator)
			typing = TRUE
		if(hudt)
			hud_typing = TRUE
	else
		if(typing)
			cut_overlay(typing_indicator)
			typing = FALSE
			hud_typing = FALSE
	return state

/mob/living/key_down(_key, client/user)
	if(stat == CONSCIOUS)
//		var/list/binds = user.prefs?.key_bindings[_key]
//		if(binds)
/*			if("Say" in binds)
				set_typing_indicator(TRUE, TRUE)
			if("Me" in binds)
				set_typing_indicator(TRUE, TRUE)*/
		if(_key == "T")
			set_typing_indicator(TRUE, TRUE)
		if(_key == "M")
			set_typing_indicator(TRUE, TRUE)
		if(_key == ",")
			set_typing_indicator(TRUE, TRUE)
	return ..()

/mob/proc/handle_typing_indicator()
	if(!client || stat)
		set_typing_indicator(FALSE)
		return

/mob/proc/set_afk_indicator(state)
	if(!afk_indicator)
		afk_indicator = mutable_appearance('icons/mob/ssd_indicator.dmi', "default0", FLY_LAYER)
		afk_indicator.alpha = 200
		afk_indicator.pixel_y = 16

	if(state)
		if(!afk_indicator_active)
			add_overlay(afk_indicator)
			afk_indicator_active = TRUE
	else
		if(afk_indicator_active)
			cut_overlay(afk_indicator)
			afk_indicator_active = FALSE
	return state
