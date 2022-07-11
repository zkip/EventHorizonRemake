extends Node
class_name Captain

var _manager
var _id: int setget _noop, get_captain_id

var con: IContainer


func _noop(v: int):
	pass


func _init(id: int):
	_manager = explorerShipManager
	_id = id


func get_captain_id():
	return _id


func get_licenses() -> Array:
	return explorerShipManager.get_owner_all_licenses(self)


# 转移执照的所有者
func transfer_license(license: String, other: Captain):
	_manager.set_license_owner(license, other)
	pass


# 销毁执照和对应的飞船
func drop_license():
	pass
