extends Area2D

var velocity = Vector2.ZERO

var speed = 4200
var _emmitter

export(Vector2) var direction = Vector2.ZERO
export(float) var initial_speed = 0.0

var expiredTime


func _ready():
	rotation = direction.angle() - Vector2.UP.angle()
	pass


func _move():
	velocity = direction * (initial_speed + speed)


func _process(delta):
	position += velocity * delta
	var rot = global_position.direction_to(get_global_mouse_position()).angle() - Vector2.UP.angle()
	global_rotation = lerp_angle(
		global_rotation, rot, rand_range(0.1, 5) * rand_range(0.1, 4) * delta
	)
	direction = Vector2.UP.rotated(rotation)
	_move()

	if Time.get_ticks_msec() > expiredTime:
		queue_free()


func init(init_position: Vector2, dir: Vector2, init_speed, emmitter):
	direction = dir
	initial_speed = init_speed
	position = init_position
	_emmitter = emmitter
	expiredTime = Time.get_ticks_msec() + 30000


func _on_Bullet_body_entered(body):
	if _emmitter == null:
		return
	if _emmitter.is_a_parent_of(body) || _emmitter == body:
		pass
	else:
		# if body is Ship:
		# 	body.on_hurt(self)
		queue_free()
