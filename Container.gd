extends GridContainer

var activated = null


func _on_Container_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			var mls = self.get_local_mouse_position()
			var grid_pos = (mls / 32).floor()
			var children = get_children()
			var index = grid_pos.x + self.columns * grid_pos.y

			if index < children.size():
				globalState.set_activated_component_by_name(children[index].name)

				if activated != children[index]:
					if activated:
						activated.modulate = Color(1.0, 1.0, 1.0, 1.0)
					children[index].modulate = Color(0.0, 1.0, 1.0, 1.0)
					activated = children[index]

				else:
					globalState.clear_activated_component()
					if activated:
						activated.modulate = Color(1.0, 1.0, 1.0, 1.0)
						activated = null
	pass


func _process(_delta):
	if not globalState.get_activated_component():
		if activated:
			activated.modulate = Color(1.0, 1.0, 1.0, 1.0)
			activated = null
