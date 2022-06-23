extends KinematicBody

export var min_speed := 10
export var max_speed := 18

var velocity := Vector3.ZERO

func _physics_process(delta):
	move_and_slide(velocity)


# called from the Main scene
func initialize(start_position: Vector3, player_position: Vector3):
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(rand_range(-PI / 4, PI / 4))

	var random_speed = rand_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_VisibilityNotifier_screen_exited():
	pass # Replace with function body.
