extends Area2D

var speed = 15

func _process(delta: float) -> void:
	
	position += Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized() * speed
