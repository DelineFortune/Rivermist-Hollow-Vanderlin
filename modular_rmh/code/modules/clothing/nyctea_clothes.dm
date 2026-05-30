/obj/item/clothing/armor/leather/advanced/foreign_habit
	name = "foreign holy dress"
	desc = "An odd-looking foreign dress made with unknown technique, quite revealing and yet durable at the same time."
	icon = 'modular_rmh/icons/clothing/nyctea.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/onmob/nyctea_onmob.dmi'
	icon_state = "dress"
	item_state = "dress"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	ignore_sleeves_code = TRUE
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/legwears/foreign_habit_stockings
	name = "foreign holy stockings"
	desc = "Odd-looking foreign stockings made with unknown technique, form-fitting and light."
	icon = 'modular_rmh/icons/clothing/nyctea.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/onmob/nyctea_onmob.dmi'
	icon_state = "stockings"
	item_state = "stockings"
	misc_flags = CRAFTING_TEST_EXCLUDE
	damaged_icon = 'modular_rmh/icons/clothing/nyctea.dmi'
	damaged_overlay_icon = 'modular_rmh/icons/clothing/onmob/nyctea_onmob.dmi'

/obj/item/clothing/head/helmet/leather/advanced/jester/foreign_habit_jester
	name = "foreign holy hat"
	desc = "What seems like a regular jester's hat at the first sight, this unconventional and odd headwear also provides good protection for what's the most important - your wit."
	icon = 'modular_rmh/icons/clothing/nyctea.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/onmob/nyctea_onmob.dmi'
	icon_state = "hat"
	item_state = "hat"
	sewrepair = TRUE
	armor = ARMOR_HEAD_LEATHER
	salvage_result = /obj/item/natural/hide/cured
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/helmet/leather/advanced/jester/foreign_habit_jester/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = list(SFX_JINGLE_BELLS), move_delay_override = 2, falloff_exponent = 20)

/obj/item/clothing/shoes/boots/foreign_habit_boots
	name = "foreign holy boots"
	desc = "Odd-ooking boots made with foreign techniques, they are light yet durable."
	icon = 'modular_rmh/icons/clothing/nyctea.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/onmob/nyctea_onmob.dmi'
	icon_state = "boots"
	item_state = "boots"
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/gloves/leather/advanced/foreign_habit_gloves
	name = "foreign holy gloves"
	desc = "Odd-looking gloves made with foreign techniques, they are light yet warm"
	icon = 'modular_rmh/icons/clothing/nyctea.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/onmob/nyctea_onmob.dmi'
	icon_state = "gloves"
	item_state = "gloves"
	misc_flags = CRAFTING_TEST_EXCLUDE
