/obj/item/clothing/armor/chainmail/bronze
	name = "bronze haubergeon"
	desc = "A maille shirt fashioned from hundreds of interlinked bronze rings. The value of flexible protection, especially in the centuries before plate, made any form of chainmail a rather valuable commodity."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "bhaubergeon"
	item_state = "bhaubergeon"
	armor = ARMOR_MAILLE_BRONZE
	max_integrity = INTEGRITY_STRONG + 75
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze

/obj/item/clothing/armor/chainmail/hauberk/bronze
	name = "bronze hauberk"
	desc = "A maille-aketon of bronze, sleeved to cover both the arms and legs. Light enough to leave a well-trained warrior unfettered, yet still capable of turning away both arrow and blade."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "bhauberk"
	item_state = "bhauberk"
	armor = ARMOR_MAILLE_BRONZE
	max_integrity = INTEGRITY_STRONG + 75
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze

/obj/item/clothing/armor/chainmail/light
	name = "haubyrnie"
	desc = "A sleeveless maille shirt, fashioned from dozens of interlinked steel rings. Light enough to comfortably tuck underneath a blouse, yet tough enough to thwart the razor-sharp edges of unwelcomed company."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
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

/obj/item/clothing/armor/chainmail/light/bronze
	name = "bronze haubyrnie"
	desc = "A sleeveless maille shirt, fashioned from dozens of interlinked bronze rings. For the discerning traveler - ideally, from an antique land."
	icon_state = "bhaubyrnie"
	item_state = "bhaubyrnie"
	armor = ARMOR_MAILLE_BRONZE
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL * 0.75
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze

/obj/item/clothing/armor/medium/scale/bronze
	name = "bronze lamellar"
	desc = "A coat of small bronze plates, segmented together in a manner not unlike chainmail. Divorced from the romanticized images of bare-chested legionnaires, but venerable nevertheless."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "blamellar"
	armor = ARMOR_MAILLE_BRONZE
	max_integrity = INTEGRITY_STRONG - 25
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze

/obj/item/clothing/armor/medium/scale/iron
	name = "iron lamellar"
	desc = "A coat of small iron plates, segmented together in a manner not unlike chainmail. This curious combination provides the best of both worlds; protection on par with more rigid sets of plate armor, but without all the weight."
	icon_state = "ilamellar"
	armor = ARMOR_MAILLE_IRON
	max_integrity = INTEGRITY_STANDARD + 50
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron

/obj/item/clothing/armor/leather/jacket/newmoon
	name = "newmoon jacket"
	desc = "A heavy, ornate coat of dense and sturdy fabric, protected well enough to see use in the field. A distinctive mark of a sacred order, worn with a holy amulet at the center of its chestpiece."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "newmoon_jacket"
	item_state = "newmoon_jacket"
	blocksound = SOFTHIT
	armor = ARMOR_MINIMAL
	nodismemsleeves = TRUE
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	max_integrity = INTEGRITY_STRONG
	armor_class = AC_MEDIUM
