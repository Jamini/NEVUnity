#define REACTOR_HEAT_COEFFICIENT 4
#define REACTOR_MAX_ENERGY_TRANSFER 4000
#define REACTOR_HEAT_CAPACITY 5000
/obj/machinery/unityreactor/
	name = "Supermatter Reactor Core"
	desc = "The Reactor Core."
	icon = 'engine.dmi'
	icon_state = "darkmatter"
	unacidable = 1
	anchored = 0
	density = 1
	use_power = 0
	luminosity = 6
	var/energy = 50 //How strong are we? 500 is optimal (~level 2 sing)
	var/MAX_ENERGY = 500 //How strong this can be
	var/event_chance = 15 //Prob for event each tick
	var/temperature = 273	//measured in kelvin, if this exceeds 1200 the core goes critical and explodes
	var/max_temp = 600

/obj/machinery/unityreactor/process()
	pulse() //Emits power
	heat() //Emits heat and explodes if it gets too hot!
	if(prob(event_chance))//Chance for it to run a special event TODO:Come up with one or two more that fit
		event()
	return



/obj/machinery/unityreactor/proc/event()
	var/numb = pick(1,2,3,4,5,6,7)
	switch(numb)
		if(1)//EMP
			emp_area()
		if(2,3)//tox damage all carbon mobs in area
			toxmob()
		if(4)//Stun mobs who lack optic scanners
			mezzer()
		if(5)
			braincrushmob()
		else
			return 0
	return 1


/obj/machinery/unityreactor/proc/toxmob()
	var/toxrange = 10
	var/toxdamage = 4
	var/radiation = 15
	var/radiationmin = 3
	if (src.energy>200)
		toxdamage = round(((src.energy-150)/50)*4,1)
		radiation = round(((src.energy-150)/50)*5,1)
		radiationmin = round((radiation/5),1)//
	for(var/mob/living/M in view(toxrange, src.loc))
		M.apply_effect(rand(radiationmin,radiation), IRRADIATE)
		toxdamage = (toxdamage - (toxdamage*M.getarmor(null, "rad")))
		M.apply_effect(toxdamage, TOX)
	return

/obj/machinery/unityreactor/proc/braincrushmob()
	for(var/mob/living/carbon/M in oviewers(8, src))
		if(M.stat == CONSCIOUS)
			if (istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(istype(H.glasses,/obj/item/clothing/glasses/meson))
					H << "\blue You look directly into The [src.name], good thing you had your protective eyewear on!"
					return
		M << "\red You look directly into The [src.name] and feel strange."
		M.hallucination += energy/((get_dist(M,src)))
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>[] twitches erratically!</B>", M), 1)

/obj/machinery/unityreactor/proc/mezzer()
	for(var/mob/living/carbon/M in oviewers(8, src))
		if(istype(M, /mob/living/carbon/brain)) //Ignore brains
			continue

		if(M.stat == CONSCIOUS)
			if (istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(istype(H.glasses,/obj/item/clothing/glasses/meson))
					H << "\blue You look directly into The [src.name], good thing you had your protective eyewear on!"
					return
		M << "\red You look directly into The [src.name] and feel weak."
		M.apply_effect(3, STUN)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>[] stares blankly at The []!</B>", M, src), 1)
	return


/obj/machinery/unityreactor/proc/emp_area()
	if(energy > 49) //can only EMP if you have 50 energy to spend
		empulse(src, 3, 5)
		energy -= 50
	return


/obj/machinery/unityreactor/proc/pulse()
	if(energy > 4) //Can only provide power if you have five or more energy to spend
		for(var/obj/machinery/power/rad_collector/R in rad_collectors)
			if(get_dist(R, src) <= 15) // Better than using orange() every process
				R.receive_pulse(energy)
		energy -= 5//every pulse reduces the amount of energy the reactor has
	return

/obj/machinery/unityreactor/proc/heat()

	var/heat_added = energy*REACTOR_HEAT_COEFFICIENT
	var/datum/gas_mixture/env = src.loc.return_air()
	var/environmental_temp = env.temperature
	var/temperature_difference = abs(environmental_temp-temperature)
	var/datum/gas_mixture/removed = loc.remove_air(env.total_moles*0.25)
	var/heat_capacity = removed.heat_capacity()
	heat_added = max(temperature_difference*heat_capacity, REACTOR_MAX_ENERGY_TRANSFER)
	if(temperature > environmental_temp)
		//cool down to match the air
		src.temperature = max(TCMB, temperature - heat_added/REACTOR_HEAT_CAPACITY)
		removed.temperature = max(TCMB, removed.temperature + heat_added/heat_capacity)
	else
		//heat up to match the air
		src.temperature = max(TCMB, temperature + heat_added/REACTOR_HEAT_CAPACITY)
		removed.temperature = max(TCMB, removed.temperature - heat_added/heat_capacity)
	env.merge(removed)
	if(src.temperature < src.max_temp)
		src.temperature += heat_added/REACTOR_HEAT_CAPACITY
	if(temperature > 400)
		if(prob(5))
			var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)
			a.autosay("Warning, core is overheating.", "[station_name()] Power System Automated Annoucement")
	if(temperature > 500)
		var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)
		a.autosay("Reactor core is at critical temperatures. Explosion imminent. Have a nice day.", "[station_name()] Power System Automated Annoucement")
		explosion(src.loc, 7,10,15,30)
		empulse(src.loc, 21, 42)
		del(src)

/obj/machinery/unityreactor/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.flag != "bullet")
		if(energy < 500)
			src.energy += Proj.damage
	return 0