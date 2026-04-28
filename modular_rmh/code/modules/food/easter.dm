// PAINTING EGGS

/obj/item/oviposition_egg
	var/custom_painted_icon = null
	var/custom_painted_icon_state = null
	var/custom_painted_color = null

/obj/item/oviposition_egg/proc/apply_paint_override()
	if(custom_painted_icon)
		icon = custom_painted_icon
	if(custom_painted_icon_state)
		icon_state = custom_painted_icon_state
	if(custom_painted_color)
		color = custom_painted_color

/obj/item/oviposition_egg/update_appearance(updates)
	. = ..()
	apply_paint_override()

/obj/item/paint_brush/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()

	if(!proximity_flag)
		return

	if(istype(target, /obj/item/reagent_containers/food/snacks/chocolate/egg))
		if(paint_chocolate_egg(user, target))
			return

	if(istype(target, /obj/item/reagent_containers/food/snacks/chocolate/egg_large))
		if(paint_chocolate_egg_large(user, target))
			return

	if(istype(target, /obj/item/reagent_containers/food/snacks/egg))
		if(paint_food_egg(user, target))
			return

	if(istype(target, /obj/item/oviposition_egg))
		if(paint_harpy_egg(user, target))
			return

/obj/item/paint_brush/proc/paint_food_egg(mob/living/user, obj/item/reagent_containers/food/snacks/egg/E)
	var/list/options = list(
		"Purple" = "egg-purple",
		"Blue" = "egg-blue",
		"Red" = "egg-red",
		"Orange" = "egg-orange",
		"Yellow" = "egg-yellow",
		"Green" = "egg-green",
		"Rainbow" = "egg-rainbow",
		"Chocolate" = "chocolateegg")

	var/choice = input(user, "Choose a painting pattern", "Egg Painting") as null|anything in options
	if(!choice)
		return TRUE

	E.icon = 'icons/obj/food/food.dmi'
	E.icon_state = options[choice]
	E.update_appearance()

	to_chat(user, span_notice("You paint [E] [lowertext(choice)]."))
	return TRUE

// HARPY / OVIPOSITION EGG PAINTING

/obj/item/paint_brush/proc/paint_harpy_egg(mob/living/user, obj/item/oviposition_egg/O)
	var/datum/oviposition_egg_profile/profile = O.get_egg_profile()
	if(!istype(profile, /datum/oviposition_egg_profile/harpy))
		return FALSE

	var/list/options = list(
		"Chocolate" = "egg_chocolate",
		"Yellow" = "egg_yellow",
		"Blue" = "egg_blue",
		"Orange" = "egg_orange",
		"Green" = "egg_green",
		"Purple" = "egg_purple",
		"Red" = "egg_red",
		"Rainbow" = "egg_rainbow",
		"Pink Shots" = "egg_pinkshots",
		"Synthetic" = "egg_synthetic",
		"Slime Glob" = "egg_slimeglob",
		"Polychrome" = "egg_polychrome")

	var/choice = input(user, "Choose a painting pattern", "Harpy Egg Painting") as null|anything in options
	if(!choice)
		return TRUE
	O.custom_painted_icon = 'modular_rmh/icons/obj/items/oviposition.dmi'
	O.custom_painted_icon_state = options[choice]
	O.custom_painted_color = null
	O.update_appearance()
	to_chat(user, span_notice("You carefully paint [O] [lowertext(choice)]."))
	return TRUE

// CHOCOLATE EGGS

#define CHOCO_EGG_STATES list(\
	"egg-purple", \
	"egg-blue", \
	"egg-red", \
	"egg-orange", \
	"egg-yellow", \
	"egg-green", \
	"egg-rainbow", \
	"chocolateegg" \
)

#define CHOCO_EGG_LARGE_STATES list(\
	"egg_chocolate", \
	"egg_yellow", \
	"egg_blue", \
	"egg_orange", \
	"egg_green", \
	"egg_purple", \
	"egg_red", \
	"egg_rainbow", \
	"egg_pinkshots", \
	"egg_synthetic", \
	"egg_slimeglob", \
	"egg_polychrome" \
)

/obj/item/reagent_containers/food/snacks/chocolate/egg
	name = "chocolate egg"
	desc = "A smooth, rich chocolate egg. A seasonal delicacy."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "chocolateegg"
	bitesize = 3
	nutrition = CHOCCY_NUTRITION
	w_class = WEIGHT_CLASS_TINY
	tastes = list("rich sweetness" = 1)

/obj/item/reagent_containers/food/snacks/chocolate/egg/random/Initialize()
	icon_state = pick(CHOCO_EGG_STATES)
	if(prob(10))
		list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/aphrodisiac = 5)
	. = ..()

/obj/item/reagent_containers/food/snacks/chocolate/egg/aphrodisiac/Initialize()
	icon_state = pick(CHOCO_EGG_STATES)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/aphrodisiac = 5)
	. = ..()

/obj/item/reagent_containers/food/snacks/chocolate/egg_large
	name = "large chocolate egg"
	desc = "A large, hollow chocolate egg. A seasonal delicacy."
	icon = 'modular_rmh/icons/obj/items/oviposition.dmi'
	icon_state = "egg_chocolate"
	bitesize = 6
	nutrition = CHOCCY_NUTRITION * 2
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("rich sweetness" = 2)

/obj/item/reagent_containers/food/snacks/chocolate/egg_large/random/Initialize()
	icon_state = pick(CHOCO_EGG_LARGE_STATES)
	if(prob(10))
		list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/aphrodisiac = 5)
	. = ..()

/obj/item/reagent_containers/food/snacks/chocolate/egg_large/aphrodisiac/Initialize()
	icon_state = pick(CHOCO_EGG_LARGE_STATES)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/aphrodisiac = 5)
	. = ..()

/obj/item/paint_brush/proc/paint_chocolate_egg(mob/living/user, obj/item/reagent_containers/food/snacks/chocolate/E)
	var/list/options = list(
		"Purple" = "egg-purple",
		"Blue" = "egg-blue",
		"Red" = "egg-red",
		"Orange" = "egg-orange",
		"Yellow" = "egg-yellow",
		"Green" = "egg-green",
		"Rainbow" = "egg-rainbow",
		"Chocolate" = "chocolateegg"
	)

	E.icon = 'icons/obj/food/food.dmi'

	var/choice = input(user, "Choose a chocolate egg design", "Chocolate Egg Painting") as null|anything in options
	if(!choice)
		return TRUE

	E.icon_state = options[choice]
	E.update_appearance()
	to_chat(user, span_notice("You decorate [E] with a custom chocolate pattern."))
	return TRUE

/obj/item/paint_brush/proc/paint_chocolate_egg_large(mob/living/user, obj/item/reagent_containers/food/snacks/chocolate/egg_large/E)
	var/list/options = list(
		"Chocolate" = "egg_chocolate",
		"Yellow" = "egg_yellow",
		"Blue" = "egg_blue",
		"Orange" = "egg_orange",
		"Green" = "egg_green",
		"Purple" = "egg_purple",
		"Red" = "egg_red",
		"Rainbow" = "egg_rainbow",
		"Pink Shots" = "egg_pinkshots",
		"Synthetic" = "egg_synthetic",
		"Slime Glob" = "egg_slimeglob",
		"Polychrome" = "egg_polychrome")

	var/choice = input(user, "Choose a chocolate egg design", "Chocolate Egg Painting") as null|anything in options
	if(!choice)
		return TRUE
	E.icon_state = options[choice]
	E.update_appearance()
	to_chat(user, span_notice("You decorate [E] with a custom chocolate pattern."))
	return TRUE

//CHOCOLATE BUNNY

/obj/item/reagent_containers/food/snacks/chocolate/bunny
	name = "chocolate bunny"
	desc = "A hollow chocolate bunny. A seasonal delicacy."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "chocolatebunny"
	bitesize = 6
	nutrition = CHOCCY_NUTRITION * 2
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("rich sweetness" = 2)

// EASTER BASKET

/obj/item/storage/handbasket/easter
	populate_contents = list(
		/obj/item/clothing/head/bunny,
		/obj/item/paint_brush,
		/obj/item/dildo/plug/bunny,
		/obj/item/reagent_containers/food/snacks/chocolate/bunny)
	component_type = /datum/component/storage/concrete/grid/handbasket/easter_special

/datum/component/storage/concrete/grid/handbasket/easter_special
	screen_max_rows = 5
	screen_max_columns = 5
