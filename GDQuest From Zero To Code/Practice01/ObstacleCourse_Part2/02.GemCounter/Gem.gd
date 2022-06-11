extends Area2D


onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(_body: Node) -> void:
	animation_player.play("destroy")
