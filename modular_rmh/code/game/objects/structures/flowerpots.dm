/obj/structure/flowerpot
	name = "flower pot"
	desc = "Clay vessel filled with some dirt for flower living purpose."
	icon = 'modular_rmh/icons/obj/flora/flowerpots.dmi'
	icon_state = "pot_large"

	density = FALSE
	anchored = TRUE
	resistance_flags = FIRE_PROOF
	max_integrity = 50

	var/pot_color = "#a3c1c2"

/obj/structure/flowerpot/Initialize(mapload)
	. = ..()
	if(color)
		pot_color = color
	update_appearance()

/obj/structure/flowerpot/update_overlays()
	. = ..()

	var/mutable_appearance/pot = mutable_appearance(icon, icon_state, layer = layer)
	pot.color = pot_color
	. += pot

	var/dirt_state = replacetext(icon_state, "pot_", "dirt_")
	var/mutable_appearance/dirt = mutable_appearance(icon, dirt_state, layer = layer + 0.1)
	dirt.color = null
	dirt.appearance_flags |= RESET_COLOR
	. += dirt

/obj/structure/flowerpot/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == "color" || var_name == NAMEOF(src, color))
		pot_color = var_value
		update_appearance()
		return TRUE

/obj/structure/flowerpot/update_appearance(updates)
	. = ..()
	update_overlays()

/obj/structure/flowerpot/medium
	icon_state = "pot_medium"

/obj/structure/flowerpot/small
	icon_state = "pot_small"

/obj/structure/flowerpot/bong
	icon_state = "pot_bong"
