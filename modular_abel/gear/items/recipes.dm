/datum/anvil_recipe/tools/bronze/fork
	name = "Forks (bronze)"
	created_item = /obj/item/kitchen/fork/bronze
	output_amount = 2

/datum/anvil_recipe/tools/bronze/spoon
	name = "Spoons (bronze)"
	created_item = /obj/item/kitchen/spoon/bronze
	output_amount = 2

/datum/anvil_recipe/tools/bronze/bowl
	name = "Bowl (bronze)"
	created_item = /obj/item/reagent_containers/glass/bowl/bronze
	output_amount = 2

/datum/anvil_recipe/tools/bronze/pote
	name = "Cooking pot (bronze)"
	created_item = /obj/item/reagent_containers/glass/bucket/pot/bronze

/datum/anvil_recipe/tools/bronze/frypan
	name = "Pan (bronze)"
	created_item = /obj/item/cooking/pan/bronze

/datum/anvil_recipe/tools/bronze/mugbronze
	name = "Bronze Mugs"
	created_item = /obj/item/reagent_containers/glass/cup/bronzemug
	output_amount = 3

/datum/anvil_recipe/tools/bronze/gobletbronze
	name = "Bronze Goblets"
	created_item = /obj/item/reagent_containers/glass/cup/bronzegob
	output_amount = 3

/datum/anvil_recipe/armor/bronze/chaincoif
	name = "Chain Coif, Bronze"
	created_item = /obj/item/clothing/neck/chaincoif/bronze

/datum/anvil_recipe/armor/bronze/chainglove
	name = "Chain Gauntlets, Bronze"
	created_item = /obj/item/clothing/gloves/chain/bronze
	output_amount = 2

/datum/anvil_recipe/armor/bronze/haubergeon
	name = "Haubergeon, Bronze"
	created_item = /obj/item/clothing/armor/chainmail/bronze

/datum/anvil_recipe/armor/bronze/hauberk
	name = "Hauberk, Bronze (+Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/bronze
	craftdiff = 3

/datum/anvil_recipe/armor/bronze/haubyrnie
	name = "Haubyrnie, Bronze"
	created_item = /obj/item/clothing/armor/chainmail/light/bronze

/datum/anvil_recipe/armor/bronze/lamellar
	name = "Lamellar, Bronze (+Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/armor/medium/scale/bronze
	craftdiff = 3

/datum/anvil_recipe/armor/bronze/mailleboots
	name = "Maille Boots, Bronze (+2 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/boots/armor/bronze_maille
	output_amount = 2

/datum/anvil_recipe/armor/iron/lamellar
	name = "Lamellar, Iron (+Bar)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/medium/scale/iron
	craftdiff = 3

/datum/anvil_recipe/armor/iron/haubyrnie
	name = "Haubyrnie, Iron"
	created_item = /obj/item/clothing/armor/chainmail/light/iron

/datum/anvil_recipe/armor/steel/haubyrnie
	name = "Haubyrnie"
	created_item = /obj/item/clothing/armor/chainmail/light

/datum/anvil_recipe/armor/steel/mailleboots
	name = "Maille Boots (+2 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/boots/armor/maille_steel
	output_amount = 2

/datum/anvil_recipe/valuables/bronze/rings
	name = "Bronze Rings"
	created_item = /obj/item/clothing/ring/bronze
	output_amount = 3

/datum/repeatable_crafting_recipe/sewing/silkbra
	name = "giltsilk bra"
	output = /obj/item/clothing/shirt/silkbra
	requirements = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	category = "Undershirt"

/datum/repeatable_crafting_recipe/sewing/desertbra
	name = "desert bra"
	output = /obj/item/clothing/shirt/desertbra
	requirements = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Undershirt"

/datum/repeatable_crafting_recipe/sewing/desert_skirt
	name = "desert skirt"
	output = /obj/item/clothing/pants/skirt/desert
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	category = "Pants"

/datum/repeatable_crafting_recipe/sewing/maidfancy
	name = "fancy maid dress"
	output = /obj/item/clothing/shirt/dress/maidfancy
	requirements = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 2)
	craftdiff = 4
	category = "Dress"

/datum/repeatable_crafting_recipe/sewing/leo_robe_leopard
	name = "leopard robe (leopard colored)"
	output = /obj/item/clothing/shirt/leo_robe/leopard
	requirements = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 4
