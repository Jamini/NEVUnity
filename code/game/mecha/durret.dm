/obj/mecha/combat/durand/durret
	name = "Mannable Turret"
	desc = "A mannable anti-boarding turret."
	anchored = 1
	icon_state = "durret"
	initial_icon = "durret"
	can_move = 0
/obj/mecha/combat/durand/durret/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	var/obj/item/mecha_parts/mecha_equipment/POWER = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	ME.attach(src)
	POWER.attach(src)
	return