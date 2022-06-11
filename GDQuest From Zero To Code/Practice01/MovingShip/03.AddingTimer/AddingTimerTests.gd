extends PracticeTests

var start_position: Vector2
var did_all_keys_change_direction := true

var speed_after_boost := -1.0
var speed_after_timeout := -1.0
var timer: Timer


func _init() -> void:
	add_requirement(".", ["boost_speed", "normal_speed", "max_speed", "direction", "velocity"])


func _ready() -> void:
	required_input_actions = ["boost"]
	connect("completed_actions_changed", self, "call_deferred", ["_test_speed_after_boost"])


func _test_speed_after_boost() -> void:
	speed_after_boost = scene_root.get("max_speed")


func _prepare_async():
	if scene_root.get_child_count() > 0:
		timer = scene_root.get_child(0) as Timer
		if timer:
			timer.connect("timeout", self, "_on_Timer_timeout")

	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")


func test_ship_has_a_timer_node() -> String:
	if not timer:
		return tr("You should have a Timer node as a child of the ship's sprite.")
	return ""


func test_timer_timeout_signal_is_connected() -> String:
	if not timer:
		return tr("As you don't have a Timer node, we can't check for the timeout signal.")
	if timer.get_signal_connection_list("timeout").empty():
		return tr(
			"The Timer's timeout signal isn't connected. You need to connect it for the mechanic to work."
		)
	return ""


func test_boosting_increases_movement_speed() -> String:
	if not speed_after_boost > scene_root.normal_speed:
		return tr("Pressing the boost input did not increase the ship's speed as expected.")
	return ""


func test_speed_goes_back_to_normal_on_timeout() -> String:
	if not timer:
		return tr("As you don't have a Timer node, we can't test the ship's speed on timeout.")
	if not matches_code_line(["*.start()"]):
		return tr("It seems the timer never started. Did you call Timer.start()?")
	if speed_after_timeout > scene_root.get("normal_speed"):
		return (
			tr("After the timer timed out, the speed stayed at %s. It should instead be at %s.")
			% [speed_after_timeout, scene_root.get("normal_speed")]
		)
	return ""


func test_timer_is_one_shot() -> String:
	if not timer:
		return tr("As you don't have a Timer node, we can't check its one_shot property.")
	if not timer.one_shot:
		return tr("The Timer's one_shot property should be true so it doesn't cycle.")
	return ""


func _on_Timer_timeout() -> void:
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	speed_after_timeout = scene_root.get("max_speed")
