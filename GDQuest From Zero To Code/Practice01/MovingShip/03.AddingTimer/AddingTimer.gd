extends Sprite

var boost_speed := 1500.0
var normal_speed := 600.0

var max_speed := normal_speed

var direction := Vector2.ZERO
var velocity := Vector2.ZERO


func _process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		get_node("Timer").start()

	velocity = max_speed * direction
	position += velocity * delta
	if direction:
		rotation = velocity.angle()


func _on_Timer_timeout() -> void:
	max_speed = normal_speed
