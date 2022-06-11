extends Control

onready var label := $HBoxContainer/Label


func set_text(new_text: String) -> void:
	label.text = new_text
