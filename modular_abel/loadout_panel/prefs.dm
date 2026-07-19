/datum/loadout_item
	var/panel_donator = FALSE

/datum/preferences
	var/list/panel_loadout_items = list()
	var/datum/loadout_panel/loadout_panel_ui

/datum/mind
	var/panel_loadout_applied = FALSE

/datum/preferences/proc/get_panel_loadout_size(mob/user)
	var/base_slots = 3
	var/client/C = user?.client || parent
	switch(C?.patreon?.access_rank)
		if(ACCESS_THANKS_RANK)
			return 7
		if(ACCESS_ASSISTANT_RANK)
			return 11
		if(ACCESS_COMMAND_RANK)
			return 17
		if(ACCESS_TRAITOR_RANK)
			return 21
		if(ACCESS_NUKIE_RANK)
			return 27
	return base_slots

/datum/preferences/proc/clean_panel_loadout(mob/user)
	var/list/valid_items = list()
	var/has_invalid_items = FALSE
	for(var/path_str in panel_loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		if(!item)
			has_invalid_items = TRUE
			continue
		if(item.loadout_flags & LOADOUT_FLAG_NO_EQUIP)
			has_invalid_items = TRUE
			continue
		valid_items += path_str
	if(has_invalid_items)
		panel_loadout_items = valid_items
		if(user)
			to_chat(user, "Твой лодаут был очищен из-за изменений в предметах.")
	if(length(panel_loadout_items) > get_panel_loadout_size(user))
		panel_loadout_items = list()
		if(user)
			to_chat(user, "Размер твоего лодаута был изменён и его пришлось сбросить!")

/datum/preferences/proc/open_donor_loadout(mob/user)
	if(!loadout_panel_ui)
		loadout_panel_ui = new(src)
	loadout_panel_ui.ui_interact(user)

/datum/preferences/load_character(slot)
	. = ..()
	if(!.)
		return
	if(!path || !fexists(path))
		return
	var/savefile/S = new /savefile(path)
	if(!S)
		return
	S.cd = "/character[default_slot]"
	S["panel_loadout_items"] >> panel_loadout_items
	if(!islist(panel_loadout_items))
		panel_loadout_items = list()

/datum/preferences/save_character()
	. = ..()
	if(!.)
		return
	if(!path)
		return
	var/savefile/S = new /savefile(path)
	if(!S)
		return
	S.cd = "/character[default_slot]"
	if(!islist(panel_loadout_items))
		panel_loadout_items = list()
	WRITE_FILE(S["panel_loadout_items"], panel_loadout_items)
