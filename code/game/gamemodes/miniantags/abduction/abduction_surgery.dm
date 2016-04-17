/datum/surgery/organ_extraction
	name = "experimental dissection"
	steps = list(/datum/surgery_step/generic/cut_open, /datum/surgery_step/generic/clamp_bleeders, /datum/surgery_step/generic/retract_skin, /datum/surgery_step/open_encased/saw, /datum/surgery_step/generic/retract_skin, /datum/surgery_step/internal/extract_organ, /datum/surgery_step/internal/gland_insert, /datum/surgery_step/generic/cauterize)
	possible_locs = list("chest")

/datum/surgery/organ_extraction/can_start(mob/user, mob/living/carbon/target)
	if(!ishuman(user))
		return 0
	var/mob/living/carbon/human/H = user
	if(H.get_species() == "Abductor")
		return 1
	if((locate(/obj/item/weapon/implant/abductor) in H))
		return 1
	return 0


/datum/surgery_step/internal/extract_organ
	name = "remove heart"
	accept_hand = 1
	time = 32
	var/obj/item/organ/internal/IC = null
	var/list/organ_types = list(/obj/item/organ/internal/heart)

/datum/surgery_step/internal/extract_organ/begin_step(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	for(var/obj/item/I in target.internal_organs)
		if(I.type in organ_types)
			IC = I
			break
	user.visible_message("[user] starts to remove [target]'s organs.", "<span class='notice'>You start to remove [target]'s organs...</span>")
	..()

/datum/surgery_step/internal/extract_organ/end_step(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(IC)
		user.visible_message("[user] pulls [IC] out of [target]'s [target_zone]!", "<span class='notice'>You pull [IC] out of [target]'s [target_zone].</span>")
		user.put_in_hands(IC)
		IC.remove(target, special = 1)
		return 1
	else
		to_chat(user, "<span class='warning'>You don't find anything in [target]'s [target_zone]!</span>")
		return 0

/datum/surgery_step/internal/gland_insert
	name = "insert gland"
	allowed_tools = list(/obj/item/organ/internal/gland = 100)
	time = 32

/datum/surgery_step/internal/gland_insert/begin_step(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] starts to insert [tool] into [target].", "<span class ='notice'>You start to insert [tool] into [target]...</span>")
	..()

/datum/surgery_step/internal/gland_insert/end_step(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] inserts [tool] into [target].", "<span class ='notice'>You insert [tool] into [target].</span>")
	user.drop_item()
	var/obj/item/organ/internal/gland/gland = tool
	gland.insert(target, 2)
	return 1