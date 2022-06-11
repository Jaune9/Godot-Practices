extends Sprite

var max_speed := 600.0

var direction := Vector2.ZERO
var velocity := Vector2.ZERO

func _process(delta: float) -> void:
	direction = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	)
	
	velocity = max_speed * direction
	
	position += velocity * delta
	if direction:
		rotation = velocity.angle()
