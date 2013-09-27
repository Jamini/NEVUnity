//this is everything i'm going to be using in my outpost zeta map, and possibly future maps.

turf/unsimulated/desert
	name = "desert"
	icon = 'desert.dmi'
	icon_state = "desert"
	temperature = 393.15
	luminosity = 5
	lighting_lumcount = 8

turf/unsimulated/desert/New()
	icon_state = "desert[rand(0,4)]"

turf/simulated/wall/impassable_rock
	name = "Mountain Wall"

	//so that you can see the impassable sections in the map editor
	icon_state = "riveted"
	New()
		icon_state = "rock"

/area/awaymission/labs/researchdivision
	name = "Research"
	icon_state = "away3"

/area/awaymission/labs/militarydivision
	name = "Military"
	icon_state = "away2"

/area/awaymission/labs/gateway
	name = "Gateway"
	icon_state = "away1"

/area/awaymission/labs/command
	name = "Command"
	icon_state = "away"

/area/awaymission/labs/civilian
	name = "Civilian"
	icon_state = "away3"

/area/awaymission/labs/cargo
	name = "Cargo"
	icon_state = "away2"

/area/awaymission/labs/medical
	name = "Medical"
	icon_state = "away1"

/area/awaymission/labs/security
	name = "Security"
	icon_state = "away"

/area/awaymission/labs/solars
	name = "Solars"
	icon_state = "away3"

/area/awaymission/labs/cave
	name = "Caves"
	icon_state = "away2"

//corpses and possibly other decorative items

/obj/effect/landmark/aliencorpse
	name = "Unknown"
	var/mobname = "Unknown"  //Unused now but it'd fuck up maps to remove it now
	var/corpseuniform = null //Set this to an object path to have the slot filled with said object on the corpse.
	var/corpsesuit = null
	var/corpseshoes = null
	var/corpsegloves = null
	var/corpseradio = null
	var/corpseglasses = null
	var/corpsemask = null
	var/corpsehelmet = null
	var/corpsebelt = null
	var/corpsepocket1 = null
	var/corpsepocket2 = null
	var/corpseback = null
	var/corpseid = 0     //Just set to 1 if you want them to have an ID
	var/corpseidjob = null // Needs to be in quotes, such as "Clown" or "Chef." This just determines what the ID reads as, not their access
	var/corpseidaccess = null //This is for access. See access.dm for which jobs give what access. Again, put in quotes. Use "Captain" if you want it to be all access.
	var/corpseidicon = null //For setting it to be a gold, silver, centcomm etc ID
	var/mutantrace = "vox"

/obj/effect/landmark/aliencorpse/initialize()
	createCorpse()

/obj/effect/landmark/aliencorpse/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/vox/M = new /mob/living/carbon/human/vox (src.loc)
	M.dna.mutantrace = mutantrace
	M.real_name = src.name
	M.death(1) //Kills the new mob
	if(src.corpseuniform)
		M.equip_to_slot_or_del(new src.corpseuniform(M), slot_w_uniform)
	if(src.corpsesuit)
		M.equip_to_slot_or_del(new src.corpsesuit(M), slot_wear_suit)
	if(src.corpseshoes)
		M.equip_to_slot_or_del(new src.corpseshoes(M), slot_shoes)
	if(src.corpsegloves)
		M.equip_to_slot_or_del(new src.corpsegloves(M), slot_gloves)
	if(src.corpseradio)
		M.equip_to_slot_or_del(new src.corpseradio(M), slot_l_ear)
	if(src.corpseglasses)
		M.equip_to_slot_or_del(new src.corpseglasses(M), slot_glasses)
	if(src.corpsemask)
		M.equip_to_slot_or_del(new src.corpsemask(M), slot_wear_mask)
	if(src.corpsehelmet)
		M.equip_to_slot_or_del(new src.corpsehelmet(M), slot_head)
	if(src.corpsebelt)
		M.equip_to_slot_or_del(new src.corpsebelt(M), slot_belt)
	if(src.corpsepocket1)
		M.equip_to_slot_or_del(new src.corpsepocket1(M), slot_r_store)
	if(src.corpsepocket2)
		M.equip_to_slot_or_del(new src.corpsepocket2(M), slot_l_store)
	if(src.corpseback)
		M.equip_to_slot_or_del(new src.corpseback(M), slot_back)
	if(src.corpseid == 1)
		var/obj/item/weapon/card/id/W = new(M)
		W.name = "[M.real_name]'s ID Card"
		var/datum/job/jobdatum
		for(var/jobtype in typesof(/datum/job))
			var/datum/job/J = new jobtype
			if(J.title == corpseidaccess)
				jobdatum = J
				break
		if(src.corpseidicon)
			W.icon_state = corpseidicon
		if(src.corpseidaccess)
			if(jobdatum)
				W.access = jobdatum.get_access()
			else
				W.access = list()
		if(corpseidjob)
			W.assignment = corpseidjob
		W.registered_name = M.real_name
		M.equip_to_slot_or_del(W, slot_wear_id)
	del(src)


/obj/effect/landmark/aliencorpse/raider
	name = "Vox Raider"
	corpseuniform = /obj/item/clothing/under/vox/vox_robes
	corpseradio = /obj/item/device/radio/headset/syndicate
	corpsesuit = /obj/item/clothing/suit/space/vox/carapace
	corpsebelt = /obj/item/weapon/storage/belt/utility/full
	corpsehelmet = /obj/item/clothing/head/helmet/space/vox/carapace
	corpsegloves = /obj/item/clothing/gloves/yellow/vox
	corpseshoes = /obj/item/clothing/shoes/magboots/vox
	corpseid = 0

/obj/effect/landmark/aliencorpse/medic
	name = "Vox Medic"
	corpseuniform = /obj/item/clothing/under/vox/vox_robes
	corpseradio = /obj/item/device/radio/headset/syndicate
	corpsesuit = /obj/item/clothing/suit/space/vox/medic
	corpsebelt = /obj/item/weapon/storage/belt/utility/full
	corpsehelmet = /obj/item/clothing/head/helmet/space/vox/medic
	corpsegloves = /obj/item/clothing/gloves/yellow/vox
	corpseshoes = /obj/item/clothing/shoes/magboots/vox
	corpseid = 0

/obj/effect/landmark/aliencorpse/engie
	name = "Vox Engineer"
	corpseuniform = /obj/item/clothing/under/vox/vox_robes
	corpseradio = /obj/item/device/radio/headset/syndicate
	corpsesuit = /obj/item/clothing/suit/space/vox/pressure
	corpsebelt = /obj/item/weapon/storage/belt/utility/full
	corpsehelmet = /obj/item/clothing/head/helmet/space/vox/pressure
	corpsegloves = /obj/item/clothing/gloves/yellow/vox
	corpseshoes = /obj/item/clothing/shoes/magboots/vox
	corpseid = 0

/obj/effect/landmark/corpse/overseer
	name = "Overseer"
	corpseuniform = /obj/item/clothing/under/rank/navyhead_of_security
	corpsesuit = /obj/item/clothing/suit/armor/hosnavycoat
	corpseradio = /obj/item/device/radio/headset/heads/captain
	corpsegloves = /obj/item/clothing/gloves/black/hos
	corpseshoes = /obj/item/clothing/shoes/swat
	corpsehelmet = /obj/item/clothing/head/beret/navyhos
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpseid = 1
	corpseidjob = "Facility Overseer"
	corpseidaccess = "Captain"

/obj/effect/landmark/corpse/officer
	name = "Security Officer"
	corpseuniform = /obj/item/clothing/under/rank/navysecurity
	corpsesuit = /obj/item/clothing/suit/armor/navysecvest
	corpseradio = /obj/item/device/radio/headset/headset_sec
	corpseshoes = /obj/item/clothing/shoes/swat
	corpsehelmet = /obj/item/clothing/head/beret/navysec
	corpseid = 1
	corpseidjob = "Security Officer"
	corpseidaccess = "Security Officer"

/*
 * Weeds
 */
#define NODERANGE 1

/obj/effect/alien/flesh/weeds
	name = "Fleshy Growth"
	desc = "A pulsating grouping of odd, alien tissues. It's almost like it has a heartbeat..."
	icon = 'biocraps.dmi'
	icon_state = "flesh"

	anchored = 1
	density = 0
	var/health = 15
	var/obj/effect/alien/weeds/node/linked_node = null

/obj/effect/alien/flesh/weeds/node
	icon_state = "fleshnode"
	icon = 'biocraps.dmi'
	name = "Throbbing Pustule"
	desc = "A grotquese, oozing, pimple-like growth. You swear you can see something moving around in the bulb..."
	luminosity = NODERANGE
	var/node_range = NODERANGE

/obj/effect/alien/flesh/weeds/node/New()
	..(src.loc, src)


/obj/effect/alien/flesh/weeds/New(pos, node)
	..()
	linked_node = node
	if(istype(loc, /turf/space))
		del(src)
		return
	if(icon_state == "flesh")icon_state = pick("flesh", "flesh1", "flesh2")
	spawn(rand(150, 200))
		if(src)
			Life()
	return

/obj/effect/alien/flesh/weeds/proc/Life()
	set background = 1
	var/turf/U = get_turf(src)
/*
	if (locate(/obj/movable, U))
		U = locate(/obj/movable, U)
		if(U.density == 1)
			del(src)
			return

Alien plants should do something if theres a lot of poison
	if(U.poison> 200000)
		health -= round(U.poison/200000)
		update()
		return
*/
	if (istype(U, /turf/space))
		del(src)
		return

	direction_loop:
		for(var/dirn in cardinal)
			var/turf/T = get_step(src, dirn)

			if (!istype(T) || T.density || locate(/obj/effect/alien/flesh/weeds) in T || istype(T.loc, /area/arrival) || istype(T, /turf/space))
				continue

			if(!linked_node || get_dist(linked_node, src) > linked_node.node_range)
				return

	//		if (locate(/obj/movable, T)) // don't propogate into movables
	//			continue

			for(var/obj/O in T)
				if(O.density)
					continue direction_loop

			new /obj/effect/alien/flesh/weeds(T, linked_node)


/obj/effect/alien/flesh/weeds/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
		if(2.0)
			if (prob(50))
				del(src)
		if(3.0)
			if (prob(5))
				del(src)
	return

/obj/effect/alien/flesh/weeds/attackby(var/obj/item/weapon/W, var/mob/user)
	if(W.attack_verb.len)
		visible_message("\red <B>\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]")
	else
		visible_message("\red <B>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]")

	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

	health -= damage
	healthcheck()

/obj/effect/alien/flesh/weeds/proc/healthcheck()
	if(health <= 0)
		del(src)


/obj/effect/alien/flesh/weeds/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		health -= 5
		healthcheck()

/*/obj/effect/alien/weeds/burn(fi_amount)
	if (fi_amount > 18000)
		spawn( 0 )
			del(src)
			return
		return 0
	return 1
*/

#undef NODERANGE

//clothing, weapons, and other items that can be worn or used in some way

/obj/item/clothing/under/rank/navywarden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpsuit"
	icon_state = "wardendnavyclothes"
	item_state = "wardendnavyclothes"
	color = "wardendnavyclothes"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/rank/navysecurity
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "officerdnavyclothes"
	item_state = "officerdnavyclothes"
	color = "officerdnavyclothes"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/rank/navyhead_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon_state = "hosdnavyclothes"
	item_state = "hosdnavyclothes"
	color = "hosdnavyclothes"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags = FPRINT | TABLEPASS

/obj/item/clothing/suit/armor/hosnavycoat
	name = "armored coat"
	desc = "A coat enchanced with a special alloy for some protection and style."
	icon_state = "hosdnavyjacket"
	item_state = "armor"
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/head/beret/navysec
	name = "security beret"
	desc = "A beret with the security insignia emblazoned on it. For officers that are more inclined towards style than safety."
	icon_state = "officerberet"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/beret/navywarden
	name = "warden's beret"
	desc = "A beret with a two-colored security insignia emblazoned on it. For wardens that are more inclined towards style than safety."
	icon_state = "wardenberet"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/beret/navyhos
	name = "security head's beret"
	desc = "A stylish beret bearing a golden insignia that proudly displays the security coat of arms. A commander's must-have."
	icon_state = "hosberet"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/suit/armor/navysecvest
	name = "armored coat"
	desc = "An armored coat that protects against some damage."
	icon_state = "officerdnavyjacket"
	item_state = "armor"
	flags = FPRINT | TABLEPASS
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/navywardenvest
	name = "Warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon_state = "wardendnavyjacket"
	item_state = "armor"
	flags = FPRINT | TABLEPASS
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

//hostile entities or npcs

/obj/item/projectile/slimeglob
	icon = 'projectiles.dmi'
	icon_state = "toxin"
	damage = 20
	damage_type = BRUTE

/obj/item/projectile/slimeglob
	icon = 'projectiles.dmi'
	icon_state = "toxin"
	damage = 20
	damage_type = BRUTE

/mob/living/simple_animal/hostile/fleshmonster
	name = "Fleshy Horror"
	desc = "A grotesque, shambling fleshy horror... was this once a... a person?"
	icon = 'icons/mob/mob.dmi'
	icon_state = "horror"
	icon_living = "horror"
	icon_dead = "horror"
	health = 160
	maxHealth = 240
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = "claws"
	projectilesound = 'sound/weapons/bite.ogg'
	projectiletype = /obj/item/projectile/neurotox
	faction = "flesh"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4
	ranged = 0

/mob/living/simple_animal/hostile/fleshmonster/fleshslime
	name = "Flesh Slime"
	icon = 'biocraps.dmi'
	icon_state = "livingflesh"
	desc = "A creature that appears to be made out of living tissue strewn together haphazardly. Some kind of liquid bubbles from its maw."
	ranged = 1
	health = 120

/mob/living/simple_animal/hostile/fleshmonster/Die()
	..()
	visible_message("<b>[src]</b> disintegrates into mush!")
	new /obj/effect/decal/remains/xeno(src.loc)
	playsound(loc, 'sound/voice/hiss6.ogg', 80, 1, 1)
	del src
	return

//machinery and lore objects

/obj/machinery/computer/personal
	name = "Personal Log Computer"
	icon = 'computer.dmi'
	icon_state = "medlaptop"
	circuit = "/obj/item/weapon/circuitboard/research_shuttle"

/obj/machinery/computer/personal/dorms
	name = "Personal Log Computer"
	desc = "An old-model laptop that bears the science emblem of a corporation you've not heard of. It is faded and has dried blood splattered across the screen."
	icon = 'computer.dmi'
	icon_state = "medlaptop"
	circuit = "/obj/item/weapon/circuitboard/research_shuttle"

/obj/machinery/computer/personal/dorms/attack_hand(user as mob)
	src.add_fingerprint(usr)
	var/dat = "<center>Czerka Corporation</center><br> <center>Dr. Thomas Johnson</center><br><br>Stardate: April 22, 2435<br><br> We couldn't stop it. It's spread through the ship and has taken many of my colleagues. All we could do was watch in horror as it slaughtered our friends and co-workers.<br><br>Those damned abominations. I told Doctor Michaels that powering up the gateway on dubious coordinates pilfered from ancient artifacts was not a safe thing to do on a ship with as small of a guard as this one.<br><br>But it doesn't matter now. Delilah and I have locked ourselves in our room and plan to spend our last hours together.If anyone finds this, please. Destroy this ship.<br><br>Don't let them spread back to civilization."

	user << browse("[dat]", "window=logs;size=800x400")

/obj/machinery/computer/personal/gateway
	name = "Personal Log Computer"
	desc = "An old laptop that appears hardwired into a multitude of servers and electronics beneath the table. It bears the science emblem of a corporation you've not heard of."
	icon = 'computer.dmi'
	icon_state = "medlaptop"
	circuit = "/obj/item/weapon/circuitboard/research_shuttle"

/obj/machinery/computer/personal/gateway/attack_hand(user as mob)
	src.add_fingerprint(usr)
	var/dat = "<center>Czerka Corporation</center><br> <center>Testing Facility</center><br><br>Stardate: February 12, 2435<br><br> The gateway has been experiencing odd energy fluctuations since we sent the last team through, and we've received no contact since.<br><br>All encrypted radio channels have fallen silent and the men have gone off of our ship's scanning systems. But the Director still has high hopes for them - after all, they were the best mercenaries the company could hire for us.<br><br>That said, since they've gone through we've been receiving odd artefacts in return, some we've been sending to the labs. One interesting find of specific value was what appeared to be some sort of flesh-like growth that had spawned through the portal.<br><br>The tissue seems to have some sort of regenerative stasis, and appears close to the human genetic structure, so it could have serious applications in the medical field.<br><br>But for now, we'll simply continue testing until told otherwise. Admittedly, the mercenary commander aboard our ship is causing quite the ruckus over his lost men, which is making it quite hard to work at all."

	user << browse("[dat]", "window=logs;size=800x400")

/obj/machinery/computer/personal/captain
	name = "Personal Log Computer"
	desc = "A laptop that is embossed with gold and black. It seems important."
	icon = 'computer.dmi'
	icon_state = "medlaptop"
	circuit = "/obj/item/weapon/circuitboard/research_shuttle"

/obj/machinery/computer/personal/captain/attack_hand(user as mob)
	src.add_fingerprint(usr)
	var/dat = "<center>Czerka Corporation</center><br> <center>Captain Amelie Roselle</center><br><br>Stardate: May 30, 2435<br><br> They tried to take our position again. Lost another one of the greenhorns to them. They dragged him off, bleeding, kicking and screaming into the darkness beyond. Could almost swear I could heard them tearing his flesh off in chunks.<br><br>We're getting a steady supply of metal salvage from the surrounding asteroids, but sending parties to the airlock to gather it is proving more dangerous. The creatures have seemingly nigh-endless numbers and we're losing good men every day.<br><br>Medical supplies are running low and we keep getting pelted by rocks. Engineering said we lost the starboard thruster after a particularly nasty collision, and we don't have the manpower to fix it. Best we don't, though.<br><br>We're going to send a team into the reactor to overload and detonate it. We can't risk these things finding a way to maneuver this ship. They managed to fly off in the shuttle, but the rocks stopped them that time.<br><br>I don't think we'll be so lucky if they try again."

	user << browse("[dat]", "window=logs;size=800x400")

/obj/item/weapon/paper/asteroid
	name = "paper - 'Farewell"
	info = {"Well, I guess this is it for me. I don't think I can take a few more steps without my intestines spilling out of my side.<br>
	Those things took me on their shuttle when they were going to lift off. Don't know why, don't really care this point. They're shit at piloting because we just flew face-first into a rock. Think I've still got some of that chair in my gut.<br>
	Now it's just me, a smoking wreck, a punctured space suit and a bunch of broken gear. Guess this is how I spend my final moments. Cold and alone in space. Got some salvaged engineering-grade tape from the wreck and tried to patch my suit. Internal pressure systems are failing.<br>
	I hope someone finds this. I hope someone does, and blows up that disgusting ship with all of those things on it. Those people used to be my friends, my co-workers before they were changed. Sometimes I swear I could still see the light in their eyes. Like they knew what was going on, but how they were powerless to stop it.<br>
	For now, I think I'm just going to go lay down. There's some medical gear I managed to pull out of the wreck. Fitting I curl up and die in a cryo tube than to those things.<br>
	<br>
	I'm sorry I couldn't come home like I promised, Mateo. I love you."}