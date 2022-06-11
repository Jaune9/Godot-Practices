extends PracticeTests

const Rock := preload("Rock.gd")

onready var rock := scene_root.get_node("Rock") as Rock

func _init() -> void:
	add_requirement("Rock", [], ["_on_DragArea_requested_move"])


func _prepare_async() -> void:
	yield(get_tree(), "idle_frame")
	var script: Script = rock.get_script()
	code = _preprocess_code(script)
	yield(get_tree().create_timer(1.0), "timeout")


func test_impulse_is_properly_applied() -> String:
	if not matches_code_line(["*apply_central_impulse*"]):
		if matches_code_line(["*apply_impulse*"]):
			return tr("It seems you've used `apply_impulse`. Please use `apply_central_impulse` instead!")
		return tr("There doesn't seem to be an impulse applied on the rock. Did you use the proper method?")
	return ""
