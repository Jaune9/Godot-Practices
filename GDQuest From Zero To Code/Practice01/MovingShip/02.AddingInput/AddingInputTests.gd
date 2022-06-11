extends PracticeTests

var did_all_keys_change_direction := true


func _init() -> void:
	add_requirement(".", ["max_speed", "direction", "velocity"])


func _ready() -> void:
	required_input_actions = ["move_right", "move_left", "move_up", "move_down"]
	connect("completed_actions_changed", self, "call_deferred", ["_test_direction"])


var is_velocity_code_ok := false
var is_velocity_added_to_ship := false

func _prepare_async():
	._prepare_async()
	yield(get_tree(), "idle_frame")
	is_velocity_code_ok = is_pattern_in_code(["velocity=direction*max_speed", "velocity=max_speed*direction"])
	is_velocity_added_to_ship = matches_code_line(["position*=*velocity*delta", "position*=*delta*velocity"])


func _test_direction() -> void:
	if scene_root.velocity.is_equal_approx(Vector2.ZERO):
		did_all_keys_change_direction = false


func test_direction_uses_get_vector_function() -> String:
	if not matches_code_line(["direction=Input.get_vector(*)"]):
		return tr(
			"You need to use the Input.get_vector() function to get the ship's movement direction."
		)
	return ""


func test_get_vector_call_uses_correct_move_actions() -> String:
	if not matches_code_line(
		['direction=Input.get_vector("move_left","move_right","move_up","move_down")', "direction=Input.get_vector('move_left','move_right','move_up','move_down')"]
	):
		return tr("The Input.get_vector() function is not getting the correct input events.")
	return ""


func test_direction_vector_moves_ship() -> String:
	if not (is_velocity_code_ok and is_velocity_added_to_ship):
		return tr("One or more of the four direction keys did not move the ship.")
	return ""


func test_movement_uses_direction_and_max_speed() -> String:
	if not is_velocity_code_ok:
		return tr("The velocity should be equal to direction * max_speed. It seems that it is not the case.")
	return ""
