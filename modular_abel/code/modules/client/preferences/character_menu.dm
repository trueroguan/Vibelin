#define PREF_LINK(pref_task, label) ("<a class='row' href='?_src_=prefs;" + pref_task + "'>" + label + "</a>")

/datum/preferences/build_and_show_menu(mob/user)
	if(!user?.client)
		return

	user.client.acquire_dpi()

	var/datum/faith/selected_faith
	if(selected_patron)
		selected_faith = GLOB.faith_list[selected_patron.associated_faith]

	var/high_job
	for(var/job_type in job_preferences)
		if(job_preferences[job_type] != JP_HIGH)
			continue
		high_job = job_type
		break

	var/erp_state = erp_enabled ? "On" : "Off"

	var/list/dat = list()
	dat += {"<html><head><meta charset="utf-8"><style>
		* { box-sizing:border-box; }
		body { background:#10131a; color:#c4ccd6; font-family:'Segoe UI','Trebuchet MS',sans-serif; font-size:13px; margin:0; padding:0; }
		.bar { position:sticky; top:0; background:linear-gradient(#1c2230,#141925); border-bottom:2px solid #2f6f7a; padding:10px 14px; }
		.bar .name { font-size:17px; font-weight:bold; color:#7fd1de; letter-spacing:1px; }
		.bar .sub { font-size:11px; color:#7c8694; margin-top:2px; }
		.wrap { display:flex; gap:14px; flex-wrap:wrap; padding:12px 14px; }
		.col { flex:1; min-width:185px; }
		h3 { color:#8aa0b8; font-size:11px; font-weight:600; letter-spacing:2px; text-transform:uppercase; margin:14px 0 5px; padding-left:6px; border-left:3px solid #2f6f7a; }
		h3:first-child { margin-top:0; }
		a.row { display:block; padding:6px 10px; margin:3px 0; background:#181d27; color:#d3dae3; text-decoration:none; border:1px solid #232a36; border-radius:4px; transition:all .12s ease; }
		a.row:hover { background:#212a39; border-color:#2f6f7a; color:#eaf3fa; transform:translateX(2px); }
		a.row b { color:#7fd1de; font-weight:600; }
		a.toggle { border-color:#3a5a4a; }
		a.toggle b { color:#7fde9a; }
		a.done { background:#13241a; border-color:#2f6f4a; color:#9fe6b6; text-align:center; font-weight:bold; }
		a.done:hover { background:#19311f; }
	</style></head><body>
	<div class="bar"><div class="name">[real_name]</div><div class="sub">[pref_species.name] &middot; [gender == MALE ? "Masculine" : "Feminine"] &middot; Slot [default_slot]</div></div>
	<div class="wrap"><div class="col">"}

	dat += "<h3>Identity</h3>"
	dat += PREF_LINK("preference=name;task=input", "Name: <b>[real_name]</b>")
	dat += PREF_LINK("preference=species;task=input", "Species: <b>[pref_species.name]</b>")
	dat += PREF_LINK("preference=patron;task=input", "Patron: <b>[selected_patron.name]</b>")
	dat += PREF_LINK("preference=faith;task=input", "Faith: <b>[selected_faith?.name || "None"]</b>")
	dat += PREF_LINK("preference=job;task=menu", "Class: <b>[high_job || "None"]</b>")

	dat += "<h3>Body</h3>"
	dat += PREF_LINK("preference=age;task=input", "Age: <b>[age]</b>")
	dat += PREF_LINK("preference=gender", "Body Type: <b>[gender == MALE ? "M" : "F"]</b>")
	dat += PREF_LINK("preference=pronouns;task=input", "Pronouns: <b>[pronouns]</b>")
	dat += PREF_LINK("preference=domhand", "Dominant Hand: <b>[domhand == 1 ? "Left" : "Right"]</b>")
	dat += PREF_LINK("preference=s_tone;task=input", "Ancestry")
	dat += PREF_LINK("preference=select_quirks", "Select Quirks")

	dat += "<h3>Appearance</h3>"
	dat += PREF_LINK("preference=customizers;task=menu", "Features <b>(genitals, ears, tail...)</b>")
	dat += PREF_LINK("preference=randomiseappearanceprefs", "Randomise Appearance")
	dat += PREF_LINK("preference=headshot;task=input", "Headshot")
	dat += "<a class='row toggle' href='?_src_=prefs;preference=abel_erp_toggle'>Intimacy opt-in: <b>[erp_state]</b></a>"
	if(erp_enabled)
		dat += "<a class='row' href='?_src_=prefs;preference=abel_erp_panel'>Open intimacy panel</a>"

	dat += "</div><div class=\"col\">"

	dat += "<h3>Flavour</h3>"
	dat += PREF_LINK("preference=flavortext;task=input", "Flavour Text")
	dat += PREF_LINK("preference=descriptors;task=menu", "Descriptors")
	dat += PREF_LINK("preference=culture;task=input", "Culture: <b>[culture ? culture::name : "None"]</b>")
	dat += PREF_LINK("preference=culinary;task=menu", "Food Preferences")
	dat += PREF_LINK("preference=ooc_notes;task=input", "OOC Notes")
	dat += PREF_LINK("preference=ooc_extra;task=input", "OOC Extra")

	dat += "<h3>Voice &amp; Family</h3>"
	dat += PREF_LINK("preference=voicetype;task=input", "Voice Type: <b>[voice_type]</b>")
	dat += PREF_LINK("preference=selected_accent;task=input", "Accent: <b>[selected_accent]</b>")
	dat += PREF_LINK("preference=family", "Family: <b>[family ? family : "None"]</b>")
	dat += PREF_LINK("preference=setspouse", "Spouse Pref")

	dat += "<h3>Loadout &amp; Triumphs</h3>"
	dat += PREF_LINK("preference=loadout_item;loadout_number=1;task=input", "Loadout 1: <b>[loadout1 ? loadout1.name : "None"]</b>")
	dat += PREF_LINK("preference=loadout_item;loadout_number=2;task=input", "Loadout 2: <b>[loadout2 ? loadout2.name : "None"]</b>")
	dat += PREF_LINK("preference=loadout_item;loadout_number=3;task=input", "Loadout 3: <b>[loadout3 ? loadout3.name : "None"]</b>")
	dat += PREF_LINK("preference=triumph_buy_menu", "Triumph Shop")
	dat += PREF_LINK("preference=antag;task=menu", "Special Roles")

	dat += "<h3>Menu</h3>"
	dat += PREF_LINK("preference=multi;task=menu", "Character Ready Order")
	dat += PREF_LINK("preference=changeslot", "Change Character")
	dat += PREF_LINK("preference=toggles", "Toggles")
	dat += PREF_LINK("preference=keybinds;task=menu", "Keybinds")
	dat += PREF_LINK("preference=save", "Save")
	dat += PREF_LINK("preference=load", "Undo")
	dat += "<a class='row done' href='?_src_=prefs;preference=finished'>Done</a>"

	dat += "</div></div></body></html>"

	var/menu_size = winget(user, "mapwindow", "size")
	if(!menu_size || !findtext(menu_size, "x"))
		menu_size = "816x950"

	winshow(user, "stonekeep_prefwin", TRUE)
	winset(user, "stonekeep_prefwin", "pos=0,0;size=[menu_size]")
	winset(user, "stonekeep_prefwin.preferences_browser", "size=[menu_size]")
	winshow(user, "stonekeep_prefwin.character_preview_map", FALSE)
	user << browse(dat.Join(), "window=preferences_browser;size=[menu_size]")

/datum/preferences/update_menu_data(mob/user, list/fields_to_update)
	if(!winexists(user, "preferences_browser"))
		return
	build_and_show_menu(user)

/datum/preferences/process_link(mob/user, list/href_list)
	switch(href_list["preference"])
		if("abel_erp_toggle")
			erp_enabled = !erp_enabled
			save_character()
			var/mob/living/carbon/human/H = user
			if(istype(H))
				H.erp_on_spawn_setup()
			to_chat(user, span_notice("Intimacy opt-in [erp_enabled ? "enabled" : "disabled"] for this character (saved to slot)."))
			build_and_show_menu(user)
			return TRUE
		if("abel_erp_panel")
			var/mob/living/carbon/human/H = user
			if(!istype(H) || !erp_enabled)
				to_chat(user, span_warning("Enable the intimacy opt-in first, in a living body."))
				return TRUE
			H.start_erp_session(H)
			return TRUE
	return ..()

#undef PREF_LINK
