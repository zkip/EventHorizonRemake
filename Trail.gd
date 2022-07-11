extends Line2D

export(NodePath) var targetPath
export(int) var frequency = 100
export(int) var segmentsMax = 0
var target

var last_fired_time = Time.get_ticks_msec()


func _ready():
	target = get_node(targetPath)
	pass


func _process(delta):
	global_position = Vector2.ZERO
	global_rotation = 0

	var now = Time.get_ticks_msec()
	if now - last_fired_time > frequency:
		add_point(target.global_position)

		last_fired_time = now

	while get_point_count() > segmentsMax:
		remove_point(0)
	pass
