/obj/item/clothing/head/roguehood/newmoon
	name = "newmoon hood"
	desc = "A hood woven from dense material. Sturdy enough to resist tearing, and warmed by its lining. The secret of the fabric's make remains a mystery even to those who wear it."
	color = "#78a3c9"
	slot_flags = ITEM_SLOT_HEAD
	armor = ARMOR_MINIMAL
	body_parts_covered = HEAD|HAIR|EARS|NOSE|NECK
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE + 30
	armor_class = AC_MEDIUM

/obj/item/clothing/head/stewardtophat
	name = "top hat"
	desc = "A tall, formal hat favored by butlers and stewards."
	icon = 'modular_abel/gear/icons/head.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/head_64.dmi'
	icon_state = "stewardtophat"
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/kokoshnik
	name = "kokoshnik"
	desc = "An ornate headdress favored by northern noblewomen."
	icon = 'modular_abel/gear/icons/head.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/head_32x48.dmi'
	icon_state = "white_mage_headwear"
	flags_inv = HIDEEARS

/obj/item/clothing/head/kokoshnik/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	var/list/colors = list("White" = "white_mage_headwear", "Blue" = "blue_mage_headwear")
	var/choice = tgui_input_list(user, "Choose a color.", "Kokoshnik colors", colors)
	if(!choice)
		return
	icon_state = colors[choice]
	update_appearance(UPDATE_ICON)

/obj/item/clothing/head/flowercrown/rosa/twilight_resprite
	name = "crown of eora flowers"
	desc = "A crown woven from Eora's own flowers."
	item_state = "flower_crown_eora"
	icon_state = "flower_crown_eora"
	icon = 'modular_abel/gear/icons/head.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/head_32.dmi'

/obj/item/clothing/head/sultan
	name = "sultan's turban"
	desc = "Bask in its noble size and grandeur!"
	icon = 'modular_abel/gear/icons/head.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/head_32x48.dmi'
	icon_state = "sultan"
	item_state = "sultan"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/sultan/merchant
	name = "merchant's turban"
	desc = "A turban, large and elaborate, made of the finest silk money can buy."
	icon_state = "merchant"
	item_state = "merchant"
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/sultan/amir
	name = "amir's turban"
	desc = "Soft, decadent, grandiose, but above all - princely."
	icon_state = "amir"
	item_state = "amir"
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/sultana
	name = "sultana's headdress"
	desc = "Silky smooth, foreign silk headdress."
	icon = 'modular_abel/gear/icons/head.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/head_32.dmi'
	icon_state = "sultana"
	item_state = "sultana"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS|HIDEHAIR
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/hooded/rainhood/amirhood
	name = "amir's hood"
	desc = "A silky red hood as light as a feather, embroidered with gold patterns. Fit for a foreign prince."
	icon = 'modular_abel/gear/icons/head.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/head_32.dmi'
	icon_state = "dprince"
	item_state = "dprince"
	block2add = FOV_BEHIND
	flags_inv = HIDEHAIR

/obj/item/clothing/head/desert_sorceress
	name = "desert sorceress hood"
	desc = "A thin desert hood worn by sorceresses to shield against sun and sand while leaving the face and eyes unobstructed."
	icon = 'modular_abel/gear/icons/head.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/head_32.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	icon_state = "sorceresshood"
	item_state = "sorceresshood"

/obj/item/clothing/head/tombraider
	name = "tomb raider's hat"
	desc = "The perfect protection both from heat and things falling on your head."
	icon = 'modular_abel/gear/icons/head.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/head_32.dmi'
	icon_state = "tombraiderhat"
	item_state = "tombraiderhat"
	armor = ARMOR_LEATHER
	salvage_result = /obj/item/natural/hide/cured
