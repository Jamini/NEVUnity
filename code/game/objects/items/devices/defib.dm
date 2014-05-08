/obj/item/device/defibulator
	name = "Cardiac Defibrillator"
	icon_state = "shockpaddle" //Borrowing health scanners until I get a proper sprite
	item_state = "analyzer"
	desc = "A portable defibrillator used to revive paitents recently flatlined, CLEAR!"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 5
	throw_range = 10
	m_amt = 300
	g_amt = 100
	var/charges = 1
	origin_tech = "magnets=2;biotech=1"
	var/mode = 1;

/obj/item/device/defibulator/attack(mob/living/silicon/S as mob, mob/living/user as mob)
	user << text("\red Wait, machines don't have hearts...") //Unneccesary, but funny! Checks for silicon and gives a message that you can't shock 'em.
	return

/obj/item/device/defibulator/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if((CLUMSY in user.mutations) && prob(50)) //Clumsy check. 50% chance to shock thyself. why ar'st thou shocking thyself?
		if(charges > 0) //If we have charges left...
			charges--
			user.visible_message("<span class='notice'> [user] grabs the defibrillator by the wrong end!","<span class='notice'> You grab the defibulator by the wrong end!")
			user.apply_effect(40, AGONY, 0)
			user.Weaken(30)
		else //Otherwise...
			user << "<span class='warning'>\The defibrillator is out of charge.</span>"
		return //Get us out of here. We're done shocking



	if(M.stat == DEAD && M.timeofdeath-600 < world.timeofday) //If the mobs time of death -600 ticks is under the current TOD...
		if(charges > 0) //If we have charges left
			user.visible_message("<span class='notice'> [user] jabs the defibrillator into [M]'s chest, making them jolt a moment and gasp!","<span class='notice'> You jab the defibulator into [M]'s chest.")
			M.adjustOxyLoss(-30)
			M.adjustToxLoss(-5)
			M.adjustBruteLoss(-5)
			M.stat = 0 //IT LIVES
			playsound(src.loc, "sparks", 75, 1, -1)
			charges--
		else
			user << "<span class='warning'>\The defibrillator is out of charge.</span>"
		return//Get us out of here. We're done shocking

	if(M.stat == DEAD && M.timeofdeath-1200 < world.timeofday) // If the mob has only been dead for 1200 ticks...

		if(charges > 0)
			user.visible_message("<span class='notice'> [user] jabs the defibrillator into [M]'s chest, making them jolt a moment and gasp!","<span class='notice'> You jab the defibulator into [M]'s chest.")
			M.adjustOxyLoss(-30)
			M.adjustToxLoss(-5)
			M.adjustBruteLoss(-5)
			M.adjustBrainLoss(50) //uh-oh. brain damage!
			M.stat = 0 //IT LIVES
			playsound(src.loc, "sparks", 75, 1, -1)
			charges--
		else
			user << "<span class='warning'>\The defibrillator is out of charge.</span>"
		return//Get us out of here. We're done shocking
	if(M.stat == 0 || M.stat == 1) //If we are shocking someone who IS alive
		if(charges > 0)
			user.visible_message("<span class='notice'> [user] jabs the defibrillator into [M]!","<span class='notice'> You jab the defibulator into [M]!")
			M.adjustFireLoss(15) //WHOOPS
			playsound(src.loc, "sparks", 75, 1, -1)
			M.apply_effect(40, AGONY, 0) // OHGODWHYAREYOUDOINGTHISTOME... SHITCURITY!
			M.Weaken(15) // Halp... i'm on the ground and can't comment
			charges--
		else
			user << "<span class='warning'>\The defibrillator is out of charge.</span>"
		return//Get us out of here. We're done shocking
	if(M.status_flags & FAKEDEATH) //Oh, you think you're clever faking your death?
		if(charges > 0) //still looks dead! Better put him in the morgue for an autopsy after the station blows up...
			user.visible_message("<span class='notice'> [user] jabs the defibrillator into [M]'s chest, making them jolt a moment before falling limp.","<span class='notice'> You jab the defibulator into [M]'s chest, it doesn't seem to be working...")
			playsound(src.loc, "sparks", 75, 1, -1)
			charges--
		else
			user << "<span class='warning'>\The defibrillator is out of charge.</span>"
		return//Get us out of here. We're done shocking



	if(charges > 0) //If all else fails...well at this point we're shocking a long-dead guy!
		user.visible_message("<span class='notice'> [user] jabs the defibrillator into [M]'s chest, making them jolt a moment before falling limp.","<span class='notice'> You jab the defibulator into [M]'s chest, it doesn't seem to be working...")
		playsound(src.loc, "sparks", 75, 1, -1)
	else
		user << "<span class='warning'>\The defibrillator is out of charge.</span>"
	return//Get us out of here. We're done shocking