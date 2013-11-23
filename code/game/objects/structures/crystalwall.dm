/obj/structure/crywall
	desc = "A wall made of solid crystal. It is smooth and cool to the touch."
	name = "The crystal wall"
	icon = 'icons/obj/structures.dmi'
	icon_state = "crystal"
	density = 1
	anchored = 1
	flags = FPRINT | CONDUCT
	pressure_resistance = 10*ONE_ATMOSPHERE
	layer = 5
	explosion_resistance = 5
	var/health = 45
	var/destroyed = 0

/obj/structure/crywall/ex_act(severity)
	del(src)

/obj/structure/crywall/blob_act()
	del(src)

/obj/structure/crywall/meteorhit(var/obj/M)
	del(src)


/obj/structure/crywall/attack_paw(mob/user as mob)
	attack_hand(user)

/obj/structure/crywall/attack_hand(mob/user as mob)
	playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 80, 1)
	user.visible_message("<span class='warning'>[user] kicks [src].</span>", \
						 "<span class='warning'>You kick [src].</span>", \
						 "You hear breaking glass.")
	if(HULK in user.mutations)
		health -= 5
	else
		health -= 3
	healthcheck()

/obj/structure/crywall/attack_alien(mob/user as mob)
	if(istype(user, /mob/living/carbon/alien/larva))	return

	playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 80, 1)
	user.visible_message("<span class='warning'>[user] mangles [src].</span>", \
						 "<span class='warning'>You mangle [src].</span>", \
						 "You hear breaking glass.")

/obj/structure/crywall/attack_slime(mob/user as mob)
	if(!istype(user, /mob/living/carbon/slime/adult))	return

	playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 80, 1)
	user.visible_message("<span class='warning'>[user] smashes against [src].</span>", \
						 "<span class='warning'>You smash against [src].</span>", \
						 "You hear breaking glass.")

	health -= rand(2,3)
	healthcheck()
	return

/obj/structure/crywall/attack_animal(var/mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)	return

	playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 80, 1)
	M.visible_message("<span class='warning'>[M] smashes against [src].</span>", \
					  "<span class='warning'>You smash against [src].</span>", \
					  "You hear breaking glass.")

	health -= M.melee_damage_upper
	healthcheck()
	return


/obj/structure/crywall/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	src.health -= Proj.damage*0.2
	healthcheck()
	return 0


/obj/structure/crywall/proc/healthcheck()
	if(health <= 0)
		new /obj/item/weapon/shard(loc)
		new /obj/item/weapon/shard(loc)
		new /obj/item/weapon/shard(loc)
		new /obj/item/weapon/shard(loc)
		del(src)
		return
	return

/obj/structure/crywall/vox
	desc = "A wall made of solid crystal. It looks like there is something suspended inside!"
	name = "The crystal wall"
	icon_state = "crystal_vox"
	health = 90

/obj/structure/crywall/vox/healthcheck()
	if(health <= 0)
		new /obj/structure/crywall/vox_free (src.loc)
		del(src)
		return
	return

/obj/structure/crywall/vox_free
	desc = "A wall made of solid crystal. It looks like there is something suspended inside!"
	name = "The crystal wall"
	icon_state = "crystal_vox_free"
	anchored = 0
	health = 90

/obj/structure/crywall/vox_free/healthcheck()
	if(health <= 0)
		new /obj/effect/landmark/mobcorpse/vox (src.loc)
		del(src)
		return
	return


/obj/structure/crywall/attackby(obj/item/weapon/W as obj, mob/user as mob)
	playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 80, 1)
	switch(W.damtype)
		if("fire")
			health -= W.force
		if("brute")
			health -= W.force * 0.75
	healthcheck()
	..()
	return