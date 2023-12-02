extends CanvasLayer

# False = white, True = black
var is_black = false
signal palette_switched

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_switch_milk_pressed() -> void:
	$PaletteSwitcher.material.set_shader_parameter("on", is_black)
	is_black = not is_black
	palette_switched.emit()
