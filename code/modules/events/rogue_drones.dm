/datum/event/rogue_drone
	startWhen = 10
	endWhen = 1000
	var/list/drones_list = list()

/datum/event/rogue_drone/start()
	//spawn them at the same place as carp
	var/list/possible_spawns = list()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			possible_spawns.Add(C)

	//25% chance for this to be a false alarm
	var/num
	if(prob(25))
		num = 0
	else
		num = rand(2,6)
	for(var/i=0, i<num, i++)
		var/mob/living/simple_animal/hostile/retaliate/malf_drone/D = new(get_turf(pick(possible_spawns)))
		drones_list.Add(D)
		if(prob(25))
			D.disabled = rand(15, 60)

/datum/event/rogue_drone/announce()
	var/msg
	if(prob(33))
		msg = "Unidentified combat drones have been detected in this sector. If any are sighted approach with caution."
	else if(prob(50))
		msg = "Hostile combat drone signatures have been identified in this sector. If any are sighted in the area, approach with caution."
	else
		msg = "A wing of combat drones have just appeared on our sensors and are moving towards [station_name()]. If any are sighted in the area, approach with caution."
	command_alert(msg, "Rogue drone alert")

/datum/event/rogue_drone/tick()
	return

/datum/event/rogue_drone/end()
	var/num_recovered = 0
	for(var/mob/living/simple_animal/hostile/retaliate/malf_drone/D in drones_list)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, D.loc)
		sparks.start()
		D.z = 2
		D.has_loot = 0

		del(D)
		num_recovered++

	if(num_recovered > drones_list.len * 0.75)
		command_alert("The drone wing has moved off.", "Rogue drone alert")
	else
		command_alert("The drone wing has broken off its persuit.", "Rogue drone alert")
