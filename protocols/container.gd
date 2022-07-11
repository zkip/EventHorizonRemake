extends Node

class_name IContainer
# 容器管理类，它管理所有的包含内容
# 它允以多个维度进行存储，通过cluster api来访问，默认存储在default cluster
var _items_map: Array = []  # Item[]

export var clusters: PoolStringArray = []


func put_in(v, cluster_name = "default"):
	_access_cluster(cluster_name).append(v)
	pass


func has(name: String, cluster_name = "default") -> bool:
	return get(name, cluster_name) != null


func get(name: String, cluster_name = "default"):
	for item in _access_cluster(cluster_name):
		if name == item.name:
			return true

	return false


func _access_cluster(cluster_name):
	if not _items_map.has(cluster_name):
		return []

	return _items_map[cluster_name]


func _ready():
	for cluster_name in clusters:
		_items_map[cluster_name] = []

	pass
