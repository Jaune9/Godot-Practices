extends PanelContainer

onready var scores_columns := $MarginContainer/VBoxContainer/ScoresColumn


func _ready() -> void:
	pass

func add_line(player_name: String, player_points: String) -> void:
	var line := preload("ScoreLine.tscn").instance()
	scores_columns.add_child(line)
	line.set_player_name(player_name)
	line.set_player_points(player_points)


func _on_HideButton_pressed() -> void:
	hide()
