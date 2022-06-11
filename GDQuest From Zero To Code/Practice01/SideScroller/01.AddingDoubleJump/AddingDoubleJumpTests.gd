extends PracticeTests

var did_double_jump := false
var jump_heights := []


onready var character := scene_root.get_node("SideScrollDoubleJump") as KinematicBody2D


func _init() -> void:
	add_requirement("SideScrollDoubleJump", ["speed", "gravity", "jump_strengths"])


func _ready() -> void:
	required_input_actions = ["jump", "jump"]
	simulated_input_time_interval = 0.3
	connect("completed_actions_changed", self, "call_deferred", ["_record_height"])


func _simulate_input_action() -> void:
	._simulate_input_action()
	if not _current_simulated_input:
		return

	if Input.is_action_just_pressed(_current_simulated_input):
		jump_heights.append(character.position.y)


func _on_completed_actions_changed() -> void:
	if not required_input_actions:
		emit_signal("student_actions_completed")
		set_process_input(false)


func _prepare_async() -> void:
	yield(get_tree(), "idle_frame")
	var script: Script = character.get_script()
	code = _preprocess_code(script)
	yield(get_tree().create_timer(1.0), "timeout")


func test_limit_the_number_of_jumps() -> String:
	if not matches_code_line(["*if*jump_number<jump_strengths.size()*"]):
		return tr(
			"You need to limit the amounts of jumps the character can do. Are you checking if jump_number is lower than jump_strength's size?"
		)
	return ""

func test_increment_jump_number() -> String:
	var patterns := [
		"jump_number+=*",
		"jump_number=jump_number+*",
		"jump_number=*+jump_number",
	]
	if not matches_code_line(patterns):
		return tr(
			"It seems you're not increasing the jump number. Did you increment it when jumping?"
		)
	return ""

func test_reset_the_number_of_jumps_when_on_the_floor() -> String:
	if not (matches_code_line(["*if*is_on_floor():"]) and matches_code_line(["*jump_number=0*"])):
		return tr(
			"You need to reset the jump_number when the character is on the ground."
		)
	return ""

# func test_character_performed_double_jump() -> String:
# 	if jump_heights.size() < 2:
# 		return tr("The character didn't perform a double jump. Did you increase jump_number?")
# 	return ""
