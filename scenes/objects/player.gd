# Top Down 2D
extends CharacterBody2D

signal switch_milk_pressed
@onready var texture = $Texture

var allow_switch_milk := true
var inverse_collision_enter_count := 0

@export var speed: int = 75
@export var deceleration: int = 50
var direction: Vector2

func _ready():
	switch_milk_pressed.connect(Hud._on_switch_milk_pressed)
	texture.play("idle_down")

func _physics_process(delta):
	Global.player_position = self.global_position
	if Input.is_action_just_pressed("restart"):
		Global.change_room(Global.current_room_pack, 3)
		if Hud.is_black:
			await Hud.animate_black_screen.animation_finished
			switch_milk_pressed.emit()
	
	if not Global.all_actors_disabled:
		if Input.is_action_just_pressed("switch_milk") and allow_switch_milk:
			Audio.moo.play()
			Global.shake_screen(1, 0.2)
			switch_milk_pressed.emit()
			
		var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
		if direction:
			# Animation
			if direction.y < 0:
				texture.flip_h = false
				texture.play("move_up")
			elif direction.y > 0:
				texture.flip_h = false
				texture.play("move_down")
			elif direction.x > 0:
				texture.flip_h = false
				texture.play("move_right")
			elif direction.x < 0:
				texture.flip_h = true
				texture.play("move_right")
				
			velocity = direction * speed
		else:
			texture.stop()
			velocity = Vector2(move_toward(velocity.x, 0, deceleration), move_toward(velocity.y, 0, deceleration))
	else:
		velocity = Vector2.ZERO
		if not Global.is_changing_scene:
			texture.play("dead")
			
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collision_obj = collision.get_collider()
		if collision_obj.has_method("push") and not collision_obj.is_moving:
			var pushable_obj = collision.get_collider()
			pushable_obj.push(velocity)
		#print("Collision")

func on_hit() -> void:
	if not Global.all_actors_disabled:
		Audio.play_sound("bullet_hit_wall")
		Vfx.play_vfx(self.global_position, "blood_splurt")
	Global.all_actors_disabled = true

func _on_inverse_obj_checker_body_entered(body):
	if inverse_collision_enter_count == 0:
		allow_switch_milk = false
	inverse_collision_enter_count += 1
	

func _on_inverse_obj_checker_body_exited(body):
	inverse_collision_enter_count -= 1
	if inverse_collision_enter_count == 0:
		allow_switch_milk = true
