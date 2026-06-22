/datum/anvil_recipe/armor/iron/taur_horseshoes
	name = "Iron Horseshoes (+1 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/taur_horseshoes

/datum/anvil_recipe/armor/steel/taur_horseshoes
	name = "Steel Horseshoes (+1 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/taur_horseshoes/steel

/datum/repeatable_crafting_recipe/leather/taur_horseshoes
	name = "leather hoofguards"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/shoes/taur_horseshoes/leather
