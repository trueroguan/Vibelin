/datum/asset/spritesheet_batched/loadout_panel_icons
	name = "loadout_panel_icons"
	ignore_dir_errors = TRUE

/datum/asset/spritesheet_batched/loadout_panel_icons/create_spritesheets()
	var/list/ids = list()
	for(var/path in GLOB.loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[path]
		var/atom/movable/typepath = item.item_path
		if(!typepath)
			continue
		var/icon = item.ui_icon
		var/icon_state = item.ui_icon_state
		if(!icon || !icon_state)
			continue
		var/id = sanitize_css_class_name("[typepath]")
		if(id in ids)
			continue
		ids += id
		var/datum/universal_icon/new_icon = uni_icon(icon, icon_state)
		new_icon.scale(128, 128)
		insert_icon(id, new_icon)
