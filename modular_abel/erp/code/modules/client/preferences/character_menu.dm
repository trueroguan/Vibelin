/datum/preferences/var/abel_preferences_initial_tab = "identity"
/datum/preferences/var/abel_preferences_open_sequence = 0
/datum/preferences/var/abel_tgui_theme = "grim"
/datum/preferences/var/abel_preview_underwear = TRUE
/datum/preferences/var/abel_preview_clothes = TRUE
/datum/preferences/var/abel_preview_dir = SOUTH
/datum/preferences/var/abel_preview_background
/datum/preferences/var/abel_preview_cache
/datum/preferences/var/abel_preview_sig
/datum/preferences/var/abel_static_sig
/datum/preferences/var/abel_hover_cache
/datum/preferences/var/abel_hover_for
/datum/preferences/var/abel_hover_base
/datum/preferences/var/abel_hover_base_for

GLOBAL_LIST_EMPTY(abel_preview_b64_cache)
GLOBAL_LIST_EMPTY(abel_turf_thumb_cache)
GLOBAL_LIST_EMPTY(abel_hover_base_cache)

// ===== PREF MENU DEBUG LOGGER (temporary — remove with its hooks once chargen perf is fixed) =====
GLOBAL_VAR_INIT(pref_menu_debug, TRUE)
GLOBAL_VAR_INIT(pref_thumbnail_renders, 0)

/datum/preferences/var/list/pref_log_counts
/datum/preferences/var/pref_log_action_name = ""
/datum/preferences/var/pref_log_action_tod = 0

/datum/preferences/proc/pref_log(category, msg)
	if(!GLOB.pref_menu_debug)
		return
	WRITE_LOG("[GLOB.log_directory]/pref_menu.log", "[world.timeofday]ds [parent?.ckey || "?"] \[[category]\] [msg]")

/datum/preferences/proc/pref_log_action(action_name, extra)
	if(!GLOB.pref_menu_debug)
		return
	pref_log_counts = list()
	pref_log_action_name = action_name
	pref_log_action_tod = world.timeofday
	pref_log("ACTION", ">>>>> [action_name][extra ? " ([extra])" : ""]")

/datum/preferences/proc/pref_log_op(op, start_tod, detail)
	if(!GLOB.pref_menu_debug)
		return
	LAZYINITLIST(pref_log_counts)
	pref_log_counts[op] = (pref_log_counts[op] || 0) + 1
	var/cnt = pref_log_counts[op]
	var/delta = world.timeofday - start_tod
	pref_log("OP", "[op] x[cnt] took=[delta]ds[detail ? " {[detail]}" : ""][cnt > 1 ? "  *** MULTIPLICATIVE in [pref_log_action_name] ***" : ""]")
// ===== END PREF MENU DEBUG LOGGER =====

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
	var/_t = world.timeofday
	var/new_static_sig = "[pref_species?.type]-[gender]"
	if(new_static_sig != abel_static_sig)
		abel_static_sig = new_static_sig
		pref_log("UPDATE", "static sig changed ([new_static_sig]) -> update_static_data (resends thumbs catalog!)")
		update_static_data(user)
	pref_log_op("update_menu_data", _t)
	abel_refresh_preview(user)

/datum/preferences/ui_state(mob/user)
	return GLOB.always_state

/datum/preferences/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/abel_chargen))

/datum/preferences/proc/abel_handle_color_task(mob/user, list/href_list)
	var/customizer_type = text2path(href_list["customizer"])
	if(!customizer_type)
		return FALSE
	var/datum/customizer_entry/hair/he = get_customizer_entry_for_customizer_type(customizer_type)
	if(!istype(he))
		return FALSE
	var/field
	switch(href_list["customizer_task"])
		if("hair_color")
			field = "hair_color"
		if("natural_gradient_color")
			field = "natural_color"
		if("dye_gradient_color")
			field = "dye_color"
		else
			return FALSE
	var/new_color = input(user, "Choose color", "Color", he.vars[field]) as color|null
	if(new_color)
		he.vars[field] = sanitize_hexcolor(new_color)
	return TRUE

/datum/preferences/ui_static_data(mob/user)
	var/_t = world.timeofday
	. = list()
	.["background_options"] = abel_background_options()
	.["thumbs"] = abel_thumbnail_catalog()
	pref_log_op("ui_static_data", _t, "thumbs=[length(.["thumbs"])] bg=[length(.["background_options"])]")

/datum/preferences/proc/abel_thumbnail_catalog()
	var/_t = world.timeofday
	var/start_renders = GLOB.pref_thumbnail_renders
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
					.[key] = sanitize_css_class_name("[accessory_type]")
	for(var/datum/sprite_accessory/undie in pref_species.get_spec_undies_list(gender))
		.[undie.name] = sanitize_css_class_name("[undie.type]")
	pref_log_op("abel_thumbnail_catalog", _t, "entries=[length(.)] rendered=[GLOB.pref_thumbnail_renders - start_renders]")

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
	var/datum/job/result
	var/highest = 0
	for(var/job_type in job_preferences)
		if(job_preferences[job_type] > highest)
			highest = job_preferences[job_type]
			result = SSjob.GetJob(job_type)
	return result

/datum/preferences/proc/abel_refresh_preview(mob/user)
	set waitfor = FALSE
	pref_log("REFRESH", "abel_refresh_preview start (async)")
	var/previous = abel_preview_sig
	abel_build_preview(user, json_encode(abel_build_features_data()))
	if(abel_preview_sig != previous)
		pref_log("REFRESH", "preview changed -> 2nd update_uis (extra ui_data!)")
		SStgui.update_uis(src)

/datum/preferences/proc/abel_preview_extra_sig()
	return ""

/datum/preferences/proc/abel_setup_preview_dummy(datum/job/preview_job, datum/outfit/preview_outfit, slotkey = DUMMY_HUMAN_SLOT_PREFERENCES)
	var/_t = world.timeofday
	var/mob/living/carbon/human/dummy/body = generate_or_wait_for_human_dummy(slotkey)
	pref_log_op("dummy_generate", _t, "slot=[slotkey]")
	if(!body)
		return null
	_t = world.timeofday
	apply_prefs_to(body, TRUE)
	pref_log_op("apply_prefs_to", _t)
	_t = world.timeofday
	if(preview_job)
		body.dna.species.pre_equip_species_outfit(preview_job, body, TRUE)
	if(preview_outfit)
		body.equipOutfit(preview_outfit, TRUE)
	body.update_inv_hands(hide_experimental = TRUE)
	body.update_inv_belt(hide_experimental = TRUE)
	body.update_inv_back(hide_experimental = TRUE)
	body.update_inv_head(hide_nonstandard = TRUE)
	pref_log_op("dummy_dress", _t)
	return body

/datum/preferences/proc/abel_finish_preview_dummy(mob/living/carbon/human/dummy/body, slotkey = DUMMY_HUMAN_SLOT_PREFERENCES)
	if(!body)
		return
	body.update_inv_hands()
	body.update_inv_belt()
	body.update_inv_back()
	body.update_inv_head()
	unset_busy_human_dummy(slotkey)

// Modular copy of /proc/getFlatIcon (code/__HELPERS/icons.dm) with the canvas-expansion bug fixed:
// core uses && (only grows when all four edges change) and scrambles the bound assignments, so any
// sprite wider/taller than 32x32 (taurs) gets clipped to 32x32. Used ONLY by the chargen preview.
/proc/abel_get_flat_icon(image/appearance, defdir, deficon, defstate, defblend, start = TRUE, no_anim = FALSE)
	#define ABEL_PROCESS_OVERLAYS_OR_UNDERLAYS(flat, process, base_layer) \
		for (var/i in 1 to length(process)) { \
			var/image/current = process[i]; \
			if (!current) { \
				continue; \
			} \
			if (current.plane != FLOAT_PLANE && current.plane != appearance.plane) { \
				continue; \
			} \
			var/current_layer = current.layer; \
			if (current_layer < 0) { \
				if (current_layer <= -1000) { \
					return flat; \
				} \
				current_layer = base_layer + appearance.layer + current_layer / 1000; \
			} \
			for (var/index_to_compare_to in 1 to length(layers)) { \
				var/compare_to = layers[index_to_compare_to]; \
				if (current_layer < layers[compare_to]) { \
					layers.Insert(index_to_compare_to, current); \
					break; \
				} \
			} \
			layers[current] = current_layer; \
		}

	var/static/icon/flat_template = icon('icons/blanks/32x32.dmi', "nothing")
	var/icon/flat = icon(flat_template)

	if(!appearance || appearance.alpha <= 0)
		return flat

	if(start)
		if(!defdir)
			defdir = appearance.dir
		if(!deficon)
			deficon = appearance.icon
		if(!defstate)
			defstate = appearance.icon_state
		if(!defblend)
			defblend = appearance.blend_mode

	var/curicon = appearance.icon || deficon
	var/curstate = appearance.icon_state || defstate
	var/curdir = (!appearance.dir || appearance.dir == SOUTH) ? defdir : appearance.dir

	var/render_icon = curicon

	if(render_icon)
		if(!icon_exists(curicon, curstate))
			if(icon_exists(curicon, ""))
				curstate = ""
			else
				render_icon = FALSE

	var/base_icon_dir

	if(render_icon)
		if (curdir != SOUTH)
			if(!length(icon_states(icon(curicon, curstate, NORTH))))
				base_icon_dir = SOUTH

		var/list/icon_dimensions = get_icon_dimensions(curicon)
		var/icon_width = icon_dimensions["width"]
		var/icon_height = icon_dimensions["height"]
		if(icon_width != 32 || icon_height != 32)
			flat.Scale(icon_width, icon_height)

	if(!base_icon_dir)
		base_icon_dir = curdir

	var/curblend = appearance.blend_mode || defblend

	if(length(appearance.overlays) || length(appearance.underlays))
		var/list/layers = list()
		var/image/copy
		if(render_icon)
			copy = image(icon=curicon, icon_state=curstate, layer=appearance.layer, dir=base_icon_dir)
			copy.color = appearance.color
			copy.alpha = appearance.alpha
			copy.blend_mode = curblend
			layers[copy] = appearance.layer

		ABEL_PROCESS_OVERLAYS_OR_UNDERLAYS(flat, appearance.underlays, 0)
		ABEL_PROCESS_OVERLAYS_OR_UNDERLAYS(flat, appearance.overlays, 1)

		var/icon/add

		var/flatX1 = 1
		var/flatX2 = flat.Width()
		var/flatY1 = 1
		var/flatY2 = flat.Height()

		var/addX1 = 0
		var/addX2 = 0
		var/addY1 = 0
		var/addY2 = 0

		for(var/image/layer_image as anything in layers)
			if(layer_image.alpha == 0)
				continue

			if(layer_image == copy)
				curblend = BLEND_OVERLAY
				add = icon(layer_image.icon, layer_image.icon_state, base_icon_dir)
			else
				add = abel_get_flat_icon(image(layer_image), curdir, curicon, curstate, curblend, FALSE, no_anim)
			if(!add)
				continue

			addX1 = min(flatX1, layer_image.pixel_x + 1)
			addX2 = max(flatX2, layer_image.pixel_x + add.Width())
			addY1 = min(flatY1, layer_image.pixel_y + 1)
			addY2 = max(flatY2, layer_image.pixel_y + add.Height())

			if (
				addX1 != flatX1 \
				|| addX2 != flatX2 \
				|| addY1 != flatY1 \
				|| addY2 != flatY2 \
			)
				flat.Crop(
					addX1 - flatX1 + 1,
					addY1 - flatY1 + 1,
					addX2 - flatX1 + 1,
					addY2 - flatY1 + 1
				)

				flatX1 = addX1
				flatX2 = addX2
				flatY1 = addY1
				flatY2 = addY2

			flat.Blend(add, blendMode2iconMode(curblend), layer_image.pixel_x + 2 - flatX1, layer_image.pixel_y + 2 - flatY1)

		if(appearance.color)
			if(islist(appearance.color))
				flat.MapColors(arglist(appearance.color))
			else
				flat.Blend(appearance.color, ICON_MULTIPLY)

		if(appearance.alpha < 255)
			flat.Blend(rgb(255, 255, 255, appearance.alpha), ICON_MULTIPLY)

		if(no_anim)
			var/icon/cleaned = new /icon()
			cleaned.Insert(flat, "", SOUTH, 1, 0)
			return cleaned
		else
			return icon(flat, "", SOUTH)
	else if (render_icon)
		var/icon/final_icon = icon(icon(curicon, curstate, base_icon_dir), "", SOUTH, no_anim ? TRUE : null)

		if (appearance.alpha < 255)
			final_icon.Blend(rgb(255,255,255, appearance.alpha), ICON_MULTIPLY)

		if (appearance.color)
			if (islist(appearance.color))
				final_icon.MapColors(arglist(appearance.color))
			else
				final_icon.Blend(appearance.color, ICON_MULTIPLY)

		return final_icon

	#undef ABEL_PROCESS_OVERLAYS_OR_UNDERLAYS

/datum/preferences/proc/abel_flatten_dummy(mob/living/carbon/human/dummy/body, preview_dir)
	var/_t = world.timeofday
	body.setDir(preview_dir)
	var/icon/character = abel_get_flat_icon(body, defdir = preview_dir, no_anim = TRUE)
	pref_log_op("getFlatIcon", _t, "dir=[preview_dir] size=[character ? "[character.Width()]x[character.Height()]" : "null"]")
	return character

/datum/preferences/proc/abel_render_preview_icon(datum/job/preview_job, datum/outfit/preview_outfit, preview_dir, slotkey = DUMMY_HUMAN_SLOT_PREFERENCES)
	var/mob/living/carbon/human/dummy/body = abel_setup_preview_dummy(preview_job, preview_outfit, slotkey)
	if(!body)
		return null
	var/icon/out_icon = abel_flatten_dummy(body, preview_dir)
	abel_finish_preview_dummy(body, slotkey)
	return out_icon

// Renders the doll WITHOUT the hovered customizer (temporarily disables its entry) so the candidate
// overlay replaces the current one instead of stacking on top. Cached per (customizer, current sig).
/datum/preferences/proc/abel_render_hover_base(customizer_type)
	if(!pref_species)
		return ""
	var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
	if(!entry)
		return ""
	var/cache_key = "[customizer_type]|[abel_preview_sig]"
	if(cache_key in GLOB.abel_hover_base_cache)
		return GLOB.abel_hover_base_cache[cache_key]
	var/datum/job/preview_job = abel_preview_clothes ? abel_preview_job() : null
	var/datum/outfit/preview_outfit
	if(preview_job)
		preview_outfit = (gender == FEMALE && preview_job.outfit_female) ? preview_job.outfit_female : preview_job.outfit
	var/saved_underwear = underwear
	if(!abel_preview_underwear)
		underwear = "Nude"
	var/was_disabled = entry.disabled
	entry.disabled = TRUE
	var/icon/flat = abel_render_preview_icon(preview_job, preview_outfit, abel_preview_dir, "abel_hover_base")
	entry.disabled = was_disabled
	underwear = saved_underwear
	var/result = ""
	if(flat)
		var/b64 = icon2base64(flat)
		if(b64)
			result = "data:image/png;base64,[b64]"
	GLOB.abel_hover_base_cache[cache_key] = result
	return result

/datum/preferences/proc/abel_request_hover_base(customizer_type, customizer_ref)
	set waitfor = FALSE
	var/b64 = abel_render_hover_base(customizer_type)
	if(abel_hover_base_for == customizer_ref)
		abel_hover_base = b64
		SStgui.update_uis(src)

/datum/preferences/proc/abel_build_preview(mob/user, features_json)
	if(!pref_species)
		return null
	var/_t = world.timeofday

	var/datum/job/preview_job = abel_preview_clothes ? abel_preview_job() : null
	var/datum/outfit/preview_outfit
	if(preview_job)
		preview_outfit = (gender == FEMALE && preview_job.outfit_female) ? preview_job.outfit_female : preview_job.outfit

	var/sig = list2params(list(
		"sp" = "[pref_species.type]",
		"g" = gender,
		"u" = underwear,
		"uc" = "[underwear_color]",
		"su" = abel_preview_underwear,
		"sc" = abel_preview_clothes,
		"d" = abel_preview_dir,
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
		pref_log_op("abel_build_preview", _t, "CACHE_HIT")
		return cached

	var/saved_underwear = underwear
	if(!abel_preview_underwear)
		underwear = "Nude"
	var/icon/flat = abel_render_preview_icon(preview_job, preview_outfit, abel_preview_dir)
	underwear = saved_underwear
	if(!flat)
		return abel_preview_cache

	var/_tb = world.timeofday
	var/b64 = icon2base64(flat)
	pref_log_op("icon2base64", _tb)
	if(!b64)
		return abel_preview_cache

	abel_preview_cache = "data:image/png;base64,[b64]"
	abel_preview_sig = sig
	GLOB.abel_preview_b64_cache[sig] = abel_preview_cache
	pref_log_op("abel_build_preview", _t, "RENDER dir=[abel_preview_dir]")
	return abel_preview_cache

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
	return list(
		list("name" = "None", "value" = "none"),
		list("name" = "White", "value" = "white"),
		list("name" = "Dark", "value" = "dark"),
	)

/datum/preferences/ui_data(mob/user)
	var/_t = world.timeofday
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
	data["tgui_theme"] = abel_tgui_theme
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
	data["hover_sprite"] = abel_hover_cache
	data["hover_for"] = abel_hover_for
	data["hover_base"] = abel_hover_base
	data["hover_base_for"] = abel_hover_base_for

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

	pref_log_op("ui_data", _t, "features=[length(data["features"])] uw_opts=[length(data["underwear_options"])]")
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
	pref_log_action("pref:[href_list["preference"]]", json_encode(href_list))
	switch(href_list["preference"])
		if("abel_customizer")
			var/_ct = world.timeofday
			validate_customizer_entries()
			pref_log_op("validate_customizer_entries", _ct)
			_ct = world.timeofday
			if(!abel_handle_color_task(user, href_list))
				handle_customizer_topic(user, href_list)
			pref_log_op("handle_customizer_topic", _ct)
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
				abel_preview_background = bg_choice
			save_character()
			update_menu_data(user)
			return TRUE
		if("species")
			var/saved_age = age
			var/saved_name = real_name
			..()
			if(saved_age && (saved_age in pref_species.possible_ages))
				age = saved_age
			if(saved_name)
				real_name = saved_name
			update_menu_data(user)
			return TRUE
		if("abel_tgui_theme")
			var/new_theme = href_list["theme"]
			if(new_theme)
				abel_tgui_theme = new_theme
				SStgui.update_uis(src)
			return TRUE
		if("abel_hover")
			var/acc_path = text2path(href_list["acc"])
			var/datum/sprite_accessory/sa = acc_path ? SPRITE_ACCESSORY(acc_path) : GLOB.underwear_list[href_list["acc"]]
			abel_hover_for = href_list["acc"]
			abel_hover_cache = sa ? sa.abel_dir_sprite(abel_preview_dir, href_list["color"]) : ""
			var/cust_ref = href_list["customizer"]
			abel_hover_base_for = cust_ref
			abel_hover_base = ""
			var/cust_type = cust_ref ? text2path(cust_ref) : null
			if(cust_type)
				abel_request_hover_base(cust_type, cust_ref)
			SStgui.update_uis(src)
			return TRUE
	return ..()
