// Debug grant verbs for the DND spell pack.
// These names are intentionally different from existing debug_grant_dnd_fireball() verbs.

/mob/living/carbon/human/verb/debug_grant_dnd_spell_pack()
	set name = "Grant DND Spell Pack"
	set category = "Debug"

	setup_default_dnd_spell_slots()
	grant_dnd_spell_hud()

	var/list/spells_to_grant = list(
		/datum/action/cooldown/spell/projectile/dnd_fireball,
		/datum/action/cooldown/spell/projectile/dnd_fireball/greater,
		/datum/action/cooldown/spell/projectile/acid_splash/dnd,
		/datum/action/cooldown/spell/projectile/frost_bolt/dnd,
		/datum/action/cooldown/spell/projectile/lightning/dnd,
		/datum/action/cooldown/spell/healing/dnd,
		/datum/action/cooldown/spell/sacred_flame/dnd,
		/datum/action/cooldown/spell/mind_spike/dnd,
	)

	for(var/spell_type in spells_to_grant)
		var/datum/action/cooldown/spell/S = new spell_type
		S.Grant(src)

	to_chat(src, span_notice("DND spell pack granted."))

/mob/living/carbon/human/verb/debug_grant_dnd_fireball_v2()
	set name = "Grant DND Fireball V2"
	set category = "Debug"

	setup_default_dnd_spell_slots()
	grant_dnd_spell_hud()

	var/datum/action/cooldown/spell/projectile/dnd_fireball/F = new
	F.Grant(src)

	to_chat(src, span_notice("DND Fireball granted."))
