/datum/preferences/var/abel_preferences_initial_tab = "identity"
/datum/preferences/var/abel_preferences_open_sequence = 0

/datum/preferences/show_choices(mob/user, tabchoice)
	if(!user || !user.client)
		return
	if(slot_randomized)
		load_character(default_slot)
		slot_randomized = FALSE

	abel_preferences_initial_tab = (tabchoice == 1 || current_tab == 1) ? "game" : "identity"
	abel_preferences_open_sequence++
	current_tab = (abel_preferences_initial_tab == "game") ? 1 : 0
	build_and_show_menu(user)
	current_tab = 0

/datum/preferences/build_and_show_menu(mob/user)
	if(!user?.client)
		return

	user.client.acquire_dpi()
	winshow(user, "stonekeep_prefwin", FALSE)
	user << browse(null, "window=preferences_browser")

	preload_preferences_tgui_assets(user)

	ui_interact(user)

/datum/preferences/update_menu_data(mob/user, list/fields_to_update)
	SStgui.update_uis(src)

/datum/preferences/proc/preload_preferences_tgui_assets(mob/user)
	if(!user?.client)
		return

	var/client/C = user.client
	get_asset_datum(/datum/asset/simple/tgui).send(C)
	get_asset_datum(/datum/asset/simple/namespaced/fontawesome).send(C)
	get_asset_datum(/datum/asset/simple/namespaced/tgfont).send(C)
	get_asset_datum(/datum/asset/simple/namespaced/fonts).send(C)
	get_asset_datum(/datum/asset/json/icon_ref_map).send(C)
	C.browse_queue_flush()

/datum/preferences/ui_state(mob/user)
	return GLOB.always_state

/datum/preferences/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PreferencesMenu", "Preferences", 1024, 650)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/preferences/ui_data(mob/user)
	var/list/data = list()

	var/datum/faith/selected_faith
	if(selected_patron)
		selected_faith = GLOB.faith_list[selected_patron.associated_faith]

	var/high_job = "None"
	for(var/job_type in job_preferences)
		if(job_preferences[job_type] != JP_HIGH)
			continue
		high_job = "[job_type]"
		break

	var/gender_name = "Other"
	var/gender_short = "X"
	switch(gender)
		if(MALE)
			gender_name = "Masculine"
			gender_short = "M"
		if(FEMALE)
			gender_name = "Feminine"
			gender_short = "F"
		if(PLURAL)
			gender_name = "Plural"
			gender_short = "P"

	var/patron_name = "None"
	if(selected_patron)
		patron_name = selected_patron.display_name ? selected_patron.display_name : selected_patron.name

	var/list/age_options = list()
	var/age_index = 1
	if(pref_species && length(pref_species.possible_ages))
		var/current_index = 1
		for(var/possible_age in pref_species.possible_ages)
			age_options += "[possible_age]"
			if(possible_age == age)
				age_index = current_index
			current_index++
	else
		age_options += "[age || AGE_ADULT]"

	var/list/loadout_slots = list()
	for(var/slot_number in 1 to 3)
		var/loadout_name = "None"
		var/loadout_ref = _get_loadout_slot(slot_number)
		if(loadout_ref)
			var/loadout_path = istext(loadout_ref) ? text2path(loadout_ref) : loadout_ref
			var/datum/loadout_item/loadout_item = GLOB.loadout_items[loadout_path]
			if(loadout_item)
				loadout_name = loadout_item.name
		loadout_slots += list(list(
			"slot" = slot_number,
			"name" = loadout_name,
		))

	data["real_name"] = real_name || "Unnamed"
	data["initial_tab"] = abel_preferences_initial_tab
	data["open_sequence"] = abel_preferences_open_sequence
	data["species_name"] = pref_species ? pref_species.name : "Human"
	data["gender"] = gender_name
	data["gender_short"] = gender_short
	data["default_slot"] = default_slot

	data["patron_name"] = patron_name
	data["faith_name"] = selected_faith ? selected_faith.name : "None"
	data["high_job"] = high_job
	data["age"] = age
	data["age_index"] = age_index
	data["age_min"] = 1
	data["age_max"] = max(1, length(age_options))
	data["age_options"] = age_options
	data["pronouns"] = pronouns || "None"
	data["domhand"] = (domhand == 1) ? "Left" : "Right"
	data["ancestry_label"] = pref_species?.skin_tone_wording || "Ancestry"

	data["erp_enabled"] = !!erp_enabled
	data["headshot"] = is_valid_headshot_link(null, headshot_link, TRUE) ? headshot_link : null

	data["culture_name"] = culture ? culture::name : "None"
	data["voice_type"] = voice_type || "Default"
	data["voice_color"] = voice_color ? "#[voice_color]" : "#a0a0a0"
	data["selected_accent"] = selected_accent || "None"
	data["family"] = family || "None"
	data["gender_pref"] = gender_choice || "Any"
	data["spouse"] = setspouse || "None"

	data["loadouts"] = loadout_slots
	data["triumphs"] = triumphs
	data["special_role"] = next_special_trait ? "[next_special_trait]" : "None"
	data["player_quality"] = user?.ckey ? get_playerquality(user.ckey, text = TRUE) : "Unknown"

	data["game_prefs"] = list(
		"hotkeys" = !!hotkeys,
		"buttons_locked" = !!buttons_locked,
		"see_chat_non_mob" = !!see_chat_non_mob,
		"tgui_fancy" = !!tgui_fancy,
		"tgui_lock" = !!tgui_lock,
		"windowflashing" = !!windowflashing,
		"lobby_music" = !!(toggles & SOUND_LOBBY),
		"hear_midis" = !!(toggles & SOUND_MIDI),
		"ambientocclusion" = !!ambientocclusion,
		"auto_fit_viewport" = !!auto_fit_viewport,
		"widescreenpref" = !!widescreenpref,
		"allow_midround_antag" = !!(toggles & MIDROUND_ANTAG),
		"pixel_size" = "[pixel_size]",
		"scaling_method" = "[scaling_method]",
	)

	return data

/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui?.user || usr
	if(!user)
		return FALSE

	switch(action)
		if("pref")
			if(!islist(params) || !params["preference"])
				return FALSE

			var/list/href_list = list()
			for(var/key in params)
				href_list[key] = params[key]

			if(href_list["preference"] == "tab")
				current_tab = text2num("[href_list["tab"]]")
				return TRUE

			var/handled = process_link(user, href_list)
			if(href_list["preference"] == "finished")
				ui?.close(FALSE)
			return handled || TRUE

		if("set_age")
			if(!islist(params))
				return FALSE

			var/new_age = params["value"]
			if(!isnum(new_age))
				new_age = text2num("[new_age]")
			if(!isnum(new_age))
				return FALSE

			if(!pref_species || !length(pref_species.possible_ages))
				return FALSE

			var/age_index = clamp(round(new_age), 1, length(pref_species.possible_ages))
			var/selected_age = pref_species.possible_ages[age_index]
			if(age != selected_age)
				age = selected_age
				reset_jobs(user)
			return TRUE

	return FALSE

/datum/preferences/process_link(mob/user, list/href_list)
	switch(href_list["preference"])
		if("abel_erp_toggle")
			erp_enabled = !erp_enabled
			save_character()
			var/mob/living/carbon/human/H = user
			if(istype(H))
				H.erp_on_spawn_setup()
			to_chat(user, span_notice("Intimacy opt-in [erp_enabled ? "enabled" : "disabled"] for this character (saved to slot)."))
			update_menu_data(user)
			return TRUE
		if("abel_erp_panel")
			var/mob/living/carbon/human/H = user
			if(!istype(H) || !erp_enabled)
				to_chat(user, span_warning("Enable the intimacy opt-in first, in a living body."))
				return TRUE
			H.start_erp_session(H)
			return TRUE
	return ..()
