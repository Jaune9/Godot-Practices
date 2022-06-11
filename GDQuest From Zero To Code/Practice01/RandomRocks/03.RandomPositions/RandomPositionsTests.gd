extends PracticeTests

const MAX_POSITION := Vector2.ONE * 500.0


func _init() -> void:
	add_requirement(".", [], ["calculate_random_position", "generate_gems_at_random_positions"])


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")


func test_function_outputs_random_positions_within_max_offset() -> String:
	scene_root.generate_gems_at_random_positions(100, MAX_POSITION)
	var rect := Rect2(Vector2.ZERO, MAX_POSITION)
	var gems_bbox := Rect2(Vector2.INF, Vector2.ZERO)
	for child in scene_root.get_children():
		if not rect.has_point(child.position):
			return (
				tr(
					"We expected all generated gems to be at random positions within %s but we found one sprite at position %s. Did you use max_offset in calculate_random_position()?"
				)
				% [rect, MAX_POSITION]
			)
		gems_bbox.position.x = min(child.position.x, gems_bbox.position.x)
		gems_bbox.position.y = min(child.position.y, gems_bbox.position.y)
		gems_bbox.size.x = max(child.position.x, gems_bbox.position.x)
		gems_bbox.size.y = max(child.position.y, gems_bbox.position.y)

	if gems_bbox.size.is_equal_approx(Vector2.ZERO):
		return tr(
			"All the gems were generated at the same position. Did you generate random positions in the calculate_random_position() function?"
		)
	if gems_bbox.size.length() < 1.0:
		return tr(
			"All the gems were placed within a 1 by 1 pixel rectangle. Did you take max_offset into account in calculate_random_position()?"
		)
	return ""
