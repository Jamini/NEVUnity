/obj/structure/closet/secure_closet/bar
	name = "Bar Wardrobe"
	req_access = list(access_bar)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"


	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/backpack/satchel( src )
		new /obj/item/clothing/shoes/black( src )
		new /obj/item/clothing/suit/armor/vest( src )
		new /obj/item/clothing/under/rank/bartender( src )
		new /obj/item/weapon/storage/box/survival( src )
		new /obj/item/ammo_casing/shotgun/beanbag( src )
		new /obj/item/ammo_casing/shotgun/beanbag( src )
		new /obj/item/ammo_casing/shotgun/beanbag( src )
		new /obj/item/ammo_casing/shotgun/beanbag( src )
		new /obj/item/clothing/under/rank/chef( src )
		new /obj/item/clothing/suit/chef( src )
		new /obj/item/clothing/shoes/black( src )
		new /obj/item/clothing/head/chefhat( src )
		return

/obj/structure/closet/secure_closet/bar/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened
