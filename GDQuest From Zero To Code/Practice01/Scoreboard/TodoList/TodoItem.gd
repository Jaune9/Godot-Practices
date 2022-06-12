extends Control

onready var label := $HBoxContainer/Label


func set_text(new_text: String) -> void:

#	if not is_inside_tree():
#		yield(self, "ready")
	label.text = new_text
