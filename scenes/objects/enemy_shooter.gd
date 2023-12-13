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
#var initial_hud_state: bool
var current_state
var cooldown_timer_started = false
var direction = Vector2.ZERO
@export var speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	Hud.palette_switched.connect(self._on_palette_switched)
		
	# Assume white is the initial HUD state
	current_state = set_initial_state
	match current_state:
		0:
			initialize_shooting()
		1:
			initialize_idle()
			
	## Ran into bug where shooters wouldn't reset properly when
	## player resets the scene. This seems to fix it.
	if Hud.is_black:
		current_state = flip_state(current_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not Global.disable_actor:
		aim.look_at(Global.player_position)
		breathing_room.look_at(Global.player_position)
		
		match current_state:
			# Shooting
			0:
				velocity = Vector2.ZERO
				if not cooldown_timer_started:
					#if breathing_room.is_colliding():
						#if not breathing_room.get_collider().get_class() == "TileMap":
							#pass
					#else:
						#cooldown.start()
						#cooldown_timer_started = true
					cooldown.start()
					cooldown_timer_started = true
			# Idle
			1:
				direction = Vector2.RIGHT.rotated(aim.rotation)
				velocity = direction * speed
			
			_:
				print(self.name + ": Error! current_state out of bounds!")
			
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider = collision.get_collider()
			if collider.has_method("on_hit") and collider.is_in_group("Player"):
				collider.on_hit()
	else:
		footsteps.stop()
		cooldown.stop()

func on_hit() -> void:
	#self.queue_free()
	pass
	
func _on_crushed() -> void:
	self.queue_free()

func _on_palette_switched() -> void:
	current_state = flip_state(current_state)
		
func flip_state(state):
	var new_state: int
	match state:
		0:
			new_state = 1
			initialize_shooting()
		1:
			new_state = 0
			initialize_idle()
		_:
			print(self.name + ": In flip_current_state(), state is out of bounds!")
	return new_state

func initialize_shooting() -> void:
	cooldown.stop()
	show_shoot_animation.stop()
	cooldown_timer_started = false
	texture.play("move")

func initialize_idle() -> void:
	texture.play("idle")
		
func _on_cooldown_timeout():
	shoot_bullet()

func shoot_bullet() -> void:
	texture.play("shoot")
	Audio.play_sound("gunshot")
	var new_bullet = Global.bullet.instantiate()
	owner.add_child(new_bullet)
	new_bullet.setup(aim, muzzle)
	show_shoot_animation.start()

func _on_show_shoot_animation_timeout():
	texture.play("idle")
	cooldown.start()



func _on_stuck_detector_entered(body):
	# Just doing this for now to check for blocks
	print(body.get_class())
	if body.get_class() == "AnimatableBody2D":
		_on_crushed()
