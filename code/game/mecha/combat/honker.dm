/obj/mecha/combat/honker
	desc = "Produced by \"Acetic Co LTL Industries\", this exosuit is designed for riot-control."
	name = "Josiah"
	icon_state = "honker"
	initial_icon = "honker"
	step_in = 4
	health = 120
	deflect_chance = 25
	internal_damage_threshold = 60
	damage_absorption = list("brute"=0.9,"fire"=1.1,"bullet"=1,"laser"=1,"energy"=1,"bomb"=0.5)
	max_temperature = 25000
	infra_luminosity = 5
	wreckage = /obj/effect/decal/mecha_wreckage/honker
	add_req_access = 0
	max_equip = 3

/*
/obj/mecha/combat/honker/New()
	..()

	weapons += new /datum/mecha_weapon/honker(src)
	weapons += new /datum/mecha_weapon/missile_rack/banana_mortar(src)
	weapons += new /datum/mecha_weapon/missile_rack/mousetrap_mortar(src)
	selected_weapon = weapons[1]
	return
*/


/obj/mecha/combat/honker/melee_action(target)
	if(!melee_can_hit)
		return
	else if(istype(target, /mob))
		step_away(target,src,15)
	return

/obj/mecha/combat/honker/get_stats_part()
	var/output = ..()
	return output