extends Node

var thrust_will = Vector2.LEFT
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
