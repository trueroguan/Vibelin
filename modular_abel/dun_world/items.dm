/obj/item/hair_dye_cream
	name = "hair dye cream"
	desc = "A cream that can be used to dye and style hair with various colors and gradients."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "cream"
	w_class = WEIGHT_CLASS_SMALL
	var/uses_remaining = 30

/obj/item/hair_dye_cream/attack(mob/living/M, mob/living/user)
	if(!ishuman(M))
		return ..()
	var/mob/living/carbon/human/H = M
	if(uses_remaining <= 0)
		to_chat(user, span_warning("The jar is empty."))
		return
	if(!user.Adjacent(H))
		return
	var/static/list/choices = list("hair color", "facial hair color", "natural gradient", "natural gradient color", "dye gradient", "dye gradient color")
	var/chosen = browser_input_list(user, "What would you like to dye?", "Hair Dye", choices)
	if(!chosen || !user.Adjacent(H))
		return
	if(!do_after(user, 30 SECONDS, target = H))
		to_chat(user, span_warning("The dyeing was interrupted!"))
		return
	if(!dye_apply(H, user, chosen))
		return
	uses_remaining--
	if(uses_remaining <= 0)
		icon_state = "empty_cream"
	else if(uses_remaining <= 15)
		icon_state = "low_cream"
	H.update_body()
	H.update_body_parts()
	user.visible_message(span_notice("[user] tends to [H == user ? "[user.p_their()] hair" : "[H]'s hair"]."))

/obj/item/hair_dye_cream/proc/dye_apply(mob/living/carbon/human/H, mob/living/user, chosen)
	switch(chosen)
		if("hair color")
			var/picked = input(user, "Choose a hair color:", "Hair Dye", H.get_hair_color()) as color|null
			if(!picked)
				return FALSE
			H.set_hair_color(sanitize_hexcolor(picked, 6, TRUE), FALSE)
			return TRUE
		if("facial hair color")
			var/picked = input(user, "Choose a facial hair color:", "Hair Dye", H.get_hair_color()) as color|null
			if(!picked)
				return FALSE
			H.set_facial_hair_color(sanitize_hexcolor(picked, 6, TRUE), FALSE)
			return TRUE
		if("natural gradient")
			return dye_gradient(H, user, "natural_gradient")
		if("dye gradient")
			return dye_gradient(H, user, "dye_gradient")
		if("natural gradient color")
			return dye_gradient_color(H, user, "natural_color")
		if("dye gradient color")
			return dye_gradient_color(H, user, "dye_color")
	return FALSE

/obj/item/hair_dye_cream/proc/get_head_hair(mob/living/carbon/human/H)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head?.bodypart_features)
		return null
	for(var/datum/bodypart_feature/hair/head/feature in head.bodypart_features)
		return feature
	return null

/obj/item/hair_dye_cream/proc/make_entry(datum/bodypart_feature/hair/head/current)
	var/datum/customizer_entry/hair/head/entry = new()
	entry.hair_color = current.hair_color
	entry.natural_gradient = current.natural_gradient
	entry.natural_color = current.natural_color
	entry.dye_gradient = current.hair_dye_gradient
	entry.dye_color = current.hair_dye_color
	entry.accessory_type = current.accessory_type
	return entry

/obj/item/hair_dye_cream/proc/rebuild_hair(mob/living/carbon/human/H, datum/bodypart_feature/hair/head/current, datum/customizer_entry/hair/head/entry)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		return
	var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
	var/datum/bodypart_feature/hair/head/new_hair = new()
	new_hair.set_accessory_type(current.accessory_type, entry.hair_color, H)
	hair_choice.customize_feature(new_hair, H, null, entry)
	head.remove_bodypart_feature(current)
	head.add_bodypart_feature(new_hair)

/obj/item/hair_dye_cream/proc/dye_gradient(mob/living/carbon/human/H, mob/living/user, field)
	var/datum/bodypart_feature/hair/head/current = get_head_hair(H)
	if(!current)
		to_chat(user, span_warning("There is no hair to dye."))
		return FALSE
	var/list/gradients = hair_gradient_name_to_type_list()
	var/picked = browser_input_list(user, "Choose a gradient:", "Hair Dye", gradients)
	if(!picked)
		return FALSE
	var/datum/customizer_entry/hair/head/entry = make_entry(current)
	entry.vars[field] = gradients[picked]
	rebuild_hair(H, current, entry)
	return TRUE

/obj/item/hair_dye_cream/proc/dye_gradient_color(mob/living/carbon/human/H, mob/living/user, field)
	var/datum/bodypart_feature/hair/head/current = get_head_hair(H)
	if(!current)
		to_chat(user, span_warning("There is no hair to dye."))
		return FALSE
	var/picked = input(user, "Choose a gradient color:", "Hair Dye", current.hair_color) as color|null
	if(!picked)
		return FALSE
	var/datum/customizer_entry/hair/head/entry = make_entry(current)
	entry.vars[field] = sanitize_hexcolor(picked, 6, TRUE)
	rebuild_hair(H, current, entry)
	return TRUE

/obj/item/dye_brush
	name = "dye brush"
	desc = "A sizeable brush made of the finest mane-hairs. Thick dye adheres to it well."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "dbrush"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.7
	var/dye = null

/obj/item/dye_brush/update_icon()
	. = ..()
	cut_overlays()
	if(dye)
		var/mutable_appearance/M = mutable_appearance('icons/roguetown/items/misc.dmi', "dbrush_colour")
		M.color = dye
		M.alpha = 150
		add_overlay(M)

/obj/item/dye_brush/examine(mob/user)
	. = ..()
	if(dye)
		. += span_notice("It is currently lathering <font color=[dye]>paint</font>. Use in hand to wipe it clean.")
	else
		. += span_notice("Use in active hand to pick a paint.")

/obj/item/dye_brush/attack_self(mob/user)
	..()
	if(dye)
		if(!do_after(user, 3 SECONDS, target = src))
			return
		dye = null
		to_chat(user, span_notice("I wipe the brush clean."))
		update_icon()
		return
	var/static/list/presets = CLOTHING_COLOR_MAP + EXTENDED_COLOR_MAP
	var/choice_mode = alert(user, "Input Choice", "Brush Dye", "Color Wheel", "Color Preset")
	if(choice_mode == "Color Preset")
		var/picked = input(user, "Choose your dye:", "Dyes", null) as null|anything in presets
		if(!picked)
			return
		dye = presets[picked]
	else
		var/picked = input(user, "Choose your dye:", "Dyes", dye) as color|null
		if(!picked)
			return
		var/hexdye = sanitize_hexcolor(picked, 6, TRUE)
		if(hexdye == "#000000")
			return
		dye = hexdye
	update_icon()

/obj/item/dye_brush/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!proximity_flag || !dye)
		return
	if(!iswallturf(target) && !isstructure(target))
		return
	if(target.color)
		to_chat(user, span_warning("[target] is already painted by a <font color=[target.color]>dye</font>!"))
		return
	if(!do_after(user, isstructure(target) ? 3 SECONDS : 6 SECONDS, target = target))
		return
	user.visible_message(span_notice("[user] finishes <font color=[dye]>painting</font> [target]."), \
		span_notice("I finish <font color=[dye]>painting</font> [target]."))
	playsound(loc, "sound/foley/scrubbing[pick(1,2)].ogg", 60, TRUE)
	target.color = dye

/obj/item/armor_brush
	name = "fine brush"
	desc = "A coarse brush for scrubbing armor thoroughly. Made of the finest Lupin hair."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "brush_0"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.6
	var/roughness = 0

/obj/item/armor_brush/attack_self(mob/user)
	roughness = 1 - roughness
	if(roughness)
		to_chat(user, span_info("I flip the brush to the coarse side."))
		name = "coarse brush"
	else
		to_chat(user, span_info("I flip the brush to the fine side."))
		name = "fine brush"
	icon_state = "brush_[roughness]"

/obj/item/clothing/head/crown/dun_world_fake
	name = "Crown"
	desc = "A kingly crown, heavy with authority. Or perhaps a clever counterfeit, light as a lie."
	icon_state = "serpcrown"
	sellprice = 5

/obj/item/weapon/sword/rapier/dun_world_lord
	name = "sword of the Mad Duke"
	desc = "A royal heirloom whose spiraling basket hilt is inlaid with fine cut gems. It bears the burnish of time, where once sharply defined features have been worn down by so many hands. An old rumor ties this implement to the siege that smashed the Mad Duke's keep to rubble, and burnt the Duke himself to cinders."
	icon = 'modular_abel/dun_world/icons/swords64.dmi'
	icon_state = "lordrap"
	sellprice = 150
	max_integrity = 300
	wdefense = 7
