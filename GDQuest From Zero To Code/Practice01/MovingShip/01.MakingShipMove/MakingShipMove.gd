extends Sprite

var velocity := Vector2.RIGHT * 100 + Vector2.DOWN * 15

func _process(delta: float) -> void:
	position += delta * velocity
	rotation = velocity.angle()
