extends Node
class_name ShipManager

var _ships_data = {}

var _license_owner_map = {}

var _captain_licneses_map = {}


func get_ship_data(license: String):
	return _ships_data.get(license)


func set_ship_data(license: String, data: Dictionary):
	_ships_data[license] = data
	data["license"] = license
	pass


func save_ship_data(license: String, data: Object):
	print("Saving... ", data)
	pass


func get_owner_all_licenses(owner: Captain):
	return _captain_licneses_map.get(owner.get_captain_id())


func set_license_owner(license: String, owner: Captain):
	_license_owner_map[license] = owner.get_captain_id()
	var licenses = _captain_licneses_map.get(owner.get_captain_id())
	if licenses != null:
		licenses.append(license)
	pass


func get_license_owner(license: String):
	return _license_owner_map.get(license)


# 销毁执照和对应的飞船
func drop_ship(license: String):
	var ship = _ships_data.get(license)
	if ship != null:
		_license_owner_map.erase(license)
		_ships_data.erase(license)


func get_ship_scene(license: String):
	var data = get_ship_data(license)
	if data != null:
		if "ship_name" in data:
			var ship_name = data.get("ship_name")
			var ship = load("res://ships/%s.tscn" % [ship_name]) as PackedScene
			return ship


# 所有同名ship共用一个texture
const _ship_texture_map = {}


func get_ship_texture(ship_name: String) -> AtlasTexture:
	var ship_scene = load("res://ships/%s.tscn" % [ship_name]) as PackedScene
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


func regist_captain() -> Captain:
	var captain = Captain.new(0x47)
	_captain_licneses_map[captain.get_captain_id()] = []
	return captain


func test_regist() -> Captain:
	var captain = regist_captain()

	set_ship_data("101", {"ship_name": "interceptor"})
	set_ship_data("104", {"ship_name": "interceptor_mk2"})
	set_ship_data("106", {"ship_name": "scout"})
	set_ship_data("151", {"ship_name": "scout_mk2"})
	set_ship_data("155", {"ship_name": "spectrum"})
	set_ship_data("156", {"ship_name": "spectrum_mk2"})
	set_ship_data("159", {"ship_name": "scout_mk2"})

	set_license_owner("101", captain)
	set_license_owner("104", captain)
	set_license_owner("106", captain)
	set_license_owner("151", captain)
	set_license_owner("155", captain)
	set_license_owner("156", captain)
	set_license_owner("159", captain)

	return captain
