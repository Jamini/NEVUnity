/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */

//Used for logging people entering cryosleep and important items they are carrying.
var/global/list/frozen_crew = list()
var/global/list/frozen_items = list()

//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"
	circuit = "/obj/item/weapon/circuitboard/cryopodcontrol"
	var/mode = null

/obj/machinery/computer/cryopod/attack_paw()
	src.attack_hand()

/obj/machinery/computer/cryopod/attack_ai()
	src.attack_hand()

obj/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(stat & (NOPOWER|BROKEN))
		return

	user.set_machine(src)
	src.add_fingerprint(usr)

	var/dat

	if (!( ticker ))
		return

	dat += "<hr/><br/><b>Cryogenic Oversight Control</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref[src];log=1'>View storage log</a>.<br>"
	dat += "<a href='?src=\ref[src];item=1'>Recover object</a>.<br>"
	dat += "<a href='?src=\ref[src];crew=1'>Revive crew</a>.<br/><hr/>"

	user << browse(dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

obj/machinery/computer/cryopod/Topic(href, href_list)

	if(..())
		return

	var/mob/user = usr

	src.add_fingerprint(user)

	if(href_list["log"])

		var/dat = "<b>Recently stored crewmembers</b><br/><hr/><br/>"
		for(var/person in frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryolog")

	else if(href_list["item"])

		if(frozen_items.len == 0)
			user << "\blue There is nothing to recover from storage."
			return

		var/obj/item/I = input(usr, "Please choose which object to retrieve.","Object recovery",null) as obj in frozen_items

		if(!I || frozen_items.len == 0)
			user << "\blue There is nothing to recover from storage."
			return

		visible_message("\blue The console beeps happily as it disgorges \the [I].", 3)

		I.loc = get_turf(src)
		frozen_items -= I

	else if(href_list["allitems"])

		if(frozen_items.len == 0)
			user << "\blue There is nothing to recover from storage."
			return

		visible_message("\blue The console beeps happily as it disgorges the desired objects.", 3)

		for(var/obj/item/I in frozen_items)
			I.loc = get_turf(src)
			frozen_items -= I

	else if(href_list["crew"])

		user << "\red Functionality unavailable at this time."

	src.updateUsrDialog()
	return

/obj/item/weapon/circuitboard/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = "/obj/machinery/computer/cryopod"
	origin_tech = "programming=3"

//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed

	name = "\improper cryogenic feed"
	desc = "A bewildering tangle of machinery and pipes."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryo_rear"
	anchored = 1

	var/orient_right = null //Flips the sprite.

/obj/structure/cryofeed/right
	orient_right = 1
	icon_state = "cryo_rear-r"

/obj/structure/cryofeed/New()

	if(orient_right)
		icon_state = "cryo_rear-r"
	else
		icon_state = "cryo_rear"
	..()

//Cryopods themselves.
/obj/machinery/stasispod
	name = "\improper cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1

	var/mob/occupant = null      // Person waiting to be despawned.
	var/orient_right = null      // Flips the sprite.
	var/time_till_despawn = 3000 // 5 minutes-ish safe period before being despawned.
	var/time_entered = 0         // Used to keep track of the safe period.
	var/obj/item/device/radio/intercom/announce

/obj/machinery/stasispod/right
	orient_right = 1
	icon_state = "body_scanner_0-r"


/obj/machinery/stasispod/New()

	announce = new /obj/item/device/radio/intercom(src)

	if(orient_right)
		icon_state = "body_scanner_0-r"
	else
		icon_state = "body_scanner_0"
	..()

/obj/machinery/stasispod/allow_drop()
	return 0

/obj/machinery/stasispod/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/stasispod/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Stasis Pod"

	if (usr.stat != 0)
		return
	src.go_out()
	for(var/obj/O in src)
		if(!(istype(O,/obj/item/device/radio/intercom))) //Let's not eject the annoucement computer
			O.loc = get_turf(src)//Ejects items that manage to get in there (exluding the components)
	if(!occupant)
		for(var/mob/M in src)//Failsafe so you can get mobs out
			M.loc = get_turf(src)
	add_fingerprint(usr)
	return

/obj/machinery/stasispod/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Stasis Pod"

	if (usr.stat != 0)
		return
	if (src.occupant)
		usr << "\blue <B>The scanner is already occupied!</B>"
		return
	if (usr.abiotic())
		usr << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
	usr.stop_pulling()
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.loc = src
	src.occupant = usr
	if(orient_right)
		src.icon_state = "body_scanner_1-r"
	else
		src.icon_state = "body_scanner_1"
	..()
	/*
	for(var/obj/O in src)    // THIS IS P. STUPID -- LOVE, DOOHL
		//O = null
		del(O)
		//Foreach goto(124)
	*/
	src.add_fingerprint(usr)
	return


/obj/machinery/stasispod/attackby(obj/item/weapon/grab/G as obj, user as mob)
	if ((!( istype(G, /obj/item/weapon/grab) ) || !( ismob(G.affecting) )))
		return
	if (src.occupant)
		user << "\blue <B>The scanner is already occupied!</B>"
		return
	if (G.affecting.abiotic())
		user << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
	var/mob/M = G.affecting
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	src.occupant = M
	if(orient_right)
		src.icon_state = "body_scanner_1-r"
	else
		src.icon_state = "body_scanner_1"
	..()
	src.add_fingerprint(user)
	return

/obj/machinery/stasispod/proc/go_out()
	if ((!( src.occupant )))
		return
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	if(orient_right)
		src.icon_state = "body_scanner_0-r"
	else
		src.icon_state = "body_scanner_0"
	return
/obj/machinery/stasispod/process()
	if(src.occupant)

		//Allow a ten minute gap between entering the pod and actually despawning.
		if(world.time - time_entered < time_till_despawn)
			return

		if(!src.occupant.client && (src.occupant.stat==0||src.occupant.stat==1))//if the living creature has no client
			for(var/obj/item/W in occupant) //remove everything they are wearing
			//Items with the STASIS_DEL flag are deleted
				if (W.flags & STASIS_DEL)
					if(istype(W, /obj/item/device/pda))
						for(var/obj/item/weapon/card/X in W)
							if(X.flags & STASIS_DEL)
								del(X)
					del(W)
				occupant.drop_from_inventory(W)
		//free up their job slot
			var/job = occupant.mind.assigned_role
			var/role = occupant.mind.special_role
			job_master.FreeRole(job)
			if(role == "traitor" || role == "MODE")
				del(occupant.mind.objectives)
				occupant.mind.special_role = null
			else
				if(ticker.mode.name == "AutoTraitor")
					var/datum/game_mode/traitor/autotraitor/current_mode = ticker.mode
					current_mode.possible_traitors.Remove(occupant)

			//delete them from datacore
			for(var/datum/data/record/R in data_core.medical)
				if ((R.fields["name"] == occupant.real_name))
					del(R)
			for(var/datum/data/record/T in data_core.security)
				if ((T.fields["name"] == occupant.real_name))
					del(T)
			for(var/datum/data/record/G in data_core.general)
				if ((G.fields["name"] == occupant.real_name))
					del(G)


			if(orient_right)
				src.icon_state = "body_scanner_0-r"
			else
				src.icon_state = "body_scanner_0"

			//This should guarantee that ghosts don't spawn.
			occupant.ckey = null
			//Make an announcement and log the person entering storage.
			frozen_crew += "[occupant.real_name]"
			announce.autosay("[occupant.real_name] has entered stasis.", "Stasis Management Computer")
			visible_message("\blue The crypod hums and hisses as it moves [occupant.real_name] into storage.", 3)
			del(src.occupant)//delete the mob
			src.occupant = null
		return
