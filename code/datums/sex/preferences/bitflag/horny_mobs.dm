/datum/erp_preference/bitflag/horny_mobs //placeholder
	name = "Horny AI Preferences"
	description = "Choose whether male and/or female horny mobs may target you."
	category = "Mobs"
	flags = list(
		"Allow Males" = HORNY_MOBS_TAG_MALES,
		"Allow Females" = HORNY_MOBS_TAG_FEMALES,
	)
	flag_descriptions = list(
		"Allow Males" = "Male mobs will try to couple with you.",
		"Allow Females" = "Female mobs will try to couple with you.",
		)
