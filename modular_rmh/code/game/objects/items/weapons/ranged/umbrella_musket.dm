/obj/item/gun/ballistic/revolver/grenadelauncher/pistol/musket/umbrella
	name = "umbrella musket"
	desc = "An inconspicuous high-class umbrella at the first sight, it's unusual handle betrays it's true nature as an actual combat musket. It's quite unwieldy due to it's shape and general form."
	icon = 'modular_rmh/icons/obj/items/weapons/ranged/musket.dmi'
	icon_state = "umbrella_icon_closed"
	item_state = "umbrella_closed"
	lefthand_file = 'modular_rmh/icons/obj/items/weapons/ranged/musket_lefthand.dmi'
	righthand_file = 'modular_rmh/icons/obj/items/weapons/ranged/musket_righthand.dmi'
	experimental_inhand = FALSE
	slot_flags = 0
	var/umbrella_state = FALSE
	alternate_worn_layer = BODY_FRONT_LAYER
	possible_item_intents = list(/datum/intent/dagger/thrust/stiletto, INTENT_GENERIC)
	force = DAMAGE_DAGGER
	wdefense = AVERAGE_PARRY
	wbalance = HARD_TO_DODGE
	max_blade_int = 400

/obj/item/gun/ballistic/revolver/grenadelauncher/pistol/musket/umbrella/MiddleClick()
	toggle_state()

/obj/item/gun/ballistic/revolver/grenadelauncher/pistol/musket/umbrella/proc/toggle_state()
	umbrella_state = !umbrella_state
	update_appearance(UPDATE_ICON_STATE)

/obj/item/gun/ballistic/revolver/grenadelauncher/pistol/musket/umbrella/update_icon_state()
	. = ..()
	if(umbrella_state)
		icon_state = "umbrella_icon_open"
		item_state = "umbrella_open"
	else
		icon_state = "umbrella_icon_closed"
		item_state = "umbrella_closed"

