extends CanvasLayer

# False = white, True = black
var is_black = false
signal palette_switched
@export var palette: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO,Vector3.ZERO];

# Called when the node enters the scene tree for the first time.
func _ready():
	$PaletteSwitcher.material.set_shader_parameter("color1", palette[0])
	$PaletteSwitcher.material.set_shader_parameter("color2", palette[1])
	$PaletteSwitcher.material.set_shader_parameter("color3", palette[2])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_switch_milk_pressed() -> void:
	$PaletteSwitcher.material.set_shader_parameter("on", is_black)
	is_black = not is_black
	palette_switched.emit()
