extends RigidBody2D
class_name Ship

export(Array, Script) var drivers = [null]
export(float) var scattering = 0.0

onready var currentDriver
onready var shell = $shell
onready var tag_set = utils.Set.new($protocols/item.tags)

var Bullet = preload("res://Ammunitions/Missile.tscn")

var license: String

var last_fired_time = Time.get_ticks_msec()
var host = owner

var frequency = 20
var ready_for_fire = false

var components = []

var velocity = Vector2.ZERO
var thrust_velocity = Vector2.ZERO
var rotate_velocity = Vector2.ZERO
var thrust_energe = Vector2.ZERO

var thrust = Vector2(0, 50)

const THRUST_ACCELERATION = 1100.0 / 12
const THRUST_FRICTION = 0.0 / 12
const THRUST_POWER = 3300.0

const THRUST_BOOTING_ACCELERATION = 4.0 / 1
const THRUST_SLEEPING_FRICTION = 1.0 / 2
const THRUST_INERTANCE = 1.0 / 2

const BRAKE_POWER = 1.0 / 4

const ROTATE_ACCELERATION = PI * 1.2 / 1.0
const ROTATE_FRICTION = PI * 1.2 / 10.0
const ROTATE_POWER = PI * 3 / 1.0

const IMPLUS_POWER = 2.0 * 1 / 1.0

var trail
var currentTrail


func init(license_: String):
	license = license_
	return self


func _ready():
	tag_set.add("ship")

	var driverPoolNode = Node.new()
	driverPoolNode.name = "drivers"
	self.add_child(driverPoolNode)

	for n in drivers.size():
		var driverScript = drivers[n]
		var driverNode = Node.new()
		driverPoolNode.add_child(driverNode)

		if driverScript:
			driverNode.set_script(driverScript)
			# 默认选第一个
			if currentDriver == null:
				currentDriver = driverNode

	# 惯性抵抗协议, 使玩家更容易操控; 自动扭矩阻尼
	angular_damp = ROTATE_POWER + PI / 10

	trail = $Trail
	remove_child(trail)


func _integrate_forces(_state):
	if currentDriver:
		_move_controll()
		_fire_controll()

	# 惯性抵抗协议, 使玩家更容易操控; 急停急走
	if thrust_velocity != Vector2.ZERO:
		var target_velocity = thrust_velocity
		var acc_velocity = target_velocity - linear_velocity
		set_applied_force(acc_velocity * 2 * mass)
	else:
		set_applied_force(thrust_velocity)

	# 惯性抵抗协议, 使玩家更容易操控; 急转急停
	if rotate_velocity.x != 0:
		var target_acc = rotate_velocity.x
		var acc_torque = target_acc - angular_velocity
		set_applied_torque(acc_torque * 2 * inertia)
	else:
		set_applied_torque(0)

	if thrust_velocity != Vector2.ZERO:
		if currentTrail != null:
			currentTrail = trail.duplicate(DUPLICATE_USE_INSTANCING)
			currentTrail.target = trail.target
			add_child(currentTrail)
	else:
		if currentTrail:
			remove_child(currentTrail)
			currentTrail = null


func _move_controll():
	var rotational_direction = currentDriver.getRotationalWill()
	var thrust_direction = currentDriver.getThrustWill()
	var brake_strength = currentDriver.getBrakeWill()

	if rotational_direction.x != 0:
		var thrust_vector = Vector2(rotational_direction.x, 0)
		rotate_velocity = thrust_vector * ROTATE_POWER
	else:
		rotate_velocity = Vector2.ZERO

	var forward_direction = Vector2(0, thrust_direction.x).rotated(rotation)

	if thrust_direction.x != 0:
		thrust_velocity = (forward_direction * THRUST_POWER)

	else:
		thrust_velocity = Vector2.ZERO

	if brake_strength.x != 0:
		thrust_velocity = thrust_velocity.move_toward(Vector2.ZERO, BRAKE_POWER * brake_strength.x)


func fire():
	var now = Time.get_ticks_msec()
	if now - last_fired_time > frequency:
		var bullet = Bullet.instance()
		bullet.init(
			$shots/main.global_position,
			Vector2.UP.rotated(
				global_rotation + deg2rad(rand_range(-scattering / 2, scattering / 2))
			),
			linear_velocity.length(),
			self
		)
		get_tree().get_root().add_child(bullet)

		ready_for_fire = true
		last_fired_time = now
		# $AnimationPlayer.play("fire")

	else:
		if ready_for_fire:
			ready_for_fire = false
			# $AnimationPlayer.play("refill")


func _fire_controll():
	var fire_direction = currentDriver.getFireWill()
	if fire_direction.x > 0:
		fire()


func on_hurt(body, fx):
	var shape_owners = body.get_shape_owners()
	var body_transform = body.get_transform()
	var self_transform = self.get_transform()

	if fx:
		var self_shape = ConvexPolygonShape2D.new()
		self_shape.set_point_cloud(shell.get("polygon"))
		for owner_id in shape_owners:
			var shape = body.shape_owner_get_owner(owner_id).shape
			var collision_points = self_shape.collide_and_get_contacts(
				self_transform, shape, body_transform
			)
			for points in collision_points:
				var hurt_fx = fx.instance()
				get_tree().get_root().add_child(hurt_fx)
				hurt_fx.global_position = points
				break

	pass
