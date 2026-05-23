/datum/anvil_recipe/repair_kits
	appro_skill = /datum/skill/craft/blacksmithing
	i_type = "Repair kits"
	abstract_type = /datum/anvil_recipe/repair_kits
	category = "Repair kits"

/datum/anvil_recipe/repair_kits/poor_armorkit
	name = "Poor armor repair kit"
	recipe_name = "a poor armor repair kit"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/rope/chain, /obj/item/ingot/iron)
	created_item = /obj/item/repair_kit/poor_armorkit
	craftdiff = 2

/datum/anvil_recipe/repair_kits/armorkit
	name = "Armor repair kit"
	recipe_name = "a armor repair kit"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/rope/chain, /obj/item/ingot/steel)
	created_item = /obj/item/repair_kit
	craftdiff = 4
