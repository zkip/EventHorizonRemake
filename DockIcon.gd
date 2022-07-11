extends Control
class_name DockIcon

export(Texture) var texture

var is_activated = false

signal activate
signal inactivate


func init(name: String, texture_: Texture):
	$name.text = name
	texture = texture_
	return self


func _ready():
	if texture != null:
		$ShipShot.texture = texture
	pass


func _on_DockIcon_mouse_entered():
	if not is_activated:
		$AnimationPlayer.play("hover")
	pass


func _on_DockIcon_mouse_exited():
	if not is_activated:
		$AnimationPlayer.play("RESET")
	pass


func receive_active(emitter):
	if emitter != self:
		inactive()


func active():
	if not is_activated:
		for node in get_tree().get_nodes_in_group("DockIcon"):
			node.receive_active(self)

		emit_signal("activate")
		is_activated = true
		$AnimationPlayer.play("activate")


func inactive():
	if is_activated:
		is_activated = false
		emit_signal("inactivate")
		$AnimationPlayer.play("RESET")


func _on_DockIcon_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if is_activated:
			inactive()
		else:
			active()
	pass
