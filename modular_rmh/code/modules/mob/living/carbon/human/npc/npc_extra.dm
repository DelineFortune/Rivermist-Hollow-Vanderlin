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

	if(brute >= threshold_brute || \
	burn  >= threshold_burn  || \
	tox   >= threshold_tox   || \
	oxy   >= threshold_oxy)


		if(prob(chance_escape && legcuffed == null && handcuffed == null && buckled == null && !pulledby))
			visible_message("<span class='warning'>[src] escapes!</span>")
			do_smoke(1, get_turf(src), /obj/effect/particle_effect/smoke)
			qdel(src)
			return
		else
			visible_message("<span class='danger'>[src] dies!</span>")
			var/total_damage = brute + burn + tox + oxy
			if(total_damage < 200)
				adjustOxyLoss(200 - total_damage)
			death(FALSE)
			return
	return
