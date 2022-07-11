extends Camera2D

var _position_backup = null
var _zoom_backup = null
var start_mgpos = null

var is_panning = false

var zoom_step = 1.2


func _input(event):
	if event is InputEventMouse:
		if event.is_pressed() and not event.is_echo():
			var mouse_position = event.position
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_at_point(1 / zoom_step, mouse_position)
			else:
				if event.button_index == BUTTON_WHEEL_DOWN:
					zoom_at_point(zoom_step, mouse_position)


func zoom_at_point(zoom_change, point):
	var viewport_size = get_viewport().size
	var zoom_will = zoom * zoom_change

	var offset = (-0.5 * viewport_size + point) * (zoom - zoom_will)

	zoom = zoom_will
	global_position += offset


func _process(_delta):
	if Input.is_action_pressed("camera_pan"):
		if not is_panning:
			_position_backup = position
			start_mgpos = get_viewport().get_mouse_position()
			is_panning = true

	if Input.is_action_just_released("camera_pan"):
		if is_panning:
			_position_backup = null
			start_mgpos = null
			is_panning = false

	if is_panning:
		var offset = get_viewport().get_mouse_position() - start_mgpos
		position = _position_backup - offset * zoom

	pass
