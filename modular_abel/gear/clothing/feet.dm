/obj/item/clothing/shoes/boots/armor/bronze_maille
	name = "bronze maille boots"
	desc = "A pair of leather boots, reinforced with smaller bronze plates along the feet and ankles. A thick layer of chainmail has been woven across the cuffs of each boot."
	icon = 'modular_abel/gear/icons/feet.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/feet.dmi'
	icon_state = "bsoldierboots"
	item_state = "bsoldierboots"
	armor_class = AC_LIGHT
	armor = ARMOR_MAILLE_BRONZE
	max_integrity = INTEGRITY_STANDARD + 50
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	melt_amount = 75

/obj/item/clothing/shoes/boots/armor/maille_steel
	name = "maille boots"
	desc = "A pair of leather boots, reinforced with smaller steel plates along the feet and ankles. Woven into the top of each boot's cuff is a thick layer of chainmail."
	body_parts_covered = FEET
	icon = 'modular_abel/gear/icons/feet.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/feet.dmi'
	icon_state = "shalfplateboots"
	item_state = "shalfplateboots"
	armor = ARMOR_MAILLE
	armor_class = AC_LIGHT
	max_integrity = INTEGRITY_STRONG
	smeltresult = /obj/item/ingot/steel_slag
