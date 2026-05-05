/datum/wound/artery
	name = "severed artery"
	check_name = "<span class='artery'><B>ARTERY</B></span>"
	severity = WOUND_SEVERITY_CRITICAL
	crit_message = "Blood sprays from %VICTIM's %BODYPART!"
	sound_effect = 'sound/combat/crit.ogg'
	whp = 50
	sewn_whp = 20
	bleed_rate = ARTERY_LIMB_BLEEDRATE
	sewn_bleed_rate = 0.2
	clotting_threshold = null
	sewn_clotting_threshold = null
	woundpain = 35
	sewn_woundpain = 20
	mob_overlay = "s1"
	sewn_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	critical = TRUE
	sleep_healing = 0
	embed_chance = 0
	werewolf_infection_probability = 0
	associated_bclasses = ARTERY_BCLASSES
	min_damage = 5
	min_damage_dividend = 0
	strong_intent_bonus = TRUE
	aimed_intent_bonus = TRUE
	var/artery_type_override

/datum/wound/artery/get_crit_prob(bclass, dam, damage_dividend, mob/living/user, obj/item/bodypart/affected, zone_precise, list/modifiers)
	if(affected.limb_flags & BODYPART_BONE_ENCASED && !affected.has_wound(/datum/wound/fracture))
		return 0
	return ..()

/datum/wound/artery/can_apply_to_bodypart(obj/item/bodypart/affected)
	. = ..()
	if(affected.status == BODYPART_ROBOTIC)
		return FALSE
	if(!affected.get_incision())
		return FALSE
	if(affected.limb_flags & BODYPART_BONE_ENCASED && !affected.has_wound(/datum/wound/fracture))
		return FALSE

/datum/wound/artery/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/artery) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/artery/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("paincrit", TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/artery/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	affected.temporary_crit_paralysis(10 SECONDS)

/datum/wound/artery/apply_to_bodypart(obj/item/bodypart/affected, silent, crit_message)
	. = ..()
	if(!.)
		return
	var/obj/item/organ/artery/artery
	for(var/obj/item/organ/possible_artery in shuffle(affected.getorganslotlist(ORGAN_SLOT_ARTERY)))
		if(!possible_artery)
			continue
		if(possible_artery.damage >= possible_artery.maxHealth)
			continue
		if(artery_type_override && !istype(possible_artery, artery_type_override))
			continue
		artery = possible_artery
		break
	var/dissection = (severity >= WOUND_SEVERITY_CRITICAL) || (artery?.damage >= (artery.maxHealth * 0.5))
	if(artery)
		if(dissection)
			artery.dissect()
		else
			artery.tear()
	qdel(src)

/datum/wound/artery/neck
	name = "torn carotid"
	check_name = "<span class='artery'><B>CAROTID</B></span>"
	crit_message = "Blood sprays from %VICTIM's throat!"
	severity = WOUND_SEVERITY_FATAL
	whp = 100
	sewn_whp = 25
	bleed_rate = 60
	sewn_bleed_rate = 0.5
	woundpain = 45
	sewn_woundpain = 20
	mob_overlay = "s1_throat"
	mortal = TRUE
	artery_type_override = /obj/item/organ/artery/neck
	can_roll = FALSE //snowflake used for neck slit

/datum/wound/artery/chest
	name = "aortic dissection"
	check_name = "<span class='artery'><B>AORTA</B></span>"
	crit_message = "A tide of blood gushes from %VICTIM's chest!"
	severity = WOUND_SEVERITY_FATAL
	whp = 100
	sewn_whp = 35
	bleed_rate = 60
	sewn_bleed_rate = 0.8
	woundpain = 80
	sewn_woundpain = 50
	mortal = TRUE
	artery_type_override = /obj/item/organ/artery/chest
	associated_bclasses = ARTERY_HEART_BCLASSES
	viable_zones = list(BODY_ZONE_CHEST)

/datum/wound/artery/dissect
	severity = WOUND_SEVERITY_CRITICAL

/datum/wound/artery/dissect/neck
	artery_type_override = /obj/item/organ/artery/neck
	can_roll = FALSE //snowflake used for neck slit

/datum/wound/artery/reattachment
	name = "replantation"
	check_name = "<span class='artery'><B>UNSEWN</B></span>"
	severity = WOUND_SEVERITY_FATAL
	whp = 100
	sewn_whp = 25
	bleed_rate = 50
	sewn_bleed_rate = 0.5
	woundpain = 60
	sewn_woundpain = 30
	disabling = TRUE
