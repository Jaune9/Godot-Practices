extends GridContainer

const InventoryItem := preload("InventoryItem.tscn")

func _ready() -> void:
	for i in 25:
		add_inventory_item()


func add_inventory_item() -> void:	
	# Create an instance of InventoryItem.tscn.
	# Add it as a child of this node by calling the add_child() function.
	var invItem := InventoryItem.instance()
	add_child(invItem)
