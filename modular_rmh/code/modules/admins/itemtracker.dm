GLOBAL_LIST_EMPTY(important_items)
#define IMPORTANT_ITEMS_BULK_ADD_LIMIT 10
#define WINDOW_MAIN "importantitems"
#define WINDOW_ADD "importantitems_add"
#define WINDOW_CONFIRM "importantitems_confirm"

/proc/register_important_item(obj/item/I, display_name)
	if(!I || QDELETED(I))
		return FALSE

	if(I.important_item_key)
		return FALSE

	if(!display_name)
		display_name = I.name || "Unknown Item"

	GLOB.important_items[display_name] = I
	I.important_item_key = display_name
	return TRUE

/proc/unregister_important_item(key)
	var/obj/item/I = GLOB.important_items[key]
	if(I)
		I.important_item_key = null
	GLOB.important_items -= key
	return TRUE

/proc/item_in_zone(obj/item/I, zone_filter)
	if(!zone_filter)
		return TRUE

	var/turf/T = get_turf(I)
	if(!T)
		return FALSE

	var/area/A = T.loc
	if(!A)
		return FALSE

	var/search = lowertext(zone_filter)
	if(findtext(lowertext("[A.type]"), search))
		return TRUE
	if(findtext(lowertext(A.name), search))
		return TRUE

	return FALSE

/obj/item
	var/mob/last_touched_by
	var/important_item_key = null

/obj/item/Destroy()
	if(important_item_key && GLOB.important_items[important_item_key] == src)
		GLOB.important_items -= important_item_key
		important_item_key = null
	return ..()

/obj/item/pickup(mob/user)
	. = ..()
	if(!user)
		return
	last_touched_by = user

/client/proc/get_items_by_path(item_path)
	var/path = text2path(item_path)
	if(!path)
		return null

	var/list/found_items = list()
	for(var/obj/item/I in world)
		if(istype(I, path))
			found_items += I
	return found_items

/client/proc/search_important_items()
	set category = "Admin.Jump"
	set name = "Important Items Tracker"

	if(!holder)
		return

	var/dat = "<h2>Important Items Tracker</h2><HR>"
	dat += "<b>Total tracked:</b> [length(GLOB.important_items)] items<BR><BR>"
	dat += "<a href='byond://?src=[REF(src)];addimportant=1'><b>+ Add items by path</b></a><HR>"

	for(var/key in GLOB.important_items)
		var/obj/item/I = GLOB.important_items[key]
		dat += "<b>[key]</b> "

		if(I && !QDELETED(I))
			var/turf/T = get_turf(I)
			var/location = T ? "[AREACOORD(T)]" : "Unknown location"
			dat += "<a href='byond://?src=[REF(src)];searchitem=[REF(I)]'>→ [location]</a>"
			dat += " <a href='byond://?src=[REF(src)];deleteitem=[REF(I)]' style='color:red;text-decoration:none;'><b>RMV</b></a>"
		else
			dat += "<span class='bad'>DESTROYED</span>"
			if(I?.last_touched_by)
				dat += " | Last touched by: <b>[I.last_touched_by.real_name]</b> ([I.last_touched_by.ckey])"
			dat += " <a href='byond://?src=[REF(src)];deletekey=[key]' style='color:red;text-decoration:none;'><b>RMV</b></a>"
		dat += "<BR>"

	if(!length(GLOB.important_items))
		dat += "<i>No important items registered yet.</i><BR>"

	dat += "<HR><a href='byond://?src=[REF(src)];close=1;window=[WINDOW_MAIN]'><b>Close</b></a>"

	var/datum/browser/popup = new(usr, WINDOW_MAIN, "Important Items Tracker", 550, 450)
	popup.set_content(dat)
	popup.open(TRUE)

/client/proc/open_add_important_menu()
	if(!holder)
		return

	var/dat = "<h2>Add Important Items by Path</h2><HR>"
	dat += "Enter item path to track (e.g., /obj/item/key/lord):<BR><BR>"
	dat += "<form action='byond://?src=[REF(src)]' method='get'>"
	dat += "<input type='hidden' name='src' value='[REF(src)]'>"
	dat += "<input type='hidden' name='doadd_search' value='1'>"
	dat += "<input type='text' name='item_path' style='width:100%' placeholder='/obj/item/key/lord'><BR><BR>"
	dat += "<i>Note: Will add up to [IMPORTANT_ITEMS_BULK_ADD_LIMIT] items at once.</i><BR><BR>"
	dat += "<input type='submit' value='Search & Add'>"
	dat += "</form><HR>"
	dat += "<a href='byond://?src=[REF(src)];close=1;window=[WINDOW_ADD]'><b>Cancel</b></a>"

	var/datum/browser/popup = new(usr, WINDOW_ADD, "Add Important Items", 500, 300)
	popup.set_content(dat)
	popup.open(TRUE)

/client/proc/open_confirm_add(item_path, total_found, list/found_items, add_limit, zone_filter = "")
	if(!holder)
		return

	var/dat = "<h2>Confirm Add</h2><HR>"
	dat += "Found <b>[total_found]</b> instance(s) of <b>[item_path]</b><BR>"
	dat += "Will add up to <b>[add_limit]</b> items<BR><BR>"

	if(total_found == 0)
		dat += "<span class='bad'><b>No such item exists.</b></span><BR><BR>"
		dat += "<a href='byond://?src=[REF(src)];back_to_add=1'><b>Back</b></a> | "
		dat += "<a href='byond://?src=[REF(src)];close=1;window=[WINDOW_CONFIRM]'><b>Cancel</b></a>"
	else

		dat += "<form action='byond://?src=[REF(src)]' method='get'>"
		dat += "<input type='hidden' name='src' value='[REF(src)]'>"
		dat += "<input type='hidden' name='filter_search' value='1'>"
		dat += "<input type='hidden' name='item_path' value='[item_path]'>"
		dat += "<b>Filter by zone:</b> "
		dat += "<input type='text' name='zone_filter' value='[zone_filter]' placeholder='e.g., druid, /area/.../druid' style='width:250px'>"
		dat += "<input type='submit' value='Apply'>"
		dat += "</form><BR>"

		var/list/filtered_items = found_items
		if(zone_filter != "")
			filtered_items = list()
			for(var/obj/item/I in found_items)
				if(item_in_zone(I, zone_filter))
					filtered_items += I

		var/filtered_count = filtered_items.len

		if(zone_filter != "" && filtered_count == 0)
			dat += "<span class='bad'><b>No items in zone '[zone_filter]'.</b></span><BR>"
			dat += "<a href='byond://?src=[REF(src)];back_to_confirm=1;path=[item_path]'><b>Clear Filter</b></a><BR>"
		else
			var/add_count = min(filtered_count, add_limit)
			dat += "<b>[filtered_count]</b> item(s) after filter, will add <b>[add_count]</b><BR><BR>"

			if(filtered_count > 0)
				dat += "<b>Items to add:</b><BR>"
				var/count = 0
				for(var/obj/item/I in filtered_items)
					if(++count > add_limit)
						break
					var/turf/T = get_turf(I)
					var/area/A = T ? T.loc : null
					var/zone_info = A ? "[A.type] ([A.name])" : "Unknown"
					var/status = I.important_item_key ? "<span class='bad'>ALREADY TRACKED</span> " : ""
					dat += "- [status][I.name] at [zone_info]<BR>"
					dat += "&nbsp;&nbsp;→ [T ? "[AREACOORD(T)]" : "Unknown"]<BR>"

				if(filtered_count > add_limit)
					dat += "<BR><span class='warning'>[filtered_count - add_limit] more items not added (bulk limit).</span><BR>"

				dat += "<BR><a href='byond://?src=[REF(src)];doadd_bulk=1;path=[item_path];limit=[add_limit];zone=[zone_filter]'><b>Add Filtered Items</b></a><BR>"

			if(zone_filter != "")
				dat += "<a href='byond://?src=[REF(src)];back_to_confirm=1;path=[item_path]'><b>Clear Filter</b></a><BR>"

		dat += "<BR><a href='byond://?src=[REF(src)];back_to_add=1'><b>Back to Search</b></a> | "
		dat += "<a href='byond://?src=[REF(src)];close=1;window=[WINDOW_CONFIRM]'><b>Cancel</b></a>"

	var/datum/browser/popup = new(usr, WINDOW_CONFIRM, "Confirm Add", 650, 550)
	popup.set_content(dat)
	popup.open(TRUE)

/client/proc/add_items_of_type(path, max_count = 10, zone_filter = "")
	if(!holder)
		return FALSE

	var/list/found_items = list()
	for(var/obj/item/I in world)
		if(!istype(I, path))
			continue
		if(I.important_item_key)
			continue
		if(zone_filter != "" && !item_in_zone(I, zone_filter))
			continue
		found_items += I

	if(!found_items.len)
		var/msg = "No unregistered items of type [path]"
		if(zone_filter != "")
			msg += " in zone matching '[zone_filter]'"
		to_chat(usr, span_warning("[msg]."))
		return FALSE

	var/add_count = min(found_items.len, max_count)
	var/success_count = 0
	var/short_path = replacetext("[path]", "/obj/item/", "")

	for(var/i = 1 to add_count)
		var/obj/item/I = found_items[i]
		var/turf/T = get_turf(I)
		var/area/A = T ? T.loc : null
		var/zone_name = A ? "[A.type] ([A.name])" : "Unknown"
		var/display_name = "[short_path] ([zone_name]) #[success_count + 1]"

		if(register_important_item(I, display_name))
			success_count++

	if(!success_count)
		to_chat(usr, span_warning("Failed to add items."))
		return FALSE

	var/msg = "Added [success_count] item(s) of type [path]"
	if(zone_filter != "")
		msg += " from '[zone_filter]'"
	to_chat(usr, span_notice("[msg]."))
	return TRUE

/client/Topic(href, href_list)
	. = ..()

	if(href_list["close"])
		var/window_name = href_list["window"]
		if(window_name)
			usr << browse(null, "window=[window_name]")
		return

	if(href_list["searchitem"])
		var/obj/item/I = locate(href_list["searchitem"])
		if(I && !QDELETED(I))
			usr.forceMove(get_turf(I))
			to_chat(usr, span_notice("Teleported to [I]."))
		else
			to_chat(usr, span_warning("Item no longer exists."))
		return

	if(href_list["deleteitem"])
		var/obj/item/I = locate(href_list["deleteitem"])
		if(I && I.important_item_key)
			var/deleted_key = I.important_item_key
			unregister_important_item(deleted_key)
			to_chat(usr, span_notice("Removed '[deleted_key]' from tracker."))
		else
			to_chat(usr, span_warning("Item not found or not tracked."))
		search_important_items()
		return

	if(href_list["deletekey"])
		var/key = href_list["deletekey"]
		if(GLOB.important_items[key])
			unregister_important_item(key)
			to_chat(usr, span_notice("Removed '[key]' from tracker."))
		else
			to_chat(usr, span_warning("Key not found in tracker."))
		search_important_items()
		return

	if(href_list["addimportant"])
		open_add_important_menu()
		return

	if(href_list["back_to_add"])
		open_add_important_menu()
		return

	if(href_list["back_to_confirm"])
		var/path = href_list["path"]
		var/list/items = get_items_by_path(path)
		if(items)
			open_confirm_add(path, items.len, items, IMPORTANT_ITEMS_BULK_ADD_LIMIT, "")
		else
			open_add_important_menu()
		return

	if(href_list["filter_search"])
		var/item_path = href_list["item_path"]
		var/zone_filter = href_list["zone_filter"]
		var/list/items = get_items_by_path(item_path)
		if(items)
			open_confirm_add(item_path, items.len, items, IMPORTANT_ITEMS_BULK_ADD_LIMIT, zone_filter)
		else
			open_add_important_menu()
		return

	if(href_list["doadd_search"])
		var/item_path = href_list["item_path"]
		if(!item_path)
			to_chat(usr, span_warning("Enter a valid item path."))
			open_add_important_menu()
			return

		var/list/items = get_items_by_path(item_path)
		if(!items)
			to_chat(usr, span_warning("Invalid path: [item_path]"))
			open_add_important_menu()
			return

		if(!items.len)
			to_chat(usr, span_warning("No items of type [item_path] found."))

		open_confirm_add(item_path, items.len, items, IMPORTANT_ITEMS_BULK_ADD_LIMIT)
		return

	if(href_list["doadd_bulk"])
		var/path = text2path(href_list["path"])
		var/limit = text2num(href_list["limit"])
		var/zone_filter = href_list["zone"] || ""

		if(!path)
			to_chat(usr, span_warning("Invalid path."))
		else
			if(!limit)
				limit = IMPORTANT_ITEMS_BULK_ADD_LIMIT
			add_items_of_type(path, limit, zone_filter)

		search_important_items()
		return

	if(href_list["canceladd"])
		search_important_items()
		return
