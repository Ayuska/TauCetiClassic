/obj/effect/flood
	name = ""
	mouse_opacity = 0
	layer = FLY_LAYER
	color = "#66D1FF"
	icon = 'icons/effects/liquids.dmi'
	icon_state = "ocean"
	alpha = FLUID_MAX_ALPHA
	simulated = 0
	density = 0
	opacity = 0
	anchored = 1

/obj/effect/flood/ex_act()
	return

/obj/effect/flood/New()
	..()
	verbs.Cut()

/turf/var/fluid_blocked_dirs = 0
/turf/var/flooded // Whether or not this turf is absolutely flooded ie. a water source.

/proc/spawn_fluid(turf/T, amount)

	if(!istype(T))
		return

	T.add_fluid(null, amount)

/turf/proc/add_fluid(fluidtype = "water", amount)

	var/obj/effect/fluid/F = locate() in src
	if(!F)
		F = new(src)
	F.set_depth(F.fluid_amount + amount)

/turf/proc/remove_fluid(amount = 0)
	var/obj/effect/fluid/F = locate() in src
	if(!F)
		return
	F.lose_fluid(amount)

/turf/return_fluid()
	return (locate(/obj/effect/fluid) in contents)

/turf/Destroy()
	fluid_update()
	if(SSfluids)
		SSfluids.remove_active_source(src)
	return ..()

/turf/ChangeTurf(turf/N, tell_universe = 1, force_lighting_update = 0)
	var/old_flooded = flooded
	var/obj/effect/fluid/F = locate() in src
	. = ..()
	if(F)
		F.forceMove(src)
		F.start_loc = src
		fluid_update()
	if(old_flooded)
		flooded = 1
		update_icon()

/turf/simulated/atom_init()
	if((ticker.current_state == GAME_STATE_PLAYING) && SSfluids)
		fluid_update()
	. = ..()

/turf/check_fluid_depth(min)
	..()
	return (get_fluid_depth() >= min)

/turf/get_fluid_depth()
	..()
	if(is_flooded(absolute = 1))
		return FLUID_MAX_DEPTH
	var/obj/effect/fluid/F = return_fluid()
	return (istype(F) ? F.fluid_amount : 0 )

