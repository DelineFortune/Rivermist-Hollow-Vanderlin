/datum/job/adventurer_rogue
	title = "Adventurer Rogue"
	tutorial = "With stealth, skill, and uncanny reflexes, rogues' versatility lets them get the upper hand in almost any situation."
	department_flag = ADVENTURERS
	faction = FACTION_NEUTRAL
	total_positions = 20
	spawn_positions = 20
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_ADVENTURER_ROGUE

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = ALL_RACES_LIST
	advclass_cat_rolls = list(CAT_ADVENTURER_ROGUE = 50)

	selection_color = JCOLOR_ADVENTURERS

	give_bank_account = TRUE
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT)

	job_subclasses = list(
		/datum/job/advclass/combat/adventurer_rogue/antiquarian,
		/datum/job/advclass/combat/adventurer_rogue/assassin,
		/datum/job/advclass/combat/adventurer_rogue/bloodsucker,
		/datum/job/advclass/combat/adventurer_rogue/calishite_assasin,
		/datum/job/advclass/combat/adventurer_rogue/corsair,
		/datum/job/advclass/combat/adventurer_rogue/duelist,
		/datum/job/advclass/combat/adventurer_rogue/porter,
		/datum/job/advclass/combat/adventurer_rogue/pyromaniac,
		/datum/job/advclass/combat/adventurer_rogue/renegade,
		/datum/job/advclass/combat/adventurer_rogue/royal_outcast,
		/datum/job/advclass/combat/adventurer_rogue/shadowblade,
		/datum/job/advclass/combat/adventurer_rogue/swashbuckler,
		/datum/job/advclass/combat/adventurer_rogue/thief,
		/datum/job/advclass/combat/adventurer_rogue/treasurehunter,
	)

/datum/job/adventurer_rogue/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	to_chat(spawned, "<br><font color='#855b14'><span class='bold'>If I wanted to make amnas by selling my services, or completing quests, the Adventurers Guild would be a good place to start.</span></font><br>")

