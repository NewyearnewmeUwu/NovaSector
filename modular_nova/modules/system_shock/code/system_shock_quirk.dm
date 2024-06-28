/datum/quirk/system_shock
	name = "System Shock"
	desc = "You and electricity have a volatile relationship. One spark's liable to forcefully reboot your systems."
	gain_text = span_danger("You start feeling nervous around plug sockets.")
	lose_text = span_notice("You feel normal about sparks.")
	medical_record_text = "Patient's processors are unusually uninsulated."
	value = -8
	mob_trait = TRAIT_SYSTEM_SHOCK
	icon = FA_ICON_BED
	quirk_flags = QUIRK_HUMAN_ONLY

/datum/quirk/system_shock/add(client/client_source)
	if(!issynthetic(quirk_holder))
		qdel(src)
	RegisterSignal(quirk_holder, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))
	RegisterSignal(quirk_holder, COMSIG_LIVING_MINOR_SHOCK, PROC_REF(on_electrocute))

/datum/quirk/system_shock/remove()
	UnregisterSignal(quirk_holder, COMSIG_LIVING_ELECTROCUTE_ACT)
	UnregisterSignal(quirk_holder, COMSIG_LIVING_MINOR_SHOCK)


/datum/quirk/system_shock/proc/on_electrocute()
	SIGNAL_HANDLER
	var/knockout_length = 9 + rand(0,5)
	quirk_holder.set_static_vision(knockout_length SECONDS)
	quirk_holder.balloon_alert(quirk_holder, "system rebooting")
	to_chat(quirk_holder, span_danger("CRIT&!AL ERR%R: S#STEM REBO#TING."))
	addtimer(CALLBACK(src, PROC_REF(knock_out), knockout_length-4), 2 SECONDS)

/datum/quirk/system_shock/proc/knock_out(var/length)
	if(!length)
		return
	quirk_holder.Sleeping(length SECONDS)
