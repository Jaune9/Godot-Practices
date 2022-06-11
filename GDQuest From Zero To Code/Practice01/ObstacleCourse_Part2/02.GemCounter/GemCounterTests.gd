extends PracticeTests

var counter := 0
var ui_counter_text := ""

var gem: Area2D = preload("Gem.tscn").instance()
var expected_collision_mask := 4

onready var godot := scene_root.get_node("Godot") as KinematicBody2D
onready var godot_area: Area2D = scene_root.get_node("Godot/Area2D")

func _init() -> void:
	add_requirement("Gems/Gem", [], ["_on_body_entered"])
	add_requirement("Godot")


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")


func test_godot_area_is_connected() -> String:
	var godot_area_is_connected = godot_area.is_connected("area_entered", scene_root, "_on_GodotArea2D_area_entered")
	if not godot_area_is_connected:
		return tr("godot's area is not connected to the root scene's _on_GodotArea2D_area_entered. Did you set up the signal correctly in _ready()?")
	return ""


func test_godot_area_layers_are_correct() -> String:
	if godot.collision_mask == 0:
		return tr("Godot has no collision mask set at all. Make sure to set the appropriate mask!")
	var expected_collision_layer := 1
	
	if not godot.collision_layer & expected_collision_layer:
		return tr("You changed Godot's collision layer. Make sure it's %s")%[expected_collision_layer]
	
	if not godot_area.collision_mask & expected_collision_mask:
		return tr("You changed Godot's Area's collision masks. Make sure it's %s")%[expected_collision_mask]
	
	return ""


func test_godot_can_pick_gems() -> String:
	var is_working_gem_collision = gem.collision_layer & godot.collision_mask == expected_collision_mask
	if not is_working_gem_collision:
		return tr("The gems' collision layer does not match any of the player's physics layers. Did you set the Gem node's collision layer to match the player's physics layer and mask?")
	return ""

func test_godot_can_count_gems() -> String:
	var is_working_gem_collision = gem.collision_layer & godot_area.collision_mask == expected_collision_mask
	if not is_working_gem_collision:
		return tr("The gems' collision layer does not match any of the player's physics layers. Did you set the Gem node's collision layer to match the player's physics layer and mask?")
	return ""


func test_godot_does_not_have_additional_layer() -> String:
	var is_correct_gem_collision = gem.collision_layer == expected_collision_mask
	if not is_correct_gem_collision:
			return tr("You selected more layers than necessary. Please select only the appropriate collision layers")
	return ""


func test_picking_increases_the_counter() -> String:
	save_counter()
	var expected_counter = scene_root.counter + 1
	scene_root._on_GodotArea2D_area_entered(null)

	var msg := ""
	if not expected_counter == scene_root.counter:
		msg = tr("The counter isn't increasing properly. Did you forget to increment the counter before setting the label text?")

	reset_counter()
	return msg


func test_ui_counter_text_updates() -> String:
	save_counter()
	scene_root._on_GodotArea2D_area_entered(null)
	var expected_text = "Gems: " + str(scene_root.counter)

	var msg := ""
	if not (expected_text == scene_root.ui_counter.text and scene_root.counter > 0):
		msg = tr("The UI counter label doesn't show the correct text. Did you forget to set the label's text value?")

	reset_counter()
	return msg


func save_counter() -> void:
	counter = scene_root.counter
	ui_counter_text = scene_root.ui_counter.text



func reset_counter() -> void:
	scene_root.counter = counter
	scene_root.ui_counter.text = ui_counter_text
