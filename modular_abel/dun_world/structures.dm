/obj/structure/fluff/canopy
	name = "canopy"
	desc = "A canopy of striped fabric over a modest stall! A common sight in market towns, under which all manners of goods may be sold."
	icon = 'modular_abel/dun_world/icons/canopy.dmi'
	icon_state = "canopy"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASH
	resistance_flags = FLAMMABLE
	max_integrity = 20
	integrity_failure = 0.33
	dir = SOUTH
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/obj/structure/fluff/canopy/green
	icon_state = "canopyg"

/obj/structure/fluff/canopy/booth
	icon_state = "canopyr-booth"

/obj/structure/fluff/canopy/booth/Initialize()
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/canopy/booth/booth02
	icon_state = "canopyr-booth-2"

/obj/structure/fluff/canopy/booth/booth_green
	icon_state = "canopyg-booth"

/obj/structure/fluff/canopy/booth/booth_green02
	icon_state = "canopyg-booth-2"

/obj/structure/fluff/canopy/booth/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(get_dir(loc, mover) == dir)
		return FALSE

/obj/structure/fluff/canopy/booth/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/fluff/pillow
	name = "pillows"
	desc = "Soft plush pillows. Resting your head on one is so relaxing."
	icon = 'modular_abel/dun_world/icons/structure.dmi'
	icon_state = "pillow"
	density = FALSE

/obj/structure/fluff/pillow/red
	color = CLOTHING_RED

/obj/structure/fluff/pillow/blue
	color = CLOTHING_BLUE

/obj/structure/fluff/pillow/green
	color = CLOTHING_DARK_GREEN

/obj/structure/fluff/pillow/brown
	color = CLOTHING_BROWN

/obj/structure/fluff/pillow/magenta
	color = CLOTHING_MAGENTA

/obj/structure/fluff/pillow/purple
	color = CLOTHING_PURPLE

/obj/structure/fluff/pillow/black
	color = CLOTHING_BLACK

/obj/structure/fluff/dun_world_hookah
	name = "shisha pipe"
	desc = "A traditional shisha pipe."
	icon = 'modular_abel/dun_world/icons/structure.dmi'
	icon_state = "hookah"
	density = FALSE
	anchored = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 300

/obj/structure/fluff/ceramicswheel
	name = "potter's wheel"
	desc = "A rotating platform used by skilled artisans to mold and shape clay."
	icon = 'modular_abel/dun_world/icons/structure.dmi'
	icon_state = "potwheel"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 150
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/obj/structure/fluff/statue/dun_world_aasimar
	name = "aasimar statue"
	desc = "Stone wrought to resemble an Aasimar, the living artifice of the Gods. No life inhabits its eyes, nor strength in its limbs; mortal hands may only imitate divine crafts."
	icon_state = "aasimar"

/obj/structure/fluff/statue/dun_world_abyssor
	name = "abyssor statue"
	desc = "A slate statue of the ancient god Abyssor. One of many depictions drawn from a dream no doubt. This particular one is horrifying to look at."
	icon = 'modular_abel/dun_world/icons/tallandwide.dmi'
	icon_state = "abyssor"
	pixel_x = -16

/obj/structure/fluff/statue/dun_world_abyssor/dolomite
	desc = "A rare dolomite statue of the ancient god Abyssor, the Dreamer, He Who Slumbers, patron of the seas and all those that travel by them. He is asleep, and his followers pray fervently that he remains so for a very long time yet."
	icon_state = "abyssor_dolomite"

/obj/structure/fluff/statue/dun_world_psybloody
	name = "legionnaire statue"
	desc = "A statue styled in the manner of an ancient Legionnaire of times long past. Dried blood cakes its features."
	icon = 'modular_abel/dun_world/icons/statue96.dmi'
	icon_state = "psy_bloody"
	pixel_x = -32

/obj/structure/fluff/statue/dun_world_female1
	desc = "Beauty fades in all but stone."
	icon = 'icons/roguetown/misc/ay.dmi'
	icon_state = "2"
	pixel_x = -32
	pixel_y = -16

/obj/structure/fluff/statue/dun_world_female2
	desc = "Beauty fades in all but stone."
	icon = 'icons/roguetown/misc/ay.dmi'
	icon_state = "5"
	pixel_x = -32
	pixel_y = -16

/obj/structure/fluff/statue/femalestatue/dun_world_zizo
	desc = "An ancient statue depicting an elven woman."
	icon_state = "4"

/obj/structure/fluff/statue/knight/interior/r/dun_world_bronze
	color = "#ff9c1a"

/obj/structure/train/dun_world
	name = "far travel"
	desc = "Frankly, my dear, I don't give a damn.\n(Drag your sprite onto this to exit the round!)"
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'
	icon_state = "fartravel"
	layer = BELOW_OBJ_LAYER
	density = FALSE

/obj/structure/underworld/carriage_normal
	name = "carriage"
	desc = "The road home awaits."
	icon = 'modular_abel/dun_world/icons/carriage.dmi'
	icon_state = "carriage_normal"
	anchored = TRUE
	density = TRUE

/obj/effect/dun_world_oneway
	name = "one way effect"
	desc = ""
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "field_dir"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE

/obj/effect/dun_world_oneway/CanAllowThrough(atom/movable/mover, turf/target)
	var/turf/T = get_turf(src)
	var/turf/MT = get_turf(mover)
	return ..() && (T == MT || get_dir(MT, T) == dir)

/obj/effect/dun_world_oneway/barrier
	name = "magical barrier"
	desc = "Victory or death - once you pass this point you will either triumph or fall. Recommended 3 players or more."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING

/obj/structure/fluff/traveltile/dun_world_bathhouse
	name = "suspicious passage"
	desc = "A crevice in the wall. It looks like it leads somewhere."
	aportalid = "smuggler_bathhouse"
	aportalgoesto = "smuggler_cove"

/obj/structure/fluff/traveltile/dun_world_bathhouse/cave
	aportalid = "smuggler_cove"
	aportalgoesto = "smuggler_bathhouse"

/obj/structure/fluff/traveltile/dun_world_dungeon
	name = "gate"
	desc = "This gate's enveloping darkness is so oppressive you dread to step through it."
	icon = 'icons/roguetown/misc/portal.dmi'
	icon_state = "portal"
	bound_width = 96
	appearance_flags = NONE
	opacity = FALSE

/obj/structure/fake_machine/merchantvend/dun_world_silver
	name = "SILVERFACE"
	icon_state = "streetvendor1"

/obj/structure/fake_machine/merchantvend/dun_world_bath
	name = "BRASSFACE"
	icon_state = "vendor-bath"

/obj/structure/fake_machine/merchantvend/dun_world_wretch
	name = "Vile Vheslie"
	desc = "A ferocious little beast that hoards a mountain of goods under its home. The dreaded creechur is willing to part ways with its lower quality items... for a price."
	icon = 'modular_abel/dun_world/icons/structure.dmi'
	icon_state = "vheslie"

/obj/structure/fake_machine/merchantvend/dun_world_potions
	name = "POTIONSELLER"
	icon_state = "vendor-drugold"

/turf/open/floor/sand/dun_world
	name = "sand"
	desc = "Warm sand that, sadly, has been mixed with dirt."
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'
	icon_state = "grimshart"
	smoothing_flags = NONE
	smoothing_list = null
	neighborlay = null

/turf/open/floor/sand/dun_world/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/obj/structure/fluff/railing/corner/dun_world
	icon = 'modular_abel/dun_world/icons/railing.dmi'
	icon_state = "border"
	dir = 9

/obj/structure/fluff/psycross/baotha
	name = "spider cross"
	icon = 'modular_abel/dun_world/icons/tallstructure.dmi'
	icon_state = "cross_baotha"

/obj/structure/fluff/psycross/baotha/decorated
	name = "webbed spider cross"
	icon_state = "cross_baotha_u"

/obj/structure/fluff/psycross/graggar
	name = "vicious cross"
	icon = 'modular_abel/dun_world/icons/tallstructure.dmi'
	icon_state = "cross_graggar"

/obj/structure/fluff/psycross/graggar/decorated
	name = "revered vicious cross"
	icon_state = "cross_graggar_u"

/obj/structure/fluff/psycross/matthios
	name = "grinning cross"
	icon = 'modular_abel/dun_world/icons/tallstructure.dmi'
	icon_state = "cross_matthios"

/obj/structure/fluff/psycross/matthios/decorated
	name = "ornate cross"
	icon_state = "cross_matthios_u"

/obj/structure/fluff/psycross/necra
	name = "necran cross"
	icon = 'modular_abel/dun_world/icons/tallstructure.dmi'
	icon_state = "cross_necra"

/obj/structure/fluff/psycross/necra/cloth
	icon_state = "cross_necra_cloth"

/obj/structure/fluff/psycross/zizocross/stone
	name = "stone inverted cross"
	icon = 'modular_abel/dun_world/icons/tallstructure.dmi'
	icon_state = "cross_zizo_r"

/obj/structure/fluff/psycross/zizocross/golden
	name = "golden inverted cross"
	icon = 'modular_abel/dun_world/icons/tallstructure.dmi'
	icon_state = "cross_zizo_u"

/obj/structure/fluff/littlebanners
	name = "hanging little banners"
	icon = 'modular_abel/dun_world/icons/canopy.dmi'
	icon_state = "hangingbanners_wr"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASH
	resistance_flags = FLAMMABLE
	max_integrity = 20
	integrity_failure = 0.33
	dir = SOUTH

/obj/structure/fluff/littlebanners/bluered
	icon_state = "hangingbanners_br"

/obj/structure/fluff/littlebanners/bluewhite
	icon_state = "hangingbanners_bw"

/obj/structure/fluff/littlebanners/greenblue
	icon_state = "hangingbanners_gb"

/obj/structure/fluff/littlebanners/greenred
	icon_state = "hangingbanners_gr"

/obj/structure/fluff/littlebanners/greenwhite
	icon_state = "hangingbanners_gw"

/obj/effect/decal/herringbone
	name = "herringbone flooring"
	desc = "These stone bricks have been carefully arranged in a rather pleasing pattern."
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'
	icon_state = "herringedge"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/wood/herringbone
	name = "herringbone flooring"
	desc = "Thin planks of wood carefully arranged in a rather pleasing pattern."
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'
	icon_state = "herringbonewoodedge"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/wood/herringbone2
	name = "herringbone flooring"
	desc = "Thin planks of wood carefully arranged in a rather pleasing pattern."
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'
	icon_state = "herringbonewood2edge"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/fluff/dun_world_mossmother
	name = "Mossmother"
	desc = "One of the most sacred of trees. The very heart of the bog, its roots extend across every single inch of land drenched by maddened waters. Its moss is said to have magical properties."
	icon = 'modular_abel/dun_world/icons/hag_tree.dmi'
	icon_state = "mossmother"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	pixel_y = -30

/obj/structure/fluff/dun_world_mossmother/tree
	name = "Heartroot tree"
	desc = "No one knows why, but these trees seem nigh indestructible. You feel uneasy looking at this monstrosity of roots and bark."
	icon_state = "tree"

/obj/structure/noticeboard/dun_world
	name = "notice board"
	desc = "A large wooden notice board, carrying postings from all across the realm. A perch sits atop it."
	icon = 'modular_abel/dun_world/icons/noticeboard64.dmi'
	icon_state = "noticeboard0"

/obj/structure/noticeboard/dun_world/Initialize(mapload)
	. = ..()
	dun_world_refresh_icon()

/obj/structure/noticeboard/dun_world/attackby(obj/item/O, mob/user, list/modifiers)
	. = ..()
	dun_world_refresh_icon()

/obj/structure/noticeboard/dun_world/Topic(href, href_list)
	. = ..()
	dun_world_refresh_icon()

/obj/structure/noticeboard/dun_world/proc/dun_world_refresh_icon()
	icon_state = "noticeboard[clamp(notices, 0, 3)]"

/obj/structure/noticeboard/dun_world/wall
	icon = 'modular_abel/dun_world/icons/noticeboard32.dmi'

/obj/structure/fluff/walldeco/wantedposter/dun_world_excidium
	name = "Excidium"
	desc = "A device hungering for the flesh and souls of the wicked. While favored by Astratan orders and tolerated by Ravoxian sects, it is seen as nothing more than a barbaric implement by anyone else. This one allows one to meditate upon those who need to be brought to justice."
	icon = 'modular_abel/dun_world/icons/statue1.dmi'
	icon_state = "baldguy"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	SET_BASE_PIXEL(0, 0)

/obj/structure/fluff/walldeco/wantedposter/dun_world_excidium/Initialize()
	. = ..()
	icon_state = "baldguy"
	dir = SOUTH
