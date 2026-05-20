/**
 * Build the pagination controls for the current item browser page.
 *
 * @return {string} - HTML for pagination controls
 */
/datum/buildmode/proc/build_pagination_controls()
	if(browser_page_count <= 1)
		return ""

	var/list/dat = list()
	var/search_params = browser_search ? ";search=[url_encode(browser_search)]" : ""
	dat += "<div class='pagination'>"
	if(current_page > 1)
		dat += "<a class='button' href='?src=[REF(src)];page=[current_page - 1][search_params]'>Previous</a>"
	dat += "<span class='page-status'>Page [current_page] of [browser_page_count] ([browser_total_items] entries)</span>"
	if(current_page < browser_page_count)
		dat += "<a class='button' href='?src=[REF(src)];page=[current_page + 1][search_params]'>Next</a>"
	dat += "</div>"
	return dat.Join()

/**
 * Filter buildmode type paths by a search query before pagination.
 *
 * @param {list} item_types - Type paths in the current category
 * @param {string} search_text - Search query to match against names and type paths
 * @return {list} - Matching type paths
 */
/proc/filter_buildmode_types_for_search(list/item_types, search_text)
	if(!istext(search_text) || !length(search_text))
		return item_types.Copy()

	var/search_lower = lowertext(search_text)
	var/list/search_results = list()
	for(var/item_path in item_types)
		var/atom/item_atom = item_path
		var/name_display = initial(item_atom.name) || item_path
		if(findtext(lowertext("[name_display]"), search_lower) || findtext(lowertext("[item_path]"), search_lower))
			search_results += item_path

	return search_results

/**
 * Generate a paginated HTML grid for buildmode paths.
 *
 * @param {list} filtered_types - Type paths to show
 * @param {string} search_text - Search query to apply before pagination
 * @return {string} - HTML for the current page
 */
/datum/buildmode/proc/generate_buildmode_item_page(list/filtered_types, search_text = "")
	var/list/dat = list()
	var/list/search_results = filter_buildmode_types_for_search(filtered_types, search_text)
	browser_total_items = length(search_results)
	if(!browser_total_items)
		current_page = 1
		browser_page_count = 1
		return "<div class='more'>No entries.</div>"

	browser_page_count = max(1, CEILING(browser_total_items / BM_ITEMS_PER_PAGE, 1))
	current_page = CLAMP(current_page, 1, browser_page_count)

	var/start_index = ((current_page - 1) * BM_ITEMS_PER_PAGE) + 1
	var/end_index = min(start_index + BM_ITEMS_PER_PAGE - 1, browser_total_items)
	for(var/index in start_index to end_index)
		var/item_path = search_results[index]
		var/atom/item_atom = item_path
		var/name_display = initial(item_atom.name) || item_path
		dat += "<div class='item' data-path='[item_path]' title='[item_path]' onclick='window.location=\"?src=[REF(src)];item=[item_path]\"'>"
		dat += "<div class='item-icon'><img src='\ref[initial(item_atom.icon)]?state=[initial(item_atom.icon_state)]&dir=[initial(item_atom.dir)]'/></div>"
		dat += "<div class='item-name'>[name_display]</div>"
		dat += "</div>"
	return dat.Join()

/**
 * Generate HTML for turf selections
 *
 * @return {string} - HTML for the turf list
 */
/datum/buildmode/proc/generate_turf_list()
	var/list/turf_types = subtypesof(/turf)
	var/list/filtered_types = list()
	for(var/turf/T as anything in turf_types)
		if(initial(T.icon) && !ispath(T, /turf/template_noop))
			filtered_types += T
	sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return generate_buildmode_item_page(filtered_types, browser_search)

/**
 * Generate HTML for object selections
 *
 * @return {string} - HTML for the object list
 */
/datum/buildmode/proc/generate_obj_list()
	var/list/obj_types = subtypesof(/obj)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/obj/O as anything in obj_types)
			if(IS_ABSTRACT(O))
				continue
			if(ispath(O, /obj/item))
				continue
			if(ispath(O, /obj/abstract))
				continue

			if(initial(O.icon) && !ispath(O, /obj/effect))
				filtered_types += O
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return generate_buildmode_item_page(filtered_types, browser_search)

/**
 * Generate HTML for mob selections
 *
 * @return {string} - HTML for the mob list
 */
/datum/buildmode/proc/generate_mob_list()
	var/list/mob_types = subtypesof(/mob)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/mob/M as anything in mob_types)
			if(initial(M.icon) && !ispath(M, /mob/dead) && !ispath(M, /mob/camera))
				filtered_types += M
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return generate_buildmode_item_page(filtered_types, browser_search)

/**
 * Generate HTML for item selections
 *
 * @return {string} - HTML for the item list
 */
/datum/buildmode/proc/generate_item_list()
	var/list/item_types = subtypesof(/obj/item)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/obj/item/I as anything in item_types)
			if(ispath(I, /obj/item/clothing) || ispath(I, /obj/item/weapon) || ispath(I, /obj/item/reagent_containers))
				continue
			if(initial(I.icon))
				filtered_types += I
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return generate_buildmode_item_page(filtered_types, browser_search)

/**
 * Generate HTML for food selections
 *
 * @return {string} - HTML for the food list
 */
/datum/buildmode/proc/generate_food_list()
	var/list/item_types = subtypesof(/obj/item/reagent_containers/food)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/obj/item/I as anything in item_types)
			if(initial(I.icon))
				filtered_types += I
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return generate_buildmode_item_page(filtered_types, browser_search)

/**
 * Generate HTML for reagent container selections
 *
 * @return {string} - HTML for the reagent container list
 */
/datum/buildmode/proc/generate_reagentcontainer_list()
	var/list/item_types = subtypesof(/obj/item/reagent_containers)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/obj/item/I as anything in item_types)
			if(ispath(I, /obj/item/reagent_containers/food))
				continue
			if(initial(I.icon))
				filtered_types += I
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return generate_buildmode_item_page(filtered_types, browser_search)

/**
 * Generate HTML for clothing selections
 *
 * @return {string} - HTML for the clothing list
 */
/datum/buildmode/proc/generate_clothing_list()
	var/list/item_types = subtypesof(/obj/item/clothing)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/obj/item/I as anything in item_types)
			if(initial(I.icon))
				filtered_types += I
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return generate_buildmode_item_page(filtered_types, browser_search)

/**
 * Generate HTML for weapon selections
 *
 * @return {string} - HTML for the weapon list
 */
/datum/buildmode/proc/generate_weapon_list()
	var/list/item_types = subtypesof(/obj/item/weapon)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/obj/item/I as anything in item_types)
			if(initial(I.icon))
				filtered_types += I
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return generate_buildmode_item_page(filtered_types, browser_search)
