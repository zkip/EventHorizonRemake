extends Node
class_name SlotProtocol

var type_name_dict = {}  # { position : tile_name }
var kind_name_dict = {}  # { position : tile_name }

onready var type_slots: TileMap = $type_slots
onready var kind_slots: TileMap = get_node_or_null("kind_slots")


func get_cell_types(cell: Vector2):
	var key = "%s,%s" % [cell.x, cell.y]
	if key in type_name_dict:
		return type_name_dict[key]
	return null


func get_cell_kinds(cell: Vector2):
	var key = "%s,%s" % [cell.x, cell.y]
	if key in kind_name_dict:
		return kind_name_dict[key]
	return null


func can_accept(sloter: SlotProtocol, cell: Vector2):
	var self_cell = (
		((sloter.type_slots.global_position - type_slots.global_position) / 64).floor()
		+ cell
	)

	var types = get_cell_types(self_cell)
	var kinds = get_cell_kinds(self_cell)

	var sloter_types = sloter.get_cell_types(cell)
	var sloter_kinds = sloter.get_cell_kinds(cell)

	if not sloter_types or not types:
		return false

	for type in types.split("&"):
		for sloter_type in sloter_types.split("&"):
			var is_weapon = type == "weapon" && sloter_type == "weapon"
			var is_kind_matched = true

			if is_weapon:
				is_kind_matched = false

				if kinds and sloter_kinds:
					if kinds == "universal" || sloter_kinds == "universal":
						is_kind_matched = true
					else:
						for kind in kinds:
							if sloter_kinds.find(kind) >= 0:
								is_kind_matched = true
								break

			if (
				is_kind_matched
				&& (type == "universal" || sloter_type == "universal" || type == sloter_type)
			):
				return true

	return false


func _ready():
	var slot_cells = type_slots.get_used_cells()
	for n in slot_cells.size():
		var cell = slot_cells[n]

		var key = "%s,%s" % [cell.x, cell.y]
		var type_id = type_slots.get_cellv(cell)
		type_name_dict[key] = type_slots.tile_set.tile_get_name(type_id)

		if kind_slots != null:
			var kind_id = kind_slots.get_cellv(cell)

			if kind_id >= 0:
				kind_name_dict[key] = kind_slots.tile_set.tile_get_name(kind_id)
