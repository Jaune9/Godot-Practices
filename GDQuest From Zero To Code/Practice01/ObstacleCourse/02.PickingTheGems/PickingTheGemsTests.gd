extends PracticeTests

var gem_mask := -1
var player_layer := -1

var gem_is_connected := false
var gem_gets_freed := false


func _init() -> void:
	add_requirement("Gems/Gem", [], ["_on_body_entered"])
	add_requirement("Godot")


func _prepare_async():
	._prepare_async()

	var gem: Area2D = preload("Gem.tscn").instance()
	gem.hide()
	add_child(gem)

	gem_mask = gem.collision_mask
	player_layer = scene_root.get_node("Godot").collision_layer

	gem_is_connected = gem.is_connected("body_entered", gem, "_on_body_entered")
	gem._on_body_entered(null)
	gem_gets_freed = gem.is_queued_for_deletion()

	yield(get_tree().create_timer(0.5), "timeout")


func test_godot_can_pick_gems() -> String:
	if gem_mask & player_layer == 0:
		return tr("The gems' collision mask does not match any of the player's physics layers. Did you set the Gem node's collision mask to match the player's physics layer?")
	return ""


func test_picking_gems_frees_them() -> String:
	if not gem_is_connected:
		return tr("The gem's body_entered is not connected to _on_body_entered(). Did you connect the signal in the _ready() function?")

	if not gem_gets_freed:
		return tr("When the player touches a gem, the gem doesn't get deleted. Did you call queue_free() in the callback function?")

	return ""
