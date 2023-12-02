extends CharacterBody2D

# Set initial state in Inspector
@export_enum("Shooting", "Moving") var state: int
var current_state
var cooldown_timer_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Hud.palette_switched.connect(self._on_palette_switched)
	current_state = state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Aim.look_at(Global.player_position)
	
	# Shooting
	if current_state == 0:
		velocity = Vector2.ZERO
		if not cooldown_timer_started:
			$Cooldown.start()
			cooldown_timer_started = true
	
	# Moving
	elif current_state == 1:
		velocity = Vector2.ZERO
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		print(self.name + ": Collision!")

func _on_palette_switched() -> void:
	# By default:
	# When light mode, this guy should be shooting
	# When dark, this guy should be smoovin'
	if current_state == 0:
		current_state = 1
		$Cooldown.stop()
		$ShowShootAnimation.stop()
		cooldown_timer_started = false
		$AnimatedSprite2D.play("move")
	elif current_state == 1:
		current_state = 0
		$AnimatedSprite2D.play("idle")
		
func _on_cooldown_timeout():
	shoot_bullet()

func shoot_bullet() -> void:
	$AnimatedSprite2D.play("shoot")
	
	var new_bullet = Global.bullet.instantiate()
	new_bullet.setup($Aim, $Aim/Muzzle)
	owner.add_child(new_bullet)
	
	$ShowShootAnimation.start()

func _on_show_shoot_animation_timeout():
	$AnimatedSprite2D.play("idle")
	$Cooldown.start()
