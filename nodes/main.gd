extends Node
@export var mob_scene : PackedScene

var score

func _ready():
	#new_game()
	pass 

func game_over():
	$scoreTimer.stop()
	$mobTimer.stop()
	$HUD.show_game_over()
	$music.stop()
	$deathSound.play()
	
func new_game():
	score = 0
	$Player.start($startPosition.position)
	$startTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$music.play()
	get_tree().call_group("mobs", "queue_free")


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$mobTimer.start()
	$scoreTimer.start()

func _on_mob_timer_timeout():
	# Create a new instanceo of the mob scene
	var mob = mob_scene.instantiate()
	
	# Choose a random location on path2D
	var mob_spawn_location = $mobPath/mobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction
	# In functions requiring angles, Godot uses radians, not degrees.
	# deg_to_rad() and rad_to_deg() to convert between the two
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob
	add_child(mob)
