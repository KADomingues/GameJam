extends Area2D
signal hit

@export var speed = 350 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window

# _ready is called when a node enters the scene tree
func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if Input.is_action_pressed("use_dash"):
		speed = 600
	elif Input.is_action_pressed("use_walk"):
		speed = 200
	else:
		speed = 350
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $AnimatedSprite2D.play() is the same as get_node("AnimatedSprite2D").play()
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		# Boolean assignment.
		# a comparison test (boolean) and also assigning a boolean value
		# Consider this code versus the one-line boolean assignment above:
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
