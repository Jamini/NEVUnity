/mob/living/simple_animal/borer/nt
	name = "Alex"
	real_name = "Alex"
	truename = "Alex"
	damageprob = 0
	controldelay = 275
	desc = "A small, quivering sluglike creature with a barcode tatooed on its side."
/mob/living/simple_animal/borer/nt/verb/Namepick()
	set category = "Alien"
	set name = "Select Name"
	set desc = "Change your name."

	var/newname = input(src,"You are a NT borer. Enter a name, or leave blank for the default name.", "Name change","") as text
	if (newname != "")
		name = newname
		real_name = newname
		truename = newname
	else
		return
