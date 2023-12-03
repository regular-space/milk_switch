extends AnimatableBody2D

const left := Vector2(-1,0)
const right := Vector2(1,0)
const up := Vector2(0,-1)
const down := Vector2(0,1)
const block_speed := 32

# This value is an export so it can be different per object when you create a 
# map with multiple blocks
@export var milk_switched := false

var inital_pos : Vector2
var move_dir : Vector2
var is_moving := false
var allow_move := false
var snap_pos := true

func push(direction: Vector2):
	inital_pos = Vector2(int(position.x),int(position.y))
	# Checking which is the greater value for direction and using that. Because
	# we don't want to push in diagonals at all
	var x_greater_than_y = abs(direction.x) > abs(direction.y)
	var y_greater_than_x = abs(direction.y) > abs(direction.x)
	# Don't want to allow changing of direction mid push. Done this to replicate
	# the old Zelda feel of moving blocks
	if not is_moving and allow_move:
		if x_greater_than_y:
			# Move right
			if direction.x > 0:
				move_dir = right
				$PushTimer.start()
				is_moving = true
			# Move left
			elif direction.x < 0:
				move_dir = left
				$PushTimer.start()
				is_moving = true
		elif y_greater_than_x:
			# Move down
			if direction.y > 0:
				move_dir = down
				$PushTimer.start()
				is_moving = true
			# Move up
			elif direction.y < 0:
				move_dir = up
				$PushTimer.start()
				is_moving = true
		# This happens when going in diagonals cuz x & y's magnitude equal each
		# other, so both the variables at the start will be false
		else:
			stop()
	elif $ConfirmPushTimer.is_stopped():
		$ConfirmPushTimer.start()
	
func stop() -> void:
	move_dir = Vector2.ZERO
	is_moving = false
	allow_move = false
	# This code here just snaps the position to a integer value because 
	# sometimes when it is a decimal the screen position is off by a pixel
	print(position)

func is_block_blocked_by_block(direction: Vector2) -> bool:
	match direction:
		up:
			return $BlockCheckUp.is_colliding()
		right:
			return $BlockCheckRight.is_colliding()
		down:
			return $BlockCheckDown.is_colliding()
		left:
			return $BlockCheckLeft.is_colliding()
		_:
			return false

func _physics_process(delta):
	
	if is_moving:
		# Stops blocks from pushing each other
		if is_block_blocked_by_block(move_dir):
			stop()
		var move_vec = Vector2(move_dir * block_speed * delta)
		var collision = move_and_collide(move_vec)
		snap_pos = true
		if collision:
			# If colliding into the wall no snapping necessary
			if collision.get_collider().is_class("TileMap"):
				snap_pos = false
		
	
func _on_block_push_timer_timeout():
	# Snapping this to the position it should be at (16 px from inital position) 
	# because I keep coming across problems with the visuals since movement is 
	# done in done in floats there's a sort of desync between the actual position 
	# and the displayed pixels. Sort of how subpixels work but in a bad way.
	if snap_pos:
		match move_dir:
			up:
				position = Vector2(inital_pos.x,inital_pos.y - 16)
			right:
				position = Vector2(inital_pos.x + 16,inital_pos.y)
			down:
				position = Vector2(inital_pos.x,inital_pos.y + 16)
			left:
				position = Vector2(inital_pos.x - 16,inital_pos.y)
	stop()
	
func _on_confirm_push_timer_timeout():
	# Are any of the move actions held
	var any_move_actions_held = Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")
	if any_move_actions_held:
		allow_move = true
	else:
		allow_move = false

