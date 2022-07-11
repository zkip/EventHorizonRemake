extends Area2D

var velocity = Vector2.ZERO

var speed = 2200
var range_i = 11300

var _emmitter

var spwan_position

export(Vector2) var direction = Vector2.ZERO
export(float) var initial_speed = 120.0


func _move():
	rotation = (direction.angle() - Vector2.UP.angle())  # 默认“上”是前方

	velocity = ((direction) * (initial_speed + speed))


func _process(delta):
	position += velocity * delta

	if global_position.distance_squared_to(spwan_position) > range_i * range_i:
		queue_free()
	else:
		_move()


func _ready():
	rotation = direction.angle() - Vector2.UP.angle()  # 默认“上”是前方
	pass


func init(init_position: Vector2, dir: Vector2, init_speed, emmitter):
	direction = dir
	initial_speed = init_speed
	position = init_position
	spwan_position = init_position
	_emmitter = emmitter


func _on_Bullet_body_entered(body):
	if _emmitter == null:
		return
	if _emmitter.is_a_parent_of(body) || _emmitter == body:
		pass
	else:
		body.on_hurt(self)
		queue_free()
