// Separate DND Fireball spell.
// Uses /datum/action/cooldown/spell/projectile/dnd_fireball so the normal fireball stays untouched.

/datum/action/cooldown/spell/projectile/dnd_fireball
	name = "DND Fireball"
	desc = "Shoot out a ball of fire that scales with the selected DND spell slot."
	button_icon_state = "fireball"
	charge_sound = 'sound/magic/charging_fire.ogg'
	sound = 'sound/magic/fireball.ogg'

	cast_range = 8
	point_cost = 4
	attunements = list(
		/datum/attunement/fire = 0.5
	)

	invocation = "ONI SOMA!!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2.5 SECONDS
	charge_drain = 0
	charge_slowdown = 0.7
	cooldown_time = 10 SECONDS
	spell_cost = 0
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/aoe/fireball/dnd

	dnd_use_spell_slots = TRUE
	dnd_min_spell_slot_level = 1
	dnd_max_spell_slot_level = 5
	dnd_spell_slot_label = "Fireball"

/datum/action/cooldown/spell/projectile/dnd_fireball/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE

	return dnd_spell_slot_can_cast(feedback)

/datum/action/cooldown/spell/projectile/dnd_fireball/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/dnd_result = dnd_spell_slot_before_cast(cast_on)
	if(dnd_result & SPELL_CANCEL_CAST)
		return . | SPELL_CANCEL_CAST

	return .

/datum/action/cooldown/spell/projectile/dnd_fireball/proc/apply_dnd_fireball_level(obj/projectile/magic/aoe/fireball/to_fire)
	if(!to_fire)
		return dnd_get_cast_level()

	var/level = dnd_get_cast_level()

	switch(level)
		if(1)
			to_fire.damage = 35
			to_fire.exp_light = 2
			to_fire.exp_fire = 1
			to_fire.exp_heavy = 0
			to_fire.speed = 3

		if(2)
			to_fire.damage = 45
			to_fire.exp_light = 3
			to_fire.exp_fire = 2
			to_fire.exp_heavy = 0
			to_fire.speed = 3

		if(3)
			to_fire.damage = 60
			to_fire.exp_light = 3
			to_fire.exp_fire = 3
			to_fire.exp_heavy = 0
			to_fire.speed = 3

		if(4)
			to_fire.damage = 80
			to_fire.exp_light = 4
			to_fire.exp_fire = 3
			to_fire.exp_heavy = 0
			to_fire.speed = 4

		if(5)
			to_fire.damage = 110
			to_fire.exp_light = 5
			to_fire.exp_fire = 4
			to_fire.exp_heavy = 1
			to_fire.speed = 5

	return level

/datum/action/cooldown/spell/projectile/dnd_fireball/ready_projectile(obj/projectile/magic/aoe/fireball/to_fire, atom/target, mob/user, iteration)
	. = ..()

	var/level = apply_dnd_fireball_level(to_fire)

	to_fire.damage *= attuned_strength
	to_fire.exp_light *= attuned_strength
	to_fire.exp_fire *= attuned_strength

	if(user)
		to_chat(user, span_notice("The Fireball forms at spell level [level]."))

/datum/action/cooldown/spell/projectile/dnd_fireball/after_cast(atom/cast_on)
	. = ..()
	dnd_spell_slot_after_cast()

/datum/action/cooldown/spell/projectile/dnd_fireball/greater
	name = "DND Fireball (Greater)"
	desc = "Shoot out an immense ball of fire that scales with the selected DND spell slot."
	button_icon_state = "fireball_greater"

	point_cost = 6
	attunements = list(
		/datum/attunement/fire = 1.1,
	)

	charge_time = 4 SECONDS
	charge_drain = 0
	charge_slowdown = 1.3
	cooldown_time = 70 SECONDS
	spell_cost = 0
	spell_flags = NONE

	projectile_type = /obj/projectile/magic/aoe/fireball/dnd/great
	dnd_min_spell_slot_level = 3
	dnd_spell_slot_label = "Greater Fireball"

/obj/projectile/magic/aoe/fireball/dnd
	name = "fireball"
	exp_heavy = 0
	exp_light = 2
	exp_flash = 0
	exp_fire = 1
	damage = 35
	damage_type = BURN
	nodamage = FALSE
	flag = "magic"
	hitsound = 'sound/fireball.ogg'
	aoe_range = 0
	speed = 3

/obj/projectile/magic/aoe/fireball/dnd/great
	name = "fireball"
	exp_devi = 0
	exp_heavy = 1
	exp_light = 5
	exp_flash = 0
	exp_fire = 4
	damage = 130
	exp_hotspot = 0
	aoe_range = 0
	speed = 6

/datum/action/cooldown/spell/projectile/dnd_fireball/greater/apply_dnd_fireball_level(obj/projectile/magic/aoe/fireball/to_fire)
	if(!to_fire)
		return dnd_get_cast_level()

	var/level = dnd_get_cast_level()

	switch(level)
		if(3)
			to_fire.damage = 130
			to_fire.exp_light = 5
			to_fire.exp_fire = 4
			to_fire.exp_heavy = 1
			to_fire.speed = 6

		if(4)
			to_fire.damage = 160
			to_fire.exp_light = 6
			to_fire.exp_fire = 5
			to_fire.exp_heavy = 1
			to_fire.speed = 6

		if(5)
			to_fire.damage = 200
			to_fire.exp_light = 7
			to_fire.exp_fire = 6
			to_fire.exp_heavy = 2
			to_fire.speed = 7

	return level
