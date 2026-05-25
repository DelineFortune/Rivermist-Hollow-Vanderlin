/datum/quirk/vice/lovefiend
	name = "Nymphomaniac"
	desc = "I must make love!"
	time = 40 MINUTES
	needsate_text = "I'm so horny..."
	sated_text = "That's much better..."
	point_value = 3
	debuff = /datum/status_effect/debuff/addiction/lovefiend

/datum/quirk/vice/sadist
	name = "Sadist"
	desc = "There is no greater pleasure than the suffering of another."
	time = 2 HOURS
	needsate_text = "I need to hear someone whimper."
	sated_text = "That's much better..."
	point_value = 3
	debuff = /datum/status_effect/debuff/addiction/sadist

/datum/status_effect/debuff/addiction/sadist //yes it's intended
/datum/status_effect/debuff/addiction/lovefiend
