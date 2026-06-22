/datum/preferences/var/abel_preferences_initial_tab = "identity"
/datum/preferences/var/abel_preferences_open_sequence = 0
/datum/preferences/var/abel_preview_underwear = TRUE
/datum/preferences/var/abel_preview_clothes = TRUE
/datum/preferences/var/abel_preview_dir = SOUTH
/datum/preferences/var/abel_preview_background
/datum/preferences/var/abel_preview_cache
/datum/preferences/var/abel_preview_sig
/datum/preferences/var/abel_ghost_cache
/datum/preferences/var/abel_ghost_rendering = FALSE
/datum/preferences/var/abel_static_sig

GLOBAL_LIST_EMPTY(abel_preview_b64_cache)
GLOBAL_LIST_EMPTY(abel_turf_thumb_cache)

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

	validate_customizer_entries()
	abel_static_sig = "[pref_species?.type]-[gender]"
	abel_build_preview(user, json_encode(abel_build_features_data()))
	ui_interact(user)

/datum/preferences/update_menu_data(mob/user, list/fields_to_update)
	var/new_static_sig = "[pref_species?.type]-[gender]"
	if(new_static_sig != abel_static_sig)
		abel_static_sig = new_static_sig
		update_static_data(user)
	SStgui.update_uis(src)
	abel_refresh_preview(user)

/datum/preferences/ui_state(mob/user)
	return GLOB.always_state

/datum/preferences/ui_static_data(mob/user)
	. = list()
	.["background_options"] = abel_background_options()
	.["thumbs"] = abel_thumbnail_catalog()

/datum/preferences/proc/abel_thumbnail_catalog()
	. = list()
	if(!pref_species)
		return
	for(var/customizer_type in pref_species.customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer)
			continue
		for(var/choice_type in customizer.customizer_choices)
			var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(choice_type)
			if(!choice || !LAZYLEN(choice.sprite_accessories))
				continue
			for(var/accessory_type in choice.sprite_accessories)
				var/key = "[accessory_type]"
				if(.[key])
					continue
				var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
				if(accessory)
					.[key] = accessory.abel_thumbnail()
	for(var/datum/sprite_accessory/undie in pref_species.get_spec_undies_list(gender))
		.[undie.name] = undie.abel_thumbnail()

/datum/preferences/reset_jobs(mob/user, silent = FALSE)
	job_preferences = list()
	if(!silent)
		to_chat(user, "<font color='red'>Classes reset.</font>")
	if(winget(user, "mob_occupation", "is-visible") == "true")
		set_choices(user)

/datum/preferences/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PreferencesMenu", "Character Setup", 1180, 760)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/preferences/proc/abel_selectable_ages()
	. = list()
	if(!pref_species)
		return
	for(var/possible_age in pref_species.possible_ages)
		if(possible_age == AGE_CHILD)
			continue
		. += possible_age

/datum/preferences/proc/abel_underwear_options()
	. = list(list("name" = "Nude", "value" = "Nude"))
	if(!pref_species)
		return
	for(var/datum/sprite_accessory/undie in pref_species.get_spec_undies_list(gender))
		. += list(list("name" = undie.name, "value" = undie.name))

/datum/preferences/proc/abel_preview_job()
	for(var/job_type in job_preferences)
		if(job_preferences[job_type] != JP_HIGH)
			continue
		return SSjob.GetJob(job_type)
	return null

/datum/preferences/proc/abel_refresh_preview(mob/user)
	set waitfor = FALSE
	var/previous = abel_preview_sig
	abel_build_preview(user, json_encode(abel_build_features_data()))
	if(abel_preview_sig != previous)
		SStgui.update_uis(src)

/datum/preferences/proc/abel_preview_extra_sig()
	return ""

/datum/preferences/proc/abel_render_preview_icon(datum/job/preview_job, datum/outfit/preview_outfit, preview_dir, bg_type)
	var/mob/living/carbon/human/dummy/body = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	if(!body)
		return null
	apply_prefs_to(body, TRUE)
	if(preview_job)
		body.dna.species.pre_equip_species_outfit(preview_job, body, TRUE)
	if(preview_outfit)
		body.equipOutfit(preview_outfit, TRUE)
	body.update_inv_hands(hide_experimental = TRUE)
	body.update_inv_belt(hide_experimental = TRUE)
	body.update_inv_back(hide_experimental = TRUE)
	body.update_inv_head(hide_nonstandard = TRUE)
	body.setDir(preview_dir)
	var/icon/character = getFlatIcon(body, defdir = preview_dir)
	body.update_inv_hands()
	body.update_inv_belt()
	body.update_inv_back()
	body.update_inv_head()
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	if(!character)
		return null
	var/icon/out_icon = icon('icons/effects/effects.dmi', "nothing")
	out_icon.Insert(character, dir = SOUTH)
	if(bg_type)
		var/turf/bg = bg_type
		var/icon/backdrop = icon(initial(bg.icon), initial(bg.icon_state))
		backdrop.Blend(out_icon, ICON_OVERLAY)
		return backdrop
	return out_icon

/datum/preferences/proc/abel_build_preview(mob/user, features_json)
	if(!pref_species)
		return null

	var/datum/job/preview_job = abel_preview_clothes ? abel_preview_job() : null
	var/datum/outfit/preview_outfit
	if(preview_job)
		preview_outfit = (gender == FEMALE && preview_job.outfit_female) ? preview_job.outfit_female : preview_job.outfit

	var/bg_type = abel_preview_background ? text2path(abel_preview_background) : null
	if(bg_type && !ispath(bg_type, /turf))
		bg_type = null

	var/sig = list2params(list(
		"sp" = "[pref_species.type]",
		"g" = gender,
		"u" = underwear,
		"uc" = "[underwear_color]",
		"su" = abel_preview_underwear,
		"sc" = abel_preview_clothes,
		"d" = abel_preview_dir,
		"bg" = bg_type ? "[bg_type]" : "none",
		"j" = preview_job ? "[preview_job.type]" : "none",
		"o" = preview_outfit ? "[preview_outfit]" : "none",
		"sk" = skin_tone,
		"a" = age,
		"x" = abel_preview_extra_sig(),
		"f" = features_json,
	))

	var/cached = GLOB.abel_preview_b64_cache[sig]
	if(cached)
		abel_preview_cache = cached
		abel_preview_sig = sig
		return cached

	var/saved_underwear = underwear
	if(!abel_preview_underwear)
		underwear = "Nude"
	var/icon/flat = abel_render_preview_icon(preview_job, preview_outfit, abel_preview_dir, bg_type)
	underwear = saved_underwear
	if(!flat)
		return abel_preview_cache

	var/b64 = icon2base64(flat)
	if(!b64)
		return abel_preview_cache

	abel_preview_cache = "data:image/png;base64,[b64]"
	abel_preview_sig = sig
	GLOB.abel_preview_b64_cache[sig] = abel_preview_cache
	return abel_preview_cache

/datum/preferences/proc/abel_build_ghost(customizer_type, acc_type)
	set waitfor = FALSE
	if(!pref_species)
		return
	var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
	if(!entry)
		return
	var/sig = "ghost|[abel_preview_sig]|[customizer_type]|[acc_type]"
	var/cached = GLOB.abel_preview_b64_cache[sig]
	if(cached)
		abel_ghost_cache = cached
		SStgui.update_uis(src)
		return
	if(abel_ghost_rendering)
		return
	abel_ghost_rendering = TRUE
	var/saved_acc = entry.accessory_type
	var/saved_disabled = entry.disabled
	entry.accessory_type = acc_type
	entry.disabled = FALSE
	var/datum/job/preview_job = abel_preview_clothes ? abel_preview_job() : null
	var/datum/outfit/preview_outfit
	if(preview_job)
		preview_outfit = (gender == FEMALE && preview_job.outfit_female) ? preview_job.outfit_female : preview_job.outfit
	var/saved_underwear = underwear
	if(!abel_preview_underwear)
		underwear = "Nude"
	var/icon/flat = abel_render_preview_icon(preview_job, preview_outfit, abel_preview_dir, null)
	underwear = saved_underwear
	entry.accessory_type = saved_acc
	entry.disabled = saved_disabled
	abel_ghost_rendering = FALSE
	if(!flat)
		return
	var/b64 = icon2base64(flat)
	if(!b64)
		return
	abel_ghost_cache = "data:image/png;base64,[b64]"
	GLOB.abel_preview_b64_cache[sig] = abel_ghost_cache
	SStgui.update_uis(src)

/datum/preferences/proc/abel_turf_thumbnail(turf_type)
	if(turf_type in GLOB.abel_turf_thumb_cache)
		return GLOB.abel_turf_thumb_cache[turf_type]
	var/result = ""
	var/turf/T = turf_type
	var/ic = initial(T.icon)
	var/state = initial(T.icon_state)
	if(ic && state)
		var/icon/thumb = icon(ic, state)
		var/b64 = thumb ? icon2base64(thumb) : null
		if(b64)
			result = "data:image/png;base64,[b64]"
	GLOB.abel_turf_thumb_cache[turf_type] = result
	return result

GLOBAL_LIST_EMPTY(abel_background_options_cache)

/datum/preferences/proc/abel_background_options()
	if(length(GLOB.abel_background_options_cache))
		return GLOB.abel_background_options_cache
	var/list/options = list(list("name" = "None", "value" = "none"))
	var/list/seen = list()
	for(var/turf/floor_type as anything in subtypesof(/turf/open/floor))
		var/ic = initial(floor_type.icon)
		var/state = initial(floor_type.icon_state)
		if(!ic || !state)
			continue
		var/dedupe_key = "[ic]:[state]"
		if(dedupe_key in seen)
			continue
		seen[dedupe_key] = TRUE
		var/thumb = abel_turf_thumbnail(floor_type)
		if(!thumb)
			continue
		options += list(list("name" = "[initial(floor_type.name)]", "value" = "[floor_type]", "thumb" = thumb))
		if(length(options) >= 48)
			break
	GLOB.abel_background_options_cache = options
	return options

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

	var/list/selectable_ages = abel_selectable_ages()
	var/list/age_options = list()
	var/age_index = 1
	if(length(selectable_ages))
		var/current_index = 1
		for(var/possible_age in selectable_ages)
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
	data["features"] = abel_build_features_data()
	data["underwear"] = underwear || "Nude"
	data["underwear_color"] = underwear_color ? underwear_color : "#cccccc"
	data["underwear_options"] = abel_underwear_options()
	data["preview_underwear"] = !!abel_preview_underwear
	data["preview_clothes"] = !!abel_preview_clothes
	data["preview_dir"] = abel_preview_dir
	data["background"] = abel_preview_background ? abel_preview_background : "none"
	data["preview_image"] = abel_preview_cache
	data["ghost_image"] = abel_ghost_cache

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
	var/pq_raw = user?.ckey ? get_playerquality(user.ckey, text = TRUE) : "Unknown"
	var/regex/pq_tags = new(@"<[^>]*>", "g")
	var/regex/pq_color = new(@"color:\s*(#[0-9a-fA-F]+)")
	data["player_quality"] = pq_tags.Replace(pq_raw, "")
	data["player_quality_color"] = pq_color.Find(pq_raw) ? pq_color.group[1] : null

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

			var/list/selectable_ages = abel_selectable_ages()
			if(!length(selectable_ages))
				return FALSE

			var/age_index = clamp(round(new_age), 1, length(selectable_ages))
			var/selected_age = selectable_ages[age_index]
			if(age != selected_age)
				age = selected_age
				reset_jobs(user)
			return TRUE

	return FALSE

/datum/preferences/process_link(mob/user, list/href_list)
	switch(href_list["preference"])
		if("abel_customizer")
			validate_customizer_entries()
			handle_customizer_topic(user, href_list)
			update_menu_data(user)
			return TRUE
		if("abel_set_choice")
			var/customizer_type = text2path(href_list["key"])
			var/choice_type = text2path(href_list["choice_type"])
			if(!customizer_type || !choice_type)
				return TRUE
			var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
			var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
			if(!entry || !customizer)
				return TRUE
			if(!(choice_type in customizer.customizer_choices) || choice_type == entry.customizer_choice_type)
				return TRUE
			customizer_entries -= entry
			customizer_entries += customizer.create_customizer_entry(src, choice_type)
			update_menu_data(user)
			return TRUE
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
		if("abel_preview_layer")
			switch(href_list["layer"])
				if("underwear")
					abel_preview_underwear = !abel_preview_underwear
				if("clothes")
					abel_preview_clothes = !abel_preview_clothes
			update_menu_data(user)
			return TRUE
		if("abel_underwear")
			var/choice = href_list["undie"]
			if(choice == "Nude")
				underwear = "Nude"
			else if(pref_species)
				for(var/datum/sprite_accessory/undie in pref_species.get_spec_undies_list(gender))
					if(undie.name == choice)
						underwear = choice
						break
			save_character()
			update_menu_data(user)
			return TRUE
		if("abel_underwear_color")
			var/new_color = input(user, "Choose underwear color", "Underwear", underwear_color) as color|null
			if(new_color)
				underwear_color = new_color
				save_character()
			update_menu_data(user)
			return TRUE
		if("gender")
			gender = (gender == MALE) ? FEMALE : MALE
			if(pref_species && underwear != "Nude")
				var/valid_undie = FALSE
				for(var/datum/sprite_accessory/u in pref_species.get_spec_undies_list(gender))
					if(u.name == underwear)
						valid_undie = TRUE
						break
				if(!valid_undie)
					underwear = pref_species.random_underwear(gender) || "Nude"
			save_character()
			update_menu_data(user)
			return TRUE
		if("abel_preview_rotate")
			var/list/dir_cycle = list(SOUTH, WEST, NORTH, EAST)
			var/idx = dir_cycle.Find(abel_preview_dir)
			if(!idx)
				idx = 1
			if(href_list["rotate"] == "left")
				idx = (idx <= 1) ? length(dir_cycle) : (idx - 1)
			else
				idx = (idx >= length(dir_cycle)) ? 1 : (idx + 1)
			abel_preview_dir = dir_cycle[idx]
			update_menu_data(user)
			return TRUE
		if("abel_preview_background")
			var/bg_choice = href_list["bg"]
			if(bg_choice == "none")
				abel_preview_background = null
			else
				var/bgp = text2path(bg_choice)
				if(ispath(bgp, /turf))
					abel_preview_background = bg_choice
			save_character()
			update_menu_data(user)
			return TRUE
		if("abel_preview_ghost")
			var/ghost_customizer = text2path(href_list["key"])
			var/ghost_acc = text2path(href_list["acc"])
			if(ghost_customizer && ghost_acc)
				abel_build_ghost(ghost_customizer, ghost_acc)
			return TRUE
	return ..()
