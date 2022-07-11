extends Node2D

onready var componentIndicator = $component_indicator

var _currentShip: Ship
var _current_slots_protocol: SlotProtocol

var _pick_offset = Vector2.ZERO
var _holder_size = Vector2.ZERO

var _hover = null
var _holder = null
var _last_holder_scene = null
var _component_current = null

var _is_collision = false
var _is_invalid = false
var _is_new = false
var _is_holder = false
var _is_picking = false

var _current_position_backup
var _last_valid_position

var _ship_map = {}
var _yard_map = {}
var _stares_map = {}
var _activated_license

var _ship_textures = {}


func get_captain():
	return globalState.currentPlayer


func get_ship(license: String) -> Ship:
	return _ship_map.get(license)


func push_to_yard_ship_queue(ship: Ship):
	_ship_map[ship.license] = ship


func remove_from_yard_ship_queue(ship: Ship):
	_ship_map.erase(ship.license)


func push_to_yard(ship: Ship):
	return _push_to_yard(ship)


func _on_dock_icon_active(license):
	if license != null:
		var ship = get_ship(license)
		_push_to_yard(ship)
		_activated_license = license


func _on_dock_icon_inactive(_license):
	if _activated_license != null:
		var ship = get_ship(_activated_license)
		_remove_to_yard(ship)
		_activated_license = null


func _push_to_yard(ship: Ship, is_in_tree = false):
	if not _yard_map.has(ship.license):
		ship.get_node("protocols/slot").visible = true
		ship.get_node("texture").modulate = Color(1, 1, 1, 0.5)
		_yard_map[ship.license] = ship

		if not is_in_tree:
			$yard.add_child(ship)


func _remove_to_yard(ship: Ship):
	if _yard_map.has(ship.license):
		ship.get_node("protocols/slot").visible = false
		ship.get_node("texture").modulate = Color(1, 1, 1, 1)
		_yard_map.erase(ship.license)

		$yard.remove_child(ship)


func _get_cell_position(position: Vector2):
	return (position / 64).floor()


func _check_and_flag():
	var live_component = _holder
	if _component_current != null:
		live_component = _component_current

	var ltm = live_component.type_slots

	var current_base_position = _get_cell_position(
		ltm.global_position - _current_slots_protocol.type_slots.global_position
	)

	var collisions = []
	var invliad_ship_slots = []
	var outside_ship_slots = []

	for cell in ltm.get_used_cells():
		var grid_position = current_base_position + cell
		for component in _currentShip.components:
			if component != live_component:
				var tm = component.type_slots
				var global_cell_position = (
					grid_position * 64
					+ _current_slots_protocol.type_slots.global_position
				)
				var component_grid_position = _get_cell_position(tm.to_local(global_cell_position))
				if tm.get_cell(component_grid_position.x, component_grid_position.y) != -1:
					collisions.append(cell)

		if not _current_slots_protocol.can_accept(live_component, cell):
			if not _current_slots_protocol.get_cell_types(grid_position):
				outside_ship_slots.append(cell)
			else:
				invliad_ship_slots.append(cell)

	for cell in ltm.get_used_cells():
		var is_outside = false

		for outside in outside_ship_slots:
			if cell == outside:
				is_outside = true
				break

		if is_outside:
			ltm.set_cell(cell.x, cell.y, ltm.tile_set.find_tile_by_name("_none"))
		else:
			var isCollisions = false
			var invalid = false

			for collision in collisions:
				if cell == collision:
					isCollisions = true

			for slot in invliad_ship_slots:
				if cell == slot:
					invalid = true

			if isCollisions || invalid:
				ltm.set_cell(cell.x, cell.y, ltm.tile_set.find_tile_by_name("_error"))
			else:
				ltm.set_cell(cell.x, cell.y, ltm.tile_set.find_tile_by_name("_active"))

	_is_collision = collisions.size() > 0
	_is_invalid = invliad_ship_slots.size() > 0 || outside_ship_slots.size() > 0


func _is_avaliable():
	return !_is_collision && !_is_invalid


func _push():
	if _component_current != null:
		_currentShip.components.append(_component_current)
	_is_new = false


func _gen_holder():
	var Component = globalState.get_activated_component()
	if Component:
		_holder = Component.instance()
		componentIndicator.add_child(_holder)
		_holder.z_index = 1
		_holder.type_slots.visible = true
		var rrect = _holder.type_slots.get_used_rect().size * _holder.type_slots.cell_size
		_holder_size = rrect
		_is_holder = true


func _clear_holder():
	if _holder != null:
		componentIndicator.remove_child(_holder)
		_holder.queue_free()
		_holder = null
		_holder_size = Vector2.ZERO


func _new():
	var Component = globalState.get_activated_component()
	if Component:
		_component_current = Component.instance()
		_currentShip.get_node("components").add_child(_component_current)
		_is_new = true


func _pick():
	if Input.is_action_pressed("create_component"):
		_new()
	else:
		_component_current = _hover
		pass

	if _component_current != null:
		_component_current.type_slots.visible = true
		_component_current.z_index = 1
		_pick_offset = _component_current.global_position - get_global_mouse_position()
		if !_is_new:
			_current_position_backup = _component_current.global_position
	pass


func _pick_and_free():
	if _component_current != null:
		_component_current.z_index = 0
		_component_current.type_slots.visible = false

		if _is_avaliable():
			if _last_valid_position != null:
				_component_current.global_position = _last_valid_position
				_component_current.type_slots.global_position = _last_valid_position

			if _is_new:
				_push()
		else:
			if _is_new:
				_component_current.queue_free()
			else:
				_component_current.global_position = _current_position_backup

		_pick_offset = Vector2.ZERO
		_component_current = null
		_current_position_backup = null
		_is_collision = false
		_is_invalid = false
		_is_holder = false
		_is_new = false


func _hover_and_free():
	if _hover != null:
		_currentShip.components.remove(_currentShip.components.find(_hover))
		_hover.queue_free()

		_pick_offset = Vector2.ZERO
		_component_current = null
		_current_position_backup = null
		_is_collision = false
		_is_invalid = false
		_is_holder = false
		_is_new = false
		pass


func _ready():
	# 恢复yard节点上的Ship
	for child in $yard.get_children():
		if child is Ship:
			push_to_yard_ship_queue(child)
			_push_to_yard(child, true)

	pass

	var captain = get_captain()

	var licenses = captain.get_licenses()

	for license in licenses:
		var data = explorerShipManager.get_ship_data(license)
		if data != null:
			if "ship_name" in data:
				var ship_name = data.get("ship_name")
				var ship_scene = explorerShipManager.get_ship_scene(license)
				var ship_inst = ship_scene.instance().init(license)
				push_to_yard_ship_queue(ship_inst)

				var ship_texture = explorerShipManager.get_ship_texture(ship_name)
				var dock_icon = load("res://DockIcon.tscn").instance().init(ship_name, ship_texture)
				dock_icon.connect("inactivate", self, "_on_dock_icon_inactive", [license])
				dock_icon.connect("activate", self, "_on_dock_icon_active", [license])

				$CanvasLayer/ScrollContainer/HBoxContainer.add_child(dock_icon)


func _process(_delta):
	for ship in _yard_map.values():
		_currentShip = ship
		_current_slots_protocol = _currentShip.get_node("protocols/slot")

	if _currentShip != null:
		var mouse_position = get_global_mouse_position()

		if Input.is_action_pressed("cancel"):
			globalState.clear_activated_component()
			_clear_holder()

		if Input.is_action_pressed("mouse_main"):
			if !_is_picking:
				if _holder != null and _activated_license != null:
					_new()
					_pick_and_free()
				else:
					_pick()
			_is_picking = true

		if Input.is_action_just_released("mouse_main"):
			if _is_picking and _activated_license != null:
				_pick_and_free()
			_is_picking = false

		if Input.is_action_pressed("mouse_side"):
			if !_is_picking:
				_hover_and_free()

		var HolderComponent = globalState.get_activated_component()
		if !_is_picking:
			if HolderComponent:
				if not _holder:
					_gen_holder()
					pass
				elif _last_holder_scene != HolderComponent:
					_clear_holder()
					_gen_holder()
				_last_holder_scene = HolderComponent
			elif not HolderComponent:
				if _holder:
					_clear_holder()
					pass

		if (_is_picking && _component_current != null) || _holder != null:
			var live_component = _holder
			if _component_current != null:
				live_component = _component_current

			var i_position = (
				(
					((mouse_position + _pick_offset - _holder_size / 2 + Vector2(32, 32) - _current_slots_protocol.type_slots.global_position) / 64).floor()
					* 64
				)
				+ _current_slots_protocol.type_slots.global_position
			)

			live_component.global_position = mouse_position + _pick_offset - _holder_size / 2
			live_component.type_slots.global_position = i_position

			if _activated_license != null:
				_check_and_flag()

			if not _is_collision and not _is_invalid:
				_last_valid_position = i_position
			else:
				_last_valid_position = null

		if not _component_current and not _holder:
			var hover_live
			for component in _currentShip.components:
				var tm = component.type_slots
				var local_mouse_grid = _get_cell_position(tm.to_local(mouse_position))
				if tm.get_cell(local_mouse_grid.x, local_mouse_grid.y) != -1:
					hover_live = component

			if _hover != hover_live:
				if _hover != null:
					_hover.type_slots.visible = false
				if hover_live != null:
					hover_live.type_slots.visible = true
					for cell in hover_live.type_slots.get_used_cells():
						hover_live.type_slots.set_cell(cell.x, cell.y, 0)
				_hover = hover_live
