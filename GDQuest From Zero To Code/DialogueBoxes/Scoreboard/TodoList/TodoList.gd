extends VBoxContainer

const TodoItem := preload("res://Scoreboard/TodoList/TodoItem.tscn")

onready var line_edit := $HBoxContainer/LineEdit


func add_todo(text: String) -> void:
	# Create an instance of the TodoItem scene, add it as a child, and set its text.
	var todo_item := TodoItem.instance()
	add_child(todo_item)
	# Call the todo_item's set_text() function to change the displayed text.
	todo_item.set_text(text)


func _on_Button_pressed() -> void:
	if line_edit.text:
		# Add a todo item with the correct text.
		add_todo(line_edit.text)
	line_edit.text = ""
