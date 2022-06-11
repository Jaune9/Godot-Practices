extends PracticeTests

const Inventory = preload("Inventory.gd")


func _init() -> void:
	add_requirement("VBoxContainer/VBoxContainer/UIInventory")
	add_requirement("VBoxContainer/VBoxContainer/Equipment")
	add_requirement("VBoxContainer/CharacterView")


func _prepare_async():
	yield(get_tree(), "idle_frame")
	code = _preprocess_code(Inventory)
	yield(get_tree().create_timer(0.5), "timeout")
