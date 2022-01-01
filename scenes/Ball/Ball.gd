extends KinematicBody2D

const GRAVITY_VECTOR = Vector2(0, 980)
const UP_DIRECTION = Vector2(0, -1)

var linear_velocity = Vector2()

func obj_reset():
	$circle.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	set_deferred("mode", RigidBody2D.MODE_STATIC)
	linear_velocity = Vector2()

func obj_set():
	$circle.show()
	$CollisionShape2D.set_deferred("disabled", false)
	set_deferred("mode", RigidBody2D.MODE_RIGID)
	

func _process(delta):
	linear_velocity += delta * GRAVITY_VECTOR
	linear_velocity = move_and_slide(linear_velocity, UP_DIRECTION)
