extends Sprite

var boost_speed := 1500.0
var normal_speed := 600.0

var max_speed := normal_speed

var direction := Vector2.ZERO
var drag_factor := 0.1

var desired_velocity := Vector2.ZERO
var steering_vector := Vector2.ZERO
var velocity := Vector2.ZERO


func _process(delta: float) -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	direction = direction.normalized()

	if Input.is_action_just_pressed("boost"):
		get_node("Timer").start()
		max_speed = boost_speed

	# Complete the following lines.
	#
	# Please don't add "var" at the start of these lines as doing so redefines
	# the script-wide variables we prepared for you and will prevent you from
	# completing the practice.
	desired_velocity
	steering_vector
	velocity

	position += velocity * delta
	if direction:
		rotation = velocity.angle()


func _on_Timer_timeout() -> void:
	max_speed = normal_speed
