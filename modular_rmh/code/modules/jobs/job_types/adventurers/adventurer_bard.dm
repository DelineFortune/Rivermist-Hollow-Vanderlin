/datum/job/adventurer_bard
	title = "Adventurer Bard"
	tutorial = "Bards know music is more than idle fancy - it is power. Through study and adventure, these travelling troubadours master song, speech, and the magic within."
	department_flag = ADVENTURERS
	faction = FACTION_NEUTRAL
	total_positions = 20
	spawn_positions = 20
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_ADVENTURER_BARD

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = ALL_RACES_LIST
	advclass_cat_rolls = list(CAT_ADVENTURER_BARD = 50)

	selection_color = JCOLOR_ADVENTURERS

	give_bank_account = TRUE
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_BARD, EXP_TYPE_MAGICK)

	magic_user = TRUE
	spell_points = 25
	attunements_max = 10
	attunements_min = 5

	job_subclasses = list(
		/datum/job/advclass/combat/adventurer_bard/college_lore,
		/datum/job/advclass/combat/adventurer_bard/college_swords,
	)

/datum/job/adventurer_bard/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	to_chat(spawned, "<br><font color='#855b14'><span class='bold'>If I wanted to make amnas by selling my services, or completing quests, the Adventurers Guild would be a good place to start.</span></font><br>")

