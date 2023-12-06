# Top Down 2D
extends CharacterBody2D

signal switch_milk_pressed

@export var speed: int = 75
@export var deceleration: int = 50
var direction: Vector2

func _ready():
	switch_milk_pressed.connect(Hud._on_switch_milk_pressed)

func _physics_process(delta):
	Global.player_position = self.position
	if Input.is_action_just_pressed("restart"):
		Global.change_room(Global.current_room_pack, 3)
		if Hud.is_black:
			await Hud.animate_black_screen.animation_finished
			switch_milk_pressed.emit()
	
	if not Global.disable_actor:
		if Input.is_action_just_pressed("switch_milk"):
			Audio.moo.play()
			Global.shake_screen(1, 0.2)
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
	else:
		velocity = Vector2.ZERO
			
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collision_obj = collision.get_collider()
		if collision_obj.has_method("push") and not collision_obj.is_moving:
			var pushable_obj = collision.get_collider()
			pushable_obj.push(velocity)
		#print("Collision")

func on_hit() -> void:
	Global.disable_actor = true
