extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.disabled = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Make a one-shot timer and wait for it to finish
	await get_tree().create_timer(2.0).timeout
	$AnimatedSprite2D.play()
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(3.0).timeout
	queue_free()
