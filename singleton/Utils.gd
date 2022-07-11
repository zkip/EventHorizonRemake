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
