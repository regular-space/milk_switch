extends CharacterBody2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite_2d = $Sprite2D

var speed := 150
var direction = Vector2.ZERO
var can_deploy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(aim, muzzle) -> void:
	direction = Vector2.RIGHT.rotated(aim.rotation)
	global_position = muzzle.global_position
	can_deploy = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if can_deploy and not Global.disable_actor:
		velocity = direction * speed
		var collision = move_and_collide(velocity * delta)
		if collision:
			if collision.get_collider().has_method("on_hit"):
				collision.get_collider().on_hit()
				disable_self()
			
			# Assuming bullet hits a wall
			else:
				disable_self()
	
func _on_lifetime_timeout():
	if not Global.disable_actor:
		self.queue_free()

func on_hit() -> void:
	disable_self()

# Doesn't queue free immediately to make sure sound plays first, if a sound plays
func disable_self() -> void:
	Audio.play_sound("bullet_hit_wall")
	Global.shake_screen(1, 0.1)
	collision_shape_2d.set_deferred("disabled", true)
	sprite_2d.hide()
	can_deploy = false

func _on_bullet_hit_wall_finished():
	queue_free()
