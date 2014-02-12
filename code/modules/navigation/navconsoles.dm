/obj/machinery/computer/astronavigation
	icon = 'icons/obj/computer.dmi'
	icon_state = "comm_monitor"
	name = "Astronavigation Console"
	desc = "This console allows you to scan nearby stars and planets!"
	var/datum/system/activesystem
	var/datum/planet/activeplanet

/**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  *
  * @return nothing
  */
/obj/machinery/computer/astronavigation/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	if(stat & (BROKEN|NOPOWER)) return
	if(user.stat || user.restrained()) return

	// this is the data which will be sent to the ui
	var/data[0]
	data["systemname1"] = ship.system1.name
	data["systemname2"] = ship.system2.name

	if(activesystem) //Pick a target to scan!

		data["systemname"] = activesystem.name
		data["systemtype"] = activesystem.star_type
		data["systemlum"] = activesystem.luminosity
		var/locations[]
		for (var/datum/planet/temps in activesystem.planets)
			if(locations)
				locations.Add(list(list("planet_name" = temps.name, "planet_orbit" = temps.orbit_number)))
			else
				locations = list(list("planet_name" = temps.name, "planet_orbit" = temps.orbit_number))
		data["planets"] = locations
		if(activesystem.luminosity2) //If it's a binary system, more info is needed!
			data["systembinary"] = activesystem.luminosity2
		else
			data["systembinary"] = null
	else
		data["systemname"] = "No target!"
		data["systemtype"] = "-"
		data["systemlum"] = "-"
		data["systembinary"] = null
//	if(activesystem && activeplanet)

//	else

/*
	var/datum/nanoui/ui = nanomanager.get_open_ui(user, src, ui_key)
	if (!ui)
		// the ui does not exist, so we'll create a new one
		ui = new(user, src, ui_key, "astronav.tmpl", name, 380, 380)
		// When the UI is first opened this is the data it will use
		ui.set_initial_data(data)
		ui.open()
	else
		// The UI is already open so push the new data to it
		//This is a crappy hack to get things to work until I can make it work better. Hate it so much.
		ui.close()
		ui.set_initial_data(data)
		ui.open()
		return
*/

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "astronav.tmpl", name, 380, 380)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)
/obj/machinery/computer/astronavigation/attack_paw(mob/user)
	user << "You are too primitive to use this computer."
	return

/obj/machinery/computer/astronavigation/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/astronavigation/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	ui_interact(user)

/obj/machinery/computer/astronavigation/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0
	if(href_list["setarget1"])
		activesystem = ship.system1
	if(href_list["setarget2"])
		activesystem = ship.system2
	if(href_list["clear"])
		activesystem = null
		activeplanet = null
	return 1







/obj/machinery/computer/navigation
	icon = 'icons/obj/computer.dmi'
	icon_state = "comm_monitor"
	name = "Navigation Console"
	desc = "This console allows you to travel to nearby stars and planets!"
