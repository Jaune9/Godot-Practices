extends VBoxContainer

onready var line_edit := $HBoxContainer/LineEdit

func add_todo(text: String) -> void:
	# Create an instance of the TodoItem scene, add it as a child, and set its text.
	var todo_item = preload("TodoItem.tscn").instance()
	add_child(todo_item)
	todo_item.set_text(text)


func _on_Button_pressed() -> void:
	if line_edit.text:
		add_todo(line_edit.text)
	line_edit.text = ""
