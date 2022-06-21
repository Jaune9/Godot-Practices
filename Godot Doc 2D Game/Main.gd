extends Node

export(PackedScene) var mob_scene
var score := 0

func _ready() -> void:
	randomize()


func _on_Player_hit() -> void:
	pass # Replace with function body.


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_ScoreTimer_timeout() -> void:
	score += 1

func _on_StartTimer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout() -> void:
	
	# create the mob
	var mob = mob_scene.instance()
	
	# chose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.offset = randi()
	
	# give the mob a direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	# randomness !
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
