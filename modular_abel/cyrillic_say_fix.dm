/proc/capitalize_utf8(t as text)
	if(!t)
		return t
	return uppertext(copytext_char(t, 1, 2)) + copytext_char(t, 2)

/mob/living/treat_message(message)
	if(HAS_TRAIT(src, TRAIT_ZOMBIE_SPEECH))
		message = "[repeat_string(rand(1, 3), "U")][repeat_string(rand(1, 6), "H")]..."
	else if(HAS_TRAIT(src, TRAIT_GARGLE_SPEECH))
		message = vocal_cord_torn(message)

	if(HAS_TRAIT(src, TRAIT_UNINTELLIGIBLE_SPEECH))
		message = unintelligize(message)

	if(derpspeech)
		message = derpspeech(message, stuttering)

	if(stuttering)
		message = stutter(message, stuttering)

	if(slurring)
		message = slur(message)

	if(cultslurring)
		message = cultslur(message)

	message = capitalize_utf8(message)

	return message

/mob/living/brain/treat_message(message)
	message = capitalize_utf8(message)
	return message

/mob/dead/observer/profane/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!message)
		return
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='boldwarning'>I cannot send IC messages (muted).</span>")
			return
		if(!(ignore_spam || forced) && src.client.handle_spam_prevention(message, MUTE_IC))
			return
	message = capitalize_utf8(trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN)))
	var/rendered = "<span class='say'><span class='name'>[name]</span> <span class='message'>[say_quote(message)]</span></span>"
	visible_message(message = rendered, self_message = FALSE, blind_message = rendered, vision_distance = 0)
