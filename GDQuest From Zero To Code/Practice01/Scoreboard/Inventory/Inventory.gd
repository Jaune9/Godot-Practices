extends GridContainer


func _ready() -> void:
	for i in 25:
		add_inventory_item()


func add_inventory_item() -> void:
	var item = preload("InventoryItem.tscn").instance()
	add_child(item)
