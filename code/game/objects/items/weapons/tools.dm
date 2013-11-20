//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/* Tools!
 * Note: Multitools are /obj/item/device
 *
 * Contains:
 * 		Wrench
 * 		Screwdriver
 * 		Wirecutters
 * 		Welding Tool
 * 		Crowbar
 */

/*
 * Wrench
 */
/obj/item/weapon/wrench
	name = "wrench"
	desc = "A wrench with common uses. Can be found in your hand."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrench"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	m_amt = 150
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")


/*
 * Screwdriver
 */
/obj/item/weapon/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	icon = 'icons/obj/items.dmi'
	icon_state = "screwdriver"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	g_amt = 0
	m_amt = 75
	attack_verb = list("stabbed")

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is stabbing the [src.name] into \his temple! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is stabbing the [src.name] into \his heart! It looks like \he's trying to commit suicide.</b>")
		return(BRUTELOSS)

/obj/item/weapon/screwdriver/New()
	switch(pick("red","blue","purple","brown","green","cyan","yellow"))
		if ("red")
			icon_state = "screwdriver2"
			item_state = "screwdriver"
		if ("blue")
			icon_state = "screwdriver"
			item_state = "screwdriver_blue"
		if ("purple")
			icon_state = "screwdriver3"
			item_state = "screwdriver_purple"
		if ("brown")
			icon_state = "screwdriver4"
			item_state = "screwdriver_brown"
		if ("green")
			icon_state = "screwdriver5"
			item_state = "screwdriver_green"
		if ("cyan")
			icon_state = "screwdriver6"
			item_state = "screwdriver_cyan"
		if ("yellow")
			icon_state = "screwdriver7"
			item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	return

/obj/item/weapon/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))	return ..()
	if(user.zone_sel.selecting != "eyes" && user.zone_sel.selecting != "head")
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/*
 * Wirecutters
 */
/obj/item/weapon/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon = 'icons/obj/items.dmi'
	icon_state = "cutters"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = 6.0
	throw_speed = 2
	throw_range = 9
	w_class = 2.0
	m_amt = 80
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("pinched", "nipped")

/obj/item/weapon/wirecutters/New()
	if(prob(50))
		icon_state = "cutters-y"
		item_state = "cutters_yellow"

/obj/item/weapon/wirecutters/attack(mob/living/carbon/C as mob, mob/user as mob)
	if((C.handcuffed) && (istype(C.handcuffed, /obj/item/weapon/handcuffs/cable)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.handcuffed = null
		C.update_inv_handcuffed()
		return
	else
		..()

/*
 * Welding Tool
 */
/obj/item/weapon/weldingtool
	name = "welding tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "rwelder"
	item_state = "rwelder"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT

	//Amount of OUCH when it's thrown
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0

	//Cost to make in the autolathe
	m_amt = 70
	g_amt = 30

	//R&D tech level
	origin_tech = "engineering=1"
	//Welding tool specific stuff
	var/welding = 0	 //Whether or not the welding tool is off(0) or on(1)
	var/status = 1		 //Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20	 //The max amount of fuel the welder can hold
	var/flame_type = "flame"  //Flame type. flame, plasma or arc, currently.
	var/decayed = 0		//Used for Arc Welder rod replenishment.

/obj/item/weapon/weldingtool/New()
//	var/random_fuel = min(rand(10,20),max_fuel)
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	set_state(0)
	return

/obj/item/weapon/weldingtool/examine()
	set src in usr
	usr << text("\icon[] [] contains []/[] units of fuel!", src, src.name, get_fuel(),src.max_fuel )
	return

/obj/item/weapon/weldingtool/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/screwdriver))
		if(welding)
			user << "\red Stop welding first!"
			return
		status = !status
		if(status)
			user << "\blue You resecure the welder."
		else
			user << "\blue The welder can now be attached and modified."
		src.add_fingerprint(user)
		return
	if((!status) && (istype(W,/obj/item/stack/rods)))
		var/obj/item/stack/rods/R = W
		R.use(1)
		var/obj/item/weapon/flamethrower/F = new/obj/item/weapon/flamethrower(user.loc)
		src.loc = F
		F.weldtool = src
		user.put_in_hands(F)	//tada. this tries to put it in either hand or the floor, and does all those screen updates and stuff.
		return
	..()
	return

/obj/item/weapon/weldingtool/process()
	switch(welding)
		//If not welding, kill our need to be in the process.
		if(0)
			processing_objects.Remove(src)
			set_state(0)
			return
		//Welders left on now use up fuel, but lets not have them run out quite that fast
		if(1)
			if(prob(5))
				remove_fuel(1)
	//I'm not sure what this does. I assume it has to do with starting fires...
	//...but it doesnt check to see if the welder is on or not. Doesn't need to, because if it's not welding, it exits processing above. IE it already checked. ...I think
	var/turf/location = src.loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = get_turf(M)
	if (istype(location, /turf))
		location.hotspot_expose(700, 5)

/obj/item/weapon/weldingtool/afterattack(obj/O as obj, mob/user as mob)
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && !src.welding)
		O.reagents.trans_to(src, max_fuel)
		user << "\blue [src] refueled"
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && src.welding)
		message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
		log_game("[key_name(user)] triggered a fueltank explosion.")
		user << "\red That was stupid of you."
		var/obj/structure/reagent_dispensers/fueltank/tank = O
		tank.explode()
		return
	if (src.welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1) //This line it heats the air triggering a fire Isn't there a better way to deal with this now?
	return

/obj/item/weapon/weldingtool/attack(mob/M as mob, mob/user as mob)
	if(hasorgans(M))
		var/datum/organ/external/S = M:organs_by_name[user.zone_sel.selecting]
		if (!S) return
		if(!(S.status & ORGAN_ROBOT) || user.a_intent != "help")
			return ..()
		if(S.brute_dam)
			S.heal_damage(15,0,0,1)
			if(user != M)
				user.visible_message("\red \The [user] patches some dents on \the [M]'s [S.display_name] with \the [src]",\
				"\red You patch some dents on \the [M]'s [S.display_name]",\
				"You hear a welder.")
			else
				user.visible_message("\red \The [user] patches some dents on their [S.display_name] with \the [src]",\
				"\red You patch some dents on your [S.display_name]",\
				"You hear a welder.")
		else
			user << "Nothing to fix!"
	else
		return ..()

/obj/item/weapon/weldingtool/attack_self(mob/user as mob)
	toggle()
	return

//Returns the amount of fuel in the welder
/obj/item/weapon/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/weapon/weldingtool/proc/set_state(var/state, mob/user as mob)
	if(state==1 && decayed ==0)
		welding = 1
		if(flame_type == "plasma")
			src.force = 20
		else
			src.force = 15
		src.damtype = "fire"
		update_icon()
		processing_objects.Add(src)
		return
	else if(state==1 && decayed ==1)
		user << "\red This welder needs a new rod!"
		welding = 0
		src.force = 3
		src.damtype = "brute"
		update_icon()
		processing_objects.Remove(src)
	else
		welding = 0
		src.force = 3
		src.damtype = "brute"
		update_icon()
		processing_objects.Remove(src)
	return

/obj/item/weapon/weldingtool/update_icon()
	overlays.Cut()
	update_cell()
	if (welding == 0)
		overlays += "welderoff"
		if(type == "arc" && decayed == 0)
			overlays += "arcrodoff"
	else if (welding == 1)
		overlays += "welderon"
		if (flame_type == "arc")
			overlays += "arcrodon"
		else if (flame_type == "plasma")
			overlays += "pflame"
		else
			overlays += "wflame"
	update_inhand()
	return

/obj/item/weapon/weldingtool/proc/update_cell()
	return

/obj/item/weapon/weldingtool/proc/update_inhand()
	if (welding == 0)
		item_state = "[icon_state]"
	else if (welding == 1)
		item_state = "[icon_state]1"
	return


//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weapon/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding || !check_fuel())	//if not on, or no fuel
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		check_fuel()
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			M << "\blue You need more welding fuel to complete this task."
		return 0

//Returns whether or not the welding tool is currently on
/obj/item/weapon/weldingtool/proc/isOn()	//should be a obj/item/ level proc, hell almost all of this should be hooks.
	return src.welding

//Toggles the welder off and on
/obj/item/weapon/weldingtool/proc/toggle(var/message = 0)
	if(!status)	return
	src.welding = !( src.welding )
	if (src.welding)
		setWelding(1)
	else
		setWelding(0, message)
	return

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weapon/weldingtool/proc/setWelding(var/temp_welding, var/message = 0)
	//If we're turning it on
	if(temp_welding > 0)
		if (remove_fuel(1))
			usr << "\blue The [src] switches on."
			set_state(1)
		else
			usr << "\blue Need more fuel!"
			set_state(0)
			return
	//Otherwise
	else
		if(!message)
			usr << "\blue You switch the [src] off."
		else
			usr << "\blue The [src] shuts off!"
		set_state(0)

//Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/weapon/weldingtool/proc/check_fuel()
	if((get_fuel() <= 0) && welding)
		toggle(1)
		return 0
	return 1


//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weapon/weldingtool/proc/eyecheck(mob/user as mob)
	if(!iscarbon(user))	return 1
	var/safety = user:eyecheck()
	switch(safety)
		if(1)
			usr << "\red Your eyes sting a little."
			user.eye_stat += rand(1, 2)
			if(user.eye_stat > 12)
				user.eye_blurry += rand(3,6)
		if(0)
			usr << "\red Your eyes burn."
			user.eye_stat += rand(2, 4)
			if(user.eye_stat > 10)
				user.eye_blurry += rand(4,10)
		if(-1)
			usr << "\red Your thermals intensify the welder's glow. Your eyes itch and burn severely."
			user.eye_blurry += rand(12,20)
			user.eye_stat += rand(12, 16)
	if(user.eye_stat > 10 && safety < 2)
		user << "\red Your eyes are really starting to hurt. This can't be good for you!"
	if (prob(user.eye_stat - 25 + 1))
		user << "\red You go blind!"
		user.sdisabilities |= BLIND
	else if (prob(user.eye_stat - 15 + 1))
		user << "\red You go blind!"
		user.eye_blind = 5
		user.eye_blurry = 5
		user.disabilities |= NEARSIGHTED
		spawn(100)
			user.disabilities &= ~NEARSIGHTED
	return


/obj/item/weapon/weldingtool/largetank
	name = "Upgraded Welding Tool"
	icon_state = "mwelder"
	max_fuel = 40
	m_amt = 70
	g_amt = 60
	origin_tech = "engineering=2"

/obj/item/weapon/weldingtool/hugetank
	name = "Industrial Welding Tool"
	icon_state = "lwelder"
	max_fuel = 80
	w_class = 3.0
	m_amt = 70
	g_amt = 120
	origin_tech = "engineering=3"
/*
/obj/item/weapon/weldingtool/arc
	name = "Electric Arc Welding Tool"
	icon_state = "awelder"
	w_class = 2.0
	m_amt = 100
	g_amt = 120
	var/obj/item/weapon/cell = null
	origin_tech = "engineering=3"

/obj/item/weapon/weldingtool/arc/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/cell))
		if(!cell)
			user.drop_item()
			W.loc = src
			cell = W
			user << "<span class='notice'>You install a cell in [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>[src] already has a cell.</span>"

	else if(istype(W, /obj/item/weapon/screwdriver))
		if(cell)
			cell.updateicon()
			cell.loc = get_turf(src.loc)
			cell = null
			user << "<span class='notice'>You remove the cell from the [src].</span>"
			set_state(0)
			return
	return

/obj/item/weapon/weldingtool/arc/update_icon()
	..()
	if(cell)
		overlays +=
	return

/obj/item/weapon/weldingtool/arc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(cell)
		if(check_fuel())
			if(cell.use((amount * 100))
				return 1
		else
			set_state(0)
			return 0

/obj/item/weapon/weldingtool/arc/check_fuel()
	if((cell.charge <= 99) && welding)
		toggle(1)
		return 0
	return 1

/obj/item/weapon/weldingtool/arc/examine()
	set src in view(1)
	if(cell)
		usr <<"<span class='notice'>The welder is [round(cell.percent())]% charged.</span>"
	if(!cell)
		usr <<"<span class='warning'>The welder does not have a power source installed.</span>"

/obj/item/weapon/weldingtool/arc/New()
	return
*/
/*
 * Crowbar
 */

/obj/item/weapon/crowbar
	name = "crowbar"
	desc = "Used to hit floors"
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 7.0
	item_state = "crowbar"
	w_class = 2.0
	m_amt = 50
	origin_tech = "engineering=1"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/crowbar/red
	icon = 'icons/obj/items.dmi'
	icon_state = "red_crowbar"
	item_state = "crowbar_red"


