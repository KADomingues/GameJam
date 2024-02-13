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
	$audios/BGM.stop()
	$audios/deathSound.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func new_game():
	score = 0
	$Player.start($startPosition.position)
	$startTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$audios/start.play()
	$audios/BGM.play()
	get_tree().call_group("mobs", "queue_free")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$mobTimer.start()
	$scoreTimer.start()

func spawnMine():
	
	# Create a new instanceo of the mob scene
	var mine = mine_scene.instantiate()
	
	# Set the location to player location
	var mine_spawn_location = $Player.get_position()
	
	# Plus some randomness in both axis
	mine_spawn_location.x += randf_range(-50, 50)
	mine_spawn_location.y += randf_range(-50, 50)
	mine.position = mine_spawn_location
	
	# 'if (randi() % 4) == (4 - 1)' means 1/4 chance
	#if (randi() % probability) == (probability - 1):
	add_child(mine)
		
func spawnMob():
	# Create a new instanceo of the mob scene
	var mob = mob_scene.instantiate()
	
	# Choose a random location on path2D
	var mob_spawn_location = $mobPath/mobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Add some randomness to the direction
	# In functions requiring angles, Godot uses radians, not degrees.
	# deg_to_rad() and rad_to_deg() to convert between the two
	direction += randf_range(-PI / 4, PI / 4)
	
	mob.position = mob_spawn_location.position
	mob.rotation = direction
	
	# Choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 300.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#if (randi() % probability) == (probability - 1):
	add_child(mob)
		
func spawn_bounce_ball():
	# Create a new instanceo of the ball scene
	var bounce_ball = bounce_scene.instantiate()
	
	# Choose a random location on path2D
	var bounce_ball_spawn_location = $mobPath/mobSpawnLocation
	bounce_ball_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction
	var bounce_ball_direction = bounce_ball_spawn_location.rotation + PI / 2
	bounce_ball.position = bounce_ball_spawn_location.position
	
	var bounce_ball_velocity = Vector2(randf_range(150.0, 250.0), randf_range(150.0, 250.0))
	bounce_ball.linear_velocity = bounce_ball_velocity
	
	#if (randi() % probability) == (probability - 1):
	add_child(bounce_ball)

func _on_mob_timer_timeout():
	
	if (randi() % 4) == (4 - 1):
		spawnMine()
	
	if score >= 9:
		if (randi() % 3) == (3 - 1):
			spawnMob()
		
	if score >= 25:
		if (randi() % 7) == (7 - 1):
			spawn_bounce_ball()	
