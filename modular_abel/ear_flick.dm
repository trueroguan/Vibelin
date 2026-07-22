/obj/item/organ/ears
	var/can_flick = FALSE

/obj/item/organ/ears/elf
	can_flick = TRUE

/obj/item/organ/ears/elfw
	can_flick = TRUE

/obj/item/organ/ears/halforc
	can_flick = TRUE

/obj/item/organ/ears/tiefling
	can_flick = TRUE

/datum/emote/living/eflick
	key = "eflick"
	key_third_person = "flicks"
	message = "flicks their ears."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/eflick/can_run_emote(mob/living/user, status_check = TRUE, intentional)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/human_user = user
	var/obj/item/organ/ears/ears = human_user.getorganslot(ORGAN_SLOT_EARS)
	return !!ears?.can_flick

/mob/living/carbon/human/verb/emote_eflick()
	set name = "Ear Flick"
	set category = "Emotes.Silent"
	emote("eflick", intentional = TRUE)

/datum/emote/living/kiss/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!ishuman(user) || !ishuman(target))
		return
	var/mob/living/carbon/human/H = user
	var/mob/living/carbon/human/E = target
	if(H.zone_selected != BODY_ZONE_PRECISE_EARS)
		return
	if(target.loc != user.loc && H.pulling != target)
		return
	if(E.cmode)
		return
	if(HAS_TRAIT(E, TRAIT_DECEIVING_MEEKNESS) || HAS_TRAIT(E, TRAIT_NOMOOD))
		return
	var/obj/item/organ/ears/target_ears = E.getorganslot(ORGAN_SLOT_EARS)
	if(!target_ears?.can_flick)
		return
	if(E.dna.species?.id != SPEC_ID_ELF)
		to_chat(target, span_love("It tickles..."))
	E.emote("eflick", intentional = TRUE)
