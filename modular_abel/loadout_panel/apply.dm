/proc/apply_panel_loadout(mob/user)
	if(!user?.mind || !user.client?.prefs)
		return
	if(user.mind.panel_loadout_applied)
		return
	var/datum/preferences/prefs = user.client.prefs
	if(!length(prefs.panel_loadout_items))
		return
	user.mind.panel_loadout_applied = TRUE
	for(var/path_str in prefs.panel_loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		if(!item)
			continue
		var/atom/item_path = item.item_path
		var/entry_name = initial(item_path.name)
		while(entry_name in user.mind.special_items)
			entry_name = "[entry_name] "
		user.mind.special_items[entry_name] = item.item_path

/obj/structure/try_fetch_special_item(mob/user)
	if(user.mind && isliving(user))
		apply_panel_loadout(user)
	return ..()
