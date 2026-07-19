/obj/item/clothing/cloak/elven
	name = "elven cloak"
	desc = "It is said that this design might predate the fall of an ancient, long-forgotten empire."
	icon = 'modular_abel/gear/icons/cloak.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/cloak.dmi'
	icon_state = "cape"
	item_state = "cape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = TRUE

/obj/item/clothing/cloak/elven/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	var/list/styles = list("Blue Cloak" = "cape_blue", "Red Cloak" = "cape_red", "Blue Furcloak" = "cape_blue_alt", "Red Furcloak" = "cape_red_alt")
	var/choice = tgui_input_list(user, "Choose a style.", "Elven styles", styles)
	if(!choice)
		return
	icon_state = styles[choice]
	item_state = styles[choice]
	update_appearance(UPDATE_ICON)

/obj/item/clothing/cloak/raincloak/furcloak/champion
	name = "champion's cloak"
	desc = "A cloak of the ruling lord's most loyal champion."
	color = "#3a75c4"
	uses_lord_coloring = LORD_SECONDARY

/obj/item/clothing/cloak/bishop
	name = "bishop cape"
	desc = "A ceremonial cape worn by high-ranking clergy."
	icon = 'modular_abel/gear/icons/cloak.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/cloak.dmi'
	icon_state = "bishop_cape"
	item_state = "bishop_cape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = TRUE

/obj/item/clothing/cloak/etrcape
	name = "wanderer's cape"
	desc = "A stylish raincoat that protects you from the rain and makes you look great."
	icon = 'modular_abel/gear/icons/cloak.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/cloak.dmi'
	sleeved = 'modular_abel/gear/icons/onmob/cloak.dmi'
	icon_state = "etrcape"
	item_state = "etrcape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = FALSE
	color = null

/obj/item/clothing/cloak/sheriff
	name = "sheriff's cloak"
	desc = "A cloak embroidered with the silver heraldry of the town watch."
	icon = 'modular_abel/gear/icons/cloak.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/cloak.dmi'
	sleeved = 'modular_abel/gear/icons/onmob/cloak.dmi'
	icon_state = "sheriffcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER

/obj/item/clothing/cloak/raincloak/amir
	name = "amir's cloak"
	desc = "A silky red cloak as light as a feather, embroidered with gold patterns. Fit for a foreign prince."
	icon = 'modular_abel/gear/icons/cloak.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/cloak.dmi'
	icon_state = "dprince"
	item_state = "dprince"
	sleeved = 'modular_abel/gear/icons/onmob/cloak.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	hoodtype = /obj/item/clothing/head/hooded/rainhood/amirhood
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/cloak/dunestalker
	name = "dunestalker cloak"
	desc = "A heavy leather cloak held together by a gilded pin, depicting a distant sultan's house. The sign of a faithful servant."
	icon = 'modular_abel/gear/icons/cloak.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/cloak.dmi'
	icon_state = "shadowcloak"
	sleeved = 'modular_abel/gear/icons/onmob/cloak.dmi'
	sleevetype = "shirt"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	allowed_sex = list(MALE, FEMALE)

/obj/item/clothing/cloak/donator
	name = "cloak of gilded maille"
	desc = "A cloak of golden chainmail links, draped over the shoulders of only the most favored."
	icon = 'modular_abel/gear/icons/cloak.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/cloak.dmi'
	icon_state = "chainking"
	item_state = "chainking"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = TRUE
