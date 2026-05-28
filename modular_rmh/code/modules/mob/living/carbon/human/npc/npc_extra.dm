/mob/living
	var/threshold_brute = 3000
	var/threshold_burn = 3000
	var/threshold_tox = 3000
	var/threshold_oxy = 3000

	var/chance_escape = 0


/mob/living/Life()
	npc_damage_threshold()
	. = ..()

/mob/living/proc/npc_damage_threshold()

	if(client)
		return

	if(stat == DEAD)
		return
	if(status_flags & GODMODE)
		return

	var/brute = getBruteLoss() * 0.5
	var/burn  = getFireLoss() * 0.5
	var/tox   = getToxLoss()
	var/oxy   = getOxyLoss()
	var/total_damage = brute + burn + tox + oxy
	var/total_threshold = max(threshold_brute, threshold_burn, threshold_tox, threshold_oxy)

	var/passed_damage_threshold = (total_damage >= total_threshold) || \
		(brute >= threshold_brute) || \
		(burn  >= threshold_burn)  || \
		(tox   >= threshold_tox)   || \
		(oxy   >= threshold_oxy)

	if(!passed_damage_threshold)
		return

	var/can_escape = chance_escape && legcuffed == null && handcuffed == null && buckled == null && !pulledby
	if(can_escape && prob(chance_escape))
		visible_message("<span class='warning'>[src] escapes!</span>")
		do_smoke(1, get_turf(src), /obj/effect/particle_effect/smoke)
		qdel(src)
		return

	visible_message("<span class='danger'>[src] dies!</span>")
	if(total_damage < 200)
		adjustOxyLoss(200 - total_damage)
	death(FALSE)
	return
