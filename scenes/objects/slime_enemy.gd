extends CharacterBody2D
@export var mov_speed := 50.0

@export var movement_target: Node2D
@export var nav_agent: NavigationAgent2D

func _ready():
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	
	call_deferred('actor_setup')
	
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
	var current_agent_pos: Vector2 = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	# Using vector to math here to get a vector pointing towards the next
	# position provided by the navigation system
	var direction := (next_path_position - current_agent_pos)
	velocity += direction
	
	nav_agent.set_velocity(velocity)


func _on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
