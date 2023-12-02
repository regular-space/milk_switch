extends CharacterBody2D

@onready var gunshot = $Gunshot
@onready var footsteps = $Footsteps
@onready var cooldown = $Cooldown
@onready var show_shoot_animation = $ShowShootAnimation
@onready var aim = $Aim
@onready var muzzle = $Aim/Muzzle
@onready var texture = $Texture

# Set initial state in Inspector
@export_enum("Shooting", "Moving") var initial_state: int
var current_state
var cooldown_timer_started = false
var direction
@export var speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	Hud.palette_switched.connect(self._on_palette_switched)
	current_state = initial_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not Global.player_dead:
		aim.look_at(Global.player_position)
		
		# Shooting
		if current_state == 0:
			velocity = Vector2.ZERO
			if not cooldown_timer_started:
				cooldown.start()
				cooldown_timer_started = true
		
		# Moving
		elif current_state == 1:
			direction = Vector2.RIGHT.rotated(aim.rotation)
			velocity = direction * speed
			
		var collision = move_and_collide(velocity * delta)
		if collision:
			#print(self.name + ": Collision!")
			pass
	else:
		cooldown.stop()

func on_hit() -> void:
	self.queue_free()

func _on_palette_switched() -> void:
	# By default:
	# When light mode, this guy should be shooting
	# When dark, this guy should be smoovin'
	if current_state == 0:
		current_state = 1
		cooldown.stop()
		show_shoot_animation.stop()
		cooldown_timer_started = false
		footsteps.play()
		texture.play("move")
	elif current_state == 1:
		current_state = 0
		footsteps.stop()
		texture.play("idle")
		
func _on_cooldown_timeout():
	shoot_bullet()

func shoot_bullet() -> void:
	texture.play("shoot")
	gunshot.play()
	var new_bullet = Global.bullet.instantiate()
	new_bullet.setup(aim, muzzle)
	owner.add_child(new_bullet)
	
	show_shoot_animation.start()

func _on_show_shoot_animation_timeout():
	texture.play("idle")
	cooldown.start()


func _on_gunshot_finished():
	gunshot.stop()
