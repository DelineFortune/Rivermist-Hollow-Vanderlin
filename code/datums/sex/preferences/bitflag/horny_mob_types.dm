/datum/erp_preference/bitflag/horny_mob_types
	name = "Horny Mob Types"
	description = "Choose which horny mob families may target you when Horny AI is enabled."
	category = "Mobs"
	default_value = HORNY_MOB_TYPE_ALL
	flags = list(
		"Humanoids" = HORNY_MOB_TYPE_HUMANOIDS,
		"Spiders" = HORNY_MOB_TYPE_SPIDERS,
		"Bog Bugs" = HORNY_MOB_TYPE_BOG_BUGS,
		"Trolls" = HORNY_MOB_TYPE_TROLLS,
		"Wild beasts" = HORNY_MOB_TYPE_BEASTS,
		"Lamias" = HORNY_MOB_TYPE_LAMIAS,
		"Minotaurs" = HORNY_MOB_TYPE_MINOTAURS,
		"Lycans" = HORNY_MOB_TYPE_LYCANS,
		"Lizards" = HORNY_MOB_TYPE_LIZARDS,
		"Undead" = HORNY_MOB_TYPE_UNDEAD,
	)
	flag_descriptions = list(
		"Humanoids" = "Humanlike horny NPCs such as orcs, goblins, bums, and other humanoid hostiles may target you.",
		"Spiders" = "Horny spiders and mire spiders may target you.",
		"Bog Bugs" = "Horny bog bugs may target you.",
		"Trolls" = "Horny trolls and bog trolls may target you.",
		"Wild beasts" = "Horny wolf-family beasts that share the wolf AI may target you.",
		"Lamias" = "Horny lamias may target you.",
		"Minotaurs" = "Horny minotaurs may target you.",
		"Lycans" = "Horny lycans may target you.",
		"Lizards" = "Horny lizards like gators may target you.",
		"Undead" = "Horny undead may target you.",
	)
