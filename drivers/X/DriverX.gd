extends Node

var thrust_will = Vector2.ZERO
var rational_will = Vector2.ZERO
var barake_will = Vector2.ZERO

var fire_will = Vector2.ZERO


func getThrustWill():
	return thrust_will


func getRotationalWill():
	return rational_will


func getBrakeWill():
	return barake_will


func getFireWill():
	return fire_will


func _init():
	set_process(true)


func _process(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	var brake_strength = Input.get_action_strength("drive_brake")

	var fire_strength = Input.get_action_strength("fire")

	thrust_will = Vector2(input_vector.y, 0)
	rational_will = Vector2(input_vector.x, 0)
	barake_will = Vector2(brake_strength, 0)
	fire_will = Vector2(fire_strength, 0)
