/obj/structure/troia/shells
	name = "Bluespace Shells"
	desc = "Large caliber shells designed to be fitted into a ship-based artillery cannon."
	icon = 'icons/obj/structures.dmi'
	icon_state = "shells"
	density = 1
	anchored = 1

/obj/item/clothing/under/rank/camoflauge
	name = "green camoflauge"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "troiacamo"
	item_state = "troiacamo"
	objcolor = "troiacamo"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags = FPRINT | TABLEPASS


/obj/item/clothing/head/helmet/space/marine
	name = "military suit helmet"
	desc = "A standard issue helmet for NanoTrasen marine detachments."
	icon_state = "helm-marine"
	item_state = "helm-marine"
	objcolor = "helm-marine"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 60)
	var/obj/machinery/camera/camera

/obj/item/clothing/head/helmet/space/marine/attack_self(mob/user)
	if(camera)
		..(user)
	else
		camera = new /obj/machinery/camera(src)
		camera.network = list("MARINE")
		cameranet.removeCamera(camera)
		camera.c_tag = user.name
		user << "\blue User scanned as [camera.c_tag]. Camera activated."

/obj/item/clothing/head/helmet/space/marine/examine()
	..()
	if(get_dist(usr,src) <= 1)
		usr << "This helmet has a built-in camera. It's [camera ? "" : "in"]active."

/obj/item/clothing/suit/space/marine
	name = "military suit"
	desc = "A standard issue armored RIG for NanoTrasen marine detachments."
	icon_state = "suit-marine"
	item_state = "suit-marine"
	w_class = 3
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 1
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank, /obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/crowbar, \
	/obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer, /obj/item/weapon/gun/energy/laser, /obj/item/weapon/gun/energy/pulse_rifle, \
	/obj/item/weapon/gun/energy/taser, /obj/item/weapon/melee/baton, /obj/item/weapon/gun/energy/gun)
	siemens_coefficient = 0.6
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECITON_TEMPERATURE

/obj/item/weapon/gun/energy/smg
	name = "energy submachinegun"
	desc = "An advanced, military grade energy-based weapon with two settings: Stun and kill."
	icon_state = "esmgstun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'

	charge_cost = 50 //How much energy is needed to fire.
	projectile_type = "/obj/item/projectile/energy/electrode"
	origin_tech = "combat=5;magnets=3"
	modifystate = "esmgstun"

	var/mode = 0 //0 = stun, 1 = kill


	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 75
				fire_sound = 'sound/weapons/Laser.ogg'
				user << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam"
				modifystate = "esmgkill"
			if(1)
				mode = 0
				charge_cost = 50
				fire_sound = 'sound/weapons/Taser.ogg'
				user << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/electrode"
				modifystate = "esmgstun"
		update_icon()


/obj/item/weapon/gun/energy/plasma
	name = "plasma pistol"
	desc = "Experimental and highly valuable. Assigned to military forces."
	icon_state = "plasmastun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'

	charge_cost = 100 //How much energy is needed to fire.
	projectile_type = "/obj/item/projectile/energy/electrode"
	origin_tech = "combat=6;plasma=4"
	modifystate = "plasmastun"

	var/mode = 0 //0 = stun, 1 = kill


	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 125
				fire_sound = 'sound/weapons/laser3.ogg'
				user << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam/xray"
				modifystate = "plasmakill"
			if(1)
				mode = 0
				charge_cost = 100
				fire_sound = 'sound/weapons/Taser.ogg'
				user << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/electrode"
				modifystate = "plasmastun"
		update_icon()


/obj/structure/closet/marine
	name = "Marine Equipment"
	desc = "It's a storage unit for military equipment."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

/obj/structure/closet/marine/New()
	..()
	sleep(2)
	new /obj/item/clothing/under/rank/camoflauge(src)
	new /obj/item/clothing/tie/storage/webbing(src)
	new /obj/item/clothing/shoes/swat(src)
	new /obj/item/clothing/gloves/swat(src)
	new /obj/item/clothing/glasses/hud/security(src)
	new /obj/item/clothing/head/beret/centcom/officer(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/suit/armor/vest(src)

/obj/structure/shipgun/heavylaser
	name = "tri-focused laser cannon"
	desc = "A heavy duty laser turret able to punch damaging holes through both small fighters and large frigates alike."
	icon = 'cruiserguns.dmi'
	icon_state = "heavylaser1"
	anchored = 1


/obj/item/weapon/gun/rocketlauncher
	var/projectile
	name = "rocket launcher"
	desc = "MAGGOT."
	icon_state = "rocket"
	item_state = "rocket"
	w_class = 4.0
	throw_speed = 2
	throw_range = 10
	force = 5.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	origin_tech = "combat=8;materials=5"
	projectile = /obj/item/missile
	var/missile_speed = 2
	var/missile_range = 30
	var/max_rockets = 1
	var/list/rockets = new/list()

/obj/item/weapon/gun/rocketlauncher/examine()
	set src in view()
	..()
	if (!(usr in view(2)) && usr!=src.loc) return
	usr << "\blue [rockets.len] / [max_rockets] rockets."

/obj/item/weapon/gun/rocketlauncher/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/ammo_casing/rocket))
		if(rockets.len < max_rockets)
			user.drop_item()
			I.loc = src
			rockets += I
			user << "\blue You put the rocket in [src]."
			user << "\blue [rockets.len] / [max_rockets] rockets."
		else
			usr << "\red [src] cannot hold more rockets."

/obj/item/weapon/gun/rocketlauncher/can_fire()
	return rockets.len

/obj/item/weapon/gun/rocketlauncher/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		var/obj/item/missile/M = new projectile(user.loc)
		playsound(user.loc, 'sound/effects/bang.ogg', 50, 1)
		M.primed = 1
		M.throw_at(target, missile_range, missile_speed)
		message_admins("[key_name_admin(user)] fired a rocket from a rocket launcher ([src.name]).")
		log_game("[key_name_admin(user)] used a rocket launcher ([src.name]).")
		rockets -= I
		del(I)
		return
	else
		usr << "\red [src] is empty."

/obj/item/weapon/storage/box/explosives
	name = "Ordinance Box"
	icon_state = "box_of_doom"

/obj/item/weapon/storage/box/explosives/New()
	..()
	new /obj/item/ammo_casing/rocket(src)
	new /obj/item/ammo_casing/rocket(src)
	new /obj/item/ammo_casing/rocket(src)
	new /obj/item/ammo_casing/rocket(src)
	new /obj/item/ammo_casing/rocket(src)
	new /obj/item/ammo_casing/rocket(src)
	new /obj/item/ammo_casing/rocket(src)