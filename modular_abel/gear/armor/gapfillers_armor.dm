/obj/item/clothing/armor/chainmail/light
	name = "haubyrnie"
	desc = "A sleeveless maille shirt, fashioned from dozens of interlinked steel rings. Light enough to comfortably tuck underneath a blouse, yet tough enough to thwart the razor-sharp edges of unwelcomed company."
	icon = 'modular_abel/gear/icons/armor_port.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor_port.dmi'
	icon_state = "haubyrnie"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	armor_class = AC_LIGHT
	armor = ARMOR_MAILLE
	body_parts_covered = COVERAGE_TORSO
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL
	material_category = ARMOR_MAT_CHAINMAIL
	smeltresult = /obj/item/ingot/steel_slag

/obj/item/clothing/armor/chainmail/light/iron
	name = "iron haubyrnie"
	desc = "A sleeveless maille shirt, fashioned from dozens of interlinked iron rings. For the discerning peasant."
	icon_state = "ihaubyrnie"
	item_state = "ihaubyrnie"
	armor = ARMOR_MAILLE_IRON
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL * 0.6
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron

/obj/item/clothing/shoes/boots/armor/maille_steel
	name = "maille boots"
	desc = "A pair of leather boots, reinforced with smaller steel plates along the feet and ankles. Woven into the top of each boot's cuff is a thick layer of chainmail."
	body_parts_covered = FEET
	icon = 'modular_abel/gear/icons/feet_port.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/feet_port.dmi'
	icon_state = "shalfplateboots"
	item_state = "shalfplateboots"
	armor = ARMOR_MAILLE
	armor_class = AC_LIGHT
	max_integrity = INTEGRITY_STRONG
	smeltresult = /obj/item/ingot/steel_slag

/obj/item/clothing/armor/medium/scale/iron
	name = "iron lamellar"
	desc = "A coat of small iron plates, segmented together in a manner not unlike chainmail. This curious combination provides the best of both worlds; protection on par with more rigid sets of plate armor, but without all the weight."
	icon_state = "ilamellar"
	armor = ARMOR_MAILLE_IRON
	max_integrity = INTEGRITY_STANDARD + 50
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron
