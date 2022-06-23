extends Area2D

export var speed = 500
var velocity := Vector2.ZERO

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	
	velocity = Vector2.ZERO
	
	velocity += Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized() 
	
	if velocity == Vector2.ZERO:
		$AnimatedSprite.stop()
	
	if velocity.x:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
