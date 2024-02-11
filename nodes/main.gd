extends Node
@export var mob_scene : PackedScene
@export var mine_scene : PackedScene
@export var bounce_scene: PackedScene

var score

func _ready():
	#new_game()
	randomize()
	pass 

func game_over():
	$scoreTimer.stop()
	$mobTimer.stop()
	$HUD.show_game_over()
	$music.stop()
	$deathSound.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func new_game():
	score = 0
	$Player.start($startPosition.position)
	$startTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$music.play()
	get_tree().call_group("mobs", "queue_free")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$mobTimer.start()
	$scoreTimer.start()

func spawnMob():
	pass

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
	if score >= 10:
		if (randi() % 4) == (4 - 1):
			add_child(mob)
	
	#################
	# Mines
	#################
	var mine = mine_scene.instantiate()
	var mine_spawn_location = $Player.get_position()
	mine_spawn_location.x += randf_range(-40, 40)
	mine_spawn_location.y += randf_range(-40, 40)
	mine.position = mine_spawn_location
	if score <= 20:
		#var probability : int = 10
		# if (randi() % 4) == (4 - 1) == 1/4 chance
		if (randi() % 4) == (4 - 1):
			add_child(mine)
			
	#################
	# Bounce
	#################
	
	var bounce_ball = bounce_scene.instantiate()
	
	var bounce_ball_spawn_location = $mobPath/mobSpawnLocation
	bounce_ball_spawn_location.progress_ratio = randf()
	
	var bounce_ball_direction = bounce_ball_spawn_location.rotation + PI / 2
	bounce_ball.position = bounce_ball_spawn_location.position
	
	var bounce_ball_velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	bounce_ball.linear_velocity = velocity.rotated(bounce_ball_direction)
	
	if score >= 1:
		if (randi() % 4) == (4 - 1):
			add_child(bounce_ball)
