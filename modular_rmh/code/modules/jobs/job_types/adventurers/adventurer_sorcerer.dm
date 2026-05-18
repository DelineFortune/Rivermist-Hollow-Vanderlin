/datum/job/adventurer_sorcerer
	title = "Adventurer Sorcerer"
	f_title = "Adventurer Sorceress"
	tutorial = "Sorcerers are natural spellcasters, drawing on inherent magic from a gift or bloodline."
	department_flag = ADVENTURERS
	faction = FACTION_NEUTRAL
	total_positions = 20
	spawn_positions = 20
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_ADVENTURER_SORCERER

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = ALL_RACES_LIST
	advclass_cat_rolls = list(CAT_ADVENTURER_SORCERER = 50)

	selection_color = JCOLOR_ADVENTURERS

	give_bank_account = TRUE
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)

	magic_user = TRUE
	spell_points = 30
	attunements_max = 15
	attunements_min = 5

	job_subclasses = list(
		/datum/job/advclass/combat/adventurer_sorcerer/desert_sorceress,
		/datum/job/advclass/combat/adventurer_sorcerer/wild_magic,
	)

/datum/job/adventurer_sorcerer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	to_chat(spawned, "<br><font color='#855b14'><span class='bold'>If I wanted to make amnas by selling my services, or completing quests, the Adventurers Guild would be a good place to start.</span></font><br>")

