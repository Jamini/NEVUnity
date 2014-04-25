
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/
	name = "ceramic mug"
	desc = "It's a mug used for storing highly caffeinated beverages"
	icon = 'icons/obj/ceramic.dmi'
	var/obj_color = "mug"
	icon_state = "mug1"
	var/original_desc = null
	amount_per_transfer_from_this = 10
	volume = 50
	New()
		..()
		original_desc = desc
		icon_state = obj_color + "1"

	on_reagent_change()
		if (reagents.reagent_list.len > 0)
			switch(reagents.get_master_reagent_id())
				if("whiskey")
					desc = "Its a mug with whiskey in it. Shame on you.."
				if("irishcoffee")
					icon_state = obj_color + "2"
					desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."
				if("water")
					desc = "Its a mug with water in it. Shameful."
				if("soy_latte")
					icon_state = obj_color + "2"
					desc = "A nice and refrshing beverage while you are reading."
				if("cafe_latte")
					icon_state = obj_color + "2"
					desc = "A nice, strong and refreshing beverage while you are reading."
				if("icecoffee")
					icon_state = obj_color + "2"
					desc = "A drink to perk you up and refresh you!"
				if("coffee")
					icon_state = obj_color + "2"
					desc = "Don't drop it, or you'll send scalding liquid everywhere."
				if("tea")
					icon_state = obj_color + "2"
					desc = "Contains tea, the sign of a true scholar and a gentleman."
				if("fuel")
					desc = "Unless you are an industrial tool, this is probably not safe for consumption."
				else
					icon_state = obj_color + "1"
					desc = original_desc
		else
			icon_state = obj_color + "1"
			desc = original_desc
		return


/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/white
	obj_color = "mug"



/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/blue
	obj_color = "bluemug"


/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/green
	obj_color = "greenmug"


/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/pink
	desc = "It's a mug used for storing highly caffeinated beverages. It's pretty and pink."
	obj_color = "pinkmug"


/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/ce
	name = "cheif engineer\'s mug"
	desc = "They probably couldnt live without it."
	obj_color = "cemug"

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/cmo
	name = "cheif medical officer\'s mug"
	obj_color = "cmomug"
	desc = "It has a red cross printed on it."

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/captain
	name = "captains mug"
	obj_color = "capmug"
	desc = "It has a NanoTrasen logo printed on it, It's probably best you left it alone."

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/helm
	name = "first officer\'s mug"
	obj_color = "helmmug"
	desc = "It might still have something in it."


/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/warden
	name = "warden\'s mug"
	obj_color = "wardmug"
	desc = "Don't even think about it."

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/qm
	name = "quartermasters mug"
	obj_color = "qmmug"
	desc = "It's probably a manufacturing reject."


/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/rd
	name = "research director\'s mug"
	obj_color = "rdmug"
	desc = "Who knows what he puts in it."


/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/syndicate
	name = "syndicate mug"
	obj_color = "syndmug"
	desc = "It has the words 'Death to NanoTrasen' crudely scratched into it."

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/detective
	name = "detective\'s mug"
	obj_color = "detmug"
	desc = "It is very likely to contain a high concentration of alcohol."
