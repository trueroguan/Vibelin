// CYRILLIC SAY FIX
// Upstream capitalize() is byte-based (uppertext(copytext(t, 1, 2)) + copytext(t, 2)):
// on a UTF-8 multi-byte first char it grabs one byte, uppercases nothing, and
// reassembles the original — a harmless no-op for Cyrillic. capitalize_utf8()
// does the real character-aware capitalization.

/proc/capitalize_utf8(t as text)
	if(!t)
		return t
	return uppertext(copytext_char(t, 1, 2)) + copytext_char(t, 2)

// Wrapper: parent runs every speech transform plus its byte-based capitalize()
// (a no-op on Cyrillic, idempotent on ASCII), then we re-capitalize UTF-8-aware.
/mob/living/treat_message(message)
	. = ..()
	. = capitalize_utf8(.)

/mob/living/brain/treat_message(message)
	. = ..()
	. = capitalize_utf8(.)

// FULL-BODY OVERRIDE — cannot be wrapped: the parent proc both transforms the
// message mid-body and emits the visible_message itself, so calling ..() would
// double-send the say. Source: code/modules/mob/dead/observer/observer_say.dm
// /mob/dead/observer/profane/say. Changes vs upstream, both on the message line:
//   capitalize() -> capitalize_utf8() (character-aware capitalization)
//   copytext()   -> copytext_char()   (byte-based MAX_MESSAGE_LEN truncation can
//                                      split a multi-byte char and corrupt the tail)
// RE-SYNC OBLIGATION: if upstream changes this proc, mirror the change here.
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
