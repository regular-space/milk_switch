extends CanvasLayer

var palette_switch = false
signal palette_switched

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_switch_milk_pressed() -> void:
	$PaletteSwitcher.material.set_shader_parameter("on", palette_switch)
	palette_switch = not palette_switch
	palette_switched.emit()
