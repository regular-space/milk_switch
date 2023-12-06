extends CanvasLayer

@onready var animate_black_screen = $AnimateBlackScreen
@onready var black_screen = $BlackScreen

# False = white, True = black
var is_black = false
signal palette_switched
@export var palette: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO,Vector3.ZERO];

# Called when the node enters the scene tree for the first time.
func _ready():
	$PaletteSwitcher.material.set_shader_parameter("color1", palette[0])
	$PaletteSwitcher.material.set_shader_parameter("color2", palette[1])
	$PaletteSwitcher.material.set_shader_parameter("color3", palette[2])
	
	#black_screen.color = Color(0, 0, 0, 0)
	black_screen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_switch_milk_pressed() -> void:
	$PaletteSwitcher.material.set_shader_parameter("on", is_black)
	is_black = not is_black
	palette_switched.emit()
	
func fade_out(length):
	#black_screen.color = Color(0, 0, 0, 0)
	black_screen.show()
	animate_black_screen.play("fade_out", -1, length)
	await animate_black_screen.animation_finished
	black_screen.hide()
	
func fade_in(length):
	#black_screen.color = Color(0, 0, 0, 255)
	black_screen.show()
	animate_black_screen.play("fade_in", -1, length)
	await animate_black_screen.animation_finished
	black_screen.hide()
