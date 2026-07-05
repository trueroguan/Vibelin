/mob/log_talk(message, message_type, tag = null, log_globally = TRUE, forced_by = null)
	. = ..()
	if(message_type != LOG_OOC || !client)
		return
	character_setup_chargen_record_ooc(
		get_display_ckey(client.ckey),
		message,
		istype(src, /mob/dead/new_player),
	)

/mob/dead/new_player/transfer_character()
	if(new_character && client?.prefs)
		SStgui.close_uis(client.prefs)
	return ..()
