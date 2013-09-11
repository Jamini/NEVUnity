#define SUIT_HUMAN 0
#define SUIT_TAJARAN 1
#define SUIT_UNATHI 2
#define SUIT_SKRELL 3

#define RIG_ENG 0
#define RIG_ATMOS 1
#define RIG_MEDICAL 2
#define RIG_MINING 3
#define RIG_SECURITY 4
#define RIG_ELITE 5
#define RIG_SYNDI 6 //Unit must be emagged


/obj/machinery/suit_fitter
	name = "Hardsuit Modification Unit"
	desc = "An industrial U-Mod-It unit designed to adjust all kinds of space suits."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000010000"//order is [has helmet][has suit][has human][is open][is locked][is UV cycling][is powered][is dirty/broken] [is superUVcycling]
	anchored = 1
	density = 1
	var/obj/item/clothing/suit/space/rig/SUIT
	var/obj/item/clothing/head/helmet/space/rig/HELMET
	var/targetspecies = 0
	var/isopen = 0
	var/isWorking = 0
	var/ispowered = 1
	var/cycletime_left = 0

/obj/machinery/suit_fitter/New()
	SUIT = null
	HELMET = null
	src.update_icon()

/obj/machinery/suit_fitter/update_icon()
	var/hashelmet = 0
	var/hassuit = 0
	if(HELMET)
		hashelmet = 1
	if(SUIT)
		hassuit = 1
	icon_state = text("suitstorage[][][][][][][][][]",hashelmet,hassuit,"0",src.isopen,"0",src.isWorking,src.ispowered,"0","0")

/obj/machinery/suit_fitter/power_change()
	if( powered() )
		src.ispowered = 1
		stat &= ~NOPOWER
		src.update_icon()
	else
		spawn(rand(0, 15))
			src.ispowered = 0
			stat |= NOPOWER
			src.isopen = 1
			src.dump_everything()
			src.update_icon()

/obj/machinery/suit_fitter/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(50))
				src.dump_everything() //So suits dont survive all the time
			del(src)
			return
		if(2.0)
			if(prob(50))
				src.dump_everything()
				del(src)
			return
		else
			return
	return

/obj/machinery/suit_fitter/attack_hand(mob/user as mob)
	var/dat
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(src.isWorking) //The thing is running its conversion cycle. You have to wait.
		dat += "<HEAD><TITLE>Suit conversion unit</TITLE></HEAD>"
		dat+= "<font color ='red'><B>Unit is converting its contents. Please wait.</font></B><BR>"
	else
		dat+= "<HEAD><TITLE>Suit conversion unit</TITLE></HEAD>"
		dat+= "<font color='blue'><font size = 4><B>U-Mod-It Suit Storage Unit, model DS2150</B></FONT><BR>"
		dat+= "<B>Welcome to the Unit control panel.</B><HR>"
		dat+= text("<font color='black'>Helmet storage compartment: <B>[]</B></font><BR>",(src.HELMET ? HELMET.name : "</font><font color ='grey'>No helmet detected.") )
		if(HELMET && src.isopen)
			dat+=text("<A href='?src=\ref[];dispense_helmet=1'>Dispense helmet</A><BR>",src)
		dat+= text("<font color='black'>Suit storage compartment: <B>[]</B></font><BR>",(src.SUIT ? SUIT.name : "</font><font color ='grey'>No exosuit detected.") )
		if(SUIT && src.isopen)
			dat+=text("<A href='?src=\ref[];dispense_suit=1'>Dispense suit</A><BR>",src)
		dat+= text("<HR><font color='black'>Unit is: [] - <A href='?src=\ref[];toggle_open=1'>[] Unit</A></font> ",(src.isopen ? "Open" : "Closed"),src,(src.isopen ? "Close" : "Open"))
		if(src.isopen)
			dat+="<HR>"
		dat+= text("<BR>Species Setting:")
		switch(targetspecies)
			if(SUIT_HUMAN)
				dat+= text("<B>Human, </B>")
				dat+= text("<A href=?src=\ref[];set_taj=1'>Tajaran, </A>",src)
				dat+= text("<A href=?src=\ref[];set_skrell=1'>Skrell, </A>",src)
				dat+= text("<A href=?src=\ref[];set_unathi=1'>Unathi, </A><BR>",src)
			if(SUIT_TAJARAN)
				dat+= text("<A href=?src=\ref[];set_human=1'>Human, </A>",src)
				dat+= text("<B>Tajaran, </B>")
				dat+= text("<A href=?src=\ref[];set_skrell=1'>Skrell, </A>",src)
				dat+= text("<A href=?src=\ref[];set_unathi=1'>Unathi, </A><BR>",src)
			if(SUIT_SKRELL)
				dat+= text("<A href=?src=\ref[];set_human=1'>Human, </A>",src)
				dat+= text("<A href=?src=\ref[];set_taj=1'>Tajaran, </A>",src)
				dat+= text("<B>Skrell, </B>")
				dat+= text("<A href=?src=\ref[];set_unathi=1'>Unathi, </A><BR>",src)
			if(SUIT_UNATHI)
				dat+= text("<A href=?src=\ref[];set_human=1'>Human, </A>",src)
				dat+= text("<A href=?src=\ref[];set_taj=1'>Tajaran, </A>",src)
				dat+= text("<A href=?src=\ref[];set_skrell=1'>Skrell, </A>",src)
				dat+= text("<B>Unathi</B><BR>")
		dat+= text("<A href='?src=\ref[];start_convert=1'>Start Conversion cycle</A><BR>",src)
		dat += text("<BR><BR><A href='?src=\ref[];mach_close=suit_fitter'>Close control panel</A>", user)
		//user << browse(dat, "window=Suit Storage Unit;size=400x500")
		//onclose(user, "Suit Storage Unit")
	user << browse(dat, "window=suit_fitter;size=400x500")
	onclose(user, "suit_fitter")
	return

/obj/machinery/suit_fitter/Topic(href, href_list) //I fucking HATE this proc
	if(..())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))
		usr.set_machine(src)
		if (href_list["dispense_helmet"])
			src.dispense_helmet(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["dispense_suit"])
			src.dispense_suit(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["toggle_open"])
			src.toggle_open(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["start_convert"])
			src.start_Working(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["set_human"])
			src.targetspecies = SUIT_HUMAN
			src.updateUsrDialog()
		if (href_list["set_taj"])
			src.targetspecies = SUIT_TAJARAN
			src.updateUsrDialog()
		if (href_list["set_skrell"])
			src.targetspecies = SUIT_SKRELL
			src.updateUsrDialog()
		if (href_list["set_unathi"])
			src.targetspecies = SUIT_UNATHI
			src.updateUsrDialog()
	/*if (href_list["refresh"])
		src.updateUsrDialog()*/
	src.add_fingerprint(usr)
	return
/obj/machinery/suit_fitter/proc/dispense_helmet(mob/user as mob)
	if(!src.HELMET)
		return //Do I even need this sanity check? Nyoro~n
	else
		src.HELMET.loc = src.loc
		src.HELMET = null
		return


/obj/machinery/suit_fitter/proc/dispense_suit(mob/user as mob)
	if(!src.SUIT)
		return
	else
		src.SUIT.loc = src.loc
		src.SUIT = null
		return
/obj/machinery/suit_fitter/proc/dump_everything()
	if(src.SUIT)
		src.SUIT.loc = src.loc
		src.SUIT = null
	if(src.HELMET)
		src.HELMET.loc = src.loc
		src.HELMET = null
	return


/obj/machinery/suit_fitter/proc/toggle_open(mob/user as mob)
	if(src.isWorking)
		user << "<font color='red'>Unable to open unit.</font>"
		return
	src.isopen = !src.isopen
	return
/obj/machinery/suit_fitter/proc/set_type()
	if(src.HELMET)
		switch(src.targetspecies)
			if(SUIT_HUMAN)
				switch(HELMET.get_department())
					if(RIG_ENG)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig()
					if(RIG_ATMOS)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/atmos()
					if(RIG_MEDICAL)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/medical()
					if(RIG_MINING)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/mining()
					if(RIG_SECURITY)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/security()
					if(RIG_ELITE)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/elite()
					if(RIG_SYNDI)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/syndi()
			if(SUIT_TAJARAN)
				switch(HELMET.get_department())
					if(RIG_ENG)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/tajara()
					if(RIG_ATMOS)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/atmos/tajara()
					if(RIG_MEDICAL)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/medical/tajara()
					if(RIG_MINING)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/mining/tajara()
					if(RIG_SECURITY)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/security/tajara()
					if(RIG_ELITE)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/elite/tajara()
					if(RIG_SYNDI)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/tajara()
			if(SUIT_UNATHI)
				switch(HELMET.get_department())
					if(RIG_ENG)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig()
					if(RIG_ATMOS)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/atmos()
					if(RIG_MEDICAL)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/medical()
					if(RIG_MINING)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/mining()
					if(RIG_SECURITY)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/security()
					if(RIG_ELITE)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/elite()
					if(RIG_SYNDI)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/syndi()
			if(SUIT_SKRELL)
				switch(HELMET.get_department())
					if(RIG_ENG)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/skrell()
					if(RIG_ATMOS)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/atmos()
					if(RIG_MEDICAL)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/medical()
					if(RIG_MINING)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/mining()
					if(RIG_SECURITY)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/security()
					if(RIG_ELITE)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/elite/skrell()
					if(RIG_SYNDI)
						src.HELMET = new /obj/item/clothing/head/helmet/space/rig/syndi()
			else
	if(src.SUIT)
		switch(src.targetspecies)
			if(SUIT_HUMAN)
				switch(SUIT.get_department())
					if(RIG_ENG)
						src.SUIT = new /obj/item/clothing/suit/space/rig()
					if(RIG_ATMOS)
						src.SUIT = new /obj/item/clothing/suit/space/rig/atmos()
					if(RIG_MEDICAL)
						src.SUIT = new /obj/item/clothing/suit/space/rig/medical()
					if(RIG_MINING)
						src.SUIT = new /obj/item/clothing/suit/space/rig/mining()
					if(RIG_SECURITY)
						src.SUIT = new /obj/item/clothing/suit/space/rig/security()
					if(RIG_ELITE)
						src.SUIT = new /obj/item/clothing/suit/space/rig/elite()
					if(RIG_SYNDI)
						src.SUIT = new /obj/item/clothing/suit/space/rig/syndi()
			if(SUIT_TAJARAN)
				switch(SUIT.get_department())
					if(RIG_ENG)
						src.SUIT = new /obj/item/clothing/suit/space/rig/tajara()
					if(RIG_ATMOS)
						src.SUIT = new /obj/item/clothing/suit/space/rig/atmos/tajara()
					if(RIG_MEDICAL)
						src.SUIT = new /obj/item/clothing/suit/space/rig/medical/tajara()
					if(RIG_MINING)
						src.SUIT = new /obj/item/clothing/suit/space/rig/mining/tajara()
					if(RIG_SECURITY)
						src.SUIT = new /obj/item/clothing/suit/space/rig/security/tajara()
					if(RIG_ELITE)
						src.SUIT = new /obj/item/clothing/suit/space/rig/elite/tajara()
					if(RIG_SYNDI)
						src.SUIT = new /obj/item/clothing/suit/space/rig/tajara()
			if(SUIT_UNATHI)
				switch(SUIT.get_department())
					if(RIG_ENG)
						src.SUIT = new /obj/item/clothing/suit/space/rig()
					if(RIG_ATMOS)
						src.SUIT = new /obj/item/clothing/suit/space/rig/atmos()
					if(RIG_MEDICAL)
						src.SUIT = new /obj/item/clothing/suit/space/rig/medical()
					if(RIG_MINING)
						src.SUIT = new /obj/item/clothing/suit/space/rig/mining()
					if(RIG_SECURITY)
						src.SUIT = new /obj/item/clothing/suit/space/rig/security()
					if(RIG_ELITE)
						src.SUIT = new /obj/item/clothing/suit/space/rig/elite()
					if(RIG_SYNDI)
						src.SUIT = new /obj/item/clothing/suit/space/rig/syndi()
			if(SUIT_SKRELL)
				switch(SUIT.get_department())
					if(RIG_ENG)
						src.SUIT = new /obj/item/clothing/suit/space/rig/skrell()
					if(RIG_ATMOS)
						src.SUIT = new /obj/item/clothing/suit/space/rig/atmos()
					if(RIG_MEDICAL)
						src.SUIT = new /obj/item/clothing/suit/space/rig/medical()
					if(RIG_MINING)
						src.SUIT = new /obj/item/clothing/suit/space/rig/mining()
					if(RIG_SECURITY)
						src.SUIT = new /obj/item/clothing/suit/space/rig/security()
					if(RIG_ELITE)
						src.SUIT = new /obj/item/clothing/suit/space/rig/elite/skrell()
					if(RIG_SYNDI)
						src.SUIT = new /obj/item/clothing/suit/space/rig/syndi()
			else
/obj/machinery/suit_fitter/proc/start_Working(mob/user as mob)
	if(src.isWorking || src.isopen) //I'm bored of all these sanity checks
		return
	if(!src.HELMET && !src.SUIT) //shit's empty yo
		user << "<font color='red'>Unit storage bays empty. Nothing to convert -- Aborting.</font>"
		return
	user << "You start the Unit's conversion cycle."
	src.cycletime_left = 20
	src.isWorking = 1
	src.update_icon()
	src.updateUsrDialog()

	var/i //our counter
	for(i=0,i<4,i++)
		sleep(50)
		if(i==3) //End of the cycle
			src.set_type(src.targetspecies)
			src.isWorking = 0 //Cycle ends
	src.update_icon()
	src.updateUsrDialog()
	return

/obj/machinery/suit_fitter/attackby(obj/item/I as obj, mob/user as mob)
	if(!src.ispowered)
		return
	if( istype(I,/obj/item/clothing/suit/space/rig) )
		if(!src.isopen)
			return
		var/obj/item/clothing/suit/space/S = I
		if(src.SUIT)
			user << "<font color='blue'>The unit already contains a suit.</font>"
			return
		user << "You load the [S.name] into the storage compartment."
		user.drop_item()
		S.loc = src
		src.SUIT = S
		src.update_icon()
		src.updateUsrDialog()
		return
	if( istype(I,/obj/item/clothing/head/helmet/space/rig) )
		if(!src.isopen)
			return
		var/obj/item/clothing/head/helmet/H = I
		if(src.HELMET)
			user << "<font color='blue'>The unit already contains a helmet.</font>"
			return
		user << "You load the [H.name] into the storage compartment."
		user.drop_item()
		H.loc = src
		src.HELMET = H
		src.update_icon()
		src.updateUsrDialog()
		return
	src.update_icon()
	src.updateUsrDialog()
	return