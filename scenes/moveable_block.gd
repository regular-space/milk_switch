extends AnimatableBody2D

var move_dir := Vector2.ZERO
var is_moving := false
const speed := 22.0

const left := Vector2(-1,0)
const right := Vector2(1,0)
const up := Vector2(0,-1)
const down := Vector2(0,1)

func push(direction: Vector2):
	# Don't want to allow changing of direction mid push. Done this to replicate
	# the old Zelda feel of moving blocks
	if not is_moving:
		# Move right
		if direction.x > 0:
			move_dir = right
			$BlockPushTimer.start()
			is_moving = true
		# Move left
		elif direction.x < 0:
			move_dir = left
			$BlockPushTimer.start()
			is_moving = true
		# Move down
		elif direction.y > 0:
			move_dir = down
			$BlockPushTimer.start()
			is_moving = true
		# Move up
		elif direction.y < 0:
			move_dir = up
			$BlockPushTimer.start()
			is_moving = true
	
func stop() -> void:
	move_dir = Vector2.ZERO
	is_moving = false

func _physics_process(delta):
	move_and_collide(move_dir * speed * delta)

func _on_block_push_timer_timeout():
	stop()
