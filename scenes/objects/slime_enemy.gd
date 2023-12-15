extends CharacterBody2D
@export var mov_speed := 50.0
@onready var texture = $Texture

@export var movement_target: Node2D
@export var nav_agent: NavigationAgent2D

var have_we_collided := false
var current_agent_pos: Vector2
var direction: Vector2

func _ready():
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	
	call_deferred('actor_setup')
	
	texture.play("default")
	
func actor_setup():
	await get_tree().physics_frame
	set_move_target(movement_target.position)
	
func set_move_target(target: Vector2):
	nav_agent.target_position = target
	
func _physics_process(delta):
	# When the navigation has no more positions to give us we just stop
	# doing anything in the phys_process func
	if nav_agent.is_navigation_finished():
		return
	# Extra help for resolving enemies being stuck in blocks
	if have_we_collided and current_agent_pos == global_position:
		# Based on which direction the enemies are roughly going
		if direction.x > 0:
			global_position -= Vector2(16,0)
		else:
			global_position += Vector2(16,0)
	
	current_agent_pos = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	set_move_target(movement_target.position)
	# Using vector to math here to get a vector pointing towards the next
	# position provided by the navigation system
	direction = (next_path_position - current_agent_pos)
	velocity += direction
	nav_agent.set_velocity(velocity)
	
	# Animation
	if direction.x < 0:
		texture.flip_h = true
	else:
		texture.flip_h = false

func _on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	have_we_collided = move_and_slide()
	var collision = move_and_collide(velocity.normalized(),true)
	if collision:
		if collision.get_collider().has_method("on_hit"):
			collision.get_collider().on_hit()

func on_hit() -> void:
	Audio.play_sound("bullet_hit_wall")
	Vfx.play_vfx(self.global_position, "blood_splurt")
	queue_free()

func _on_button_pressed(id):
	if id == 1:
		on_hit()
