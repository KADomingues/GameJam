extends RigidBody2D
@export var rotationSpeed = 0.25

var velocity = Vector2(200, 200)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.rotation += rotationSpeed
	pass

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		velocity.x *= (1.1)
		velocity.y *= (1.1)
		#print("I Collided with ", collision_info.get_collider().name)
	if velocity.x >= 400 || velocity.y >= 400:
		set_collision_mask_value(4, false)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
