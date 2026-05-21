/datum/action/cooldown/spell/projectile/fireball
	name = "Fireball"
	desc = "Shoot out a ball of fire that emits a light explosion on impact, setting the target alight."
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
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 10 SECONDS
	spell_cost = 40
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/aoe/fireball/rogue

	var/tmp/dnd_fireball_cast_level = 0

/datum/action/cooldown/spell/projectile/fireball/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		if(feedback)
			owner.balloon_alert(owner, "Only humans can use spell slots!")
		return FALSE

	var/level = H.get_selected_dnd_spell_slot_level()

	if(!H.can_spend_dnd_spell_slot(level, feedback))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/projectile/fireball/before_cast(atom/cast_on)
	dnd_fireball_cast_level = 0

	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return . | SPELL_CANCEL_CAST

	var/level = H.get_selected_dnd_spell_slot_level()

	if(!H.can_spend_dnd_spell_slot(level, TRUE))
		return . | SPELL_CANCEL_CAST

	if(!H.spend_dnd_spell_slot(level))
		to_chat(H, span_warning("My level [level] spell slot fizzles before the fire takes shape."))
		return . | SPELL_CANCEL_CAST

	dnd_fireball_cast_level = level

	var/current = H.get_dnd_spell_slots_current(level)
	var/maximum = H.get_dnd_spell_slots_max(level)

	to_chat(H, span_notice("I cast Fireball using a level [level] spell slot. Charges left: [current]/[maximum]."))
	H.balloon_alert(H, "Fireball level [level]")

	return .

/datum/action/cooldown/spell/projectile/fireball/proc/apply_dnd_fireball_level(obj/projectile/magic/aoe/fireball/to_fire, mob/user)
	if(!to_fire)
		return 1

	var/level = dnd_fireball_cast_level
	if(!isnum(level) || level <= 0)
		level = 1

	level = clamp(round(level), 1, 5)

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

/datum/action/cooldown/spell/projectile/fireball/ready_projectile(obj/projectile/magic/aoe/fireball/to_fire, atom/target, mob/user, iteration)
	. = ..()

	var/level = apply_dnd_fireball_level(to_fire, user)

	to_fire.damage *= attuned_strength
	to_fire.exp_light *= attuned_strength
	to_fire.exp_fire *= attuned_strength

	if(user)
		to_chat(user, span_notice("The Fireball forms at spell level [level]."))

/datum/action/cooldown/spell/projectile/fireball/after_cast(atom/cast_on)
	. = ..()
	dnd_fireball_cast_level = 0

/datum/action/cooldown/spell/projectile/fireball/baali
	name = "Infernal Fireball"

	associated_skill = /datum/attribute/skill/magic/blood

	spell_type = SPELL_BLOOD

	charge_time = 4 SECONDS
	spell_cost = 150
	cooldown_time = 80 SECONDS

/datum/action/cooldown/spell/projectile/fireball/greater
	name = "Fireball (Greater)"
	desc = "Shoot out an immense ball of fire that explodes on impact."
	button_icon_state = "fireball_greater"

	point_cost = 6
	attunements = list(
		/datum/attunement/fire = 1.1,
	)

	charge_time = 4 SECONDS
	charge_drain = 2
	charge_slowdown = 1.3
	cooldown_time = 70 SECONDS
	spell_cost = 80
	spell_flags = NONE

	projectile_type = /obj/projectile/magic/aoe/fireball/rogue/great

/obj/projectile/magic/aoe/fireball/rogue
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

/obj/projectile/magic/aoe/fireball/rogue/great
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
