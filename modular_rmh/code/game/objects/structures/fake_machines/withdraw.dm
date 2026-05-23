// ==================== STOCKPILE WITHDRAW ONLY ====================

/obj/structure/fake_machine/stockpile_withdraw
	name = "stockpile extractor"
	desc = "Terminal for withdrawing items from the town stockpile."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "submit"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32

	var/stockpile_index = 1
	var/datum/withdraw_tab/withdraw_tab = null

/obj/structure/fake_machine/stockpile_withdraw/Initialize(mapload)
	. = ..()
	SSroguemachine.stock_machines += src
	withdraw_tab = new(stockpile_index, src)

/obj/structure/fake_machine/stockpile_withdraw/Destroy()
	SSroguemachine.stock_machines -= src
	QDEL_NULL(withdraw_tab)
	return ..()

/obj/structure/fake_machine/stockpile_withdraw/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/coin))
		withdraw_tab.insert_coins(P)
		return attack_hand(user)

	playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
	say("TAKING ONLY YOUR COINS! NOT YOUR TRASH!")
	return

/obj/structure/fake_machine/stockpile_withdraw/Topic(href, href_list)
	. = ..()
	if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
		return

	if(withdraw_tab.perform_action(href, href_list))
		if(href_list["withdraw"])
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			flick("submit_anim", src)
		return attack_hand(usr)
	return attack_hand(usr)

/obj/structure/fake_machine/stockpile_withdraw/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return

	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)

	var/contents = withdraw_tab.get_contents("STOCKPILE EXTRACTOR", FALSE)

	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 800)
	popup.set_content(contents)
	popup.open()
