extends PanelContainer

onready var scores_columns := $MarginContainer/VBoxContainer/ScoresColumn
var player_scores := {
	"Scrooge McDuck": 999999,
	"Magicka De Spell": 700,
	"Marie Marie Mariiiiie": 270211
}

func _ready() -> void:
	for name in player_scores:
		add_line(name, str(player_scores[name]))


func add_line(player_name: String, player_points: String) -> void:
	var line := preload("ScoreLine.tscn").instance()
	scores_columns.add_child(line)
	line.set_player_name(player_name)
	line.set_player_points(player_points)


func _on_HideButton_pressed() -> void:
	hide()
