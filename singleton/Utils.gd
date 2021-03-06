extends Node
class_name Utils


class Set:
	var _map = {}

	func add(key: String):
		_map[key] = true

	func remove(key: String):
		_map.erase(key)

	func clear():
		_map.clear()

	func values():
		return _map.keys()

	func keys():
		return _map.keys()

	func has(key: String):
		return _map.has(key)

	func _init(keys: Array = []):
		for key in keys:
			add(key)


# 所有同名ship共用一个texture
const _ship_texture_map = {}


func get_ship_texture(ship_name: String) -> AtlasTexture:
	var ship_scene = get_ship_scene(ship_name)
	var ship_scene_state = ship_scene.get_state()
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


func get_ship_scene(ship_name: String) -> PackedScene:
	return load("res://ships/%s.tscn" % [ship_name]) as PackedScene
