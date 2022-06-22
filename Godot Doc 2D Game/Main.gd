extends Node

export(PackedScene) var mob_scene
var score := 0

func _ready() -> void:
	randomize()

func _on_Player_hit() -> void:
	game_over()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_ScoreTimer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout() -> void:
	
	# create the mob
	var mob = mob_scene.instance()
	
	# chose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.offset = randi()
	var direction = mob_spawn_location.rotation + PI / 2

	# give the random position to the mob
	mob.position = mob_spawn_location.position
	
	# randomness !
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# speed
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# add the instance to the tree
	add_child(mob)

