extends CharacterBody2D

var speed := 120
var direction = Vector2.ZERO
var can_deploy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(aim, muzzle) -> void:
	direction = Vector2.RIGHT.rotated(aim.rotation)
	position = muzzle.global_position
	can_deploy = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if can_deploy:
		velocity = direction * speed
		var collision = move_and_collide(velocity * delta)
		if collision:
			if collision.get_collider().has_method("on_hit"):
				collision.get_collider().on_hit()
			else:
				queue_free()
	
func _on_lifetime_timeout():
	self.queue_free()
