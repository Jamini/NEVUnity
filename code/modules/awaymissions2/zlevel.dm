proc/createAwayMission()
	var/list/potentialRandomZlevels = list()
	world << "\red \b DEBUG: Searching for away missions..."
	var/list/Lines
	if(ship.curplanet.planet_type == "Anom") //If the planet is an anomoly, load an empty space map
		Lines = file2list("maps/RandomZLevels/anomList.txt")
	else //If we don't have a map list already created, default to the default list.
		Lines = file2list("maps/RandomZLevels/fileList.txt")
	if(!Lines.len)	return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
	//	var/value = null

		if (pos)
            // No, don't do lowertext here, that breaks paths on linux
			name = copytext(t, 1, pos)
		//	value = copytext(t, pos + 1)
		else
            // No, don't do lowertext here, that breaks paths on linux
			name = t

		if (!name)
			continue

		potentialRandomZlevels.Add(name)


	if(potentialRandomZlevels.len)
		world << "\red \b Loading away mission... Expect some minor lag"

		var/map = pick(potentialRandomZlevels)
		var/file = file(map)
		if(isfile(file))
			maploader.load_map(file,z_offset = awayZLevel, load_speed = 100)


		world << "\red \b Away mission loaded."

	else
		world << "\red \b No away missions found."
		return