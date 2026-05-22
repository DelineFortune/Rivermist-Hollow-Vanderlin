
/obj/structure/flora/shroom_tree/happy
	name = "underdark mushroom"
	icon_state = "happymush1"
	icon = 'modular_rmh/icons/obj/structures/foliagetall.dmi'
	desc = "Mushrooms might be the happiest beings in this god forsaken place."

/obj/structure/flora/shroom_tree/happy/mushroom2
	icon_state = "happymush2"

/obj/structure/flora/shroom_tree/happy/mushroom3
	icon_state = "happymush3"

/obj/structure/flora/shroom_tree/happy/mushroom4
	icon_state = "happymush4"

/obj/structure/flora/shroom_tree/happy/mushroom5
	icon_state = "happymush5"

/obj/structure/flora/shroom_tree/happy/random

/obj/structure/flora/shroom_tree/happy/random/Initialize()
	. = ..()
	icon_state = "happymush[rand(1,5)]"

/obj/structure/flora/shroom_tree/happy/New(loc)
	..()
	set_light(3, 3, 3, l_color ="#5D3FD3")

/obj/structure/flora/new_shroom
	name = "shroom"
	desc = "A ginormous mushroom, prized by dwarves for their shroomwood."
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	icon_state = "red"
	base_icon_state = "red"
	density = FALSE
	max_integrity = 120
	blade_dulling = DULLING_CUT
	SET_BASE_PIXEL( 0, 0)
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/woodhit.ogg'
	static_debris = list(/obj/item/grown/log/tree/small = 1)


/obj/structure/flora/new_shroom/purple
	name = "purple mushroom"
	base_icon_state = "purple"
	icon_state = "purple"
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	desc = "Mushrooms from Underdark."

/obj/structure/flora/new_shroom/purple/New(loc)
	..()
	set_light(3, 3, 3, l_color ="#6b3fd3")

/obj/structure/flora/new_shroom/purple/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/structure/flora/new_shroom/purplef
	name = "purple mushrooms"
	icon_state = "purplef"
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	desc = "Mushrooms from Underdark."

/obj/structure/flora/new_shroom/purplef/New(loc)
	..()
	set_light(3, 3, 3, l_color ="#6b3fd3")

/obj/structure/flora/new_shroom/purplef/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/structure/flora/new_shroom/purplesmall
	name = "small purple mushroom"
	icon_state = "purplesmall"
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	desc = "Mushrooms from Underdark."

/obj/structure/flora/new_shroom/purplesmall/New(loc)
	..()
	set_light(3, 3, 3, l_color ="#6b3fd3")

/obj/structure/flora/new_shroom/purplesmall/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/structure/flora/new_shroom/red
	name = "red mushroom"
	icon_state = "red"
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	desc = "Mushrooms from Underdark."

/obj/structure/flora/new_shroom/cyan
	name = "cyan mushroom"
	icon_state = "cyan"
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	desc = "Mushrooms from Underdark."

/obj/structure/flora/new_shroom/cyan/New(loc)
	..()
	set_light(3, 3, 3, l_color ="#2c92a0")

/obj/structure/flora/new_shroom/cyan/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/structure/flora/new_shroom/cyanf
	name = "cyan mushrooms"
	icon_state = "cyanf"
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	desc = "Mushrooms from Underdark."

/obj/structure/flora/new_shroom/cyanf/New(loc)
	..()
	set_light(3, 3, 3, l_color ="#2c92a0")

/obj/structure/flora/new_shroom/cyan/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/structure/flora/new_shroom/cyansmall
	name = "small cyan mushroom"
	icon_state = "cyansmallf"
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	desc = "Mushrooms from Underdark."

/obj/structure/flora/new_shroom/cyansmall/New(loc)
	..()
	set_light(3, 3, 3, l_color ="#2c92a0")

/obj/structure/flora/new_shroom/cyansmall/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/structure/flora/new_shroom/redwall
	name = "red mushroom"
	icon_state = "redwall"
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	desc = "Mushrooms from Underdark."
	SET_BASE_PIXEL( 0, 32)

/obj/structure/flora/new_shroom/redwall/New(loc)
	..()
	set_light(3, 3, 3, l_color ="#9c1f34")

/obj/structure/flora/new_shroom/redwall/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

//bushes
/obj/structure/flora/bush
	name = "bush"
	desc = ""
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"
	anchored = TRUE

/obj/structure/flora/bush/Initialize()
	icon_state = "snowbush[rand(1, 6)]"
	. = ..()

//Jungle grass

/obj/structure/flora/grass/jungle
	name = "jungle grass"
	desc = ""
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "grassa"


/obj/structure/flora/grass/jungle/Initialize()
	icon_state = "[icon_state][rand(1, 5)]"
	. = ..()

/obj/structure/flora/grass/jungle/b
	icon_state = "grassb"

//Jungle bushes

/obj/structure/flora/junglebush
	name = "bush"
	desc = ""
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "busha"

/obj/structure/flora/junglebush/Initialize()
	icon_state = "[icon_state][rand(1, 3)]"
	. = ..()

/obj/structure/flora/junglebush/b
	icon_state = "bushb"

/obj/structure/flora/junglebush/c
	icon_state = "bushc"

/obj/structure/flora/junglebush/large
	icon_state = "bush"
	icon = 'icons/obj/flora/largejungleflora.dmi'
	pixel_x = -16
	pixel_y = -12
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/grass/bush/wall/green
	name = "green great bush"
	icon = 'modular_rmh/icons/obj/flora/greenflora.dmi'
	icon_state = "bushwall_green1"
	base_icon_state = "bushwall_green"

/obj/structure/flora/grass/bush/green
	name = "green bush"
	icon = 'modular_rmh/icons/obj/flora/greenflora.dmi'
	icon_state = "bush_green"

/obj/structure/flora/grass/bush/wall/tall/green
	name = "green great bush"
	icon = 'modular_rmh/icons/obj/flora/foliagetall.dmi'
	icon_state = "tallbush_green1"
	base_icon_state = "tallbush_green"

/obj/structure/flora/grass/bush_meagre/green
	name = "green bush"
	icon = 'modular_rmh/icons/obj/flora/greenflora.dmi'
	icon_state = "bush_green1"
	base_icon_state = "bush_green"

/obj/structure/flora/grass/bush_meagre/green2
	name = "green bush"
	icon = 'modular_rmh/icons/obj/flora/greenflora.dmi'
	icon_state = "bush_green2"
	base_icon_state = "bush_green"

/obj/structure/flora/grass/bush_meagre/green3
	name = "green bush"
	icon = 'modular_rmh/icons/obj/flora/greenflora.dmi'
	icon_state = "bush_green3"
	base_icon_state = "bush_green"

/obj/structure/flora/mushroomcluster
	name = "mushroom cluster"
	desc = "A cluster of mushrooms native to the underdark."
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	icon_state = "mushroomcluster"
	density = TRUE

/obj/structure/flora/mushroomcluster/New(loc)
	..()
	set_light(1.5, 1.5, 1.5, l_color ="#5D3FD3")

/obj/structure/flora/tinymushrooms
	name = "small mushroom cluster"
	desc = "A cluster of tiny mushrooms native to the underdark."
	icon = 'modular_rmh/icons/obj/flora/foliage.dmi'
	icon_state = "tinymushrooms"

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"
	icon = 'modular_rmh/icons/obj/flora/snowflora.dmi'

/obj/structure/flora/grass/brown/Initialize()
	icon_state = "snowgrass[rand(1, 3)]bb"
	. = ..()

/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"
	icon = 'modular_rmh/icons/obj/flora/snowflora.dmi'

/obj/structure/flora/grass/green/Initialize()
	icon_state = "snowgrass[rand(1, 3)]gb"
	. = ..()

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"
	icon = 'modular_rmh/icons/obj/flora/snowflora.dmi'

/obj/structure/flora/grass/both/Initialize()
	icon_state = "snowgrassall[rand(1, 3)]"
	. = ..()


/obj/structure/flora/grass/sparegrass
	name = "sparse grass"
	desc = "Thin, sparse tufts of grass native to this area."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "sparsegrass_1"
	base_icon_state = "sparsegrass_"
	max_integrity = 5

/obj/structure/flora/grass/sparegrass/Initialize()
	. = ..()
	icon_state = "sparsegrass_[rand(1,3)]"

/obj/structure/flora/grass/fullgrass
	name = "full grass"
	desc = "Thick, healthy clumps of grass."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "fullgrass_1"
	base_icon_state = "fullgrass_"
	max_integrity = 6

/obj/structure/flora/grass/fullgrass/Initialize()
	. = ..()
	icon_state = "fullgrass_[rand(1,3)]"

/obj/structure/flora/grass/crawlvines
	name = "crawling vines"
	desc = "Vines sprouting in different corners of dead and vivid regions."
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "vinez"
	base_icon_state = "vinez"
	num_random_icons = 0
	attacked_sound = "plantcross"
	destroy_sound = "plantcross"
	max_integrity = 5
	debris = list(/obj/item/natural/fibers = 2)

//colorful light crystal
/obj/structure/flora/crystal
	name = "light crystal"
	desc = "Shiny and colorful crystal."
	icon = 'modular_rmh/icons/obj/lighting/crystal.dmi'
	icon_state = "crystal_1"
	density = FALSE
	anchored = TRUE
	max_integrity = 10
	blade_dulling = DULLING_PICK
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	light_system = STATIC_LIGHT
	light_outer_range = 3.5
	light_power = 1.6
	light_on = TRUE
	static_debris = list(/obj/item/natural/glass = 1, /obj/effect/decal/cleanable/debris/glass = 1)

/obj/structure/flora/crystal/Initialize(mapload)
	. = ..()
	icon_state = "crystal_[rand(1, 6)]"

	if(!color)
		color = "#" + num2text(rand(0x44, 0xFF), 2, 16) + \
				num2text(rand(0x44, 0xFF), 2, 16) + \
				num2text(rand(0x44, 0xFF), 2, 16)
	//to create not to dark light-color
	update_crystal_light()

/obj/structure/flora/crystal/proc/update_crystal_light()
	var/final_color = color || "#c4dce0"
	set_light(l_outer_range = 3.5, l_power = 1.6, l_color = final_color)

/obj/structure/flora/crystal/update_appearance(updates)
	. = ..()
	update_crystal_light()

/obj/structure/flora/crystal/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == "color")
		update_crystal_light()

//loot crystals
/obj/structure/flora/gemcrystals
	name = "gem crystals"
	desc = "A gem sprouted with crystals, like a fetus with stems."
	icon = 'modular_rmh/icons/obj/lighting/crystal.dmi'
	icon_state = "gem_crystal"
	density = TRUE
	max_integrity = 150
	layer = BELOW_MOB_LAYER
	blade_dulling = DULLING_PICK
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/effect/decal/cleanable/debris/glass = 1)

//red OR coral(big and small)
/obj/structure/flora/gemcrystals/rube
	name = "red crystals"
	desc = "A huge red crystal, covered in precious gemstonenes not unlike a fruit tree."
	icon_state = "rube_crystals"

/obj/structure/flora/gemcrystals/rube/small
	name = "red crystal"
	desc = "A red gem sprouted with crystals, like a fetus with stems."
	icon_state = "rube_crystal"

/obj/structure/flora/gemcrystals/rube/deconstruct(disassembled = FALSE)
	if(!disassembled && prob(10))
		var/gem_type = pick(/obj/item/gem/red, /obj/item/gem/coral)
		if(icon_state == "rube_crystals")
			new gem_type(get_turf(src))
			new gem_type(get_turf(src))
		else if(icon_state == "rube_crystal")
			new gem_type(get_turf(src))
	return ..()

/obj/structure/flora/gemcrystals/rube/New(loc)
	..()
	set_light(2, 2, 2, l_color ="#d30d0d")

//green OR jade(big and small)
/obj/structure/flora/gemcrystals/emerald
	name = "green crystals"
	desc = "A huge green crystal, covered in precious gemstonenes not unlike a fruit tree."
	icon_state = "emerald_crystals"

/obj/structure/flora/gemcrystals/emerald/small
	name = "green crystal"
	desc = "A green gem sprouted with crystals, like a fetus with stems."
	icon_state = "emerald_crystal"

/obj/structure/flora/gemcrystals/emerald/deconstruct(disassembled = FALSE)
	if(!disassembled && prob(10))
		var/gem_type = pick(/obj/item/gem/green, /obj/item/gem/jade)

		if(icon_state == "emerald_crystals")
			new gem_type(get_turf(src))
			new gem_type(get_turf(src))

		else if(icon_state == "emerald_crystal")
			new gem_type(get_turf(src))

	return ..()

/obj/structure/flora/gemcrystals/emerald/New(loc)
	..()
	set_light(2, 2, 2, l_color ="#2ed30d")

//blue OR opal(big and small)
/obj/structure/flora/gemcrystals/aquamarine
	name = "cyan crystals"
	desc = "A huge cyan crystal, covered in precious gemstonenes not unlike a fruit tree."
	icon_state = "aquamarine_crystals"

/obj/structure/flora/gemcrystals/aquamarine/small
	name = "cyan crystal"
	desc = "A cyan gem sprouted with crystals, like a fetus with stems."
	icon_state = "aquamarine_crystal"

/obj/structure/flora/gemcrystals/aquamarine/deconstruct(disassembled = FALSE)
	if(!disassembled && prob(10))
		var/gem_type = pick(/obj/item/gem/blue, /obj/item/gem/opal)

		if(icon_state == "aquamarine_crystals")
			new gem_type(get_turf(src))
			new gem_type(get_turf(src))

		else if(icon_state == "aquamarine_crystal")
			new gem_type(get_turf(src))

	return ..()

/obj/structure/flora/gemcrystals/aquamarine/New(loc)
	..()
	set_light(2, 2, 2, l_color ="#0dd3d3")

//yellow OR amber(big and small)
/obj/structure/flora/gemcrystals/topaz
	name = "yellow crystals"
	desc = "A huge yellow crystal, covered in precious gemstonenes not unlike a fruit tree."
	icon_state = "topaz_crystals"

/obj/structure/flora/gemcrystals/topaz/small
	name = "yellow crystal"
	desc = "A yellow gem sprouted with crystals, like a fetus with stems."
	icon_state = "topaz_crystal"

/obj/structure/flora/gemcrystals/topaz/deconstruct(disassembled = FALSE)
	if(!disassembled && prob(10))
		var/gem_type = pick(/obj/item/gem/yellow, /obj/item/gem/amber)

		if(icon_state == "topaz_crystals")
			new gem_type(get_turf(src))
			new gem_type(get_turf(src))

		else if(icon_state == "topaz_crystal")
			new gem_type(get_turf(src))

	return ..()

/obj/structure/flora/gemcrystals/topaz/New(loc)
	..()
	set_light(2, 2, 2, l_color ="#f0ab16")

//amethyst OR violet OR onyxa(small)
/obj/structure/flora/gemcrystals/sapphiresmall
	name = "purple crystal"
	desc = "A purple gem sprouted with crystals, like a fetus with stems."
	icon_state = "sapphire_crystal"

/obj/structure/flora/gemcrystals/sapphiresmall/deconstruct(disassembled = FALSE)
	if(!disassembled && prob(10))
		var/gem_type = pick(/obj/item/gem/amethyst, /obj/item/gem/violet, /obj/item/gem/onyxa,)

		if(icon_state == "sapphire_crystal")
			new gem_type(get_turf(src))

	return ..()

/obj/structure/flora/gemcrystals/sapphiresmall/New(loc)
	..()
	set_light(2, 2, 2, l_color ="#9218ca")

//artifact OR elementalshard OR diamond OR leyline OR mana_crystal/standard OR /mana_crystal/small OR melded/t1(big)
/obj/structure/flora/gemcrystals/lapiz
	name = "blue crystal"
	desc = "A blue gem sprouted... it's looks diffrent."
	icon_state = "lapiz_crystals"

/obj/structure/flora/gemcrystals/lapiz/deconstruct(disassembled = FALSE)
	if(!disassembled && prob(10))
		drop_lapiz_loot()
	return ..()

/obj/structure/flora/gemcrystals/lapiz/proc/drop_lapiz_loot()
	var/list/loot_table = list(
		/obj/item/natural/artifact = 8,
		/obj/item/natural/elementalshard = 13,
		/obj/item/gem/diamond = 2,
		/obj/item/riddleofsteel = 1,
		/obj/item/natural/leyline = 6,
		/obj/item/mana_battery/mana_crystal/standard = 18,
		/obj/item/mana_battery/mana_crystal/small = 25,
		/obj/item/natural/melded/t1 = 4
	)
	var/gem_type = pickweight(loot_table)

	var/amount = 1
	if(gem_type in list(/obj/item/natural/artifact,
						/obj/item/natural/elementalshard,
						/obj/item/mana_battery/mana_crystal/standard,
						/obj/item/mana_battery/mana_crystal/small))
		amount = 2

	for(var/i in 1 to amount)
		new gem_type(get_turf(src))

/obj/structure/flora/gemcrystals/lapiz/New(loc)
	..()
	set_light(2, 2, 2, l_color ="#181bca")

//	-	-	-	-	-	-	-	//
// 			NEW TREES			//
//	-	-	-	-	-	-	-	//
/obj/structure/flora/tree/newtree
	name = "tree"
	desc = "Beautiful and young trees."
	icon = 'modular_rmh/icons/obj/flora/trees96.dmi'
	icon_state = "tree1"
	base_icon_state = "tree"
	num_random_icons = 6
	SET_BASE_PIXEL(-32, 0)
	debris = list(/obj/item/grown/log/tree/stick = 3)
	static_debris = list(/obj/item/grown/log/tree = 2)

/obj/structure/flora/tree/newtree2
	name = "tree"
	desc = "Beautiful and young trees."
	icon = 'modular_rmh/icons/obj/flora/trees96.dmi'
	icon_state = "t1"
	base_icon_state = "t"
	num_random_icons = 3
	SET_BASE_PIXEL(-32, 0)
	debris = list(/obj/item/grown/log/tree/stick = 3)
	static_debris = list(/obj/item/grown/log/tree = 2)
