/obj/structure/drape
	name = "drape"
	desc = "A hanging of cloth."
	plane = -3
	anchored = TRUE

/obj/structure/drape/desert
	name = "desert drape"
	desc = "Made from durable fabric, it serves its purpose."
	icon = 'modular_abel/ratwood/icons/deserttown/drapes.dmi'
	icon_state = "desertdrape"

/datum/blueprint_recipe/structure/desert_drape
	name = "Desert Drape"
	desc = "A hanging drape of durable desert fabric."
	result_type = /obj/structure/drape/desert
	required_materials = list(
		/obj/item/natural/cloth = 2
	)
	construct_tool = /obj/item/needle
	skillcraft = /datum/attribute/skill/misc/sewing
	craftdiff = 1

/obj/structure/drape/zybantine
	name = "zybantine drape"
	desc = "Made from prestigious fabric, a display of wealth."
	icon = 'modular_abel/ratwood/icons/deserttown/drapes.dmi'
	icon_state = "zybantinedrape1"
	color = "#a3a3a3"

/obj/structure/drape/zybantine/Initialize()
	. = ..()
	icon_state = "zybantinedrape[rand(1, 2)]"

/datum/blueprint_recipe/structure/zybantine_drape
	name = "Fancy Zybantine Drape"
	desc = "A prestigious hanging drape."
	result_type = /obj/structure/drape/zybantine
	required_materials = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/silk = 2
	)
	construct_tool = /obj/item/needle
	skillcraft = /datum/attribute/skill/misc/sewing
	craftdiff = 4

/obj/item/cushion
	name = "cushion"
	desc = "A soft cushion for sitting."
	icon = 'modular_abel/ratwood/icons/deserttown/cushions.dmi'
	icon_state = "desertcushion1"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/cushion/desert1
	name = "desert cushion"
	icon_state = "desertcushion1"

/obj/item/cushion/desert2
	name = "desert cushion"
	icon_state = "desertcushion2"

/obj/item/cushion/zybantine
	name = "zybantine cushion"
	icon_state = "zybantinecushion"

/datum/repeatable_crafting_recipe/sewing/desert_cushion
	name = "desert cushion (yellow)"
	output = /obj/item/cushion/desert1
	requirements = list(/obj/item/natural/cloth = 2)
	craftdiff = 2
	category = "Misc Sewing"

/datum/repeatable_crafting_recipe/sewing/desert_cushion_grey
	name = "desert cushion (grey)"
	output = /obj/item/cushion/desert2
	requirements = list(/obj/item/natural/cloth = 2)
	craftdiff = 2
	category = "Misc Sewing"

/datum/repeatable_crafting_recipe/sewing/zybantine_cushion
	name = "zybantine cushion"
	output = /obj/item/cushion/zybantine
	requirements = list(/obj/item/natural/silk = 2)
	craftdiff = 4
	category = "Misc Sewing"

/obj/structure/fermentation_keg/sandpot
	name = "sand pot"
	desc = "A common clay pot used for storing and sometimes fermenting fluids. Favoured over wooden barrels in the desert due to the relative scarcity of wood."
	icon = 'modular_abel/ratwood/icons/deserttown/pots.dmi'
	icon_state = "sandpot1"

/obj/structure/fermentation_keg/sandpot/Initialize()
	. = ..()
	icon_state = "sandpot[rand(1, 2)]"

/obj/structure/fermentation_keg/sandpot/random/water/Initialize()
	. = ..()
	icon_state = "sandpot1"
	reagents.add_reagent(/datum/reagent/water, rand(0, 900))

/obj/structure/fermentation_keg/sandpot/random/beer/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0, 900))

/obj/structure/fermentation_keg/sandpot/random/wine/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0, 900))

/obj/structure/fermentation_keg/sandpot/water/Initialize()
	. = ..()
	icon_state = "sandpot1"
	reagents.add_reagent(/datum/reagent/water, 900)

/obj/structure/fermentation_keg/sandpot/beer/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, 900)

/obj/structure/fermentation_keg/sandpot/wine/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, 900)

/datum/blueprint_recipe/structure/sandpot
	name = "Sand Pot"
	desc = "A clay pot for storing and fermenting fluids."
	result_type = /obj/structure/fermentation_keg/sandpot
	required_materials = list(
		/obj/item/natural/clay = 1
	)
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/attribute/skill/craft/crafting
	craftdiff = 1

/obj/structure/fermentation_keg/fancypot
	name = "fancy pot"
	desc = "Decorative and practical."
	icon = 'modular_abel/ratwood/icons/deserttown/pots.dmi'
	icon_state = "fancypot1"

/obj/structure/fermentation_keg/fancypot/Initialize()
	. = ..()
	icon_state = "fancypot[rand(1, 2)]"

/obj/structure/fermentation_keg/fancypot/random/water/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/water, rand(0, 900))

/obj/structure/fermentation_keg/fancypot/random/beer/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0, 900))

/obj/structure/fermentation_keg/fancypot/random/wine/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0, 900))

/obj/structure/fermentation_keg/fancypot/water/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/water, 900)

/obj/structure/fermentation_keg/fancypot/beer/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, 900)

/obj/structure/fermentation_keg/fancypot/wine/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, 900)

/datum/blueprint_recipe/structure/fancypot
	name = "Fancy Pot"
	desc = "A decorated clay pot."
	result_type = /obj/structure/fermentation_keg/fancypot
	required_materials = list(
		/obj/item/natural/clay = 1
	)
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/attribute/skill/craft/crafting
	craftdiff = 3

/obj/item/reagent_containers/glass/bucket/tinypot
	name = "tiny pot"
	icon = 'modular_abel/ratwood/icons/deserttown/pots.dmi'
	icon_state = "tinypot1"

/obj/machinery/light/fueled/wallfire/desert_fireplace
	name = "desert fireplace"
	desc = "A hearth of sun-fired brick, built to hold warmth through cold desert nights."
	icon = 'modular_abel/ratwood/icons/deserttown/fireplace.dmi'
	icon_state = "fireplace1"
	base_state = "fireplace"
	brightness = 4
	bulb_colour = "#ffa35c"
	density = FALSE
	anchored = TRUE

/obj/structure/pillar
	name = "pillar"
	desc = "A carved pillar of stone."
	icon = 'modular_abel/ratwood/icons/deserttown/sandpillar.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	pixel_x = -16
	plane = GAME_PLANE_UPPER
	abstract_type = /obj/structure/pillar

/obj/structure/pillar/sand1
	icon_state = "sandpillar1"

/datum/blueprint_recipe/structure/sand_pillar
	name = "Sandstone Pillar"
	desc = "A carved sandstone pillar."
	result_type = /obj/structure/pillar/sand1
	required_materials = list(
		/obj/item/natural/stone = 2
	)
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/attribute/skill/craft/masonry
	craftdiff = 4

/obj/structure/chair/wood/zybantine
	name = "zybantine chair"
	icon = 'modular_abel/ratwood/icons/deserttown/chairs.dmi'
	icon_state = "zybantinechair"

/obj/structure/chair/wood/dun_world_throne/zybantine
	name = "zybantine throne"
	icon_state = "zybantinethrone"
	icon = 'modular_abel/ratwood/icons/deserttown/throne.dmi'
	pixel_x = -16

/datum/blueprint_recipe/carpentry/zybantine_chair
	name = "Zybantine Chair"
	desc = "A wooden chair in zybantine fashion."
	result_type = /obj/structure/chair/wood/zybantine
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/attribute/skill/craft/carpentry
	craftdiff = 1

/obj/structure/chair/zybantine_sofa/right
	name = "zybantine sofa"
	icon_state = "zybantinesofa_right"
	icon = 'modular_abel/ratwood/icons/deserttown/chairs.dmi'
	item_chair = null

/obj/structure/chair/zybantine_sofa/left
	name = "zybantine sofa"
	icon_state = "zybantinesofa_left"
	icon = 'modular_abel/ratwood/icons/deserttown/chairs.dmi'
	item_chair = null

/obj/structure/sandrock
	name = "sandrock"
	desc = "A large desert rock protruding from the ground."
	icon_state = "rock1"
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock_boulders.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	debris = list(/obj/item/natural/stone = 10)
	pixel_x = -48
	pixel_y = -18
	layer = 4.81
	plane = GAME_PLANE_UPPER
	abstract_type = /obj/structure/sandrock

/obj/structure/sandrock/sandrock1
	icon_state = "sandrock1"

/obj/structure/sandrock/sandrock2
	icon_state = "sandrock2"

/obj/structure/sandrock/sandrock3
	icon_state = "sandrock3"

/obj/structure/sandrock/sandrock4
	icon_state = "sandrock4"

/obj/item/natural/rock/desert
	name = "sand rock"
	icon = 'modular_abel/ratwood/icons/deserttown/small_sandrock.dmi'
	icon_state = "sandrock1"

/obj/item/natural/rock/desert/Initialize()
	. = ..()
	icon_state = "sandrock[rand(1, 2)]"

/obj/structure/flora/grass/bush/desert
	name = "saigahorn"
	desc = "A hardy desert bush, horned like the beast it is named for."
	icon = 'modular_abel/ratwood/icons/deserttown/flora.dmi'
	icon_state = "saigahorn1"

/obj/structure/flora/grass/bush/desert/Initialize()
	. = ..()
	icon_state = "saigahorn[rand(1, 3)]"

/obj/structure/flora/grass/bush/desertshrub
	name = "treelet"
	desc = "A rounded bush-like tree or perhaps tree-like bush native to the deep desert. A valuable source of wood in the sparse dunes."
	icon = 'modular_abel/ratwood/icons/deserttown/flora.dmi'
	icon_state = "bushshrub1"
	attacked_sound = 'sound/misc/woodhit.ogg'
	max_integrity = 100
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/grown/log/tree/small = 1)

/obj/structure/flora/grass/bush/desertshrub/Initialize()
	. = ..()
	icon_state = "bushshrub[pick(1, 2)]"

/obj/structure/flora/tree/palm
	name = "palm tree"
	desc = "Scant, precious shade."
	icon = 'modular_abel/ratwood/icons/deserttown/bigpalm.dmi'
	icon_state = "palm1"
	stump_type = /obj/structure/flora/tree/stump/palm
	pixel_x = -32
	opacity = 0
	density = 0

/obj/structure/flora/tree/palm/Initialize()
	. = ..()
	icon_state = "palm[rand(1, 2)]"

/obj/structure/flora/tree/stump/palm
	name = "tree stump"
	desc = "Shade no more."
	icon_state = "palmstump1"
	icon = 'modular_abel/ratwood/icons/deserttown/bigpalm.dmi'
	stump_type = null
	pixel_x = -32
	density = 0

/obj/structure/flora/tree/stump/palm/Initialize()
	. = ..()
	icon_state = "palmstump[rand(1, 2)]"

/obj/structure/flora/grass/bush/wall/tall/desert
	icon = 'modular_abel/ratwood/icons/deserttown/foliagetall.dmi'

/obj/structure/stairs/desert
	name = "sand stairs"
	icon = 'modular_abel/ratwood/icons/deserttown/sandstairs.dmi'
	icon_state = "sandstairs"
	max_integrity = 600

/obj/structure/fluff/traveltile/alashurentrance
	desc = "Awake from this dream. The road to Al-Ashur awaits."
	name = "To Al-Ashur"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "underworldportal"

/obj/structure/vase
	name = "fancy pot"
	desc = "Decorative and practical."
	icon = 'modular_abel/ratwood/icons/deserttown/pots.dmi'
	icon_state = "fancypot1"
	anchored = TRUE
	opacity = FALSE
	density = TRUE
	max_integrity = 100

/obj/structure/window/stained/blue
	desc = "A stained-glass window filigreed in deep blue."
	icon = 'modular_abel/ratwood/icons/deserttown/windows.dmi'
	icon_state = "stained-blue"

/obj/structure/flora/grass/desertgrass
	name = "desert grass"
	desc = "Dry grass struggling to survive in the arid climate."
	icon = 'modular_abel/ratwood/icons/deserttown/flora.dmi'
	icon_state = "desertgrass1"

/obj/structure/flora/grass/desertgrass/update_icon()
	icon_state = "desertgrass[rand(1, 5)]"
	. = ..()
