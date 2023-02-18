extends Node


export(PackedScene) var mob_scene
var score = 0


func _ready():
	randomize()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()
	
	get_tree().call_group("mobs", "queue_free")	
	reset_score()
	
	
func reset_score():
	score = 0
	$HUD.update_score(score)
	

func new_game():
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	reset_score()
	$HUD.show_message("Get Ready")
	
	$Music.play()
	

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	
	# Choose random location on Path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	# Set mob's direction perpendicular to path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set mob position to random location
	mob.position = mob_spawn_location.position
	
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# choose velocity for mob
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# spwan mob
	add_child(mob)

