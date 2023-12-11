extends CharacterBody2D

@onready var footsteps = $Footsteps
@onready var cooldown = $Cooldown
@onready var show_shoot_animation = $ShowShootAnimation
@onready var aim = $Aim
@onready var muzzle = $Aim/Muzzle
@onready var texture = $Texture
@onready var breathing_room =   $BreathingRoom

# Set initial state in Inspector
@export_enum("Shooting", "Moving") var set_initial_state: int
@export var speed = 50
var initial_hud_state: bool
var current_state
var cooldown_timer_started = false
var direction


# Called when the node enters the scene tree for the first time.
func _ready():
	Hud.palette_switched.connect(self._on_palette_switched)
	
	## Black
	#if Hud.palette_switch:
		#initial_hud_state = true
	## White
	#else:
		#initial_hud_state = false
	current_state = set_initial_state
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not Global.disable_actor:
		aim.look_at(Global.player_position)
		breathing_room.look_at(Global.player_position)
		
		# Shooting
		if current_state == 0:
			velocity = Vector2.ZERO
			if not cooldown_timer_started:
				if breathing_room.is_colliding():
					if not breathing_room.get_collider().get_class() == "TileMap":
						pass
				else:
					cooldown.start()
					cooldown_timer_started = true
		
		# Moving
		elif current_state == 1:
			direction = Vector2.RIGHT.rotated(aim.rotation)
			velocity = direction * speed
			footsteps.play()
			texture.play("move")
			
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider = collision.get_collider()
			if collider.has_method("on_hit") and collider.is_in_group("Player"):
				collider.on_hit()
	else:
		footsteps.stop()
		cooldown.stop()

func on_hit() -> void:
	self.queue_free()

func _on_palette_switched() -> void:
	# By default:
	# When light mode, this guy should be shooting
	# When dark, this guy should be smoovin'
	if Hud.is_black:
		current_state = 1
		cooldown.stop()
		show_shoot_animation.stop()
		cooldown_timer_started = false
		footsteps.play()
		texture.play("move")
	else:
		current_state = 0
		footsteps.stop()
		texture.play("idle")
		
func _on_cooldown_timeout():
	shoot_bullet()

func shoot_bullet() -> void:
	texture.play("shoot")
	Audio.play_sound("gunshot")
	var new_bullet = Global.bullet.instantiate()
	new_bullet.setup(aim, muzzle)
	owner.add_child(new_bullet)
	
	show_shoot_animation.start()

func _on_show_shoot_animation_timeout():
	texture.play("idle")
	cooldown.start()

