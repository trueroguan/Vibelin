/obj/item/enchantingkit
	name = "morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item."
	icon = 'modular_abel/gear/icons/items.dmi'
	icon_state = "enchanting_kit"
	w_class = WEIGHT_CLASS_SMALL
	var/list/target_items = list()
	var/result_item = null

/obj/item/enchantingkit/pre_attack(obj/item/I, mob/user)
	if(!I || !user)
		return ..()
	if(!is_type_in_list(I, target_items))
		return ..()
	var/R_type = null
	if(LAZYLEN(target_items))
		for(var/T in target_items)
			if(istype(I, T))
				R_type = target_items[T]
				break
	if(!R_type && result_item)
		R_type = result_item
	if(!R_type)
		to_chat(user, span_warning("[src] doesn't know how to morph [I]."))
		return TRUE
	if(I.loc == user)
		user.temporarilyRemoveItemFromInventory(I, TRUE)
	var/turf/T = get_turf(user)
	if(!T)
		T = get_turf(I)
	if(!T)
		to_chat(user, span_warning("Nowhere to morph [I]."))
		return TRUE
	var/obj/item/R = new R_type(T)
	to_chat(user, span_notice("You apply [src] to [I], using the enchanting dust and tools to turn it into [R]."))
	R.name += " <font size = 1>([I.name])</font>"
	qdel(I)
	if(!user.put_in_hands(R))
		R.forceMove(get_turf(user))
	if(ismob(user))
		var/mob/M = user
		M.update_body()
	qdel(src)
	return TRUE

/obj/item/enchantingkit/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking the appropriate item with this elixir will gift it a unique appearance.")

/obj/item/enchantingkit/weapon/pre_attack(obj/item/I, mob/user)
	if(!I || !user)
		return ..()
	if(!is_type_in_list(I, target_items))
		return ..()
	var/R_type = result_item
	if(!R_type)
		to_chat(user, span_warning("[src] doesn't know how to morph [I]."))
		return TRUE
	var/obj/item/weapon/RI = R_type
	var/obj/item/weapon/TI = I
	TI.icon = initial(RI.icon)
	TI.icon_state = initial(RI.icon_state)
	TI.item_state = initial(RI.item_state)
	TI.lefthand_file = initial(RI.lefthand_file)
	TI.righthand_file = initial(RI.righthand_file)
	to_chat(user, span_notice("You apply [src] to [I], using the enchanting dust and tools to turn it into [initial(RI.name)]."))
	I.name = "[initial(RI.name)] <font size = 1>([I.name])</font>"
	I.desc = initial(RI.desc)
	I.update_icon()
	if(ismob(user))
		var/mob/M = user
		M.update_body()
	qdel(src)
	return TRUE
