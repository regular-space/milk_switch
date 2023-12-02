extends AnimatableBody2D

const left := Vector2(-1,0)
const right := Vector2(1,0)
const up := Vector2(0,-1)
const down := Vector2(0,1)
const speed := 22.0

var move_dir := Vector2.ZERO
var is_moving := false
var allow_move := false
var is_collidable := true

func push(direction: Vector2):
	# Don't want to allow changing of direction mid push. Done this to replicate
	# the old Zelda feel of moving blocks
	if not is_moving and allow_move:
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
		# Move down
		elif direction.y > 0:
			move_dir = down
			$PushTimer.start()
			is_moving = true
		# Move up
		elif direction.y < 0:
			move_dir = up
			$PushTimer.start()
			is_moving = true
	elif $ConfirmPushTimer.is_stopped():
		$ConfirmPushTimer.start()
	
func stop() -> void:
	move_dir = Vector2.ZERO
	is_moving = false

func _physics_process(delta):
	move_and_collide(move_dir * speed * delta)

func _on_block_push_timer_timeout():
	stop()

func _on_confirm_push_timer_timeout():
	# Are any of the move actions held
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		allow_move = true
	else:
		allow_move = false
