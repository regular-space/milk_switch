# Top Down 2D
extends CharacterBody2D

@export var speed: int = 100
@export var deceleration: int = 50

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	if direction:
		# Animation
		if direction.y < 0:
			$AnimatedSprite2D.play("up")
		elif direction.y > 0:
			$AnimatedSprite2D.play("down")
		elif direction.x > 0:
			$AnimatedSprite2D.play("right")
		elif direction.x < 0:
			$AnimatedSprite2D.play("left")
		
		velocity = direction * speed
	else:
		velocity = Vector2(move_toward(velocity.x, 0, deceleration), move_toward(velocity.y, 0, deceleration))
		
	move_and_slide()
	
