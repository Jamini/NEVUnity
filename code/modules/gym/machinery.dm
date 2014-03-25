/obj/machinery/conveyor/hologym
	icon = 'icons/obj/hologym.dmi'
	name = "treadmill"
	desc = "it's an excercise belt. You run along it."
/obj/machinery/conveyor_switch/hologym
	icon = 'icons/obj/hologym.dmi'
	name = "treadmill controlls"
	desc = "it turns on and off the treadmill"
/obj/machinery/punchbag
	icon = 'icons/obj/hologym.dmi'
	icon_state = "punchbag"
	name = "punching bag"
	desc = "just imagine it is the face of your least favorite person..."
	density = 1
	anchored = 1
/obj/machinery/pullupbar
	icon = 'icons/obj/hologym.dmi'
	icon_state = "pullbar"
	name = "pullup bar"
	desc = "how many reps can you do?..."
	density = 0
	anchored = 1

/obj/machinery/pullupbar/attack_hand(mob/living/carbon/human/M as mob)
	visible_message("\red <B>[M] pulls themselves off the ground with the [src]")

/obj/machinery/punchbag/attack_hand(mob/living/carbon/human/M as mob)
	if(M.species.attack_verb == "punch")
		playsound(loc, "punch", 25, 1, -1)
	else
		playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
	visible_message("\red <B>[M] has [M.species.attack_verb]ed [src]!</B>")

