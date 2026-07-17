/obj/item/clothing/shirt/dress/royal/hand_m
	name = "gilded dress shirt"
	desc = "A gold-embroidered dress shirt tailored for the right hand man."
	icon_state = "prince"
	item_state = "prince"
	boobed = TRUE
	detail_color = "#3a75c4"

/obj/item/clothing/shirt/dress/royal/hand_f
	name = "pristine dress"
	desc = "A flowy, intricate dress made by the finest tailors in the land for the right hand man."
	icon_state = "princess"
	item_state = "princess"
	boobed = TRUE
	detail_color = "#3a75c4"

/obj/item/clothing/shirt/dress/gown/wintergown/aristocratotava
	detail_color = "#1f1818"
	color = "#ffffff"

/obj/item/clothing/shirt/dress/maidfancy
	name = "valorian maid dress"
	desc = "A dress befitting the housekeeper of a lord's staff. While not as intricate as a royal's, it is indicative of the house's status."
	icon = 'modular_abel/gear/icons/shirts_port.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/shirts_port.dmi'
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	boobed = TRUE
	icon_state = "maiddressfancy"
	item_state = "maiddressfancy"
	detail_tag = "_detail"
	detail_color = CLOTHING_ASH_GREY

/obj/item/clothing/shirt/silkbra
	name = "giltsilk bra"
	desc = "An exquisite bra crafted from the finest silk and adorned with gold rings. It leaves little to the imagination."
	icon = 'modular_abel/gear/icons/shirts_port.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/shirts_port.dmi'
	icon_state = "silkbra"
	item_state = "silkbra"
	body_parts_covered = CHEST
	boobed = TRUE
	flags_inv = null
	slot_flags = ITEM_SLOT_SHIRT
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2

/obj/item/clothing/shirt/desertbra
	name = "desert bra"
	desc = "An exquisite bra crafted from durable cloth. It leaves little to the imagination."
	icon = 'modular_abel/gear/icons/shirts_port.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/shirts_port.dmi'
	icon_state = "desertbra"
	item_state = "desertbra"
	body_parts_covered = CHEST
	boobed = FALSE
	flags_inv = null
	slot_flags = ITEM_SLOT_SHIRT
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 3

/obj/item/clothing/pants/skirt/desert
	name = "desert skirt"
	desc = "At least it cools me off, but what of the modesty?"
	icon_state = "desertskirt"
	item_state = "desertskirt"
