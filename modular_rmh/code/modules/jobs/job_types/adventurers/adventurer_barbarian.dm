GLOBAL_VAR_INIT(adventurer_hugbox_duration, 30 SECONDS)
GLOBAL_VAR_INIT(adventurer_hugbox_duration_still, 3 MINUTES)

/datum/job/adventurer_barbarian
	title = "Adventurer Barbarian"
	tutorial = "The strong embrace the wild that hides inside - keen instincts, primal physicality, and most of all, an unbridled, unquenchable rage."
	department_flag = ADVENTURERS
	faction = FACTION_NEUTRAL
	total_positions = 20
	spawn_positions = 20
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_ADVENTURER_BARBARIAN

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = ALL_RACES_LIST
	advclass_cat_rolls = list(CAT_ADVENTURER_BARBARIAN = 50)

	selection_color = JCOLOR_ADVENTURERS

	give_bank_account = TRUE

	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT)

	job_subclasses = list(
		/datum/job/advclass/combat/adventurer_barbarian/wild_magic,
		/datum/job/advclass/combat/adventurer_barbarian/berserker,
		/datum/job/advclass/combat/adventurer_barbarian/exiled,
		/datum/job/advclass/combat/adventurer_barbarian/giant,
		/datum/job/advclass/combat/adventurer_barbarian/rat_wildman,
		/datum/job/advclass/combat/adventurer_barbarian/seaelf_reaver,
		/datum/job/advclass/combat/adventurer_barbarian/spearmaiden,
	)

/datum/job/adventurer_barbarian/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	to_chat(spawned, "<br><font color='#855b14'><span class='bold'>If I wanted to make amnas by selling my services, or completing quests, the Adventurers Guild would be a good place to start.</span></font><br>")

