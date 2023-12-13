extends StaticBody2D
@export var solid: bool

@onready var texture = $Texture
@onready var collision_shape_2d = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Hud.palette_switched.connect(self._on_palette_switched)
	
	match solid:
		true:
			pass
			initialize_solid()
		false:
			pass
			initialize_transparent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass


func _on_palette_switched() -> void:
	flip_state(solid)

	
func flip_state(state):
	match state:
		true:
			state = false
		false:
			state = true
	return state

	
func initialize_solid() -> void:
	texture.play("solid")
	#collision_shape_2d.set_deferred("disabled", false)


func initialize_transparent() -> void:
	texture.play("transparent")
	#collision_shape_2d.set_deferred("disabled", true)
