tool
extends TextureRect


export var source: PackedScene setget _set_source, _get_source

# 所有同名ship共用一个texture
const _ship_texture_map = {}

func _update():
		texture = get_ship_texture()
		rect_size = texture.region.size
		rect_pivot_offset = rect_size / 2

func _set_source(src: PackedScene)->void:
	source = src
	if Engine.editor_hint:
		_update()

func _get_source()->PackedScene:
	return source

# Called when the node enters the scene tree for the first time.
func _ready():
	_update()
	pass # Replace with function body.


func get_ship_texture() -> AtlasTexture:
	if source == null:
		return null
		
	var ship_scene_state = source.get_state()
	print(ship_scene_state.get_node_type(), ' >>>')
	
	var ship_name = source.resource_path.get_basename().split("/")[-1]
	var ship_texture_index

	if ship_name in _ship_texture_map:
		return _ship_texture_map.get(ship_name)

	for index in ship_scene_state.get_node_count():
		var name = ship_scene_state.get_node_name(index)
		if name == "texture":
			ship_texture_index = index

	if ship_texture_index != null:
		var texture = AtlasTexture.new()

		var result = {"texture": null, "region_rect": null}
		var found_count = result.keys().size()

		for prop_index in ship_scene_state.get_node_property_count(ship_texture_index):
			var prop_name = ship_scene_state.get_node_property_name(ship_texture_index, prop_index)
			var prop_value = ship_scene_state.get_node_property_value(
				ship_texture_index, prop_index
			)

			if prop_name in result:
				result[prop_name] = prop_value
				found_count -= 1

			if found_count <= 0:
				break

		texture.atlas = result.texture
		texture.region = result.region_rect

		_ship_texture_map[ship_name] = texture

		return texture

	return null


func _on_texture_item_rect_changed():
	rect_pivot_offset = rect_size / 2
	pass # Replace with function body.
