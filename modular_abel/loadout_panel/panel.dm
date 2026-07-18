/datum/config_entry/string/boostyurl
	config_entry_value = ""

/datum/loadout_panel
	var/datum/preferences/owner_prefs

/datum/loadout_panel/New(datum/preferences/prefs)
	owner_prefs = prefs

/datum/loadout_panel/Destroy()
	owner_prefs = null
	return ..()

/datum/loadout_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/loadout_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LoadoutPanel")
		ui.open()

/datum/loadout_panel/proc/build_item_entry(datum/loadout_item/item, mob/user)
	var/path_str = "[item.item_path]"
	var/id = sanitize_css_class_name(path_str)
	var/unavailable_reason = null
	if(item.loadout_flags & LOADOUT_FLAG_GIVEAWAY_ONLY)
		unavailable_reason = "Только с розыгрышей."
	else if(item.required_award && !item.is_unlocked_for(user.client))
		unavailable_reason = "Требуется достижение."
	else if((item.loadout_flags & LOADOUT_FLAG_PATREON_LOCKED) && !user.client?.patreon?.is_donator())
		unavailable_reason = "Требуется донат-статус."
	return list(
		"name" = item.name,
		"path" = path_str,
		"icon_class_name" = "loadout_panel_icons128x128 [id]",
		"isDonatorItem" = item.panel_donator,
		"unavailable" = !isnull(unavailable_reason),
		"unavailableReason" = unavailable_reason,
		"requiredTier" = 0,
		"triumphCost" = 0,
	)

/datum/loadout_panel/ui_static_data(mob/user)
	var/list/data = list()
	var/list/categories = list()
	categories["Всё"] = list()
	categories["Донат"] = list()

	for(var/path in GLOB.loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[path]
		if(!item.item_path)
			continue
		if(item.loadout_flags & LOADOUT_FLAG_NO_EQUIP)
			continue
		var/list/entry = build_item_entry(item, user)
		categories["Всё"] += list(entry)
		var/cat = item.panel_donator ? "Донат" : item.ui_category
		if(!(cat in categories))
			categories[cat] = list()
		categories[cat] += list(entry)

	data["categories"] = categories
	data["isDonator"] = !!user.client?.patreon?.is_donator()
	data["donatTier"] = user.client?.patreon?.access_rank || 0
	data["triumphDiscount"] = 0
	data["maxLoadoutSlots"] = owner_prefs.get_panel_loadout_size(user)
	return data

/datum/loadout_panel/ui_data(mob/user)
	var/list/data = list()
	var/list/selected = list()
	for(var/path_str in owner_prefs.panel_loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		if(!item)
			continue
		selected += list(list("path" = path_str, "name" = item.name))
	data["selectedLoadoutItems"] = selected
	data["triumphDiscountUsed"] = 0
	data["curLoadoutSlots"] = length(owner_prefs.panel_loadout_items)
	return data

/datum/loadout_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("add")
			var/path_str = params["item"]
			var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
			if(!item)
				return TRUE
			if(path_str in owner_prefs.panel_loadout_items)
				return TRUE
			if(length(owner_prefs.panel_loadout_items) >= owner_prefs.get_panel_loadout_size(user))
				to_chat(user, "Лимит исчерпан!")
				return TRUE
			if(item.loadout_flags & (LOADOUT_FLAG_NO_EQUIP | LOADOUT_FLAG_GIVEAWAY_ONLY))
				to_chat(user, "Недоступно.")
				return TRUE
			if(item.required_award && !item.is_unlocked_for(user.client))
				to_chat(user, "Требуется достижение.")
				return TRUE
			owner_prefs.panel_loadout_items += path_str
			owner_prefs.save_character()
			return TRUE

		if("remove")
			owner_prefs.panel_loadout_items -= params["item"]
			owner_prefs.save_character()
			return TRUE

		if("clear")
			owner_prefs.panel_loadout_items = list()
			owner_prefs.save_character()
			to_chat(user, "Лодаут очищен!")
			return TRUE

		if("boosty")
			var/boostyurl = CONFIG_GET(string/boostyurl)
			if(boostyurl)
				user << link(boostyurl)
			return TRUE

/datum/loadout_panel/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/loadout_panel_icons)
	)
