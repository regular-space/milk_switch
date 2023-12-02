# Top Down 2D
extends CharacterBody2D

@export var speed: float = 100.0
@export var deceleration: float = 50.0

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	if direction:
		# Animation
		if direction == Vector2.UP:
			$AnimatedSprite2D.play("up")
		elif direction == Vector2.DOWN:
			$AnimatedSprite2D.play("down")
		elif direction == Vector2.RIGHT:
			$AnimatedSprite2D.play("right")
		elif direction == Vector2.LEFT:
			$AnimatedSprite2D.play("left")
		
		velocity = direction * speed
	else:
		velocity = Vector2(move_toward(velocity.x, 0, deceleration), move_toward(velocity.y, 0, deceleration))
		
	move_and_slide()
	
