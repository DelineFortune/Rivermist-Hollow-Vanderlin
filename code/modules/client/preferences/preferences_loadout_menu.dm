// Global cache for loadout item icons to prevent memory leaks
GLOBAL_LIST_EMPTY(cached_loadout_icons)

/datum/preferences/proc/get_base_points()
	return 10

/datum/preferences/proc/get_loadout_points_spent()
	var/spent = 0
	for(var/i = 1 to 10)
		var/datum/loadout_item/L = vars["loadout[i]"]
		if(L && L.point_cost)
			spent += L.point_cost
	return spent

/datum/preferences/proc/get_remaining_points()
	var/base = get_base_points()
	var/spent = get_loadout_points_spent() // Languages no longer count toward this
	return base - spent

/datum/preferences/proc/save_to_history()
	// Initialize history list if null
	if(!customization_history)
		customization_history = list()

	// Save current state to history (max 10 entries)
	var/list/snapshot = list(
		"loadout1" = loadout1,
		"loadout2" = loadout2,
		"loadout3" = loadout3,
		"loadout4" = loadout4,
		"loadout5" = loadout5,
		"loadout6" = loadout6,
		"loadout7" = loadout7,
		"loadout8" = loadout8,
		"loadout9" = loadout9,
		"loadout10" = loadout10,
		"loadout_1_name" = loadout_1_name,
		"loadout_2_name" = loadout_2_name,
		"loadout_3_name" = loadout_3_name,
		"loadout_4_name" = loadout_4_name,
		"loadout_5_name" = loadout_5_name,
		"loadout_6_name" = loadout_6_name,
		"loadout_7_name" = loadout_7_name,
		"loadout_8_name" = loadout_8_name,
		"loadout_9_name" = loadout_9_name,
		"loadout_10_name" = loadout_10_name,
		"loadout_1_desc" = loadout_1_desc,
		"loadout_2_desc" = loadout_2_desc,
		"loadout_3_desc" = loadout_3_desc,
		"loadout_4_desc" = loadout_4_desc,
		"loadout_5_desc" = loadout_5_desc,
		"loadout_6_desc" = loadout_6_desc,
		"loadout_7_desc" = loadout_7_desc,
		"loadout_8_desc" = loadout_8_desc,
		"loadout_9_desc" = loadout_9_desc,
		"loadout_10_desc" = loadout_10_desc,
		"loadout_1_hex" = loadout_1_hex,
		"loadout_2_hex" = loadout_2_hex,
		"loadout_3_hex" = loadout_3_hex,
		"loadout_4_hex" = loadout_4_hex,
		"loadout_5_hex" = loadout_5_hex,
		"loadout_6_hex" = loadout_6_hex,
		"loadout_7_hex" = loadout_7_hex,
		"loadout_8_hex" = loadout_8_hex,
		"loadout_9_hex" = loadout_9_hex,
		"loadout_10_hex" = loadout_10_hex,
	)

	// Add to history
	customization_history.Insert(1, snapshot)

	// Keep only last 10 entries
	if(customization_history.len > 10)
		customization_history.Cut(11)

/datum/preferences/proc/undo_last_change()
	if(!customization_history || !customization_history.len)
		return FALSE

	// Get the last snapshot
	var/list/snapshot = customization_history[1]

	// Restore all values
	loadout1 = snapshot["loadout1"]
	loadout2 = snapshot["loadout2"]
	loadout3 = snapshot["loadout3"]
	loadout4 = snapshot["loadout4"]
	loadout5 = snapshot["loadout5"]
	loadout6 = snapshot["loadout6"]
	loadout7 = snapshot["loadout7"]
	loadout8 = snapshot["loadout8"]
	loadout9 = snapshot["loadout9"]
	loadout10 = snapshot["loadout10"]
	loadout_1_name = snapshot["loadout_1_name"]
	loadout_2_name = snapshot["loadout_2_name"]
	loadout_3_name = snapshot["loadout_3_name"]
	loadout_4_name = snapshot["loadout_4_name"]
	loadout_5_name = snapshot["loadout_5_name"]
	loadout_6_name = snapshot["loadout_6_name"]
	loadout_7_name = snapshot["loadout_7_name"]
	loadout_8_name = snapshot["loadout_8_name"]
	loadout_9_name = snapshot["loadout_9_name"]
	loadout_10_name = snapshot["loadout_10_name"]
	loadout_1_desc = snapshot["loadout_1_desc"]
	loadout_2_desc = snapshot["loadout_2_desc"]
	loadout_3_desc = snapshot["loadout_3_desc"]
	loadout_4_desc = snapshot["loadout_4_desc"]
	loadout_5_desc = snapshot["loadout_5_desc"]
	loadout_6_desc = snapshot["loadout_6_desc"]
	loadout_7_desc = snapshot["loadout_7_desc"]
	loadout_8_desc = snapshot["loadout_8_desc"]
	loadout_9_desc = snapshot["loadout_9_desc"]
	loadout_10_desc = snapshot["loadout_10_desc"]
	loadout_1_hex = snapshot["loadout_1_hex"]
	loadout_2_hex = snapshot["loadout_2_hex"]
	loadout_3_hex = snapshot["loadout_3_hex"]
	loadout_4_hex = snapshot["loadout_4_hex"]
	loadout_5_hex = snapshot["loadout_5_hex"]
	loadout_6_hex = snapshot["loadout_6_hex"]
	loadout_7_hex = snapshot["loadout_7_hex"]
	loadout_8_hex = snapshot["loadout_8_hex"]
	loadout_9_hex = snapshot["loadout_9_hex"]
	loadout_10_hex = snapshot["loadout_10_hex"]

	// Remove this snapshot from history
	customization_history.Cut(1, 2)

	return TRUE

/datum/preferences/proc/save_preset(preset_slot)
	if(preset_slot < 1 || preset_slot > 3)
		return FALSE

	var/list/preset = list(
		"loadout1" = loadout1?.type,
		"loadout2" = loadout2?.type,
		"loadout3" = loadout3?.type,
		"loadout4" = loadout4?.type,
		"loadout5" = loadout5?.type,
		"loadout6" = loadout6?.type,
		"loadout7" = loadout7?.type,
		"loadout8" = loadout8?.type,
		"loadout9" = loadout9?.type,
		"loadout10" = loadout10?.type,
		"loadout_1_name" = loadout_1_name,
		"loadout_2_name" = loadout_2_name,
		"loadout_3_name" = loadout_3_name,
		"loadout_4_name" = loadout_4_name,
		"loadout_5_name" = loadout_5_name,
		"loadout_6_name" = loadout_6_name,
		"loadout_7_name" = loadout_7_name,
		"loadout_8_name" = loadout_8_name,
		"loadout_9_name" = loadout_9_name,
		"loadout_10_name" = loadout_10_name,
		"loadout_1_desc" = loadout_1_desc,
		"loadout_2_desc" = loadout_2_desc,
		"loadout_3_desc" = loadout_3_desc,
		"loadout_4_desc" = loadout_4_desc,
		"loadout_5_desc" = loadout_5_desc,
		"loadout_6_desc" = loadout_6_desc,
		"loadout_7_desc" = loadout_7_desc,
		"loadout_8_desc" = loadout_8_desc,
		"loadout_9_desc" = loadout_9_desc,
		"loadout_10_desc" = loadout_10_desc,
		"loadout_1_hex" = loadout_1_hex,
		"loadout_2_hex" = loadout_2_hex,
		"loadout_3_hex" = loadout_3_hex,
		"loadout_4_hex" = loadout_4_hex,
		"loadout_5_hex" = loadout_5_hex,
		"loadout_6_hex" = loadout_6_hex,
		"loadout_7_hex" = loadout_7_hex,
		"loadout_8_hex" = loadout_8_hex,
		"loadout_9_hex" = loadout_9_hex,
		"loadout_10_hex" = loadout_10_hex,
	)

	vars["loadout_preset_[preset_slot]"] = preset
	return TRUE

/datum/preferences/proc/load_preset(preset_slot)
	if(preset_slot < 1 || preset_slot > 3)
		return FALSE

	var/list/preset = vars["loadout_preset_[preset_slot]"]
	if(!preset || !istype(preset, /list) || !preset.len)
		return FALSE

	// Save current state to history before loading preset
	save_to_history()

	// Restore all values from preset with validation
	// Use string_to_typepath() to handle both type paths and JSON-decoded strings

	// Load loadout types and instantiate them if valid
	var/loadout_type = string_to_typepath(preset["loadout1"])
	if(loadout_type && ispath(loadout_type, /datum/loadout_item))
		loadout1 = new loadout_type()
	else
		loadout1 = null

	var/loadout_type2 = string_to_typepath(preset["loadout2"])
	if(loadout_type2 && ispath(loadout_type2, /datum/loadout_item))
		loadout2 = new loadout_type2()
	else
		loadout2 = null

	var/loadout_type3 = string_to_typepath(preset["loadout3"])
	if(loadout_type3 && ispath(loadout_type3, /datum/loadout_item))
		loadout3 = new loadout_type3()
	else
		loadout3 = null

	var/loadout_type4 = string_to_typepath(preset["loadout4"])
	if(loadout_type4 && ispath(loadout_type4, /datum/loadout_item))
		loadout4 = new loadout_type4()
	else
		loadout4 = null

	var/loadout_type5 = string_to_typepath(preset["loadout5"])
	if(loadout_type5 && ispath(loadout_type5, /datum/loadout_item))
		loadout5 = new loadout_type5()
	else
		loadout5 = null

	var/loadout_type6 = string_to_typepath(preset["loadout6"])
	if(loadout_type6 && ispath(loadout_type6, /datum/loadout_item))
		loadout6 = new loadout_type6()
	else
		loadout6 = null

	var/loadout_type7 = string_to_typepath(preset["loadout7"])
	if(loadout_type7 && ispath(loadout_type7, /datum/loadout_item))
		loadout7 = new loadout_type7()
	else
		loadout7 = null

	var/loadout_type8 = string_to_typepath(preset["loadout8"])
	if(loadout_type8 && ispath(loadout_type8, /datum/loadout_item))
		loadout8 = new loadout_type8()
	else
		loadout8 = null

	var/loadout_type9 = string_to_typepath(preset["loadout9"])
	if(loadout_type9 && ispath(loadout_type9, /datum/loadout_item))
		loadout9 = new loadout_type9()
	else
		loadout9 = null

	var/loadout_type10 = string_to_typepath(preset["loadout10"])
	if(loadout_type10 && ispath(loadout_type10, /datum/loadout_item))
		loadout10 = new loadout_type10()
	else
		loadout10 = null

	// Always restore all string values from preset (including null/empty values)
	loadout_1_name = preset["loadout_1_name"]
	loadout_2_name = preset["loadout_2_name"]
	loadout_3_name = preset["loadout_3_name"]
	loadout_4_name = preset["loadout_4_name"]
	loadout_5_name = preset["loadout_5_name"]
	loadout_6_name = preset["loadout_6_name"]
	loadout_7_name = preset["loadout_7_name"]
	loadout_8_name = preset["loadout_8_name"]
	loadout_9_name = preset["loadout_9_name"]
	loadout_10_name = preset["loadout_10_name"]

	loadout_1_desc = preset["loadout_1_desc"]
	loadout_2_desc = preset["loadout_2_desc"]
	loadout_3_desc = preset["loadout_3_desc"]
	loadout_4_desc = preset["loadout_4_desc"]
	loadout_5_desc = preset["loadout_5_desc"]
	loadout_6_desc = preset["loadout_6_desc"]
	loadout_7_desc = preset["loadout_7_desc"]
	loadout_8_desc = preset["loadout_8_desc"]
	loadout_9_desc = preset["loadout_9_desc"]
	loadout_10_desc = preset["loadout_10_desc"]

	loadout_1_hex = preset["loadout_1_hex"]
	loadout_2_hex = preset["loadout_2_hex"]
	loadout_3_hex = preset["loadout_3_hex"]
	loadout_4_hex = preset["loadout_4_hex"]
	loadout_5_hex = preset["loadout_5_hex"]
	loadout_6_hex = preset["loadout_6_hex"]
	loadout_7_hex = preset["loadout_7_hex"]
	loadout_8_hex = preset["loadout_8_hex"]
	loadout_9_hex = preset["loadout_9_hex"]
	loadout_10_hex = preset["loadout_10_hex"]

	return TRUE

/datum/preferences/proc/clear_preset(preset_slot)
	if(preset_slot < 1 || preset_slot > 3)
		return FALSE

	vars["loadout_preset_[preset_slot]"] = null
	return TRUE

/datum/preferences/proc/get_preset_summary(preset_slot)
	if(preset_slot < 1 || preset_slot > 3)
		return "Invalid Slot"

	var/list/preset = vars["loadout_preset_[preset_slot]"]
	if(!preset || !preset.len)
		return "Empty"

	// Build summary string
	var/summary = ""

	// Count loadout items
	var/loadout_count = 0
	for(var/i = 1 to 10)
		var/loadout_var = "loadout[i]"
		var/loadout_path = string_to_typepath(preset[loadout_var])
		if(ispath(loadout_path, /datum/loadout_item))
			loadout_count++
	if(loadout_count > 0)
		summary += " | [loadout_count] item[loadout_count > 1 ? "s" : ""]"

	return summary

/datum/preferences/proc/open_loadout_menu(mob/user)
	if(!user || !user.client)
		return


	var/html_content = generate_loadout_html(user)
	user << browse(html_content, "window=character_custom;size=750x500")


/datum/preferences/proc/generate_loadout_html(mob/user)
	// Use same colors as main character creation menu
	var/list/theme = list(
		"bg" = "#100000",
		"text" = "#aa8f8f",
		"label" = "#aa8f8f",
		"border" = "#7b5353",
		"panel" = "#00000066",
		"panel_dark" = "#00000044",
		"button_hover" = "rgba(123, 83, 83, 0.3)"
	)

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<style>
			body {
				font-family: Verdana, Arial, sans-serif;
				background: #100000 url('flowers.png') repeat;
				color: [theme["text"]];
				margin: 0;
				padding: 0;
			}
			.header {
				text-align: center;
				padding: 5px;
				background: [theme["panel_dark"]];
				border-bottom: 2px solid [theme["border"]];
			}
			.header h1 {
				margin: 0;
				color: [theme["text"]];
				font-size: 1.0em;
			}
			.header p {
				margin: 2px 0;
				font-size: 0.65em;
				color: [theme["label"]];
			}
			.tabs {
				display: flex;
				background: [theme["panel"]];
				border-bottom: 1px solid [theme["border"]];
				padding: 0;
				margin: 0;
			}
			.tab {
				flex: 1;
				padding: 6px 10px;
				text-align: center;
				background: [theme["panel_dark"]];
				border-right: 1px solid [theme["border"]];
				color: [theme["label"]];
				cursor: pointer;
				text-decoration: none;
				display: block;
				font-size: 0.7em;
			}
			.tab:hover {
				background: [theme["button_hover"]];
				color: [theme["text"]];
			}
			.tab.active {
				background: [theme["button_hover"]];
				color: [theme["text"]];
			}
			.tab-content {
				padding: 8px;
				display: none;
			}
			.tab-content.active {
				display: block;
			}
			.loadouts-grid {
				display: grid;
				grid-template-columns: repeat(2, 1fr);
				gap: 5px;
			}
			.loadout-slot {
				background: [theme["panel_dark"]];
				border: 1px solid [theme["border"]];
				padding: 6px;
			}
			.loadout-slot.required {
				border-color: [theme["border"]];
			}
			.loadout-slot:hover {
				border-color: [theme["border"]];
			}
			.slot-header {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 4px;
				padding-bottom: 3px;
				border-bottom: 1px solid [theme["border"]];
			}
			.slot-number {
				font-weight: bold;
				color: [theme["text"]];
				font-size: 0.7em;
			}
			.slot-required {
				background: [theme["border"]];
				color: [theme["bg"]];
				padding: 1px 5px;
				font-size: 0.6em;
				font-weight: bold;
			}
			.slot-cost {
				background: #4CAF50;
				color: #1C0000;
				padding: 1px 5px;
				font-size: 0.65em;
				font-weight: bold;
			}
			.loadout-display {
				display: flex;
				align-items: flex-start;
				margin-bottom: 4px;
			}
			.loadout-info {
				flex: 1;
			}
			.loadout-name {
				font-weight: bold;
				color: [theme["text"]];
				margin-bottom: 2px;
				font-size: 0.75em;
			}
			.loadout-desc {
				font-size: 0.65em;
				color: [theme["label"]];
				line-height: 1.2;
			}
			.btn {
				padding: 3px 6px;
				border: 1px solid [theme["border"]];
				background: [theme["panel_dark"]];
				color: [theme["text"]];
				cursor: pointer;
				font-family: Verdana, Arial, sans-serif;
				font-size: 0.6em;
				text-decoration: none;
				display: inline-block;
				margin: 1px;
			}
			.btn:hover {
				background: [theme["button_hover"]];
				border-color: [theme["border"]];
			}
			.btn-select {
				background: rgba(76, 175, 80, 0.3);
				border-color: #4CAF50;
				color: #4CAF50;
			}
			.btn-select:hover {
				background: rgba(76, 175, 80, 0.5);
			}
			.btn-clear {
				background: rgba(244, 67, 54, 0.3);
				border-color: #f44336;
				color: #f44336;
			}
			.btn-clear:hover {
				background: rgba(244, 67, 54, 0.5);
			}
			.btn-customize {
				background: rgba(33, 150, 243, 0.3);
				border-color: #2196F3;
				color: #2196F3;
			}
			.btn-customize:hover {
				background: rgba(33, 150, 243, 0.5);
			}
			.btn-color {
				background: rgba(156, 39, 176, 0.3);
				border-color: #9C27B0;
				color: #9C27B0;
			}
			.btn-color:hover {
				background: rgba(156, 39, 176, 0.5);
			}
			.empty-slot {
				text-align: center;
				padding: 8px;
				color: [theme["label"]];
				font-style: italic;
				font-size: 0.7em;
			}
			.actions {
				margin-top: 4px;
				display: flex;
				flex-wrap: wrap;
				gap: 3px;
			}
			.statpack-section {
				background: [theme["button_hover"]];
				border: 2px solid [theme["border"]];
				padding: 10px;
				margin-bottom: 10px;
			}
			.statpack-section h2 {
				margin: 0 0 6px 0;
				color: [theme["text"]];
				font-size: 1.05em;
				border-bottom: 1px solid [theme["border"]];
				padding-bottom: 6px;
			}
			.statpack-current {
				background: [theme["panel_dark"]];
				padding: 8px;
				margin: 6px 0;
				border: 1px solid [theme["border"]];
			}
			.statpack-name {
				font-weight: bold;
				color: [theme["text"]];
				font-size: 0.95em;
				margin-bottom: 4px;
			}
			.statpack-desc {
				color: [theme["label"]];
				line-height: 1.3;
				margin-bottom: 5px;
				font-size: 0.8em;
			}
			.statpack-stats {
				color: #4CAF50;
				font-style: italic;
				font-size: 0.75em;
			}
		</style>
		<script>
			function showTab(tabName) {
				// Hide all tab contents
				var contents = document.getElementsByClassName('tab-content');
				for(var i = 0; i < contents.length; i++) {
					contents\[i\].classList.remove('active');
				}

				// Remove active from all tabs
				var tabs = document.getElementsByClassName('tab');
				for(var i = 0; i < tabs.length; i++) {
					tabs\[i\].classList.remove('active');
				}

				// Show selected tab content
				document.getElementById(tabName).classList.add('active');
				event.target.classList.add('active');

				// Save current tab to cookie
				document.cookie = 'loadout_menu_tab=' + tabName + '; path=/';
			}

			// Restore active tab on load
			window.onload = function() {
				var cookies = document.cookie.split(';');
				var activeTab = 'loadout';
				for(var i = 0; i < cookies.length; i++) {
					var cookie = cookies\[i\].trim();
					if(cookie.indexOf('loadout_menu_tab=') == 0) {
						activeTab = cookie.substring('loadout_menu_tab='.length);
						break;
					}
				}

				// Activate the saved tab
				if(activeTab && document.getElementById(activeTab)) {
					var contents = document.getElementsByClassName('tab-content');
					for(var i = 0; i < contents.length; i++) {
						contents\[i\].classList.remove('active');
					}

					var tabs = document.getElementsByClassName('tab');
					for(var i = 0; i < tabs.length; i++) {
						tabs\[i\].classList.remove('active');
						if(tabs\[i\].getAttribute('onclick') && tabs\[i\].getAttribute('onclick').indexOf(activeTab) >= 0) {
							tabs\[i\].classList.add('active');
						}
					}

					document.getElementById(activeTab).classList.add('active');
				}
			};
		</script>
		<body>
			<div class="header">
				<h1>Character Customization</h1>
				<p>Configure all your character features</p>
				<div style="margin-top: 10px;">
					<a class='btn' href='byond://?src=\ref[src];undo_action=undo' style='font-size: 0.85em;'>⟲ Undo Last Change ([customization_history.len] available)</a>
				</div>
			</div>

			<div class="tabs">
				<a class="tab active" onclick="showTab('loadout')">Loadout Items</a>
			</div>
			"}

	html += {"

		<div id="loadout" class="tab-content">
			<h2 style='color: [theme["text"]]; margin: 0 0 10px 0; font-size: 1.1em;'>Loadout Selection</h2>
	"}

	// Calculate point costs for loadout
	var/total_points = get_base_points()
	var/loadout_spent = get_loadout_points_spent()

	// Loadout uses its own point pool (not shared with languages)
	var/loadout_remaining = total_points - loadout_spent

	html += {"
			<div class='statpack-section'>
				<div style='font-size: 0.85em; margin-bottom: 5px;'>
					<span style='color: #4CAF50;'>Available Points: [loadout_remaining]</span> |
					<span style='color: [theme["text"]];'>Spent (Loadout): [loadout_spent]</span> /
					<span>Total Points: [total_points]</span>
				</div>
				<div style='background: rgba(123, 83, 83, 0.2); border: 1px solid [theme["border"]]; padding: 8px; margin-top: 8px; font-size: 0.7em;'>
					<div style='font-weight: bold; color: [theme["text"]]; margin-bottom: 4px;'>⚠ Loadout Item Modifications:</div>
					<div style='color: [theme["label"]]; line-height: 1.4;'>
						<b>ARMOR:</b> Set to armour minor protection (15 armor to all damage types) • Crit prevention removed • Armor class set to Light<br>
						<b>WEAPONS:</b> Damage reduced by 30% • Weapon defense reduced by 50%<br>
						<b>ALL ITEMS:</b> Sell price set to 0
					</div>
				</div>
			</div>
			<div style='display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px;'>
	"}

	// Generate loadout slots with original styling
	for(var/i = 1 to 10)
		var/slot_var = "loadout[i]"
		var/datum/loadout_item/current_item = vars[slot_var]
		var/custom_name = vars["loadout_[i]_name"]
		var/custom_desc = vars["loadout_[i]_desc"]
		var/item_color = vars["loadout_[i]_hex"]

		html += "<div class='loadout-slot'>"
		html += "<div class='slot-header'>"
		html += "<span class='slot-number'>Slot [i]</span>"

		if(current_item && current_item.point_cost)
			html += "<span class='slot-cost'>[current_item.point_cost] Points</span>"

		html += "</div>"

		if(current_item)
			// Item is selected - show with icon
			var/obj/item/sample = current_item.item_path
			var/icon_file = initial(sample.icon)
			var/icon_state = initial(sample.icon_state)
			var/item_desc = initial(sample.desc)

			html += "<div style='display: flex; align-items: center; margin-bottom: 6px;'>"
			html += "<div style='width: 48px; height: 48px; background: rgba(0,0,0,0.6); border: 1px solid #444; margin-right: 8px; display: flex; align-items: center; justify-content: center;'>"

			// Use the item's icon with caching
			if(icon_file && icon_state)
				var/cache_key = "[icon_file]_[icon_state]"
				if(!(cache_key in GLOB.cached_loadout_icons))
					// Prevent cache from growing too large
					if(GLOB.cached_loadout_icons.len >= MAX_ICON_CACHE_SIZE)
						GLOB.cached_loadout_icons.Cut(1, 50) // Remove oldest 50 entries
					GLOB.cached_loadout_icons[cache_key] = icon(icon_file, icon_state)
				user << browse_rsc(GLOB.cached_loadout_icons[cache_key], "loadout_icon_[i].png")
				html += "<img src='loadout_icon_[i].png' style='max-width: 46px; max-height: 46px;' />"

			html += "</div>"
			html += "<div style='flex: 1;'>"
			html += "<div class='loadout-name'>[custom_name ? custom_name : current_item.name]</div>"
			html += "<div class='loadout-desc'>[custom_desc ? custom_desc : (item_desc ? item_desc : current_item.description)]</div>"

			if(custom_name || custom_desc)
				html += "<div style='margin-top: 3px; font-size: 0.7em; color: [theme["label"]];'>✎ Customized</div>"

			if(item_color)
				var/color_hex = clothing_color2hex(item_color)
				html += "<div style='margin-top: 3px; font-size: 0.7em; display: flex; align-items: center;'><span style='color: [color_hex];'>●</span> <span style='color: [theme["label"]]; margin-left: 3px;'>Color: [item_color]</span></div>"

			html += "</div>"
			html += "</div>"

			html += "<div class='actions'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];loadout_action=item;slot=[i]'>Change Item</a>"
			html += "<a class='btn btn-customize' href='byond://?src=\ref[src];loadout_action=rename;slot=[i]'>Rename</a>"
			html += "<a class='btn btn-customize' href='byond://?src=\ref[src];loadout_action=describe;slot=[i]'>Description</a>"
			html += "<a class='btn btn-color' href='byond://?src=\ref[src];loadout_action=color;slot=[i]'>Color</a>"
			html += "<a class='btn btn-clear' href='byond://?src=\ref[src];loadout_action=clear;slot=[i]'>Clear</a>"
			html += "</div>"
		else
			html += "<div class='empty-slot'>"
			html += "Empty Slot<br><br>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];loadout_action=item;slot=[i]'>Select Item</a>"
			html += "</div>"

		html += "</div>"

	html += {"
			</div>
		</div>

		<div id="languages" class="tab-content">
			<h2 style='color: [theme["text"]]; margin: 0 0 20px 0;'>📜 Additional Language Selection 📜</h2>
	"}


	html += {"
		</div>

		<div style='margin-top: 20px; padding: 10px; background: [theme["panel"]]; border: 1px solid [theme["border"]];'>
			<div style='font-weight: bold; margin-bottom: 8px; color: [theme["text"]];'>📋 LOADOUT PRESETS</div>
			<div style='display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px;'>
				<div style='padding: 8px; background: [theme["panel_dark"]]; border: 1px solid [theme["border"]];'>
					<div style='font-weight: bold; margin-bottom: 3px;'>Preset 1</div>
					<div style='font-size: 0.75em; color: [theme["label"]]; margin-bottom: 5px; min-height: 30px;'>[get_preset_summary(1)]</div>
					<a class='btn' href='byond://?src=\ref[src];preset_action=save;slot=1' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>💾 Save</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=load;slot=1' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>📂 Load</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=clear;slot=1' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>🗑️ Clear</a>
				</div>
				<div style='padding: 8px; background: [theme["panel_dark"]]; border: 1px solid [theme["border"]];'>
					<div style='font-weight: bold; margin-bottom: 3px;'>Preset 2</div>
					<div style='font-size: 0.75em; color: [theme["label"]]; margin-bottom: 5px; min-height: 30px;'>[get_preset_summary(2)]</div>
					<a class='btn' href='byond://?src=\ref[src];preset_action=save;slot=2' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>💾 Save</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=load;slot=2' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>📂 Load</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=clear;slot=2' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>🗑️ Clear</a>
				</div>
				<div style='padding: 8px; background: [theme["panel_dark"]]; border: 1px solid [theme["border"]];'>
					<div style='font-weight: bold; margin-bottom: 3px;'>Preset 3</div>
					<div style='font-size: 0.75em; color: [theme["label"]]; margin-bottom: 5px; min-height: 30px;'>[get_preset_summary(3)]</div>
					<a class='btn' href='byond://?src=\ref[src];preset_action=save;slot=3' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>💾 Save</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=load;slot=3' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>📂 Load</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=clear;slot=3' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>🗑️ Clear</a>
				</div>
			</div>
		</div>

	</body>
	</html>
	"}

	return html

/datum/preferences/Topic(href, href_list)
	if(href_list["close"])
		return
	. = ..()

	// Handle loadout item selection from icon menu
	/*if(href_list["select_loadout_item"])
		if(!temp_loadout_selection)
			return

		var/item_id = href_list["select_loadout_item"]
		var/slot = text2num(href_list["slot"])
		var/list/selection_data = temp_loadout_selection

		var/list/items = selection_data["items"]
		var/datum/loadout_item/selected = items[item_id]

		if(!selected || !slot)
			temp_loadout_selection = null
			usr << browse(null, "window=loadout_selection")
			return

		var/slot_var = "loadout[slot]"

		// Check if this item is already selected in another slot
		for(var/i = 1 to 10)
			if(i == slot)
				continue
			var/datum/loadout_item/other_item = vars["loadout[i]"]
			if(other_item && other_item.type == selected.type)
				to_chat(usr, span_warning("This item is already selected in slot [i]! Each item can only be selected once."))
				temp_loadout_selection = null
				usr << browse(null, "window=loadout_select")
				return

		// Check point cost against loadout pool (not shared with languages)
		if(selected.point_cost)
			var/total_points = get_base_points()
			var/spent_points = 0

			// Calculate current loadout spent (excluding this slot if changing)
			for(var/i = 1 to 10)
				if(i == slot)
					continue
				var/datum/loadout_item/other_slot = vars["loadout[i]"]
				if(other_slot && other_slot.point_cost)
					spent_points += other_slot.point_cost

			if(spent_points + selected.point_cost > total_points)
				to_chat(usr, span_warning("Not enough points! Need [selected.point_cost], but only have [total_points - spent_points] remaining."))
				temp_loadout_selection = null
				usr << browse(null, "window=loadout_select")
				return

		vars[slot_var] = selected
		to_chat(usr, span_notice("Selected [selected.name] for slot [slot]."))

		temp_loadout_selection = null
		usr << browse(null, "window=loadout_select")
		open_loadout_menu(usr)
		return*/

	// Handle preset actions
	if(href_list["preset_action"])
		var/action = href_list["preset_action"]
		var/slot = text2num(href_list["slot"])

		if(!slot || slot < 1 || slot > 3)
			return

		switch(action)
			if("save")
				if(save_preset(slot))
					save_character() // Persist preset to disk
					to_chat(usr, span_notice("Saved current setup to Preset [slot]!"))
					open_loadout_menu(usr)
				else
					to_chat(usr, span_warning("Failed to save preset."))
			if("load")
				if(load_preset(slot))
					save_character() // Persist loaded state to disk
					to_chat(usr, span_notice("Loaded Preset [slot]!"))
					open_loadout_menu(usr)
				else
					to_chat(usr, span_warning("Preset [slot] is empty or invalid."))
			if("clear")
				if(clear_preset(slot))
					save_character() // Persist cleared preset to disk
					to_chat(usr, span_notice("Cleared Preset [slot]."))
					open_loadout_menu(usr)
				else
					to_chat(usr, span_warning("Failed to clear preset."))
		return

	// Handle undo action
	if(href_list["undo_action"])
		if(href_list["undo_action"] == "undo")
			if(undo_last_change())
				to_chat(usr, span_notice("Undid last change."))
				open_loadout_menu(usr)
			else
				to_chat(usr, span_warning("No more changes to undo!"))
		return

	if(href_list["loadout_action"])
		// Save state before any loadout change
		save_to_history()

		var/action = href_list["loadout_action"]
		var/slot = text2num(href_list["slot"])

		if(!slot || slot < 1 || slot > 10)
			return

		var/slot_var = "loadout[slot]"

		switch(action)
			if("item")
				open_loadout_menu_selection(usr, slot)
				return

			if("clear")
				vars[slot_var] = null
				vars["loadout_[slot]_name"] = null
				vars["loadout_[slot]_desc"] = null
				vars["loadout_[slot]_hex"] = null
				open_loadout_menu(usr)
				return

			if("rename")
				var/datum/loadout_item/current = vars[slot_var]
				if(!current)
					return

				var/new_name = browser_input_text(usr, "Enter a custom name for this item (leave blank to use default):", "Rename Item", vars["loadout_[slot]_name"], MAX_NAME_LEN, multiline = TRUE)

				if(new_name != null) // Allow empty string to clear
					vars["loadout_[slot]_name"] = new_name
					open_loadout_menu(usr)
				return

			if("describe")
				var/datum/loadout_item/current = vars[slot_var]
				if(!current)
					return

				var/new_desc = browser_input_text(usr, "Enter a custom description for this item (leave blank to use default):", "Describe Item", vars["loadout_[slot]_desc"], max_length = 500, multiline = TRUE)

				if(new_desc != null) // Allow empty string to clear
					vars["loadout_[slot]_desc"] = new_desc
					open_loadout_menu(usr)
				return

			if("color")
				var/datum/loadout_item/current = vars[slot_var]
				if(!current)
					return

				// Use dye bin colors for more variety
				var/list/color_choices = list("None")
				for(var/color_name in GLOB.colorlist)
					color_choices += color_name

				var/new_color = browser_input_list(usr, "Choose a color for this item:", "Item Color", color_choices, vars["loadout_[slot]_hex"])

				if(new_color)
					if(new_color == "None")
						vars["loadout_[slot]_hex"] = null
					else if(new_color == "CUSTOM")
						var/current_color = vars["loadout_[slot]_hex"]||"#FFFFFF"
						var/newer_color = input(usr, "Select color:", "Custom Color", current_color) as color|null
						if(newer_color)
							vars["loadout_[slot]_hex"] = sanitize_hexcolor(newer_color, include_crunch=1)
				else
					// Look up the hex value from GLOB.colorlist
					vars["loadout_[slot]_hex"] = GLOB.colorlist[new_color]
					open_loadout_menu(usr)
				return
