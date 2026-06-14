/obj/item/hair_dye_cream
	name = "hair dye cream"
	desc = "A cream that can be used to dye and style hair with various colors and gradients."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "cream"
	w_class = WEIGHT_CLASS_SMALL
	var/uses_remaining = 30

/obj/item/hair_dye_cream/attack(mob/living/M, mob/living/user)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/static/list/choices = list("hair color", "facial hair color", "natural gradient", "natural gradient color", "dye gradient", "dye gradient color")
	var/chosen = input(user, "What would you like to dye?", "Hair Dye") as null|anything in choices
	if(!chosen || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if(chosen == "facial hair color")
		dye_facial_hair(H, user)
	else
		dye_head_hair(H, user, chosen)

/obj/item/hair_dye_cream/proc/use_cream()
	uses_remaining--
	if(uses_remaining <= 0)
		icon_state = "empty_cream"
	else if(uses_remaining <= 15)
		icon_state = "low_cream"

/obj/item/hair_dye_cream/proc/get_hair_feature(mob/living/carbon/human/H, feature_type)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head || !head.bodypart_features)
		return null
	for(var/datum/bodypart_feature/feature as anything in head.bodypart_features)
		if(istype(feature, feature_type))
			return feature
	return null

/obj/item/hair_dye_cream/proc/dye_head_hair(mob/living/carbon/human/H, mob/living/user, mode)
	if(uses_remaining <= 0)
		to_chat(user, span_warning("The jar is empty!"))
		return
	var/datum/bodypart_feature/hair/head/current_hair = get_hair_feature(H, /datum/bodypart_feature/hair/head)
	if(!current_hair)
		to_chat(user, span_warning("There is no hair to dye!"))
		return

	var/datum/customizer_entry/hair/hair_entry = new()
	hair_entry.hair_color = current_hair.hair_color
	hair_entry.natural_gradient = current_hair.natural_gradient
	hair_entry.natural_color = current_hair.natural_color
	hair_entry.dye_gradient = current_hair.hair_dye_gradient
	hair_entry.dye_color = current_hair.hair_dye_color
	hair_entry.accessory_type = current_hair.accessory_type

	switch(mode)
		if("hair color")
			var/new_color = color_pick_sanitized(user, "Choose your hair color", "Hair Color", H.hair_color)
			if(!new_color)
				return
			hair_entry.hair_color = sanitize_hexcolor(new_color, 6, TRUE)
		if("natural gradient")
			var/new_style = input(user, "Choose your natural gradient", "Hair Gradient") as null|anything in GLOB.hair_gradients
			if(!new_style)
				return
			hair_entry.natural_gradient = new_style
		if("natural gradient color")
			var/new_color = color_pick_sanitized(user, "Choose your natural gradient color", "Natural Gradient Color", H.hair_color)
			if(!new_color)
				return
			hair_entry.natural_color = sanitize_hexcolor(new_color, 6, TRUE)
		if("dye gradient")
			var/new_style = input(user, "Choose your dye gradient", "Hair Gradient") as null|anything in GLOB.hair_gradients
			if(!new_style)
				return
			hair_entry.dye_gradient = new_style
		if("dye gradient color")
			var/new_color = color_pick_sanitized(user, "Choose your dye gradient color", "Dye Gradient Color", H.hair_color)
			if(!new_color)
				return
			hair_entry.dye_color = sanitize_hexcolor(new_color, 6, TRUE)
		else
			return

	if(!do_after(user, 30 SECONDS, target = H))
		to_chat(user, span_warning("The dyeing was interrupted!"))
		return

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
	var/datum/bodypart_feature/hair/head/new_hair = new()
	new_hair.set_accessory_type(current_hair.accessory_type, null, H)
	hair_choice.customize_feature(new_hair, H, null, hair_entry)
	H.hair_color = hair_entry.hair_color
	head.remove_bodypart_feature(current_hair)
	head.add_bodypart_feature(new_hair)
	use_cream()
	H.update_body()
	H.update_hair()
	H.update_body_parts()
	user.visible_message(span_notice("[user] dyes [H]'s hair."), span_notice("You dye [H == user ? "your" : "[H]'s"] hair."))

/obj/item/hair_dye_cream/proc/dye_facial_hair(mob/living/carbon/human/H, mob/living/user)
	if(uses_remaining <= 0)
		to_chat(user, span_warning("The jar is empty!"))
		return
	var/datum/bodypart_feature/hair/facial/current_facial = get_hair_feature(H, /datum/bodypart_feature/hair/facial)
	if(!current_facial)
		to_chat(user, span_warning("There is no facial hair to dye!"))
		return
	var/new_color = color_pick_sanitized(user, "Choose your facial hair color", "Facial Hair Color", H.facial_hair_color)
	if(!new_color)
		return
	if(!do_after(user, 30 SECONDS, target = H))
		to_chat(user, span_warning("The dyeing was interrupted!"))
		return

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
	var/datum/customizer_entry/hair/facial/facial_entry = new()
	facial_entry.hair_color = sanitize_hexcolor(new_color, 6, TRUE)
	facial_entry.accessory_type = current_facial.accessory_type

	var/datum/bodypart_feature/hair/facial/new_facial = new()
	new_facial.set_accessory_type(current_facial.accessory_type, null, H)
	facial_choice.customize_feature(new_facial, H, null, facial_entry)
	H.facial_hair_color = facial_entry.hair_color
	head.remove_bodypart_feature(current_facial)
	head.add_bodypart_feature(new_facial)
	use_cream()
	H.update_body()
	H.update_hair()
	H.update_body_parts()
	user.visible_message(span_notice("[user] dyes [H]'s facial hair."), span_notice("You dye [H == user ? "your" : "[H]'s"] facial hair."))

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
		var/hexdye = sanitize_hexcolor(color_pick_sanitized(user, "Choose your dye:", "Dyes", dye), 6, TRUE)
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
	name = "crown"
	desc = "A kingly crown, heavy with authority. Or perhaps a clever counterfeit, light as a lie."
	icon_state = "serpcrown"
	sellprice = 5

/obj/item/weapon/sword/rapier/dun_world_lord
	name = "sword of the Mad Duke"
	desc = "A royal heirloom whose spiraling basket hilt is inlaid with fine cut gems. It bears the burnish of time, where once sharply defined features have been worn down by so many hands. An old rumor ties this implement to the siege that smashed the Mad Duke's keep to rubble, and burnt the Duke himself to cinders."
	icon = 'modular_abel/icons/dun_world/swords64.dmi'
	icon_state = "lordrap"
	sellprice = 150
	max_integrity = 300
	wdefense = 7
