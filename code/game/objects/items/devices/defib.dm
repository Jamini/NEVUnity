/obj/item/device/defibulator
	name = "Cardiac Defibulator"
	icon_state = "health" //Borrowing health scanners until I get a proper sprite
	item_state = "analyzer"
	desc = "A portable defibulator used to revive paitents recently flatlined, CLEAR!"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 5
	throw_range = 10
	m_amt = 300
	g_amt = 100
	var/charges = 1
	var/status = 0
	origin_tech = "magnets=2;biotech=1"
	var/mode = 1;

/obj/item/device/defibulator/attack(mob/living/silicon/S as mob, mob/living/user as mob)
	user << text("\red Wait, machines don't have hearts...")
	return

/obj/item/device/defibulator/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user.visible_message("<span class='notice'> [user] grabs the defibulator by the wrong end!","<span class='notice'> You grab the defibulator by the wrong end!")
		user.apply_effect(40, AGONY, 0)
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		else
			status = 0
			user << "<span class='warning'>\The defibulator is out of charge.</span>"
		return

/obj/item/device/defibulator/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(M.stat == DEAD && M.tod<1+world.timeofday)
		user.visible_message("<span class='notice'> [user] jabs the defibulator into [M]'s chest, making them jolt a moment and gasp!","<span class='notice'> You jab the defibulator into [M]'s chest.")
		M.adjustOxyLoss(-30)
		M.adjustToxLoss(-5)
		M.adjustBruteLoss(-5)
		M.stat = 0
		playsound(src.loc, "sparks", 75, 1, -1)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		else
			status = 0
			user << "<span class='warning'>\The defibulator is out of charge.</span>"


	if(M.status_flags & FAKEDEATH)
		user.visible_message("<span class='notice'> [user] jabs the defibulator into [M]'s chest, making them jolt a moment before falling limp.","<span class='notice'> You jab the defibulator into [M]'s chest, it doesn't seem to be working...")
		playsound(src.loc, "sparks", 75, 1, -1)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		else
			status = 0
			user << "<span class='warning'>\The defibulator is out of charge.</span>"

	if(M.stat == DEAD && M.tod<2+world.timeofday)
		user.visible_message("<span class='notice'> [user] jabs the defibulator into [M]'s chest, making them jolt a moment and gasp!","<span class='notice'> You jab the defibulator into [M]'s chest.")
		M.adjustOxyLoss(-30)
		M.adjustToxLoss(-5)
		M.adjustBruteLoss(-5)
		M.adjustBrainLoss(50)
		M.stat = 0
		playsound(src.loc, "sparks", 75, 1, -1)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		else
			status = 0
			user << "<span class='warning'>\The defibulator is out of charge.</span>"


	if(M.stat == 0)
		user.visible_message("<span class='notice'> [user] jabs the defibulator into [M]!","<span class='notice'> You jab the defibulator into [M]!")
		M.adjustFireLoss(15)
		playsound(src.loc, "sparks", 75, 1, -1)
		M.apply_effect(40, AGONY, 0)
		M.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		else
			status = 0
			user << "<span class='warning'>\The defibulator is out of charge.</span>"

	else
		user.visible_message("<span class='notice'> [user] jabs the defibulator into [M]'s chest, making them jolt a moment before falling limp.","<span class='notice'> You jab the defibulator into [M]'s chest, it doesn't seem to be working...")
		playsound(src.loc, "sparks", 75, 1, -1)
		if(charges < 1)
			status = 0
			update_icon()
		else
			status = 0
			user << "<span class='warning'>\The defibulator is out of charge.</span>"
		return