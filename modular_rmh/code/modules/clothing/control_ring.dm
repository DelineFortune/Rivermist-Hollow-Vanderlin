/obj/item/clothing/ring/slave_control
	name = "Slave control ring"
	desc = "An ominous-looking ring with arcane engravings. \n Click with the middle mouse button to invoke a command."
	icon_state = "g_ring_ruby"
	sellprice = 1000

	var/list/phrases_list = list()
	var/ring_bound = FALSE
	var/obj/item/clothing/neck/slave_collar/bound_collar

/obj/item/clothing/ring/slave_control/attack(mob/living/M, mob/living/user, def_zone)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/I = H.wear_neck
		if(istype(I, /obj/item/clothing/neck/slave_collar))
			var/obj/item/clothing/neck/slave_collar/sc = I
			sc.bind_collar(src, user, TRUE)

/obj/item/clothing/ring/slave_control/attackby(obj/item/I, mob/living/user)
	if(!ismob(user))
		return
	if(istype(I, /obj/item/clothing/neck/slave_collar))
		var/obj/item/clothing/neck/slave_collar/sc = I
		sc.bind_collar(src, user, FALSE)
		return
	return ..()

/// Opens a radial menu of slave collar commands when middle-clicked.
/obj/item/clothing/ring/slave_control/MiddleClick(mob/user, params)
	if(!bound_collar)
		return ..()
	invoke_collar_command_radial(user, bound_collar)
	return

/// Shared radial menu for invoking commands on a slave collar.
/// Used by both the ring's MiddleClick and the leash's MiddleClick.
/obj/item/clothing/ring/slave_control/proc/invoke_collar_command_radial(mob/user, obj/item/clothing/neck/slave_collar/collar)
	if(!collar || !collar.phrases_list)
		to_chat(user, span_warning("The ring has no collar bound."))
		return
	var/list/choices = list()
	for(var/translation_key in GLOB.slave_phrases_translations)
		var/display_name = GLOB.slave_phrases_translations[translation_key]
		choices[display_name] = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_slice")
	var/chosen = show_radial_menu(user, src, choices, tooltips = TRUE, require_near = FALSE)
	if(!chosen)
		return
	var/internal_key = GLOB.reverse_slave_phrases_translations[chosen]
	if(!internal_key || !collar.phrases_list[internal_key])
		return
	if(collar.perform_command(normalize_slave_phrase(collar.phrases_list[internal_key])))
		to_chat(user, "<font size='1' color='grey'>The ring vibrates imperceptibly — the command was a success.</font>")
	else
		to_chat(user, "<font size='1' color='red'>The ring lies still — command failed to perform.</font>")

/obj/item/clothing/ring/slave_control/examine(mob/user)
	. = ..()
	. += span_userdanger("You notice three engraved phrases on the ring:")
	for(var/el in phrases_list)
		. += "<br><b>[GLOB.slave_phrases_translations[el]]:</b> \"[phrases_list[el]]\""

/datum/anvil_recipe/slave_control
	name = "Slave control ring"
	recipe_name = "a slave control ring"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/gem/red)
	created_item = /obj/item/clothing/ring/slave_control
	craftdiff = 3
	i_type = "Valuables"

/obj/item/clothing/ring/slave_control/master
	name = "Master Slaver ring"
	desc = "One Ring to Rule Them All. \n Click with the middle mouse button to invoke a command, activate in-hand to select a victim."
	icon_state = "ring_g"

/obj/item/clothing/ring/slave_control/master/attack_self(mob/user, params)
	. = ..()
	var/command_input = browser_input_list(user, "CHOOSE YOUR SERVANT", "SERVANTS", GLOB.slave_collars, null)
	if(command_input)
		var/obj/item/clothing/neck/slave_collar/collar = GLOB.slave_collars[command_input]
		if(collar.bind_collar(src, user, TRUE))
			to_chat(user, "<font size='1' color='grey'>The ring vibrates imperceptably - the linking was a success.</font>")
		else
			to_chat(user, "<font size='1' color='red'>The ring lies still - the linking failed to perform.</font>")

/datum/anvil_recipe/slave_control_master
	name = "Master Slaver ring"
	recipe_name = "One Ring to Rule Them All"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/phylactery)
	created_item = /obj/item/clothing/ring/slave_control/master
	craftdiff = 6
	i_type = "Valuables"
