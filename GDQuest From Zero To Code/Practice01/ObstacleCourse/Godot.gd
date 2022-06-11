extends KinematicBody2D


const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.DOWN + Vector2.RIGHT: 1,
	Vector2.RIGHT: 2,
	Vector2.UP + Vector2.RIGHT: 3,
	Vector2.UP: 4,
}

const SPEED := 700.0

# ANCHOR: diff_vars
var drag_factor := 0.13
var velocity := Vector2.ZERO
# END: diff_vars

onready var sprite := $Sprite


# ANCHOR: physics_process_declaration
func _physics_process(delta: float) -> void:
# END: physics_process_declaration
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

# ANCHOR: diff_velocity
	var desired_velocity := SPEED * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	velocity = move_and_slide(velocity)
# END: diff_velocity

	var direction_key := direction.round()
	direction_key.x = abs(direction_key.x)
	if direction_key in DIRECTION_TO_FRAME:
		sprite.frame = DIRECTION_TO_FRAME[direction_key]
		sprite.flip_h = sign(direction.x) == -1
