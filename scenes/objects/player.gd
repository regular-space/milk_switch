# Top Down 2D
extends CharacterBody2D

signal switch_milk_pressed

@export var speed: int = 75
@export var deceleration: int = 50

func _ready():
	switch_milk_pressed.connect(Hud._on_switch_milk_pressed)

func _physics_process(delta):
	Global.player_position = self.position
	
	if Input.is_action_just_pressed("switch_milk"):
		switch_milk_pressed.emit()
	
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
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("push_block"):
			var block = collision.get_collider()
			block.push_block(position)
		#print("Collision")
	
