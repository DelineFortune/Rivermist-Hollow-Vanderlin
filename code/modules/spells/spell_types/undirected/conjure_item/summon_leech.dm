/datum/action/cooldown/spell/undirected/conjure_item/summon_leech
	name = "Summon Leech"
	desc = "Summon a leech from the wetlands."
	button_icon_state = "curse2"
	sound = 'sound/foley/jumpland/waterland.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy

	invocation = "Come to my aid, pitiful worm!"
	invocation_type = INVOCATION_WHISPER

	cooldown_time = 1 MINUTES
	spell_cost = 30

	delete_old = FALSE
	item_type = /obj/item/natural/worms/leech/wild
	item_duration = 0

/datum/action/cooldown/spell/undirected/conjure_item/summon_leech/make_item()
	var/obj/item/natural/worms/leech/made_item = spawn_wild_leech(null)
	LAZYADD(item_refs, WEAKREF(made_item))
	return made_item

/datum/action/cooldown/spell/undirected/conjure_item/summon_leech/pestra
	name = "Healing Leech"
	desc = "Summon a Healing leech."
	button_icon_state = "diagnose"

	invocation = "Grant me a creature to cleanse the blood!"
	invocation_type = INVOCATION_WHISPER
