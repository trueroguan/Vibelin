/obj/item/needle/bronze
	name = "bronze needle"
	desc = "A deceptively long needle with a craned tip, laced for labors-a-plenty."
	icon = 'modular_abel/gear/icons/items.dmi'
	icon_state = "bronzeneedle"
	stringamt = 30
	maxstring = 30

/obj/item/inqarticles/litany
	name = "litany"
	desc = "A writ of religious anointment, printed on holy parchment. It bears a psalm dating back to the first crusades, recited to bless the faithful upon the eve of battle. Traditionally, these litanies are burned after recitement, and their ashes are smeared across a chosen weapon to consecrate them."
	icon = 'modular_abel/gear/icons/items.dmi'
	icon_state = "litany"
	item_state = "litany"
	possible_item_intents = list(/datum/intent/bless)

/obj/item/inqarticles/litany/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if(!isitem(A) || user.used_intent.type != /datum/intent/bless)
		return
	var/datum/component/psyblessed/CP = A.GetComponent(/datum/component/psyblessed)
	if(!CP)
		return
	if(CP.is_blessed)
		to_chat(user, span_info("It has already been blessed."))
		return
	playsound(user, 'sound/magic/censercharging.ogg', 100)
	user.visible_message(span_info("[user] holds \the [src] over \the [A].."))
	if(do_after(user, 50, target = A))
		CP.try_bless()
		user.visible_message(span_blue("[user] finishes their rite, anointing \the [A] with \the [src]!"))
		new /obj/effect/temp_visual/censer_dust(get_turf(A))
		qdel(src)

/obj/item/kitchen/fork/bronze
	name = "bronze fork"
	icon = 'modular_abel/gear/icons/kitchenware.dmi'
	icon_state = "fork_bronze"
	melting_material = /datum/material/bronze
	melt_amount = 20

/obj/item/kitchen/spoon/bronze
	name = "bronze spoon"
	icon = 'modular_abel/gear/icons/kitchenware.dmi'
	icon_state = "spoon_bronze"
	melting_material = /datum/material/bronze
	melt_amount = 20

/obj/item/reagent_containers/glass/bowl/bronze
	icon = 'modular_abel/gear/icons/kitchenware.dmi'
	icon_state = "bowl_bronze"
	fill_icon_state = "bowl"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	melting_material = /datum/material/bronze
	melt_amount = 20
	max_usages = 7

/obj/item/reagent_containers/glass/bucket/pot/bronze
	icon = 'modular_abel/gear/icons/kitchenware.dmi'
	icon_state = "bronzepot"
	melting_material = /datum/material/bronze

/obj/item/cooking/pan/bronze
	name = "bronze pan"
	icon = 'modular_abel/gear/icons/kitchenware.dmi'
	icon_state = "bronzepan"
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze

/obj/item/reagent_containers/glass/cup/bronzemug
	name = "bronze mug"
	desc = "A sturdy bronze mug, fit for ale or cider."
	icon = 'modular_abel/gear/icons/kitchenware.dmi'
	icon_state = "bronzemug"
	item_weight = 180 GRAMS

/obj/item/reagent_containers/glass/cup/bronzegob
	name = "bronze goblet"
	desc = "A bronze goblet, favored where steel and silver are scarce."
	icon = 'modular_abel/gear/icons/kitchenware.dmi'
	icon_state = "bronzegoblet"
	item_weight = 180 GRAMS
