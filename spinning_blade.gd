extends AnimatableBody2D

@export var velocity := Vector2(-2.0,0)
@export var milk_switched := false

# Called when the node enters the scene tree for the first time.
func _ready():
	Hud.palette_switched.connect(self._on_palette_switched)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if milk_switched:
		$BladeSprite.visible = false
		set_collision_layer_value(3,false)
		set_collision_layer_value(32,true)
		$BladeInvisSprite.visible = true
		set_collision_mask_value(2,false)
		set_collision_mask_value(3,false)
		set_collision_mask_value(32,true)
		
	else:
		$BladeSprite.visible = true
		set_collision_layer_value(32,false)
		set_collision_layer_value(3,true)
		$BladeInvisSprite.visible = false
		set_collision_mask_value(2,true)
		set_collision_mask_value(3,true)
		set_collision_mask_value(32,false)

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision:
		velocity *= -1
		if collision.get_collider().has_method("on_hit"):
			collision.get_collider().on_hit()
	$BladeSprite.rotation += deg_to_rad(45.0)
	$BladeInvisSprite.rotation += deg_to_rad(45.0)

func _on_palette_switched():
	milk_switched = not milk_switched
	
