extends Node

var all_components = {
	"afterburner1": preload("res://Components/afterburner1.tscn"),
	"armor23": preload("res://Components/armor23.tscn"),
	"armor43": preload("res://Components/armor43.tscn"),
	"armor63": preload("res://Components/armor63.tscn"),
	"core": preload("res://Components/core.tscn"),
	"drone_replicator3": preload("res://Components/drone_replicator3.tscn"),
	"energyshield": preload("res://Components/energyshield.tscn"),
	"engine5": preload("res://Components/engine5.tscn"),
	"fueltank13": preload("res://Components/fueltank13.tscn"),
	"inertial2": preload("res://Components/inertial2.tscn"),
	"pointdefense": preload("res://Components/pointdefense.tscn"),
	"reactor21": preload("res://Components/reactor21.tscn"),
	"shield_capacitor1": preload("res://Components/shield_capacitor1.tscn"),
	"shield1": preload("res://Components/shield1.tscn"),
	"zygote2": preload("res://Components/zygote2.tscn"),
	"armor11": preload("res://Components/armor11.tscn"),
	"armor31": preload("res://Components/armor31.tscn"),
	"armor51": preload("res://Components/armor51.tscn"),
	"armored_tank1": preload("res://Components/armored_tank1.tscn"),
	"drone_power1": preload("res://Components/drone_power1.tscn"),
	"dronebay1": preload("res://Components/dronebay1.tscn"),
	"engine0": preload("res://Components/engine0.tscn"),
	"engine6": preload("res://Components/engine6.tscn"),
	"fueltank21": preload("res://Components/fueltank21.tscn"),
	"intertial_damper1": preload("res://Components/intertial_damper1.tscn"),
	"ram": preload("res://Components/ram.tscn"),
	"reactor22": preload("res://Components/reactor22.tscn"),
	"shield_capacitor2": preload("res://Components/shield_capacitor2.tscn"),
	"shield2": preload("res://Components/shield2.tscn"),
	"zygote3": preload("res://Components/zygote3.tscn"),
	"armor12": preload("res://Components/armor12.tscn"),
	"armor32": preload("res://Components/armor32.tscn"),
	"armor52": preload("res://Components/armor52.tscn"),
	"armored_tank2": preload("res://Components/armored_tank2.tscn"),
	"drone_power2": preload("res://Components/drone_power2.tscn"),
	"dronebay2": preload("res://Components/dronebay2.tscn"),
	"engine1": preload("res://Components/engine1.tscn"),
	"focus1": preload("res://Components/focus1.tscn"),
	"fueltank22": preload("res://Components/fueltank22.tscn"),
	"intertial_damper2": preload("res://Components/intertial_damper2.tscn"),
	"range1": preload("res://Components/range1.tscn"),
	"reactor3": preload("res://Components/reactor3.tscn"),
	"shield_capacitor3": preload("res://Components/shield_capacitor3.tscn"),
	"teleporter": preload("res://Components/teleporter.tscn"),
	"armor13": preload("res://Components/armor13.tscn"),
	"armor33": preload("res://Components/armor33.tscn"),
	"armor53": preload("res://Components/armor53.tscn"),
	"drone_power3": preload("res://Components/drone_power3.tscn"),
	"dronebay3": preload("res://Components/dronebay3.tscn"),
	"engine2": preload("res://Components/engine2.tscn"),
	"focus2": preload("res://Components/focus2.tscn"),
	"fueltank23": preload("res://Components/fueltank23.tscn"),
	"jammer": preload("res://Components/jammer.tscn"),
	"reactor": preload("res://Components/reactor.tscn"),
	"RepairBay": preload("res://Components/RepairBay.tscn"),
	"shield_generator1": preload("res://Components/shield_generator1.tscn"),
	"teleporter1": preload("res://Components/teleporter1.tscn"),
	"armor21": preload("res://Components/armor21.tscn"),
	"armor41": preload("res://Components/armor41.tscn"),
	"armor61": preload("res://Components/armor61.tscn"),
	"drone_replicator1": preload("res://Components/drone_replicator1.tscn"),
	"DroneDamage": preload("res://Components/DroneDamage.tscn"),
	"engine3": preload("res://Components/engine3.tscn"),
	"fueltank11": preload("res://Components/fueltank11.tscn"),
	"hovertank": preload("res://Components/hovertank.tscn"),
	"lightweight": preload("res://Components/lightweight.tscn"),
	"reactor1": preload("res://Components/reactor1.tscn"),
	"repairbot1": preload("res://Components/repairbot1.tscn"),
	"shield_generator2": preload("res://Components/shield_generator2.tscn"),
	"armor22": preload("res://Components/armor22.tscn"),
	"armor42": preload("res://Components/armor42.tscn"),
	"armor62": preload("res://Components/armor62.tscn"),
	"drone_replicator2": preload("res://Components/drone_replicator2.tscn"),
	"DroneRange": preload("res://Components/DroneRange.tscn"),
	"engine4": preload("res://Components/engine4.tscn"),
	"fueltank12": preload("res://Components/fueltank12.tscn"),
	"inertial1": preload("res://Components/inertial1.tscn"),
	"lightweight1": preload("res://Components/lightweight1.tscn"),
	"reactor2": preload("res://Components/reactor2.tscn"),
	"repairsystem": preload("res://Components/repairsystem.tscn"),
	"shield_generator3": preload("res://Components/shield_generator3.tscn"),
	"zygote1": preload("res://Components/zygote1.tscn"),
	# weapons
	"accelerator1": preload("res://Components/weapons/accelerator1.tscn"),
	"energybeam1": preload("res://Components/weapons/energybeam1.tscn"),
	"firework": preload("res://Components/weapons/firework.tscn"),
	"gun2": preload("res://Components/weapons/gun2.tscn"),
	"gun4": preload("res://Components/weapons/gun4.tscn"),
	"gun6": preload("res://Components/weapons/gun6.tscn"),
	"holy_gun": preload("res://Components/weapons/holy_gun.tscn"),
	"ion_cannon1": preload("res://Components/weapons/ion_cannon1.tscn"),
	"laser1": preload("res://Components/weapons/laser1.tscn"),
	"laser3": preload("res://Components/weapons/laser3.tscn"),
	"missile0": preload("res://Components/weapons/missile0.tscn"),
	"missile2": preload("res://Components/weapons/missile2.tscn"),
	"rocket1": preload("res://Components/weapons/rocket1.tscn"),
	"shock2": preload("res://Components/weapons/shock2.tscn"),
	"shotgun2": preload("res://Components/weapons/shotgun2.tscn"),
	"torpedo1": preload("res://Components/weapons/torpedo1.tscn"),
	"torpedo3": preload("res://Components/weapons/torpedo3.tscn"),
	"doom1": preload("res://Components/weapons/doom1.tscn"),
	"energybeam2": preload("res://Components/weapons/energybeam2.tscn"),
	"gun1": preload("res://Components/weapons/gun1.tscn"),
	"gun3": preload("res://Components/weapons/gun3.tscn"),
	"gun5": preload("res://Components/weapons/gun5.tscn"),
	"gun7": preload("res://Components/weapons/gun7.tscn"),
	"hovertank_gun": preload("res://Components/weapons/hovertank_gun.tscn"),
	"ion_cannon2": preload("res://Components/weapons/ion_cannon2.tscn"),
	"laser2": preload("res://Components/weapons/laser2.tscn"),
	"laser4": preload("res://Components/weapons/laser4.tscn"),
	"missile1": preload("res://Components/weapons/missile1.tscn"),
	"missile3": preload("res://Components/weapons/missile3.tscn"),
	"shock1": preload("res://Components/weapons/shock1.tscn"),
	"shotgun1": preload("res://Components/weapons/shotgun1.tscn"),
	"targeting_unit": preload("res://Components/weapons/targeting_unit.tscn"),
	"torpedo2": preload("res://Components/weapons/torpedo2.tscn"),
	"torpedo4": preload("res://Components/weapons/torpedo4.tscn"),
}

# var currentPlayer = explorerShipManager.test_regist()
var currentPlayer = null

var activated_component = null


func set_activated_component_by_name(component_name: String):
	if component_name in all_components:
		activated_component = all_components[component_name]
		return true
	return false


func get_activated_component():
	return activated_component


func clear_activated_component():
	activated_component = null
